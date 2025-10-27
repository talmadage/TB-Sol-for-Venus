typedef union {
   char *string;
   Dyn_Var *Var;
   Dyn_Object *Object;
   Dyn_Tuple *Tuple;
} YYSTYPE;
#define	STRING	258
#define	COMMENT	259
#define	LEFT_PARENTHESIS	260
#define	RIGHT_PARENTHESIS	261
#define	SEMICOLON	262
#define	COMMA	263


extern YYSTYPE external_lval;
