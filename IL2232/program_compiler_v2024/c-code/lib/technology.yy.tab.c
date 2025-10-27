
/*  A Bison parser, made from technology.yy  */

#define YYBISON 1  /* Identify Bison output.  */

#define yyparse technology_parse
#define yylex technology_lex
#define yyerror technology_error
#define yylval technology_lval
#define yychar technology_char
#define yydebug technology_debug
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

#line 1 "technology.yy"


#define yynerrs technology_nerrs
  
#include <string.h>
#include <malloc.h>
#include <stdlib.h>
#include "lib/technology.h"
#include "lib/rli_string.h"

   Technology *technology_file=NULL;
   int nr_of_options=0;
   extern int technology_lines; 
   extern int technology_lex(); 
   extern int technology_error(char *s); 
   char *tmp;

#line 18 "technology.yy"
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

#ifndef YYLTYPE
typedef
  struct yyltype
    {
      int timestamp;
      int first_line;
      int first_column;
      int last_line;
      int last_column;
      char *text;
   }
  yyltype;

#define YYLTYPE yyltype
#endif

#include <stdio.h>

#ifndef __STDC__
#define const
#endif



#define	YYFINAL		91
#define	YYFLAG		-32768
#define	YYNTBASE	16

#define YYTRANSLATE(x) ((unsigned)(x) <= 270 ? yytranslate[x] : 38)

static const char yytranslate[] = {     0,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     1,     2,     3,     4,     5,
     6,     7,     8,     9,    10,    11,    12,    13,    14,    15
};

#if YYDEBUG != 0
static const short yyprhs[] = {     0,
     0,     1,     4,     7,    10,    13,    19,    25,    30,    34,
    37,    39,    41,    45,    49,    52,    57,    61,    63,    74,
    79,    84,    88,    90,   101,   105,   107,   109,   111,   113,
   116,   119,   122,   126,   129,   133,   136,   138,   142,   146,
   149,   151,   153,   155
};

#endif

static const short yyrhs[] = {    -1,
    16,    11,     0,    16,    17,     0,    18,    14,     0,    18,
     1,     0,    19,    12,    20,    21,    13,     0,    19,    12,
    20,    21,     1,     0,    19,    12,    20,     1,     0,    19,
    12,     1,     0,    19,     1,     0,     1,     0,    10,     0,
     3,    33,    14,     0,     3,    33,     1,     0,     3,     1,
     0,     4,    12,    22,    13,     0,    22,    15,    23,     0,
    23,     0,    12,     7,    19,    14,    24,    14,    25,    14,
    28,    13,     0,     5,    12,    26,    13,     0,     6,    12,
    26,    13,     0,    26,    15,    27,     0,    27,     0,    12,
     7,    19,    14,     8,    19,    14,     9,    19,    13,     0,
    28,    14,    29,     0,    29,     0,    30,     0,    31,     0,
    32,     0,    19,    19,     0,    19,    33,     0,    19,    35,
     0,    12,    34,    13,     0,    12,    13,     0,    34,    14,
    29,     0,    34,     1,     0,    29,     0,    12,    36,    13,
     0,    36,    15,    37,     0,    36,     1,     0,    37,     0,
    19,     0,    33,     0,    35,     0
};

#if YYDEBUG != 0
static const short yyrline[] = { 0,
    51,    52,    53,    56,    60,    66,    71,    75,    79,    83,
    87,    94,   100,   104,   108,   114,   120,   125,   131,   143,
   149,   155,   160,   166,   172,   177,   183,   187,   191,   197,
   203,   209,   215,   219,   225,   230,   234,   240,   246,   251,
   255,   261,   265,   269
};

static const char * const yytname[] = {   "$","error","$illegal.","SYSTEM","MODULES",
"INPUTS","OUTPUTS","NAME","FROM","TO","STRING","COMMENT","LEFT_PARENTHESIS",
"RIGHT_PARENTHESIS","SEMICOLON","COMMA","start","technology","tech_object","string",
"system","modules","module_list","module","inputs","outputs","port_list","port_option",
"user_options","structure","single","named_object","named_tuple","object","object_list",
"tuple","list_of_atoms","atom",""
};
#endif

static const short yyr1[] = {     0,
    16,    16,    16,    17,    17,    18,    18,    18,    18,    18,
    18,    19,    20,    20,    20,    21,    22,    22,    23,    24,
    25,    26,    26,    27,    28,    28,    29,    29,    29,    30,
    31,    32,    33,    33,    34,    34,    34,    35,    36,    36,
    36,    37,    37,    37
};

static const short yyr2[] = {     0,
     0,     2,     2,     2,     2,     5,     5,     4,     3,     2,
     1,     1,     3,     3,     2,     4,     3,     1,    10,     4,
     4,     3,     1,    10,     3,     1,     1,     1,     1,     2,
     2,     2,     3,     2,     3,     2,     1,     3,     3,     2,
     1,     1,     1,     1
};

static const short yydefact[] = {     1,
     0,    11,    12,     2,     3,     0,     0,     5,     4,    10,
     0,     9,     0,     0,    15,     0,     0,     8,     0,     0,
    34,     0,    37,    27,    28,    29,     0,    14,    13,     0,
     7,     6,     0,    30,    31,    32,    36,    33,     0,     0,
     0,    18,    42,    43,    44,     0,    41,    35,     0,    16,
     0,    40,    38,     0,     0,    17,    42,    39,     0,     0,
     0,     0,     0,     0,     0,    23,     0,     0,     0,    20,
     0,     0,     0,     0,    22,     0,     0,    26,     0,    21,
    19,     0,     0,    25,     0,     0,     0,     0,    24,     0,
     0
};

static const short yydefgoto[] = {     1,
     5,     6,    22,    14,    20,    41,    42,    61,    68,    65,
    66,    77,    23,    24,    25,    26,    35,    27,    36,    46,
    47
};

static const short yypact[] = {-32768,
    26,-32768,-32768,-32768,-32768,     9,    27,-32768,-32768,-32768,
    12,-32768,    28,    10,-32768,    20,    11,-32768,    19,     4,
-32768,    35,-32768,-32768,-32768,-32768,     6,-32768,-32768,    22,
-32768,-32768,    -4,-32768,-32768,-32768,-32768,-32768,    31,    39,
    36,-32768,    35,-32768,-32768,     3,-32768,-32768,    31,-32768,
    22,-32768,-32768,    35,    24,-32768,-32768,-32768,    50,    47,
    46,    49,    56,    57,    37,-32768,    51,    52,    31,-32768,
    49,    49,    31,    53,-32768,    41,    44,-32768,    61,-32768,
-32768,    31,    31,-32768,    58,    62,    31,    60,-32768,    65,
-32768
};

static const short yypgoto[] = {-32768,
-32768,-32768,    -1,-32768,-32768,-32768,    23,-32768,-32768,    -2,
     5,-32768,   -38,-32768,-32768,-32768,   -11,-32768,   -30,-32768,
    21
};


#define	YYLAST		86


static const short yytable[] = {     7,
    48,    17,    45,    52,    31,     3,    37,    33,    21,     8,
    18,    28,    12,    19,    13,    53,    32,    54,    38,    39,
    34,    44,     9,    45,    29,    90,     2,    10,    15,     3,
    30,    43,    21,    40,    78,     3,     4,    59,    11,    16,
     3,    34,    44,    84,     3,    49,    33,    55,    50,    70,
    51,    71,    57,    80,    60,    71,    81,    82,    62,    63,
    64,    67,    72,    69,    91,    73,    79,    74,    83,    76,
    87,    86,    89,    56,    58,    75,     0,     0,     0,     0,
     0,    85,     0,     0,     0,    88
};

static const short yycheck[] = {     1,
    39,    13,    33,     1,     1,    10,     1,    12,    13,     1,
     1,     1,     1,     4,     3,    13,    13,    15,    13,    14,
    22,    33,    14,    54,    14,     0,     1,     1,     1,    10,
    12,    33,    13,    12,    73,    10,    11,    14,    12,    12,
    10,    43,    54,    82,    10,     7,    12,    49,    13,    13,
    15,    15,    54,    13,     5,    15,    13,    14,    12,    14,
    12,     6,    12,     7,     0,    14,    14,    69,     8,    72,
     9,    14,    13,    51,    54,    71,    -1,    -1,    -1,    -1,
    -1,    83,    -1,    -1,    -1,    87
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "/usr/local/lib/bison.simple"

/* Skeleton output parser for bison,
   Copyright (C) 1984, 1989, 1990 Bob Corbett and Richard Stallman

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 1, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */


#ifndef alloca
#ifdef __GNUC__
#define alloca __builtin_alloca
#else /* not GNU C.  */
#if (!defined (__STDC__) && defined (sparc)) || defined (__sparc__) || defined (__sparc)
#include <alloca.h>
#else /* not sparc */
#if defined (MSDOS) && !defined (__TURBOC__)
#include <malloc.h>
#else /* not MSDOS, or __TURBOC__ */
#if defined(_AIX)
#include <malloc.h>
 #pragma alloca
#endif /* not _AIX */
#endif /* not MSDOS, or __TURBOC__ */
#endif /* not sparc.  */
#endif /* not GNU C.  */
#endif /* alloca not defined.  */

/* This is the parser code that is written into each bison parser
  when the %semantic_parser declaration is not specified in the grammar.
  It was written by Richard Stallman by simplifying the hairy parser
  used when %semantic_parser is specified.  */

/* Note: there must be only one dollar sign in this file.
   It is replaced by the list of actions, each action
   as one case of the switch.  */

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	return(0)
#define YYABORT 	return(1)
#define YYERROR		goto yyerrlab1
/* Like YYERROR except do call yyerror.
   This remains here temporarily to ease the
   transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */
#define YYFAIL		goto yyerrlab
#define YYRECOVERING()  (!!yyerrstatus)
#define YYBACKUP(token, value) \
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    { yychar = (token), yylval = (value);			\
      yychar1 = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { yyerror ("syntax error: cannot back up"); YYERROR; }	\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

#ifndef YYPURE
#define YYLEX		yylex()
#endif

#ifdef YYPURE
#ifdef YYLSP_NEEDED
#define YYLEX		yylex(&yylval, &yylloc)
#else
#define YYLEX		yylex(&yylval)
#endif
#endif

/* If nonreentrant, generate the variables here */

#ifndef YYPURE

int	yychar;			/*  the lookahead symbol		*/
YYSTYPE	yylval;			/*  the semantic value of the		*/
				/*  lookahead symbol			*/

#ifdef YYLSP_NEEDED
YYLTYPE yylloc;			/*  location data for the lookahead	*/
				/*  symbol				*/
#endif

int yynerrs;			/*  number of parse errors so far       */
#endif  /* not YYPURE */

#if YYDEBUG != 0
int yydebug;			/*  nonzero means print parse trace	*/
/* Since this is uninitialized, it does not stop multiple parsers
   from coexisting.  */
#endif

/*  YYINITDEPTH indicates the initial size of the parser's stacks	*/

#ifndef	YYINITDEPTH
#define YYINITDEPTH 200
#endif

/*  YYMAXDEPTH is the maximum size the stacks can grow to
    (effective only if the built-in stack extension method is used).  */

#if YYMAXDEPTH == 0
#undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
#define YYMAXDEPTH 10000
#endif

#if __GNUC__ > 1		/* GNU C and GNU C++ define this.  */
#define __yy_bcopy(FROM,TO,COUNT)	__builtin_memcpy(TO,FROM,COUNT)
#else				/* not GNU C or C++ */
#ifndef __cplusplus

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_bcopy (from, to, count)
     char *from;
     char *to;
     int count;
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#else /* __cplusplus */

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_bcopy (char *from, char *to, int count)
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#endif
#endif

#line 169 "/usr/local/lib/bison.simple"
int
yyparse()
{
  register int yystate;
  register int yyn;
  register short *yyssp;
  register YYSTYPE *yyvsp;
  int yyerrstatus;	/*  number of tokens to shift before error messages enabled */
  int yychar1;		/*  lookahead token as an internal (translated) token number */

  short	yyssa[YYINITDEPTH];	/*  the state stack			*/
  YYSTYPE yyvsa[YYINITDEPTH];	/*  the semantic value stack		*/

  short *yyss = yyssa;		/*  refer to the stacks thru separate pointers */
  YYSTYPE *yyvs = yyvsa;	/*  to allow yyoverflow to reallocate them elsewhere */

#ifdef YYLSP_NEEDED
  YYLTYPE yylsa[YYINITDEPTH];	/*  the location stack			*/
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;

#define YYPOPSTACK   (yyvsp--, yyssp--, yylsp--)
#else
#define YYPOPSTACK   (yyvsp--, yyssp--)
#endif

  int yystacksize = YYINITDEPTH;

#ifdef YYPURE
  int yychar;
  YYSTYPE yylval;
  int yynerrs;
#ifdef YYLSP_NEEDED
  YYLTYPE yylloc;
#endif
#endif

  YYSTYPE yyval;		/*  the variable used to return		*/
				/*  semantic values from the action	*/
				/*  routines				*/

  int yylen;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Starting parse\n");
#endif

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss - 1;
  yyvsp = yyvs;
#ifdef YYLSP_NEEDED
  yylsp = yyls;
#endif

/* Push a new state, which is found in  yystate  .  */
/* In all cases, when you get here, the value and location stacks
   have just been pushed. so pushing a state here evens the stacks.  */
yynewstate:

  *++yyssp = yystate;

  if (yyssp >= yyss + yystacksize - 1)
    {
      /* Give user a chance to reallocate the stack */
      /* Use copies of these so that the &'s don't force the real ones into memory. */
      YYSTYPE *yyvs1 = yyvs;
      short *yyss1 = yyss;
#ifdef YYLSP_NEEDED
      YYLTYPE *yyls1 = yyls;
#endif

      /* Get the current used size of the three stacks, in elements.  */
      int size = yyssp - yyss + 1;

#ifdef yyoverflow
      /* Each stack pointer address is followed by the size of
	 the data in use in that stack, in bytes.  */
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
#ifdef YYLSP_NEEDED
		 &yyls1, size * sizeof (*yylsp),
#endif
		 &yystacksize);

      yyss = yyss1; yyvs = yyvs1;
#ifdef YYLSP_NEEDED
      yyls = yyls1;
#endif
#else /* no yyoverflow */
      /* Extend the stack our own way.  */
      if (yystacksize >= YYMAXDEPTH)
	{
	  yyerror("parser stack overflow");
	  return 2;
	}
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;
      yyss = (short *) alloca (yystacksize * sizeof (*yyssp));
      __yy_bcopy ((char *)yyss1, (char *)yyss, size * sizeof (*yyssp));
      yyvs = (YYSTYPE *) alloca (yystacksize * sizeof (*yyvsp));
      __yy_bcopy ((char *)yyvs1, (char *)yyvs, size * sizeof (*yyvsp));
#ifdef YYLSP_NEEDED
      yyls = (YYLTYPE *) alloca (yystacksize * sizeof (*yylsp));
      __yy_bcopy ((char *)yyls1, (char *)yyls, size * sizeof (*yylsp));
#endif
#endif /* no yyoverflow */

      yyssp = yyss + size - 1;
      yyvsp = yyvs + size - 1;
#ifdef YYLSP_NEEDED
      yylsp = yyls + size - 1;
#endif

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Stack size increased to %d\n", yystacksize);
#endif

      if (yyssp >= yyss + yystacksize - 1)
	YYABORT;
    }

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Entering state %d\n", yystate);
#endif

  goto yybackup;
 yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* yychar is either YYEMPTY or YYEOF
     or a valid token in external form.  */

  if (yychar == YYEMPTY)
    {
#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Reading a token: ");
#endif
      yychar = YYLEX;
    }

  /* Convert token to internal form (in yychar1) for indexing tables with */

  if (yychar <= 0)		/* This means end of input. */
    {
      yychar1 = 0;
      yychar = YYEOF;		/* Don't call YYLEX any more */

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Now at end of input.\n");
#endif
    }
  else
    {
      yychar1 = YYTRANSLATE(yychar);

#if YYDEBUG != 0
      if (yydebug)
	{
	  fprintf (stderr, "Next token is %d (%s", yychar, yytname[yychar1]);
	  /* Give the individual parser a way to print the precise meaning
	     of a token, for further debugging info.  */
#ifdef YYPRINT
	  YYPRINT (stderr, yychar, yylval);
#endif
	  fprintf (stderr, ")\n");
	}
#endif
    }

  yyn += yychar1;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != yychar1)
    goto yydefault;

  yyn = yytable[yyn];

  /* yyn is what to do for this token type in this state.
     Negative => reduce, -yyn is rule number.
     Positive => shift, yyn is new state.
       New state is final state => don't bother to shift,
       just return success.
     0, or most negative number => error.  */

  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrlab;

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting token %d (%s), ", yychar, yytname[yychar1]);
#endif

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  /* count tokens shifted since error; after three, turn off error status.  */
  if (yyerrstatus) yyerrstatus--;

  yystate = yyn;
  goto yynewstate;

/* Do the default action for the current state.  */
yydefault:

  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;

/* Do a reduction.  yyn is the number of a rule to reduce with.  */
yyreduce:
  yylen = yyr2[yyn];
  yyval = yyvsp[1-yylen]; /* implement default value of the action */

#if YYDEBUG != 0
  if (yydebug)
    {
      int i;

      fprintf (stderr, "Reducing via rule %d (line %d), ",
	       yyn, yyrline[yyn]);

      /* Print the symbols being reduced, and their result.  */
      for (i = yyprhs[yyn]; yyrhs[i] > 0; i++)
	fprintf (stderr, "%s ", yytname[yyrhs[i]]);
      fprintf (stderr, " -> %s\n", yytname[yyr1[yyn]]);
    }
#endif


  switch (yyn) {

case 4:
#line 57 "technology.yy"
{
		   technology_file=yyvsp[-1].tech;
		;
    break;}
case 5:
#line 61 "technology.yy"
{
		   yyerror(" Semicolon Expected");
		;
    break;}
case 6:
#line 67 "technology.yy"
{
		   yyval.tech=new Technology(yyvsp[-4].string,yyvsp[-2].object,
				      	    yyvsp[-1].modules);
		;
    break;}
case 7:
#line 72 "technology.yy"
{
		   yyerror(" Right Parenthesis Expected");
		;
    break;}
case 8:
#line 76 "technology.yy"
{
		   yyerror(" Module Declaration Expected");
		;
    break;}
case 9:
#line 80 "technology.yy"
{
		   yyerror(" System Declaration Expected");
		;
    break;}
case 10:
#line 84 "technology.yy"
{
		   yyerror(" Left Parenthesis Expected");
		;
    break;}
case 11:
#line 88 "technology.yy"
{
		   tmp=catstr(" Unknown Symbol %s",yyvsp[0].string);
		   yyerror(tmp);
		;
    break;}
case 12:
#line 95 "technology.yy"
{
		   yyval.string=cpystr(yyvsp[0].string);
		;
    break;}
case 13:
#line 101 "technology.yy"
{
		   yyval.object=yyvsp[-1].object;
		;
    break;}
case 14:
#line 105 "technology.yy"
{
		   yyerror(" Semicolon Expected");
		;
    break;}
case 15:
#line 109 "technology.yy"
{
		   yyerror(" String, Object or List Declaration Expected");
		;
    break;}
case 16:
#line 115 "technology.yy"
{
		   yyval.modules=yyvsp[-1].modules;
		;
    break;}
case 17:
#line 121 "technology.yy"
{
		   yyval.modules=yyvsp[-2].modules;
		   yyval.modules->AddMember(yyvsp[0].module);
		;
    break;}
case 18:
#line 126 "technology.yy"
{
		   yyval.modules=new Modules(yyvsp[0].module);
		;
    break;}
case 19:
#line 135 "technology.yy"
{
		   yyval.module=new Module(yyvsp[-7].string,
					 yyvsp[-5].ports,
					 yyvsp[-3].ports,
					 yyvsp[-1].object);
		;
    break;}
case 20:
#line 144 "technology.yy"
{
		   yyval.ports=yyvsp[-1].ports;
		;
    break;}
case 21:
#line 150 "technology.yy"
{
		   yyval.ports=yyvsp[-1].ports;
		;
    break;}
case 22:
#line 156 "technology.yy"
{
		   yyval.ports=yyvsp[-2].ports;
		   yyval.ports->AddMember(yyvsp[0].port);
		;
    break;}
case 23:
#line 161 "technology.yy"
{
		   yyval.ports=new Ports(yyvsp[0].port);
		;
    break;}
case 24:
#line 167 "technology.yy"
{
		   yyval.port=new Port(yyvsp[-7].string,yyvsp[-4].string,yyvsp[-1].string);
		;
    break;}
case 25:
#line 173 "technology.yy"
{
		   yyval.object=yyvsp[-2].object;
		   yyval.object->AddMember(yyvsp[0].var);
		;
    break;}
case 26:
#line 178 "technology.yy"
{
		   yyval.object=new Dyn_Object(yyvsp[0].var);
		;
    break;}
case 27:
#line 184 "technology.yy"
{
		   yyval.var=yyvsp[0].var;
		;
    break;}
case 28:
#line 188 "technology.yy"
{
		   yyval.var=yyvsp[0].var;
		;
    break;}
case 29:
#line 192 "technology.yy"
{
		   yyval.var=yyvsp[0].var;
		;
    break;}
case 30:
#line 198 "technology.yy"
{
		   yyval.var=new Dyn_Var(yyvsp[-1].string,yyvsp[0].string);
		;
    break;}
case 31:
#line 204 "technology.yy"
{
		   yyval.var=new Dyn_Var(yyvsp[-1].string,yyvsp[0].object);
		;
    break;}
case 32:
#line 210 "technology.yy"
{
		   yyval.var=new Dyn_Var(yyvsp[-1].string,yyvsp[0].tuple);
		;
    break;}
case 33:
#line 216 "technology.yy"
{
		   yyval.object=yyvsp[-1].object;
		;
    break;}
case 34:
#line 220 "technology.yy"
{
		   yyval.object=NULL;
		;
    break;}
case 35:
#line 226 "technology.yy"
{
		   yyval.object=yyvsp[-2].object;
		   yyval.object->AddMember(yyvsp[0].var);
		;
    break;}
case 36:
#line 231 "technology.yy"
{
		   yyerror(" Object elements must be separated with a semicolon");
		;
    break;}
case 37:
#line 235 "technology.yy"
{
		   yyval.object=new Dyn_Object(yyvsp[0].var);
		;
    break;}
case 38:
#line 241 "technology.yy"
{
		   yyval.tuple=yyvsp[-1].tuple;
		;
    break;}
case 39:
#line 247 "technology.yy"
{
		   yyval.tuple=yyvsp[-2].tuple;
		   yyval.tuple->AddMember(yyvsp[0].var);
		;
    break;}
case 40:
#line 252 "technology.yy"
{
		   yyerror(" List elements must be separated with a comma");
		;
    break;}
case 41:
#line 256 "technology.yy"
{
		   yyval.tuple=new Dyn_Tuple(yyvsp[0].var);
		;
    break;}
case 42:
#line 262 "technology.yy"
{
		   yyval.var=new Dyn_Var(yyvsp[0].string);
		;
    break;}
case 43:
#line 266 "technology.yy"
{
		   yyval.var=new Dyn_Var(yyvsp[0].object);
		;
    break;}
case 44:
#line 270 "technology.yy"
{
		   yyval.var=new Dyn_Var(yyvsp[0].tuple);
		;
    break;}
}
   /* the action file gets copied in in place of this dollarsign */
#line 442 "/usr/local/lib/bison.simple"

  yyvsp -= yylen;
  yyssp -= yylen;
#ifdef YYLSP_NEEDED
  yylsp -= yylen;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

  *++yyvsp = yyval;

#ifdef YYLSP_NEEDED
  yylsp++;
  if (yylen == 0)
    {
      yylsp->first_line = yylloc.first_line;
      yylsp->first_column = yylloc.first_column;
      yylsp->last_line = (yylsp-1)->last_line;
      yylsp->last_column = (yylsp-1)->last_column;
      yylsp->text = 0;
    }
  else
    {
      yylsp->last_line = (yylsp+yylen-1)->last_line;
      yylsp->last_column = (yylsp+yylen-1)->last_column;
    }
#endif

  /* Now "shift" the result of the reduction.
     Determine what state that goes to,
     based on the state we popped back to
     and the rule number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTBASE] + *yyssp;
  if (yystate >= 0 && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTBASE];

  goto yynewstate;

yyerrlab:   /* here on detecting error */

  if (! yyerrstatus)
    /* If not already recovering from an error, report this error.  */
    {
      ++yynerrs;

#ifdef YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (yyn > YYFLAG && yyn < YYLAST)
	{
	  int size = 0;
	  char *msg;
	  int x, count;

	  count = 0;
	  for (x = 0; x < (sizeof(yytname) / sizeof(char *)); x++)
	    if (yycheck[x + yyn] == x)
	      size += strlen(yytname[x]) + 15, count++;
	  msg = (char *) malloc(size + 15);
	  if (msg != 0)
	    {
	      strcpy(msg, "parse error");

	      if (count < 5)
		{
		  count = 0;
		  for (x = 0; x < (sizeof(yytname) / sizeof(char *)); x++)
		    if (yycheck[x + yyn] == x)
		      {
			strcat(msg, count == 0 ? ", expecting `" : " or `");
			strcat(msg, yytname[x]);
			strcat(msg, "'");
			count++;
		      }
		}
	      yyerror(msg);
	      free(msg);
	    }
	  else
	    yyerror ("parse error; also virtual memory exceeded");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror("parse error");
    }

  goto yyerrlab1;
yyerrlab1:   /* here on error raised explicitly by an action */

  if (yyerrstatus == 3)
    {
      /* if just tried and failed to reuse lookahead token after an error, discard it.  */

      /* return failure if at end of input */
      if (yychar == YYEOF)
	YYABORT;

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Discarding token %d (%s).\n", yychar, yytname[yychar1]);
#endif

      yychar = YYEMPTY;
    }

  /* Else will try to reuse lookahead token
     after shifting the error token.  */

  yyerrstatus = 3;		/* Each real token shifted decrements this */

  goto yyerrhandle;

yyerrdefault:  /* current state does not do anything special for the error token. */

#if 0
  /* This is wrong; only states that explicitly want error tokens
     should shift them.  */
  yyn = yydefact[yystate];  /* If its default is to accept any token, ok.  Otherwise pop it.*/
  if (yyn) goto yydefault;
#endif

yyerrpop:   /* pop the current state because it cannot handle the error token */

  if (yyssp == yyss) YYABORT;
  yyvsp--;
  yystate = *--yyssp;
#ifdef YYLSP_NEEDED
  yylsp--;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "Error: state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

yyerrhandle:

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yyerrdefault;

  yyn += YYTERROR;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != YYTERROR)
    goto yyerrdefault;

  yyn = yytable[yyn];
  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrpop;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrpop;

  if (yyn == YYFINAL)
    YYACCEPT;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting error token, ");
#endif

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  yystate = yyn;
  goto yynewstate;
}
#line 275 "technology.yy"






