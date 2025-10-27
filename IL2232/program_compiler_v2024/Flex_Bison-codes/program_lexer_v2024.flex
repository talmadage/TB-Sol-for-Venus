UPPER_CASE 	[A-Z01-9_]
MIXED_CASE 	[A-Za-z01-9_]
BITS		[01ZM]
LONG_BITS	[01 ]
DEC		[01-9]
HEX		[01-9A-F ]
FILE_CHAR	[01-9A-Za-z._/~\-]

 #include <io.h>
 // #define isatty _isatty 
 //#define WINVER 0x0601
 
 //%option nounistd
 #include "program.h"
 #include "program_parser_v2020.tab.hh"

 int program_lines=1;

 #define yylval program_lval

 #define MAX_INCLUDE_DEPTH 20
 YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
 int line_ptr_stack[MAX_INCLUDE_DEPTH];
 int include_stack_ptr=0;

 extern bool ParsingVHDL;
 extern bool DEMO_MODE;

/*
 #define yylex program_lex
 #define yyin program_in
 #define yyout program_out
 #define yy_init_buffer program_init_buffer
 #define yy_create_buffer program_create_buffer
 #define yy_load_buffer_state program_load_buffer_state
 #define yyrestart program_restart
 #define yy_switch_to_buffer program_switch_to_buffer
 #define yy_delete_buffer program_delete_buffer
*/
%x comment
%x include
%x target
%x vhdl
%%

		if (ParsingVHDL) BEGIN(vhdl);
<vhdl>"}"	{ BEGIN(INITIAL); return RIGHT_CURLY_BRACKET; };
<vhdl>"$<"{MIXED_CASE}+">"{DEC}+	{
			   int where=find(yytext,'>',0);
			   yylval.Variable=new action_variable(
						midstr(yytext,2,where-2),
						atoi(midstr(yytext,where+1,strlen(yytext)-where)));
			   return VARIABLE;
			};
<vhdl>[^$\n\}]*	{ yylval.string=cpystr(yytext); return STRING; };
<vhdl>\n	{ program_lines++; return NEWLINE; };

"/*"		BEGIN(comment);
<comment>[^*\n]* /* eat up anything that is not a * or a newline */
<comment>"*"+[^/\n]* /* eat up '*'s not followed by '/'s */
<comment>\n	program_lines++;
<comment><<EOF>> { fprintf(error_log,"Unexpected end of file inside comment\n"); exit(1); };
<comment>"*"+"/" BEGIN(INITIAL);

"%include"	{ BEGIN(include); return INCLUDE; };
"%include-text" { BEGIN(include); return INCLUDE_TEXT; };
<include>[" "\t]* /* eat up whitespace */
<include>"<"{FILE_CHAR}+">" { /* Catch the file name */
		    if (include_stack_ptr>=MAX_INCLUDE_DEPTH)
		    {
		       fprintf(error_log,"Includes nested too deeply\n");
		       exit(1);
		    };
		    include_stack[include_stack_ptr]=YY_CURRENT_BUFFER;
		    line_ptr_stack[include_stack_ptr++]=program_lines;
		    char *file_name=midstr(yytext,1,strlen(yytext)-2);
		    yyin=fopen(file_name,"r");
		    if (!yyin)
		    {
		       fprintf(error_log,"Cannot find include file %s\n",file_name);
		       exit(1);
		    }
		    yylval.string=file_name;
		    program_lines=1;
		    yy_switch_to_buffer(yy_create_buffer(yyin,YY_BUF_SIZE));
		    BEGIN(INITIAL); 
		    return FILE_NAME;
		};
<include>"<"{FILE_CHAR}+ { yylval.string=cpystr(yytext); return ERROR; };
<include>{FILE_CHAR}+">" { yylval.string=cpystr(yytext); return ERROR; };
<include>.	yylval.string=cpystr(yytext); return ERROR; // Anything else

"%{"		BEGIN(target); return TARGET_CODE_START;
<target>"%}"	BEGIN(INITIAL); return TARGET_CODE_END;
<target>[^\n]*	yylval.string=cpystr(yytext); return STRING;
<target>[\n]	program_lines++;

"%input"	return INPUT;
"%inout"	return INOUT;
"%internal"	return INTERNAL;
"%output"	return OUTPUT;
"%name"		return NAME;
"%memory"	return MEMORY;
"%start"	return START;

hw		return HW;
sw		return SW;
memory		return DRIVER_MEMORY;
rate		return RATE;
kbps		return KBPS;
Mbps		return MBPS;
Gbps		return GBPS;
kHz		return KHZ;
MHz		return MHZ;
GHz		return GHZ;
range		return RANGE;
to		return TO;
clock		return CLOCK;
asynch_reset	return ASYNCH_RESET;
synch_reset	return SYNCH_RESET;
"@"		return AT;

bit		return BIT;
others		return OTHERS;
error		return ERROR;
break		return BREAK;
interrupt	return INTERRUPT;
reset		return RESET;
sync		return SYNC;
cond		return COND;
if		return IF;
else		return ELSE;
endif		return ENDIF;

{BITS}+		yylval.string = yytext; return BIT_STRING;
"["{LONG_BITS}+"]"	yylval.string = midstr(yytext,1,strlen(yytext)-2); return LONG_BIT_STRING;
H'{HEX}+	yylval.string = yytext; return HEX_NUMBER;
"["H'{HEX}+"]"	yylval.string = midstr(yytext,1,strlen(yytext)-2); return LONG_HEX_NUMBER;
{DEC}+		yylval.string = yytext; return NUMBER;
{UPPER_CASE}+	yylval.string = yytext; return CONSTANT;
{MIXED_CASE}+	yylval.string = yytext; return LEXEM;
"["		return LEFT_BRACKET;
"]"		return RIGHT_BRACKET;
"("		return LEFT_PARENTHESIS;
")"		return RIGHT_PARENTHESIS;
"{"		return LEFT_CURLY_BRACKET;
"}"		return RIGHT_CURLY_BRACKET;

"%%"		return CODE_START;
";"		return SEMICOLON;
":"		return COLON;
"|"		return OR;
"&"		return AND;
"&&"		return COND_AND;
"="		return EQUAL;
"!="		return NOT_EQUAL;
".."		return DOUBLE_PERIOD;
"."		return PERIOD;
"<"		return LESS_THAN;
">"		return GREATER_THAN;

"$"		return ACTION;

"+"		return ADD;
"-"		return SUB;
"*"		return MUL;
"/"		return DIV;
">>"		return SHR;

"^"		return NOT;

"//"[^\n]*	/* eat up comments */
[" "\t]+	/* eat up whitespace */
\n		{ ++program_lines; /* eat up newlines */
		  if (DEMO_MODE)
		  {
			if (program_lines>2000)
			{
				printf("Number of lines in Demo mode (2000) exceeded\n");
				exit(1);
			}
		  }
		  if (ParsingVHDL) return NEWLINE;
		};
\015		/* eat up carridge returns (ASCII 0d) in DOS-files */
. 		{ printf("\n Unknown Keyword %s",yylval.string = yytext);
		  return ERROR; };

<<EOF>>		{ /* Found an end of file */
		  if (--include_stack_ptr<0)
		  {
		     yyterminate();
		  }
		  else
		  {
		     FILE *tmp;
		     tmp=yyin;
		     yy_switch_to_buffer(include_stack[include_stack_ptr]);
		     program_lines=line_ptr_stack[include_stack_ptr];
		     fclose(tmp);
		  };
		  return END_OF_FILE;
		};
%%

int yywrap(void)
{
   return 1;
};
