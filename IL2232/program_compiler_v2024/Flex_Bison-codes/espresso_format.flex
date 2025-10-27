LCASE		[a-z01-9]
BITS		[01\-~]
DEC             [01-9]

 #include "espresso_format.h"
 #include "espresso_format.yy.tab.h"

 int espresso_lines=1;
 #define yylval espresso_lval

%%
".ilb"	return INPUT_LABELS;
".ob"	return OUTPUT_LABELS;
".i"	return INPUT_MARKER;
".o"	return OUTPUT_MARKER;
".p"	return PRODUCT_MARKER;
".e"	return END_MARKER;

{BITS}+		yylval.String = cpystr(yytext); return BIT_STRING;
{DEC}+          yylval.Number = atoi(yytext); return NUMBER;
{LCASE}+	yylval.String = cpystr(yytext); return STRING;

[" "\t]+        /* eat up whitespace */
\n              ++espresso_lines; /* eat up newlines */
.               {
		   fprintf(error_log,"\n Unknown Keyword %s at line %d\n", yytext,espresso_lines);
		   exit(1);
                };
%%

int yywrap(void)
{
   return 1;
};
