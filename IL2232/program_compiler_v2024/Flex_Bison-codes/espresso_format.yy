%{
   #include <string.h>
   #include <stdlib.h>
   #include <malloc.h>
   #include "lib/rli_string.h"
   #include "espresso_format.h"

   // List of prototypes
   extern void yyerror(char *s);
   extern int espresso_lex(void);
   extern int espresso_lines;

   extern parsed_cubes *Function;
   extern parsed_labels *InputLabels;
   extern parsed_labels *OutputLabels;
%}
%union {
   char *String;
   int Number;
   parsed_cube *Cube;
   parsed_cubes *Cubes;
   parsed_labels *Labels;
};

%token CUBE
%token INPUT_LABELS
%token OUTPUT_LABELS
%token INPUT_MARKER
%token OUTPUT_MARKER
%token PRODUCT_MARKER
%token END_MARKER
%token STRING
%token BIT_STRING
%token NUMBER

%start input
%%
input: /* Empty line */
	| input file
;

file: input_declaration output_declaration product_declaration
		{
		   int i;
		   Function=$<Cubes>3;
		   InputLabels=new parsed_labels();
		   OutputLabels=new parsed_labels();
		   for(i=0;i<Function->NrOfMembers();i++)
		   {
		      if (Function->Member(i)->NrOfInputs()!=$<Number>1)
		      {
			 fprintf(error_log,"Error: Input Cube size mismatch at cube %d\n",i);
			 exit(1);
		      };
		      if (Function->Member(i)->NrOfOutputs()!=$<Number>2)
		      {
			 fprintf(error_log,"Error: Output Cube %d size mismatch at cube %d\n",i);
			 exit(1);
		      };
		   };
		}
	| input_declaration output_declaration input_labels output_labels product_declaration
		{
		   int i;
		   Function=$<Cubes>5;
		   InputLabels=$<Labels>3;
		   OutputLabels=$<Labels>4;
		   if (InputLabels->NrOfMembers()!=$<Number>1)
		   {
		      fprintf(error_log,"Error: Nr of labels (%d) do not match number of inputs (%d)\n",InputLabels->NrOfMembers(),$<Number>1);
		   };
		   if (OutputLabels->NrOfMembers()!=$<Number>2)
		   {
		      fprintf(error_log,"Error: Nr of labels (%d) do not match number of outputs (%d)\n",OutputLabels->NrOfMembers(),$<Number>2);
		   };
		   for(i=0;i<Function->NrOfMembers();i++)
		   {
		      if (Function->Member(i)->NrOfInputs()!=$<Number>1)
		      {
			 fprintf(error_log,"Error: Input Cube size mismatch at cube %d\n",i);
			 exit(1);
		      };
		      if (Function->Member(i)->NrOfOutputs()!=$<Number>2)
		      {
			 fprintf(error_log,"Error: Output Cube %d size mismatch at cube %d\n",i);
			 exit(1);
		      };
		   };
		}
;

input_declaration: INPUT_MARKER number
		{
		   $<Number>$=$<Number>2;
		}
;
output_declaration: OUTPUT_MARKER number
		{
		   $<Number>$=$<Number>2;
		}
;

input_labels: INPUT_LABELS list_of_strings
		{
		   $<Labels>$=$<Labels>2;
		};

output_labels: OUTPUT_LABELS list_of_strings
		{
		   $<Labels>$=$<Labels>2;
		};

list_of_strings:list_of_strings STRING
		{
		   $<Labels>$=$<Labels>1;
		   $<Labels>$->AddMember($<String>2);
		}
	| STRING
		{
		   $<Labels>$=new parsed_labels($<String>1);
		}
;

product_declaration: PRODUCT_MARKER number product_lines END_MARKER
		{
		   if ($<Cubes>3->NrOfMembers()!=$<Number>2)
		   {
		      fprintf(error_log,"Error: Number of Cubes mismatch.\n");
		      fprintf(error_log,"Found: %d, Specified: %d\n",$<Cubes>3->NrOfMembers(),$<Number>2);
		   };
		   $<Cubes>$=$<Cubes>3;
		}
;

product_lines:product_lines product_line
		{
		   $<Cubes>$=$<Cubes>1;
		   $<Cubes>$->AddMember($<Cube>2);
		}
	| product_line
		{
		   $<Cubes>$=new parsed_cubes($<Cube>1);
		}
;

product_line: BIT_STRING BIT_STRING
		{
		   $<Cube>$=new parsed_cube($<String>1,$<String>2);
		   delete $<String>1;
		   delete $<String>2;
		}
;

number: NUMBER
		{
		   $<Number>$=$<Number>1;
		}
	| BIT_STRING // In case of only 0's and 1's
		{
		   $<Number>$=atoi($<String>1);
		   delete $<String>1;
		}
;

%%

extern int espresso_lines;
extern FILE *yyin;

void yyerror(char *s)
{
   fprintf(error_log,"\nError at line %d: %s\n",espresso_lines,s);
};
