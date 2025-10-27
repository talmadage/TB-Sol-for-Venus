%{
   #include <string.h>
   #include <stdlib.h>
   //#include <malloc.h>
   #include "lib/rli_string.h"
   #include "lib/vhdl_packages.h"
   #include "program.h"

   // List of prototypes
   extern void yyerror(char *s);
   void yyerror2(char *s);
   extern int program_lex(void);
   extern int program_lines;
   char *hex2bits(char *s);
   char *itoa(int number);
   char *Negate(char *value);

	// Error log functions...
	extern char log_str[1024];
	extern void log(char *s);

   int i=0,j=0;
   bool found;
   bool ParsingMacros=false;
   bool ParsingVHDL=false;
   char tmp[4096];
   char *tmp_str;

   #define MAX_INCLUDE_DEPTH 20
   char *file_name_stack[MAX_INCLUDE_DEPTH];
   int file_name_stack_ptr=0;
   char *current_file_name;

   target_code *UseClauses=new target_code();
   target_code *SignalDeclarations=new target_code();
   target_code *PackageCode=new target_code();
   target_code *ArchitectureCode=new target_code();

   extern char *Entity_Name;
   extern constants *Constants;
   extern inputs *Inputs;
   extern internals *Internals;
   extern outputs *Outputs;
   extern aliases *Aliases;
   extern memories *Memories;
   extern starts *Starts;
   extern layouts *Layouts;
   extern productions *Grammars;
   extern actions *Actions;
   
%}
%union {
   char *string;
   int number;
   bool boolean;
   target_code *TargetCode;
   vhdl_code *VHDLCode;
   vhdl_atom *VHDL_Atom;
   range_class *Range;
   device_driver *Driver;
   input *Input;
   internal *Internal;
   output *Output;
   alias *Alias;
   memory *Memory;
   start *Start;
   layout *Layout;
   constant *Constant;
   action_cdfg *CDFG;
   aliased_signal_name *Aliased_Signal;
   aliased_signal_names *Aliased_Signals;
   mux_condition *Mux_Condition;
   mux_expression *Mux_Expression;
   action_mux *Action_Mux;
   action_item *Action_Item;
   action_line *Action_Line;
   action *Action;
   actions *Actions;
   action_target *Action_Target;
   production_terminal *Terminal;
   production_item *Prod_Item;
   production_line *Prod_Line;
   production_lines *Prod_Lines;
   production *Production;
   input_stream *Input_Stream;
   stream_item *Stream_Item;
   action_signal *Signal;
   action_variable *Variable;
   production_cond *Cond;
}

%token INCLUDE
%token INCLUDE_TEXT
%token FILE_NAME
%token END_OF_FILE
%token TARGET_CODE_START
%token STRING
%token TARGET_CODE_END

%token INPUT
%token INOUT
%token INTERNAL
%token OUTPUT
%token NAME
%token MEMORY
%token START

%token HW
%token SW
%token DRIVER_MEMORY
%token RATE
%token KBPS MBPS GBPS
%token KHZ MHZ GHZ
%token RANGE
%token TO
%token CLOCK
%token ASYNCH_RESET
%token SYNCH_RESET
%token AT

%token BIT
%token OTHERS
%token ERROR
%token BREAK
%token INTERRUPT
%token RESET
%token SYNC
%token COND
%token BIT_STRING
%token LONG_BIT_STRING
%token HEX_NUMBER
%token LONG_HEX_NUMBER
%token NUMBER
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS
%token CONSTANT
%token LEXEM
%token IF
%token ELSE
%token ENDIF

%token CODE_START

%token SEMICOLON
%token COLON
%token NEWLINE // Used in Target Code VHDL
%token VARIABLE // Used in Target Code VHDL

%token OR
%left AND
%token COND_AND
%token EQUAL
%token NOT_EQUAL
%token DOUBLE_PERIOD
%token PERIOD
%token LESS_THAN
%token GREATER_THAN

%token LEFT_CURLY_BRACKET
%token RIGHT_CURLY_BRACKET
%token ACTION

%left ADD SUB
%left MUL DIV
%left SHR
%right NOT

%start file
%%

//input: /* Empty line */
//	| input file
//;

file: type_declarations { log("type_declarations\n"); }
          CODE_START interface_declarations 
          CODE_START token_declarations 
          CODE_START memory_layout 
	     { Memories->Initialize();  log("memory_layout\n"); }
          CODE_START 
	     { ParsingMacros=true; } 
          action_macros 
	     { ParsingMacros=false; log("action_macros\n"); }
          CODE_START //{yydebug=1;}
		  code_grammar 
		  { 
			sprintf(log_str,"END OF FILE\n");
			log(log_str);
		  }
    | error
        {
		   sprintf(tmp,"Unknown keyword %s, at line %d:\n   <%s>",$<string>1,program_lines);
		   yyerror2(tmp); return 1;
		};


type_declarations: /* Empty */
	| type_declarations type_declaration
;

type_declaration: include_declaration
	| TARGET_CODE_START target_code TARGET_CODE_END
		{
		   PackageCode->AddMembers($<TargetCode>2);
		   delete $<TargetCode>2;
		}
;

include_declaration: INCLUDE FILE_NAME
	{
	   // Switching between files is handled by LEX
	   fprintf(stderr,"Opened include file %s\n",$<string>2);
	   file_name_stack[file_name_stack_ptr++]=current_file_name;
	   current_file_name=$<string>2;
	}
	file
	{
	   // Switching between files is handled by LEX
	   fprintf(stderr,"Closed include file %s\n",current_file_name);
	   delete current_file_name;
           current_file_name=file_name_stack[--file_name_stack_ptr];
	}
	END_OF_FILE
	| INCLUDE error
		{
		   sprintf(tmp,"Include file name must be enclosed in brackets, at line %d:\n   <%s>",program_lines,$<string>2);
		   yyerror2(tmp); return 1;
		}
;

interface_declarations: /* Empty line */
	| interface_declarations interface
;

interface: INPUT input_parameters
		{
		   sprintf(log_str,"INPUT %s\n",$<Input>2->Name());
		   log(log_str);
		   Inputs->AddMember($<Input>2);
		}
	| INTERNAL internal_parameters
		{
		   sprintf(log_str,"INTERNAL %s\n",$<Internal>2->Name());
		   log(log_str);
		   Internals->AddMember($<Internal>2);
		}
	| OUTPUT output_parameters
		{
		   sprintf(log_str,"OUTPUT %s\n",$<Output>2->Name());
		   log(log_str);
		   Outputs->AddMember($<Output>2);
		}
	| NAME lexem
		{
		sprintf(log_str,"Name=%s\n",$<string>2);
		log(log_str);
		   Entity_Name=$<string>2;
		}
	| NAME name_parameters
		{
		   Aliases->AddMember($<Alias>2);
		}
	| MEMORY memory_parameters
		{
		   Memories->AddMember($<Memory>2);
		}
	| START start_parameters
		{
		   sprintf(log_str,"START %s %s clock %s\n",$<Start>2->Name(),$<Start>2->Stream()->Name(),$<Start>2->ClockName());
		   log(log_str);
		   Starts->AddMember($<Start>2);
		}
	| TARGET_CODE_START target_code TARGET_CODE_END
		{
		   UseClauses->AddMembers($<TargetCode>2);
		   delete $<TargetCode>2;
		}
	| error
		{
		   sprintf(tmp,"Unknown Interface Parameter error at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

target_code: target_code STRING
		{
		log("target_code (1)\n");
		   $<TargetCode>$=$<TargetCode>1;
		   $<TargetCode>$->AddMember($<string>2);
		};
	| STRING
		{
		log("target_code (2)\n");
		   $<TargetCode>$=new target_code();
		   $<TargetCode>$->AddMember($<string>1);
		}
;

token_declarations: /* Empty */
	| token_declarations token_declaration
		{
		   Constants->AddMember($<Constant>2);
		}
;

token_declaration: constant constant_parameters
		{
           // Check if constant already exists
		   $<Constant>$=new constant($<string>1,$<string>2);
		   sprintf(log_str,"%s %s\n",$<string>1,$<string>2);
		   log(log_str);
		   for(int i=0;i<Constants->NrOfMembers();i++)
		   {
		       if (strcmp(Constants->Member(i)->Name(),$<string>1)==0)
			   {
			   	  sprintf(tmp,"Constant Parameter already defined. Line %d:\n   %s",program_lines,$<string>1);
				  yyerror2(tmp); return 1;
			   }
		   }
		}
	| error
		{
		   sprintf(tmp,"Unknown Constant Parameter error at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

constant: CONSTANT
		{
		   $<string>$=cpystr($<string>1);
//		   delete $<string>1;
		}
;

lexem: LEXEM
		{
		   $<string>$=cpystr($<string>1);
//		   delete $<string>1;
		}
;

constant_parameters: bit_strings
		{
		   $<string>$=$<string>1;
		}
	| hex_number
		{
		   $<string>$=$<string>1;
		}
	| LEFT_BRACKET bit_strings RIGHT_BRACKET numeric_expression
		{
		   strcpy(tmp,"");
		   for (i=0;i<$<number>4;i++)
		   {
		      strcat(tmp,$<string>2);
		   };
		   $<string>$=new char[strlen(tmp)+1];
		   strcpy($<string>$,tmp);
		}
	| LEFT_BRACKET hex_number RIGHT_BRACKET numeric_expression
		{
		   strcpy(tmp,"");
		   for (i=0;i<$<number>4;i++)
		   {
		      strcat(tmp,$<string>2);
		   };
		   $<string>$=new char[strlen(tmp)+1];
		   strcpy($<string>$,tmp);
		}
	| LONG_BIT_STRING numeric_expression
		{
		   strcpy(tmp,"");
		   for (i=0;i<$<number>2;i++)
		   {
		      strcat(tmp,$<string>1);
		   };
		   $<string>$=new char[strlen(tmp)+1];
		   strcpy($<string>$,tmp);
		}
;

bit_strings: bit_strings bit_string
		{
		   $<string>$=catstr($<string>1,$<string>2);
//sprintf(log_str,"bit_strings: %s\n",$<string>$);
//log(log_str);
		   delete $<string>1;
		   delete $<string>2;
		}
	| bit_string
		{
		   $<string>$=$<string>1;
//sprintf(log_str,"bit_strings %s\n",$<string>$);
//log(log_str);
		}
;

bit_string: BIT_STRING
		{
//		   sprintf(log_str,"%s\n",$<string>1);
//		   log(log_str);
		   $<string>$=cpystr($<string>1);
		}
;

hex_number: HEX_NUMBER
		{
		   strcpy(tmp,hex2bits($<string>1));
		   $<string>$=new char[strlen(tmp)+1];
		   strcpy($<string>$,tmp);
		}
;

input_parameters: lexem bit_size RATE numeric_expression rates
		{
		   $<Input>$=new input($<string>1,new array_type(1,$<number>2),$<number>4,$<number>5);
		}
	| lexem bit_size driver_conditions
		{
		   $<Input>$=new input($<string>1,new array_type(1,$<number>2),$<Driver>3);
		}
	| lexem bit_size
		{
		   $<Input>$=new input($<string>1,new array_type(1,$<number>2));
		}
	| lexem bit_size RANGE number TO number
		{
		   $<Input>$=new input($<string>1,new array_type(1,$<number>2),new range_class($<number>4,$<number>6));
		}
	| error
		{
		   sprintf(tmp,"Unknown Lexem error at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

driver_conditions: SW
		{
		   $<Driver>$=new device_driver(new software_driver());
		}
	| SW DRIVER_MEMORY number
		{
		   $<Driver>$=new device_driver(new software_driver($<number>3));
		}
	| HW number
		{
		   $<Driver>$=new device_driver(new hardware_driver($<number>2));
		}
	| HW number DRIVER_MEMORY number
		{
		   $<Driver>$=new device_driver(new hardware_driver($<number>2,$<number>4));
		}
;

internal_parameters: port_parameter sync_parameter
		{ $<Internal>$=$<Internal>1; }
	| port_parameter
		{ $<Internal>$=$<Internal>1; }
;

sync_parameter: ASYNCH_RESET LEFT_PARENTHESIS lexem RIGHT_PARENTHESIS
	| SYNCH_RESET LEFT_PARENTHESIS lexem RIGHT_PARENTHESIS
;

port_parameter: lexem array_bit_size
		{
		   $<Internal>$=new internal($<string>1,new array_type(1,$<number>2));
		}
	| lexem array_bit_size RANGE number TO number
		{
		   $<Internal>$=new internal($<string>1,new array_type(1,$<number>2),new range_class($<number>4,$<number>6));
		}
	| error
		{
		   sprintf(tmp,"Unknown Lexem error at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

output_parameters: lexem bit_size
		{
		   $<Output>$=new output($<string>1,new array_type(1,$<number>2));
		}
	| lexem bit_size driver_conditions
		{
		   $<Output>$=new output($<string>1,new array_type(1,$<number>2),$<Driver>3);
		}
	| lexem bit_size RANGE number TO number
		{
		   $<Output>$=new output($<string>1,new array_type(1,$<number>2),new range_class($<number>4,$<number>6));
		}
;

name_parameters: LEFT_CURLY_BRACKET list_of_signal_names RIGHT_CURLY_BRACKET lexem
		{
		   $<Alias>$=new alias($<string>4,$<Aliased_Signals>2);
		}
;

list_of_signal_names: list_of_signal_names signal_name
		{
		   $<Aliased_Signals>$=$<Aliased_Signals>1;
		   $<Aliased_Signals>$->AddMember($<Aliased_Signal>2);
		}
	| signal_name
		{
		   $<Aliased_Signals>$=new aliased_signal_names($<Aliased_Signal>1);
		}
;

signal_name: lexem
		{
		   $<Aliased_Signal>$=new aliased_signal_name($<string>1);
		}
	| lexem range_statement
		{
		   $<Aliased_Signal>$=new aliased_signal_name($<string>1,$<Range>2);
		}
;

memory_parameters: lexem LEFT_BRACKET bit_size RIGHT_BRACKET lexem
		{
		   $<Memory>$=new memory($<string>1,$<number>3,1,$<string>5);
		}
	| lexem LEFT_BRACKET bit_size RIGHT_BRACKET numeric_expression lexem
		{
		   $<Memory>$=new memory($<string>1,$<number>3,$<number>5,$<string>6);
		}
	| lexem LEFT_BRACKET bit_size RIGHT_BRACKET bit_size
		{
		   $<Memory>$=new memory($<string>1,$<number>3,1,$<number>5);
		}
	| lexem LEFT_BRACKET bit_size RIGHT_BRACKET numeric_expression bit_size
		{
		   $<Memory>$=new memory($<string>1,$<number>3,$<number>5,$<number>6);
		}
;

bit_size: BIT
		{
		   $<number>$=1;
		}
	| LEFT_BRACKET BIT RIGHT_BRACKET numeric_expression
		{
		   $<number>$=$<number>4;
		}
	| error
		{
		   sprintf(tmp,"Unknown Bit Size error at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

array_bit_size: BIT
		{
		   $<number>$=1;
		}
	| LEFT_BRACKET array_bit_size RIGHT_BRACKET numeric_expression
		{
		   $<number>$=$<number>2*$<number>4;
		}
;

start_parameters: lexem LEFT_PARENTHESIS list_of_lexems RIGHT_PARENTHESIS clock_port clock_constraints
		{
		   $<Start>$=new start($<string>1,$<Input_Stream>3,$<string>5,$<number>6);
		}
;

clock_port: CLOCK LEFT_PARENTHESIS lexem RIGHT_PARENTHESIS
		{
		   $<string>$=cpystr($<string>3);
		}
;

clock_constraints: /* Empty */
		{
		   $<number>$=0;
		}
	| number KHZ
		{
		   $<number>$=$<number>2*1000;
		}
	| number MHZ
		{
		   $<number>$=$<number>2*1000000;
		}
	| number GHZ
		{
		   $<number>$=$<number>2*1000000000;
		}
;

number: NUMBER
		{
		  // In case of mixed 0:s to 9:s
		  $<number>$=atoi($<string>1);
		}
	| BIT_STRING
		{
		  // In case of only 0:s and 1:s
		  $<number>$=atoi($<string>1);
		}
;

rates: KBPS
		{
		  $<number>$=KBPS;
		}
	| MBPS
		{
		  $<number>$=MBPS;
		}
	| GBPS
		{
		  $<number>$=GBPS;
		}
;

numeric_expression: numeric_expression ADD numeric_expression
		{
		   $<number>$=$<number>1+$<number>3;
		}
	| numeric_expression SUB numeric_expression
		{
		   $<number>$=$<number>1-$<number>3;
		}
	| numeric_expression MUL numeric_expression
		{
		   $<number>$=$<number>1*$<number>3;
		}
	| numeric_expression DIV numeric_expression
		{
		   $<number>$=$<number>1/$<number>3;
		}
	| LEFT_PARENTHESIS numeric_expression RIGHT_PARENTHESIS 
		{
		   $<number>$=$<number>2;
		}
	| number
		{
		   $<number>$=$<number>1;
		}
;

memory_layout: /* Memory */
	| memory_layout memory_production
		{
		   Layouts->AddMember($<Layout>2);
		}
;

memory_production: lexem COLON definition_alternatives SEMICOLON
		{
		   $<Layout>$=new layout($<string>1,$<Prod_Line>3);
		}
 	| TARGET_CODE_START target_code TARGET_CODE_END
		{
		   SignalDeclarations->AddMembers($<TargetCode>2);
		   delete $<TargetCode>2;
		}
	| error
		{
		   sprintf(tmp,"Expected a Memory declaration or Start of Action section at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

action_macros: /* Empty */
	| action_macros action_macro
		{
		   // Check Action if already defined?
		   Actions->AddMember($<Action>2);
		}
;

action_macro: action_target EQUAL list_of_action_atoms SEMICOLON
		{
		   $<Action>$=new action($<Action_Target>1,$<Action_Line>3);
		}
	| error
		{
		   sprintf(tmp,"Expected an Action declaration or Start of Grammar section at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

code_grammar: /* Empty */
	| code_grammar grammar_production
		{
		   sprintf(log_str,"code_grammar->Production: %s\n",$<Production>2->Name());
		   log(log_str);
		   Grammars->AddMember($<Production>2);
		}
	| code_grammar architecture_target_code
		{
		   sprintf(log_str,"code_grammar->architecture_target_code\n");
		   log(log_str);
		};
;

grammar_production: lexem COLON list_of_definition_alternatives SEMICOLON
		{
			sprintf(log_str,"grammar_production %s\n",$<string>1);
			log(log_str);
		   if (Grammars->IsMember($<string>1))
		   {
		      sprintf(tmp,"Error: Duplicate Definition of Production %s at line %d\n",$<string>1,program_lines);
			  log(log_str);
		      yyerror2(tmp); return 1;
		   }
		   else
		   {
		      $<Production>$=new production($<string>1,$<Prod_Lines>3);
		   };
		   //log("BAKAYARO\n");
		}
	| lexem COLON list_of_definition_alternatives
		{
		   sprintf(tmp,"Expected semicolon at line %d.\n",program_lines);
		   yyerror2(tmp); return 1;
		}
	| SEMICOLON
		{
		   sprintf(tmp,"Stray semicolon at line %d.\n",program_lines);
		   yyerror2(tmp); return 1;
		}
	| error
		{
		   sprintf(tmp,"Expected a Grammar declaration at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

architecture_target_code: TARGET_CODE_START target_code TARGET_CODE_END
		{
		   log("architecture_target_code(1)\n");
		   ArchitectureCode->AddMembers($<TargetCode>2);
		   delete $<TargetCode>2;
		   log("architecture_target_code(2)\n");
		}
;

list_of_definition_alternatives: list_of_definition_alternatives OR definition_alternatives
		{
		   $<Prod_Lines>$=$<Prod_Lines>1;
		   $<Prod_Lines>$->AddMember($<Prod_Line>3);
		}
	| list_of_definition_alternatives AND definition_alternatives
	| definition_alternatives
		{
		   $<Prod_Lines>$=new production_lines($<Prod_Line>1);
		}
;

definition_alternatives: definition_alternatives definition
		{
		   $<Prod_Line>$=$<Prod_Line>1;
		   $<Prod_Line>$->AddMember($<Prod_Item>2);
		}
	| definition
		{
		   $<Prod_Line>$=new production_line($<Prod_Item>1);
		}
;

definition: lexem
		{
		   sprintf(log_str,"(1) Production %s\n",$<string>1);
		   log(log_str);
		   $<Prod_Item>$=new production_item(new production_lexem($<string>1));
		}
	| LEFT_BRACKET lexem RIGHT_BRACKET numeric_expression
		{
		   sprintf(log_str,"(2) Production %s x %d\n",$<string>2,$<number>4);
		   log(log_str);
		   $<Prod_Item>$=new production_item(new production_lexem($<string>2,$<number>4));
		   log("BAKA\n");
		}
	| LEFT_PARENTHESIS list_of_lexems RIGHT_PARENTHESIS
		{
		   sprintf(log_str,"Stream redirection %s %s\n",$<string>2);
		   log(log_str);
		   $<Prod_Item>$=new production_item(new production_redirection($<Input_Stream>2));
		}
	| COND_AND cond_definition
		{
		   // Left Associative Condition
		   sprintf(log_str,"Left Conditional AND\n");
		   log(log_str);
		   $<Prod_Item>$=new production_item($<Cond>2);
		}
	| cond_definition COND_AND
		{
		   // Right Associative Condition
		   sprintf(log_str,"Right Conditional AND\n");
		   log(log_str);
		   $<Prod_Item>$=new production_item($<Cond>1);
		}
	| COND_AND sync_definition
		{
		   // Left Associative Synchronisation
		   sprintf(log_str,"Left Sync\n");
		   log(log_str);
		   $<Prod_Item>$=new production_item($<Cond>2);
		}
	| sync_definition COND_AND
		{
		   // Right Associative Synchronisation
		   sprintf(log_str,"Right Sync\n");
		   log(log_str);
		   $<Prod_Item>$=new production_item($<Cond>1);
		}
	| INTERRUPT LEFT_PARENTHESIS lexem RIGHT_PARENTHESIS
		{
		   sprintf(log_str,"Interrupt\n");
		   log(log_str);
		   $<Prod_Item>$=new production_item(new production_interrupt($<string>3));
		}
	| RESET LEFT_PARENTHESIS lexem RIGHT_PARENTHESIS
		{
		   sprintf(log_str,"Reset\n");
		   log(log_str);
		   $<Prod_Item>$=new production_item(new production_reset($<string>3));
		}
	| RESET error
		{
		   sprintf(tmp,"Error in Reset statement at line %d:\n   %s",program_lines,$<string>1);
		   log(tmp);
		   yyerror2(tmp); return 1;
		}
	| constant
		{
		   //sprintf(log_str,"CONSTANT %s\n", Constants->Member(i)->Name());
		   //log(log_str);
		   found=false;
		   //sprintf(log_str,"Exist %s?\n",$<string>1);
           //log(log_str);
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),$<string>1)==0)
		      {
		         // sprintf(log_str,"Y!\n");
                 // log(log_str);
		         $<Prod_Item>$=new production_item(new production_terminal(Constants->Member(i)->Value(),false));
			     found=true;
			     break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",$<string>1,program_lines);
			  log(tmp);
		      yyerror2(tmp); return 1;
		   };
		}
	| NOT constant
		{
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 $<string>2)==0)
		      {
		         $<Prod_Item>$=new production_item(
				       new production_terminal(Constants->Member(i)->Value(),true));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",$<string>2,program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
	| BIT_STRING
		{
//			sprintf(log_str,"BIT_STRING %s\n",$<string>1);
//			log(log_str);
		   $<Prod_Item>$=new production_item(
				 new production_terminal(cpystr($<string>1),false));
		}
//	| SUB
//		{
//		   $<Prod_Item>$=new production_item(
//				 new production_terminal(cpystr("-"),false));
//		}
	| NOT BIT_STRING
		{
		      sprintf(log_str,"Not bit_string\n");
              log(log_str);
		   $<Prod_Item>$=new production_item(
				 new production_terminal(cpystr($<string>2),true));
		}
	| hex_number
		{
		      sprintf(log_str,"hex_number\n");
              log(log_str);
		   $<Prod_Item>$=new production_item(
				 new production_terminal($<string>1,false));
		}
	| NOT hex_number
		{
		      sprintf(log_str,"Not hex_number\n");
              log(log_str);
		   $<Prod_Item>$=new production_item(
				 new production_terminal($<string>2,true));
		}
	| action
		{
		   log("Action\n");
		   $<Prod_Item>$=new production_item($<Actions>1);
		}
	| size_definitions
		{
		   log("Size definition\n");
		   $<Prod_Item>$=$<Prod_Item>1;
		}
	| ERROR
		{
		   log("Error\n");
		   $<Prod_Item>$=new production_item(new production_error());
		}
	| error
		{
		   sprintf(tmp,"Expected a Lexem or a Semicolon at line %d:\n   %s",program_lines,$<string>1);
		   log(tmp);
		   yyerror2(tmp); return 1;
		}
;

cond_definition: COND LEFT_PARENTHESIS lexem cond_condition constant RIGHT_PARENTHESIS
		{
	           constant *cons;
		   cons=Constants->Member($<string>5);
		   if (cons==NULL)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",$<string>5,program_lines);
		      yyerror2(tmp); return 1;
		   };
		   $<Cond>$=new production_cond(new production_signal(new action_signal($<string>3)),$<boolean>4,cons->Value());
		}
	| COND LEFT_PARENTHESIS lexem cond_condition constant_parameters RIGHT_PARENTHESIS
		{
		   $<Cond>$=new production_cond(new production_signal(new action_signal($<string>3)),$<boolean>4,$<string>5);
		}
;

sync_definition: SYNC LEFT_PARENTHESIS lexem cond_condition constant RIGHT_PARENTHESIS
		{
	           constant *cons;
		   cons=Constants->Member($<string>5);
		   if (cons==NULL)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",$<string>5,program_lines);
		      yyerror2(tmp); return 1;
		   };
		   $<Cond>$=new production_cond(new production_signal(new action_signal($<string>3)),$<boolean>4,cons->Value());
		}
	| SYNC LEFT_PARENTHESIS lexem cond_condition constant_parameters RIGHT_PARENTHESIS
		{
		   $<Cond>$=new production_cond(new production_signal(new action_signal($<string>3)),$<boolean>4,$<string>5);
		}
;

cond_condition: EQUAL
		{
		   $<boolean>$=true;
		}
	| NOT_EQUAL
		{
		   $<boolean>$=false;
		}
;

size_definitions: OTHERS
		{
		   $<Prod_Item>$=new production_item(new production_terminal(OTHER_BIT,1,false));
		}
	| LEFT_BRACKET OTHERS RIGHT_BRACKET numeric_expression
		{
		   $<Prod_Item>$=new production_item(new production_terminal(OTHER_BIT,$<number>4,false));
		}
	| BIT
		{
		   $<Prod_Item>$=new production_item(new production_terminal(DONT_CARE_BIT,1,false));
		}
	| LEFT_BRACKET BIT RIGHT_BRACKET numeric_expression
		{
		   $<Prod_Item>$=new production_item(new production_terminal(DONT_CARE_BIT,$<number>4,false));
		}
;

list_of_lexems: list_of_lexems lexem_stmnt
		{
		   $<Input_Stream>$=$<Input_Stream>1;
		   $<Input_Stream>$->AddMember($<Stream_Item>2);
		}
	| lexem_stmnt
		{
		   $<Input_Stream>$=new input_stream($<Stream_Item>1);
		}
;

lexem_stmnt: lexem
		{
		   $<Stream_Item>$=new stream_item($<string>1);
		}
	| lexem LEFT_BRACKET lexem RIGHT_BRACKET
		{
		   $<Stream_Item>$=new stream_item($<string>1,$<string>3);
		}
;

action: LEFT_CURLY_BRACKET action_grammar RIGHT_CURLY_BRACKET
		{
		   $<Actions>$=$<Actions>2;
		   log("Action\n");
		}
;

action_grammar: action_grammar action_production
		{
		   log("Adding new Actions\n");
		   $<Actions>$=$<Actions>1;
		   $<Actions>$->AddMember($<Action>2);
		}
	| action_production
		{
		   log("Creating new Actions\n");
		   $<Actions>$=new actions($<Action>1);
		}
;

action_production: action_target EQUAL list_of_action_atoms SEMICOLON
		{
		   log("action_target OK\n");
		   $<Action>$=new action($<Action_Target>1,$<Action_Line>3);
		   log("action_production OK\n");
		}
	| vhdl_action //SEMICOLON
		{
		   log("vhdl_action ok\n");
		   $<VHDLCode>1->AddMember(new vhdl_atom("\n"));
		   log("Adding VHDLCode newline\n");
		   $<Action>$=new action($<VHDLCode>1);
		   log("action_production OK\n");
		}
;

vhdl_action: LEFT_CURLY_BRACKET { ParsingVHDL=true; log("VHDL\n"); } vhdl_code { ParsingVHDL=false; log("VHDL OK\n"); } RIGHT_CURLY_BRACKET
		{
		   sprintf(log_str,"VHDL Action (1) %08x\n",$<VHDLCode>3);
		   log(log_str);
		   log("VHDL Action\n");
		   $<VHDLCode>$=$<VHDLCode>3;
		   log("VHDL Action OK\n");
//		   $<VHDLCode>$->PrintVHDL(error_log);
//		   log("VHDL Action OK (2)\n");
		}
;

vhdl_code: vhdl_code vhdl_atom
		{
		   sprintf(log_str,"vhdl_code (2) %08x\n",$<VHDLCode>1);
		   log(log_str);
		   sprintf(log_str,"vhdl_code (2) %08x\n",$<VHDL_Atom>2);
		   log(log_str);
		   $<VHDLCode>$=$<VHDLCode>1;
		   $<VHDLCode>$->AddMember($<VHDL_Atom>2);
		   sprintf(log_str,"vhdl_code (2) %08x\n",$<VHDLCode>$);
		   log(log_str);
		};
	| vhdl_atom
		{
		   sprintf(log_str,"vhdl_atom (1) %08x\n",$<VHDL_Atom>1);
		   log(log_str);
		   $<VHDLCode>$=new vhdl_code();
		   $<VHDLCode>$->AddMember(new vhdl_atom("            "));
		   $<VHDLCode>$->AddMember($<VHDL_Atom>1);
		}
;

vhdl_atom: STRING
		{
		sprintf(log_str,"STRING %s\n",$<string>1);
		log(log_str);
		   $<VHDL_Atom>$=new vhdl_atom($<string>1);
		 sprintf(log_str,"(STRING) vhdl_atom %08x\n",$<VHDL_Atom>$);
		   log(log_str);
		}
	| NUMBER
		{
		sprintf(log_str,"NUMBER %s\n",$<string>1);
		log(log_str);
		   $<VHDL_Atom>$=new vhdl_atom($<string>1);
		}
	| NEWLINE
		{
		sprintf(log_str,"(newline)\n");
		log(log_str);
		   $<VHDL_Atom>$=new vhdl_atom("\n            ");
		}
	| VARIABLE
		{
		   // Source variable;
		sprintf(log_str,"(VARIABLE)\n");
		log(log_str);
		   $<VHDL_Atom>$=new vhdl_atom($<Variable>1);
		}
;

action_target: lexem
		{
		   $<Action_Target>$=new action_target($<string>1);
		}
	| lexem LEFT_BRACKET lexem RIGHT_BRACKET 
		{
		   $<Action_Target>$=new action_target($<string>1,new action_address(new action_signal($<string>3)));
		}
	| lexem range_statement
		{
		   $<Action_Target>$=new action_target($<string>1,new action_address($<Range>2));
		}
	| lexem LONG_BIT_STRING
		{
		   char *tmp1=FormatBitString($<string>2);
		   if (tmp1==NULL)
		   {
		      sprintf(tmp,"Address for memory access %s at line %d has not been defined\n",$<string>1,program_lines);
		      yyerror2(tmp); return 1;
		   };
		   char *tmp2=catstr("std_logic_vector'(B\"",tmp1);
		   char *tmp3=catstr(tmp2,"\")");
		   $<Action_Target>$=new action_target($<string>1,new action_address(new action_constant(tmp3)));
		   delete tmp1;
		   delete tmp2;
		   delete tmp3;
		}
	| lexem PERIOD number LEFT_BRACKET lexem RIGHT_BRACKET
		{
		   $<Action_Target>$=new action_target($<string>1,$<number>3,new action_address(new action_signal($<string>5)));
		}
	| lexem PERIOD number LONG_BIT_STRING
		{
		   char *tmp1=FormatBitString($<string>4);
		   if (tmp1==NULL)
		   {
		      sprintf(tmp,"Address for memory access %s at line %d has not been defined\n",$<string>1,program_lines);
		      yyerror2(tmp); return 1;
		   };
		   char *tmp2=catstr("std_logic_vector'(B\"",tmp1);
		   char *tmp3=catstr(tmp2,"\")");
		   $<Action_Target>$=new action_target($<string>1,$<number>3,new action_address(new action_constant(tmp3)));
		   delete tmp1;
		   delete tmp2;
		   delete tmp3;
		}
;

list_of_action_atoms: list_of_action_atoms action_atom
		{
		   $<Action_Line>$=$<Action_Line>1;
		   $<Action_Line>$->AddMember($<Action_Item>2);
		}
	| list_of_action_atoms LEFT_BRACKET action_atom RIGHT_BRACKET number
		{
			// this production results in 3 shift-reduce conflicts. It does not help to introduce another hierarchy.
			// I don't understand why...
		   $<Action_Line>$=$<Action_Line>1;
		   for(int i=0;i<$<number>5;i++) 
		   { 
			  $<Action_Line>$->AddMember($<Action_Item>3->Copy());
		   };
		   //sprintf(log_str,"BAKAYARO\n",$<Action_Item>3);
		   //log(log_str);
		   //delete $<Action_Item>3;
		   //log("SKEBE\n");
		}
	| action_atom
		{
		   $<Action_Line>$=new action_line($<Action_Item>1);
		}
	| LEFT_BRACKET action_atom RIGHT_BRACKET number
		{
 		   $<Action_Line>$=new action_line($<Action_Item>2);
		   for(int i=0;i<($<number>4)-1;i++)
		   {
			   $<Action_Line>$->AddMember($<Action_Item>2->Copy());
		   }
		   //delete $<Action_Item>2;
		}
;

action_atom: NOT lexem
		{
		   $<Action_Item>$=new action_item(new action_signal($<string>2,true));
		};
	| lexem LEFT_BRACKET lexem RIGHT_BRACKET
		{
		   $<Action_Item>$=new action_item(new action_signal($<string>1,1,new action_address(new action_signal($<string>3))));
		}
	| lexem LEFT_BRACKET constant RIGHT_BRACKET
		{
		   constant *con=Constants->Member($<string>3);
		   if (con==NULL)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",$<string>1,program_lines);
		      yyerror2(tmp); return 1;
		   }
		   else
		   {
			   $<Action_Item>$=new action_item(new action_signal($<string>1,1,new action_address(new action_constant($<string>3))));
		   };
		}
	| lexem PERIOD number LEFT_BRACKET lexem RIGHT_BRACKET
		{
		   $<Action_Item>$=new action_item(new action_signal($<string>1,$<number>3,new action_address(new action_signal($<string>5))));
		}
	| lexem range_statement
		{
	          $<Action_Item>$=new action_item(new action_signal($<string>1,$<Range>2));
		}
	| lexem
		{
		   // Action macro
		   if (Actions->Member($<string>1)!=NULL)
		   {
		      $<Action_Item>$=new action_item(new action_macro($<string>1));
		   }
		   else
		   {
		      $<Action_Item>$=new action_item(new action_signal($<string>1));
		   };
		}
/*
	| lexem LONG_BIT_STRING
		{
		   char *tmp1=FormatBitString($<string>2);
		   if (tmp1==NULL)
		   {
		      sprintf(tmp,"Address for memory access %s at line %d has not been defined\n",$<string>1,program_lines);
		      yyerror2(tmp); return 1;
			
		   };
		   char *tmp2=catstr("std_logic_vector'(B\"",tmp1);
		   char *tmp3=catstr(tmp2,"\")");
		   $<Action_Item>$=new action_item(new action_signal($<string>1,1,new action_address(new action_constant(tmp3))));
		   delete tmp1;
		   delete tmp2;
		   delete tmp3;
		}
	| lexem PERIOD number LONG_BIT_STRING
		{
		   char *tmp1=FormatBitString($<string>4);
		   if (tmp1==NULL)
		   {
		      sprintf(tmp,"Address for memory access %s at line %d has not been defined\n",$<string>1,program_lines);
		      yyerror2(tmp); return 1;
			
		   };
		   char *tmp2=catstr("std_logic_vector'(B\"",tmp1);
		   char *tmp3=catstr(tmp2,"\")");
		   $<Action_Item>$=new action_item(new action_signal($<string>1,$<number>3,new action_address(new action_constant(tmp3))));
		   delete tmp1;
		   delete tmp2;
		   delete tmp3;
		}
*/
	| if_statement
		{
		   $<Action_Item>$=new action_item($<Action_Mux>1);
		}
//	| ACTION lexem
//		{
//		   // Source variable;
//		   $<Action_Item>$=new action_item(new action_variable($<string>2));
//		}
	| ACTION LESS_THAN lexem GREATER_THAN number
		{
		   // Source variable;
		   sprintf(log_str,"Data field %s (1)\n",$<string>3);
		   log(log_str);
		   $<Action_Item>$=new action_item(new action_variable($<string>3,$<number>5));
		}
	| ACTION LESS_THAN lexem GREATER_THAN number range_statement
		{
		   // Source variable;
		   sprintf(log_str,"Data field %s (2)\n",$<string>3);
		   log(log_str);
		   $<Action_Item>$=new action_item(new action_variable($<string>3,$<number>5,$<Range>6));
		}
	| constant
		{
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 $<string>1)==0)
		      {
		         $<Action_Item>$=new action_item(
				       new action_constant(Constants->Member(i)->Value()));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",$<string>1,program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
	| NOT constant
		{
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 $<string>2)==0)
		      {
		         $<Action_Item>$=new action_item(
				       new action_constant(Negate(Constants->Member(i)->Value())));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",$<string>1,program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
	| bit_string
		{
		   $<Action_Item>$=new action_item(
				 new action_constant(cpystr($<string>1)));
		}
	| hex_number
		{
		   $<Action_Item>$=new action_item(
				 new action_constant($<string>1));
		}
	| LONG_BIT_STRING numeric_expression
		{
		   strcpy(tmp,"");
		   for (i=0;i<$<number>2;i++)
		   {
		      strcat(tmp,$<string>1);
		   };
		   $<Action_Item>$=new action_item(
				 new action_constant(cpystr(tmp)));
		}

	| LONG_HEX_NUMBER numeric_expression
		{
		   strcpy(tmp,"");
		   for (i=0;i<$<number>2;i++)
		   {
		      strcat(tmp,$<string>1);
		   };
		   $<Action_Item>$=new action_item(
				 new action_constant(cpystr(tmp)));
		}
	| LEFT_PARENTHESIS action_expression RIGHT_PARENTHESIS size_statement
		{
		   $<CDFG>2->BitRange($<Range>4);
		   $<Action_Item>$=new action_item($<CDFG>2);
		}
	| LEFT_PARENTHESIS action_expression RIGHT_PARENTHESIS
		{
		   $<Action_Item>$=new action_item($<CDFG>2);
		}
	| error
		{
		   sprintf(tmp,"Expected an Action or a Semicolon at line %d:\n   %s",program_lines,$<string>1);
		   yyerror2(tmp); return 1;
		}
;

size_statement: LEFT_BRACKET number RIGHT_BRACKET
		{
		   $<Range>$=new range_class($<number>2,$<number>2);
		}
	| LEFT_BRACKET number DOUBLE_PERIOD number RIGHT_BRACKET
		{
		   $<Range>$=new range_class($<number>2,$<number>4);
		}
;

if_statement: IF LEFT_PARENTHESIS if_expression RIGHT_PARENTHESIS list_of_action_atoms ELSE list_of_action_atoms ENDIF
		{
		   $<Action_Mux>$=new action_mux($<Mux_Expression>3,$<Action_Line>5,$<Action_Line>7);
		}
;

if_expression: LEFT_PARENTHESIS if_expression RIGHT_PARENTHESIS
		{
		   $<Mux_Expression>$=$<Mux_Expression>2;
		}
	| if_expression AND if_expression
		{
		   $<Mux_Expression>$=new mux_expression(new mux_and($<Mux_Expression>1,$<Mux_Expression>3));
		}
	| condition
		{
		   $<Mux_Expression>$=new mux_expression($<Mux_Condition>1);
		}
;

condition: condition_lexem cond_condition constant_parameters
		{
		   $<Mux_Condition>$=new mux_condition($<Signal>1,$<boolean>2,$<string>3);
		}
	| condition_lexem cond_condition condition_lexem
		{
		   $<Mux_Condition>$=new mux_condition($<Signal>1,$<boolean>2,$<Signal>3);
		}
;

condition_lexem: lexem
		{
		   $<Signal>$=new action_signal($<string>1);
		}
	| lexem range_statement
		{
		   $<Signal>$=new action_signal($<string>1,$<Range>2);
		}
;

action_expression: action_expression ADD action_expression
		{
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember($<CDFG>1); 
		   arg->AddMember($<CDFG>3);
		   $<CDFG>$=new action_cdfg("add",arg);
		}
	| action_expression SUB action_expression
		{
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember($<CDFG>1); 
		   arg->AddMember($<CDFG>3);
		   $<CDFG>$=new action_cdfg("subtract",arg);
		}
	| action_expression MUL action_expression
		{
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember($<CDFG>1); 
		   arg->AddMember($<CDFG>3);
		   $<CDFG>$=new action_cdfg("multiply",arg);
		}
	| action_expression DIV action_expression
		{
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember($<CDFG>1); 
		   arg->AddMember($<CDFG>3);
		   $<CDFG>$=new action_cdfg("divide",arg);
		}
	| action_expression SHR number
		{
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember($<CDFG>1); 
//BUG!!!! Arg 3 har fel typ
		   arg->AddMember($<CDFG>3);
		   $<CDFG>$=new action_cdfg("shift_right",arg);
		}
	| NOT action_expression
		{
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember($<CDFG>2); 
		   $<CDFG>$=new action_cdfg("not",arg);
		}
	| LEFT_PARENTHESIS action_expression RIGHT_PARENTHESIS
		{
		   $<CDFG>$=$<CDFG>2;
		}
	|  number
		{
		   $<CDFG>$=new action_cdfg(new cdfg_constant($<number>1));
		}
	|  constant
		{
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 $<string>1)==0)
		      {
		         $<CDFG>$=new action_cdfg(
				  new cdfg_constant(Constants->
						    Member(i)->
						    Value()));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",$<string>1,program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
//	| ACTION lexem
//		{
//		   $<CDFG>$=new action_cdfg(new cdfg_variable($<string>2));
//		}
	| ACTION LESS_THAN lexem GREATER_THAN number
		{
		   // Source variable;
		   $<CDFG>$=new action_cdfg(new cdfg_variable($<string>3,$<number>5));
		}
	| ACTION LESS_THAN lexem GREATER_THAN number range_statement
		{
		   // Source variable;
		   $<CDFG>$=new action_cdfg(new cdfg_variable($<string>3,$<number>5,$<Range>6));
		}
	| lexem
		{
		   $<CDFG>$=new action_cdfg(new cdfg_signal($<string>1));
		}
	| lexem LEFT_BRACKET lexem RIGHT_BRACKET
		{
		   $<CDFG>$=new action_cdfg(new cdfg_signal($<string>1,new action_address(new action_signal($<string>3))));
		}
	| lexem range_statement
		{
		   cdfg_signal *new_signal;
		   new_signal=new cdfg_signal($<string>1,$<Range>2);
		   $<CDFG>$=new action_cdfg(new_signal);
		}
;

range_statement: LEFT_BRACKET number RIGHT_BRACKET
		{
		   $<Range>$=new range_class($<number>2,$<number>2);
		}
	| LEFT_BRACKET number DOUBLE_PERIOD number RIGHT_BRACKET
		{
		   // MSB-first, i.e., parsed as [TO..FROM] 
		   $<Range>$=new range_class($<number>2,$<number>4);
		}
;

%%

extern int program_lines;
extern FILE *yyin;

void yyerror(char *s)
{
   fprintf(stderr,"\nIn file %s::\n",current_file_name);
   fprintf(stderr,"\n   %s\n",s);
};
void yyerror2(char *s)
{
   fprintf(stderr,"\n   %s\n",s);
};

char *Negate(char *value)
{
   int i;
   char *ret;
   ret=(char *)malloc(strlen(value)+1);
   for(i=0;i<strlen(value);i++)
   {
      if (value[i]=='1')
      {
	 ret[i]='0';
      }
      else
      {
	 ret[i]='1';
      };
   };
   return ret;
};

char *hex2bits(char *s)
{
   sprintf(tmp,"");
   for(i=2;i<strlen(s);i++) 
   {
      switch (int(s[i])-int('0'))
      {
	 case 0:
	    strcat(tmp,"0000"); break;
	 case 1:
	    strcat(tmp,"0001"); break;
	 case 2:
	    strcat(tmp,"0010"); break;
	 case 3:
	    strcat(tmp,"0011"); break;
	 case 4:
	    strcat(tmp,"0100"); break;
	 case 5:
	    strcat(tmp,"0101"); break;
	 case 6:
	    strcat(tmp,"0110"); break;
	 case 7:
	    strcat(tmp,"0111"); break;
	 case 8:
	    strcat(tmp,"1000"); break;
	 case 9:
	    strcat(tmp,"1001"); break;
	 case 17:
	    strcat(tmp,"1010"); break;
	 case 18:
	    strcat(tmp,"1011"); break;
	 case 19:
	    strcat(tmp,"1100"); break;
	 case 20:
	    strcat(tmp,"1101"); break;
	 case 21:
	    strcat(tmp,"1110"); break;
	 case 22:
	    strcat(tmp,"1111"); break;
      };
   };
   return tmp;
};




