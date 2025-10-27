typedef union {
   char *string;
   Technology *tech;
   Module *module;
   Modules *modules;
   Port *port;
   Ports *ports;
   Dyn_Var *var;
   Dyn_Object *object;
   Dyn_Tuple *tuple;
} YYSTYPE;
#define	SYSTEM	258
#define	MODULES	259
#define	INPUTS	260
#define	OUTPUTS	261
#define	NAME	262
#define	FROM	263
#define	TO	264
#define	STRING	265
#define	COMMENT	266
#define	LEFT_PARENTHESIS	267
#define	RIGHT_PARENTHESIS	268
#define	SEMICOLON	269
#define	COMMA	270


extern YYSTYPE technology_lval;
