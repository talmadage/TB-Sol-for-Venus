typedef union {
   char *String;
   int Number;
   parsed_cube *Cube;
   parsed_cubes *Cubes;
   parsed_labels *Labels;
} YYSTYPE;
#define	CUBE	258
#define	INPUT_LABELS	259
#define	OUTPUT_LABELS	260
#define	INPUT_MARKER	261
#define	OUTPUT_MARKER	262
#define	PRODUCT_MARKER	263
#define	END_MARKER	264
#define	STRING	265
#define	BIT_STRING	266
#define	NUMBER	267


extern YYSTYPE espresso_lval;
