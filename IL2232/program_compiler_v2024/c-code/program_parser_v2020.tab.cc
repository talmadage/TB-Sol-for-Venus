/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1


/* Substitute the variable and function names.  */
#define yyparse         program_parse
#define yylex           program_lex
#define yyerror         program_error
#define yydebug         program_debug
#define yynerrs         program_nerrs

#define yylval          program_lval
#define yychar          program_char

/* Copy the first part of user declarations.  */
#line 1 "program_parser_v2020.yy" /* yacc.c:339  */

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
   

#line 126 "program_parser_v2020.tab.cc" /* yacc.c:339  */

# ifndef YY_NULL
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULL nullptr
#  else
#   define YY_NULL 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "program_parser_v2020.tab.hh".  */
#ifndef YY_PROGRAM_PROGRAM_PARSER_V2020_TAB_HH_INCLUDED
# define YY_PROGRAM_PROGRAM_PARSER_V2020_TAB_HH_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int program_debug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INCLUDE = 258,
    INCLUDE_TEXT = 259,
    FILE_NAME = 260,
    END_OF_FILE = 261,
    TARGET_CODE_START = 262,
    STRING = 263,
    TARGET_CODE_END = 264,
    INPUT = 265,
    INOUT = 266,
    INTERNAL = 267,
    OUTPUT = 268,
    NAME = 269,
    MEMORY = 270,
    START = 271,
    HW = 272,
    SW = 273,
    DRIVER_MEMORY = 274,
    RATE = 275,
    KBPS = 276,
    MBPS = 277,
    GBPS = 278,
    KHZ = 279,
    MHZ = 280,
    GHZ = 281,
    RANGE = 282,
    TO = 283,
    CLOCK = 284,
    ASYNCH_RESET = 285,
    SYNCH_RESET = 286,
    AT = 287,
    BIT = 288,
    OTHERS = 289,
    ERROR = 290,
    BREAK = 291,
    INTERRUPT = 292,
    RESET = 293,
    SYNC = 294,
    COND = 295,
    BIT_STRING = 296,
    LONG_BIT_STRING = 297,
    HEX_NUMBER = 298,
    LONG_HEX_NUMBER = 299,
    NUMBER = 300,
    LEFT_BRACKET = 301,
    RIGHT_BRACKET = 302,
    LEFT_PARENTHESIS = 303,
    RIGHT_PARENTHESIS = 304,
    CONSTANT = 305,
    LEXEM = 306,
    IF = 307,
    ELSE = 308,
    ENDIF = 309,
    CODE_START = 310,
    SEMICOLON = 311,
    COLON = 312,
    NEWLINE = 313,
    VARIABLE = 314,
    OR = 315,
    AND = 316,
    COND_AND = 317,
    EQUAL = 318,
    NOT_EQUAL = 319,
    DOUBLE_PERIOD = 320,
    PERIOD = 321,
    LESS_THAN = 322,
    GREATER_THAN = 323,
    LEFT_CURLY_BRACKET = 324,
    RIGHT_CURLY_BRACKET = 325,
    ACTION = 326,
    ADD = 327,
    SUB = 328,
    MUL = 329,
    DIV = 330,
    SHR = 331,
    NOT = 332
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 52 "program_parser_v2020.yy" /* yacc.c:355  */

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

#line 284 "program_parser_v2020.tab.cc" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE program_lval;

int program_parse (void);

#endif /* !YY_PROGRAM_PROGRAM_PARSER_V2020_TAB_HH_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 299 "program_parser_v2020.tab.cc" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef __attribute__
/* This feature is available in gcc versions 2.5 and later.  */
# if (! defined __GNUC__ || __GNUC__ < 2 \
      || (__GNUC__ == 2 && __GNUC_MINOR__ < 5))
#  define __attribute__(Spec) /* empty */
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   735

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  78
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  74
/* YYNRULES -- Number of rules.  */
#define YYNRULES  216
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  409

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   332

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
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
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   177,   177,   181,   183,   185,   177,   195,   196,   199,
     200,   208,   215,   207,   222,   229,   230,   233,   239,   245,
     251,   257,   261,   265,   271,   276,   283,   289,   297,   298,
     304,   308,   315,   322,   329,   333,   337,   347,   357,   369,
     377,   385,   393,   401,   405,   409,   413,   417,   424,   428,
     432,   436,   442,   444,   448,   449,   452,   456,   460,   467,
     471,   475,   481,   487,   492,   498,   502,   508,   512,   516,
     520,   526,   530,   534,   541,   545,   551,   557,   564,   567,
     571,   575,   581,   586,   593,   597,   601,   607,   611,   615,
     619,   623,   627,   633,   634,   640,   644,   649,   656,   657,
     663,   667,   674,   675,   681,   688,   703,   708,   713,   720,
     729,   734,   735,   741,   746,   752,   758,   765,   771,   778,
     785,   790,   795,   799,   803,   808,   830,   850,   862,   867,
     872,   877,   882,   886,   890,   897,   908,   914,   925,   931,
     935,   941,   945,   949,   953,   959,   964,   970,   974,   980,
     987,   993,  1000,  1006,  1016,  1016,  1016,  1028,  1039,  1049,
    1057,  1063,  1069,  1078,  1082,  1086,  1090,  1105,  1109,  1126,
    1131,  1145,  1149,  1160,  1164,  1168,  1181,  1185,  1189,  1235,
    1244,  1251,  1258,  1278,  1298,  1303,  1308,  1319,  1329,  1334,
    1338,  1345,  1349,  1355,  1361,  1365,  1369,  1375,  1379,  1385,
    1389,  1395,  1403,  1411,  1419,  1427,  1436,  1443,  1447,  1451,
    1477,  1482,  1487,  1491,  1495,  1503,  1507
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "INCLUDE", "INCLUDE_TEXT", "FILE_NAME",
  "END_OF_FILE", "TARGET_CODE_START", "STRING", "TARGET_CODE_END", "INPUT",
  "INOUT", "INTERNAL", "OUTPUT", "NAME", "MEMORY", "START", "HW", "SW",
  "DRIVER_MEMORY", "RATE", "KBPS", "MBPS", "GBPS", "KHZ", "MHZ", "GHZ",
  "RANGE", "TO", "CLOCK", "ASYNCH_RESET", "SYNCH_RESET", "AT", "BIT",
  "OTHERS", "ERROR", "BREAK", "INTERRUPT", "RESET", "SYNC", "COND",
  "BIT_STRING", "LONG_BIT_STRING", "HEX_NUMBER", "LONG_HEX_NUMBER",
  "NUMBER", "LEFT_BRACKET", "RIGHT_BRACKET", "LEFT_PARENTHESIS",
  "RIGHT_PARENTHESIS", "CONSTANT", "LEXEM", "IF", "ELSE", "ENDIF",
  "CODE_START", "SEMICOLON", "COLON", "NEWLINE", "VARIABLE", "OR", "AND",
  "COND_AND", "EQUAL", "NOT_EQUAL", "DOUBLE_PERIOD", "PERIOD", "LESS_THAN",
  "GREATER_THAN", "LEFT_CURLY_BRACKET", "RIGHT_CURLY_BRACKET", "ACTION",
  "ADD", "SUB", "MUL", "DIV", "SHR", "NOT", "$accept", "file", "$@1",
  "$@2", "$@3", "$@4", "type_declarations", "type_declaration",
  "include_declaration", "$@5", "$@6", "interface_declarations",
  "interface", "target_code", "token_declarations", "token_declaration",
  "constant", "lexem", "constant_parameters", "bit_strings", "bit_string",
  "hex_number", "input_parameters", "driver_conditions",
  "internal_parameters", "sync_parameter", "port_parameter",
  "output_parameters", "name_parameters", "list_of_signal_names",
  "signal_name", "memory_parameters", "bit_size", "array_bit_size",
  "start_parameters", "clock_port", "clock_constraints", "number", "rates",
  "numeric_expression", "memory_layout", "memory_production",
  "action_macros", "action_macro", "code_grammar", "grammar_production",
  "architecture_target_code", "list_of_definition_alternatives",
  "definition_alternatives", "definition", "cond_definition",
  "sync_definition", "cond_condition", "size_definitions",
  "list_of_lexems", "lexem_stmnt", "action", "action_grammar",
  "action_production", "vhdl_action", "$@7", "$@8", "vhdl_code",
  "vhdl_atom", "action_target", "list_of_action_atoms", "action_atom",
  "size_statement", "if_statement", "if_expression", "condition",
  "condition_lexem", "action_expression", "range_statement", YY_NULL
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332
};
# endif

#define YYPACT_NINF -324

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-324)))

#define YYTABLE_NINF -113

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -324,    28,   383,  -324,   398,    43,    -1,  -324,  -324,  -324,
    -324,  -324,   216,  -324,  -324,  -324,  -324,   198,  -324,  -324,
      43,    31,    38,    10,   -36,    10,    10,  -324,  -324,    78,
     233,  -324,  -324,    20,  -324,  -324,   116,  -324,   318,    20,
    -324,    10,  -324,  -324,    67,  -324,    70,  -324,    12,  -324,
    -324,  -324,  -324,   127,   234,  -324,   116,   139,    86,   130,
    -324,   248,   149,   -33,  -324,    20,    10,  -324,  -324,  -324,
    -324,   324,   153,   376,   199,   142,   376,  -324,   203,   376,
      10,    10,   376,  -324,   376,  -324,    10,  -324,   229,   217,
     101,  -324,    56,  -324,   142,  -324,   143,  -324,   240,  -324,
    -324,   142,  -324,  -324,   269,   376,   142,  -324,   159,   267,
     142,   270,   292,   306,   374,   -18,  -324,   226,    10,   354,
    -324,  -324,    43,   365,   370,  -324,   303,    82,   384,  -324,
     303,   376,  -324,   256,  -324,  -324,  -324,   142,   142,   142,
     142,  -324,   376,   303,   376,  -324,  -324,   376,  -324,   376,
    -324,  -324,   171,   395,   399,   376,   355,  -324,   591,   142,
     142,  -324,  -324,   330,   330,  -324,  -324,  -324,  -324,  -324,
     402,  -324,  -324,  -324,    10,  -324,   301,  -324,  -324,  -324,
    -324,  -324,  -324,   407,    26,   411,   417,  -324,   123,    10,
     353,   -11,   242,  -324,  -324,  -324,   550,  -324,   404,   405,
    -324,  -324,   303,   303,  -324,   419,  -324,  -324,  -324,    13,
      10,  -324,    10,    10,    10,   423,   424,   425,   285,  -324,
    -324,  -324,    58,   107,  -324,  -324,   410,  -324,  -324,  -324,
    -324,  -324,  -324,  -324,  -324,  -324,   420,  -324,   413,   429,
     430,   366,   366,   142,   142,   142,  -324,   211,  -324,   120,
     376,  -324,  -324,  -324,   658,  -324,   658,  -324,  -324,  -324,
    -324,   372,   372,   303,   303,   303,  -324,  -324,  -324,  -324,
     211,  -324,   427,   377,  -324,   142,   142,    51,   246,   432,
     414,   394,  -324,   -20,  -324,  -324,    35,  -324,  -324,    24,
     606,   433,   434,   435,   436,   416,  -324,  -324,  -324,    10,
     303,   303,   440,   246,   422,   246,  -324,   447,  -324,   237,
     207,    10,  -324,  -324,   185,   376,  -324,    51,  -324,  -324,
    -324,    43,  -324,   442,  -324,  -324,  -324,  -324,  -324,  -324,
    -324,  -324,   454,   376,   336,    10,  -324,   120,  -324,   456,
     246,   246,   246,   246,   376,   207,   149,    -5,  -324,   366,
     438,   464,   465,   458,   467,   445,   591,  -324,  -324,  -324,
     452,   474,   376,  -324,   350,   350,   446,   446,  -324,    71,
    -324,   658,   207,   296,   376,  -324,  -324,    10,   376,  -324,
     328,   400,   376,  -324,    23,  -324,   487,  -324,  -324,  -324,
     149,   476,  -324,  -324,   591,   591,   149,  -324,   376,   658,
    -324,  -324,   457,   509,  -324,   477,   643,  -324,  -324
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       7,     0,     2,     1,     0,     0,     0,     8,     9,    14,
      11,    27,     0,    15,     7,    26,    10,     0,    12,    25,
       0,     0,     0,     0,     0,     0,     0,    28,    16,     0,
       0,    47,    33,     0,    17,    58,     0,    18,    53,     0,
      19,     0,    20,    21,     0,    22,     0,    23,     0,    13,
      24,    73,    71,     0,    45,    74,     0,    56,     0,     0,
      52,    59,    65,     0,    64,     0,     0,    31,    32,    93,
      29,     0,     0,     0,    48,     0,     0,    44,     0,     0,
       0,     0,     0,    60,     0,    66,     0,    63,     0,   147,
       0,   146,     0,    41,     0,    42,     0,    30,    34,    40,
      35,     0,    83,    82,    50,     0,     0,    92,     0,     0,
       0,     0,     0,     0,     0,     0,    62,     0,     0,     0,
     145,    97,     0,     0,     0,    94,    38,     0,     0,    39,
      72,     0,    49,     0,    84,    85,    86,     0,     0,     0,
       0,    43,     0,    75,     0,    54,    55,     0,   215,     0,
      67,    69,     0,     0,     0,    78,     0,     4,     0,     0,
       0,    51,    91,    87,    88,    89,    90,    46,    57,    61,
       0,    68,    70,   148,     0,    76,     0,    96,    98,   134,
     143,   141,   133,     0,     0,     0,     0,   127,     0,     0,
       0,     0,     0,   125,   115,   129,     0,   114,     0,     0,
     132,   131,    36,    37,   216,     0,    79,    80,    81,     0,
       0,   124,     0,     0,     0,     0,     0,     0,     0,   118,
     120,   154,   163,     0,   151,   153,     0,   128,   126,   130,
      95,   113,   119,   121,    77,   101,     0,    99,     0,     0,
       0,     0,     0,     0,     0,     0,   117,     0,   166,     0,
       0,   165,   149,   150,     0,   102,     0,   122,   123,   139,
     140,     0,     0,   144,   142,   116,   159,   160,   161,   162,
     155,   158,     0,     0,   190,     0,     0,     0,     0,     0,
       0,     0,   182,   178,   184,   185,     0,   171,   179,     0,
       0,     0,     0,     0,     0,     0,   157,   164,   168,     0,
     186,   187,     0,     0,     0,     0,   209,   212,   208,     0,
       0,     0,   183,   173,     0,     0,   177,     0,   152,   169,
     108,     0,   107,     0,   103,   104,   100,   137,   138,   135,
     136,   156,     0,     0,     0,     0,   206,     0,   214,   189,
       0,     0,     0,     0,     0,     0,   199,     0,   196,     0,
       0,     0,     0,     0,     0,     0,     0,   167,   172,   207,
       0,     0,     0,   188,   201,   202,   203,   204,   205,     0,
     200,     0,     0,     0,     0,   175,   174,     0,     0,   109,
     106,     0,     0,   213,     0,   194,     0,   195,   197,   198,
     180,     0,   170,   105,     0,     0,   210,   191,     0,     0,
     181,   176,     0,     0,   211,     0,     0,   192,   193
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -324,   511,  -324,  -324,  -324,  -324,  -324,  -324,  -324,  -324,
    -324,  -324,  -324,   -14,  -324,  -324,   -41,   -21,  -227,   431,
     -55,   -23,  -324,   471,  -324,  -324,  -324,  -324,  -324,  -324,
     473,  -324,   -27,   485,  -324,  -324,  -324,    54,  -324,     4,
    -324,  -324,  -324,  -324,  -324,  -324,  -324,  -324,  -247,  -187,
     363,   364,  -234,  -324,   356,   -73,  -324,  -324,   333,  -324,
    -324,  -324,  -324,   291,   357,  -245,  -267,  -324,  -324,  -323,
    -324,   189,     3,  -167
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     6,   123,   178,   236,     2,     7,     8,    14,
      29,    17,    28,    12,    48,    70,   282,   283,    97,    98,
     284,   285,    34,    77,    37,    60,    38,    40,    43,    63,
      64,    45,    54,    57,    47,   155,   175,   107,   141,   108,
      92,   125,   209,   237,   289,   324,   325,   380,   196,   197,
     198,   199,   261,   200,    90,    91,   201,   223,   224,   225,
     247,   295,   270,   271,   226,   286,   287,   363,   288,   347,
     348,   349,   309,    85
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      33,    36,    39,    42,    44,    46,    30,    71,   262,   231,
     302,   290,    61,    67,   235,    32,    99,   120,    32,   319,
      62,    51,   369,   319,    -6,   320,   314,   211,     3,   148,
      -6,   321,    31,    41,   292,   294,   274,    86,    88,    35,
      32,    99,    62,   129,   371,    89,   315,   149,   100,   387,
     354,    11,   274,    52,    13,   251,   372,   121,   221,   112,
     113,    32,    68,   122,    32,   116,    53,    69,    -5,    89,
     397,   124,   129,   128,   212,    32,    93,   275,    95,   276,
     322,   317,    32,   278,    49,    68,    32,   279,   398,    32,
     151,   318,    93,   275,    95,   276,   150,   153,   126,   278,
     248,    68,    32,   279,   249,   130,   280,    32,   156,   381,
     133,    -3,   281,    65,   143,   373,   316,   193,    66,   319,
     385,   152,   280,    93,   250,   172,   386,   104,   281,   159,
     109,   171,   372,   111,    80,   195,   114,   194,   115,   319,
     338,   163,   164,   165,   166,   120,   388,   402,   403,    55,
     119,   228,    32,   205,   406,   193,   215,   216,    32,   132,
      72,   102,    56,   202,   203,   103,    79,   217,    89,   229,
     222,    32,    51,   195,    32,   194,   221,   252,    81,   370,
     134,   135,   136,   102,    93,   161,    95,   103,   222,   239,
     106,   240,   241,   242,   231,    84,   167,    89,   168,    19,
     101,   169,   222,   170,    52,    20,    99,    99,    21,   176,
      22,    23,    24,    25,    26,   231,   231,    53,   105,   266,
     291,   293,    32,   400,    15,    16,   102,    51,   272,   404,
     103,   137,   138,   139,   140,    68,    32,   306,   100,   100,
     312,    15,    50,   137,   138,   139,   140,   263,   264,   265,
     110,    73,    74,    27,    75,   345,   267,   307,    32,    52,
     313,    76,   306,   118,   306,    73,    74,   102,   323,   268,
     269,   103,    53,   351,   106,    82,   117,    32,   332,   300,
     301,    93,   307,   227,   307,    95,   339,   102,   131,   346,
     350,   103,    68,   352,   303,   142,    68,    32,   144,   306,
     306,   306,   306,   115,   273,   162,   334,   355,   336,   340,
     341,   342,   343,   344,   360,   193,   361,   304,    99,   307,
     307,   307,   307,   305,   346,   206,   207,   208,   137,   138,
     139,   140,   308,   195,   246,   194,    32,    93,    94,    95,
     193,   145,    96,   364,   365,   366,   367,    32,    58,    59,
     100,   346,   346,   193,   193,   146,   391,   308,   195,   308,
     194,   193,   193,    15,   177,    93,    94,    95,   115,   353,
      96,   195,   195,   194,   194,   137,   138,   139,   140,   195,
     195,   194,   194,   154,   393,   359,     4,   358,   394,   395,
       5,   115,   185,   186,   308,   308,   308,   308,   368,     9,
    -112,   179,   147,    10,   139,   140,  -112,  -112,   340,   341,
     342,   343,   344,    93,    94,    95,   384,   102,    96,   298,
     157,   103,    68,   299,   342,   343,   344,   158,   390,   259,
     260,   160,   392,   180,   181,   182,   396,   183,   184,   185,
     186,   187,   173,    95,    68,    32,   188,   174,   189,   204,
      68,    32,   405,    15,   379,   210,  -112,  -110,   179,   213,
    -112,  -112,   190,  -110,  -110,   214,   232,   233,   234,   191,
     243,   244,   245,   254,   297,   255,   256,   192,   257,   258,
     310,   311,   327,   328,   329,   330,   331,   333,   274,   335,
     180,   181,   182,   337,   183,   184,   185,   186,   187,   356,
      95,   357,   362,   188,   377,   189,   374,    68,    32,  -111,
     179,   375,   376,  -110,   378,  -111,  -111,  -110,  -110,   190,
     382,   383,   344,   401,   407,    18,   191,   127,    93,   275,
      95,   276,    83,   317,   192,   278,    87,    68,    32,   279,
     399,    78,   180,   181,   182,   218,   183,   184,   185,   186,
     187,   179,    95,   219,   220,   188,   253,   189,   280,    68,
      32,   296,   389,     0,   281,  -111,   238,     0,     0,  -111,
    -111,   190,     0,     0,     0,     0,     0,     0,   191,     0,
       0,     0,     0,   180,   181,   182,   192,   183,   184,   185,
     186,   187,   179,    95,     0,     0,   188,     0,   189,     0,
      68,    32,     0,     0,     0,     0,   230,   274,     0,     0,
       0,     0,   190,     0,     0,     0,     0,     0,     0,   191,
       0,     0,     0,     0,   180,   181,   182,   192,   183,   184,
     185,   186,   187,     0,    95,     0,     0,   188,     0,   189,
       0,    68,    32,     0,   274,     0,     0,    93,   275,    95,
     276,     0,   317,   190,   278,     0,    68,    32,   279,   274,
     191,     0,   326,     0,     0,     0,     0,     0,   192,     0,
       0,     0,     0,     0,     0,     0,     0,   280,     0,     0,
       0,     0,     0,   281,    93,   275,    95,   276,     0,   317,
       0,   278,     0,    68,    32,   279,     0,   408,     0,    93,
     275,    95,   276,     0,   277,     0,   278,     0,    68,    32,
     279,     0,     0,     0,   280,     0,     0,     0,     0,     0,
     281,     0,     0,     0,     0,     0,     0,     0,     0,   280,
       0,     0,     0,     0,     0,   281
};

static const yytype_int16 yycheck[] =
{
      21,    22,    23,    24,    25,    26,    20,    48,   242,   196,
     277,   256,    39,     1,     1,    51,    71,    90,    51,   286,
      41,     1,   345,   290,     0,     1,    46,     1,     0,    47,
       6,     7,     1,    69,   261,   262,     1,    70,    65,     1,
      51,    96,    63,    98,    49,    66,    66,    65,    71,   372,
     317,     8,     1,    33,    55,   222,    61,     1,    69,    80,
      81,    51,    50,     7,    51,    86,    46,    55,    55,    90,
      47,    92,   127,    96,    48,    51,    41,    42,    43,    44,
      56,    46,    51,    48,     6,    50,    51,    52,    65,    51,
     117,    56,    41,    42,    43,    44,   117,   118,    94,    48,
      42,    50,    51,    52,    46,   101,    71,    51,   122,   356,
     106,    55,    77,    46,   110,   349,   283,   158,    48,   386,
      49,   117,    71,    41,    66,   152,   371,    73,    77,    47,
      76,   152,    61,    79,    48,   158,    82,   158,    84,   406,
     307,   137,   138,   139,   140,   218,   373,   394,   395,    33,
      49,   192,    51,   174,   399,   196,    33,    34,    51,   105,
      33,    41,    46,   159,   160,    45,    27,   188,   189,   192,
     191,    51,     1,   196,    51,   196,    69,    70,    48,   346,
      21,    22,    23,    41,    41,   131,    43,    45,   209,   210,
      48,   212,   213,   214,   381,    46,   142,   218,   144,     1,
      47,   147,   223,   149,    33,     7,   261,   262,    10,   155,
      12,    13,    14,    15,    16,   402,   403,    46,    19,     8,
     261,   262,    51,   390,     8,     9,    41,     1,   249,   396,
      45,    72,    73,    74,    75,    50,    51,   278,   261,   262,
     281,     8,     9,    72,    73,    74,    75,   243,   244,   245,
      47,    17,    18,    55,    20,    48,    45,   278,    51,    33,
     281,    27,   303,    46,   305,    17,    18,    41,   289,    58,
      59,    45,    46,   314,    48,    27,    47,    51,   299,   275,
     276,    41,   303,    41,   305,    43,    49,    41,    19,   310,
     311,    45,    50,   314,    48,    28,    50,    51,    28,   340,
     341,   342,   343,   249,   250,    49,   303,   321,   305,    72,
      73,    74,    75,    76,   335,   356,   337,    71,   373,   340,
     341,   342,   343,    77,   345,    24,    25,    26,    72,    73,
      74,    75,   278,   356,    49,   356,    51,    41,    42,    43,
     381,    49,    46,   340,   341,   342,   343,    51,    30,    31,
     373,   372,   373,   394,   395,    49,   377,   303,   381,   305,
     381,   402,   403,     8,     9,    41,    42,    43,   314,   315,
      46,   394,   395,   394,   395,    72,    73,    74,    75,   402,
     403,   402,   403,    29,    56,    49,     3,   333,    60,    61,
       7,   337,    39,    40,   340,   341,   342,   343,   344,     1,
       0,     1,    28,     5,    74,    75,     6,     7,    72,    73,
      74,    75,    76,    41,    42,    43,   362,    41,    46,    42,
      55,    45,    50,    46,    74,    75,    76,    57,   374,    63,
      64,    47,   378,    33,    34,    35,   382,    37,    38,    39,
      40,    41,    47,    43,    50,    51,    46,    48,    48,    47,
      50,    51,   398,     8,     9,    48,    56,     0,     1,    48,
      60,    61,    62,     6,     7,    48,    62,    62,    49,    69,
      47,    47,    47,    63,    47,    55,    63,    77,    49,    49,
      48,    67,    49,    49,    49,    49,    70,    47,     1,    67,
      33,    34,    35,    46,    37,    38,    39,    40,    41,    57,
      43,    47,    46,    46,    46,    48,    68,    50,    51,     0,
       1,    47,    47,    56,    47,     6,     7,    60,    61,    62,
      68,    47,    76,    47,    47,    14,    69,    96,    41,    42,
      43,    44,    61,    46,    77,    48,    63,    50,    51,    52,
      53,    56,    33,    34,    35,   189,    37,    38,    39,    40,
      41,     1,    43,   190,   190,    46,   223,    48,    71,    50,
      51,   270,   373,    -1,    77,    56,   209,    -1,    -1,    60,
      61,    62,    -1,    -1,    -1,    -1,    -1,    -1,    69,    -1,
      -1,    -1,    -1,    33,    34,    35,    77,    37,    38,    39,
      40,    41,     1,    43,    -1,    -1,    46,    -1,    48,    -1,
      50,    51,    -1,    -1,    -1,    -1,    56,     1,    -1,    -1,
      -1,    -1,    62,    -1,    -1,    -1,    -1,    -1,    -1,    69,
      -1,    -1,    -1,    -1,    33,    34,    35,    77,    37,    38,
      39,    40,    41,    -1,    43,    -1,    -1,    46,    -1,    48,
      -1,    50,    51,    -1,     1,    -1,    -1,    41,    42,    43,
      44,    -1,    46,    62,    48,    -1,    50,    51,    52,     1,
      69,    -1,    56,    -1,    -1,    -1,    -1,    -1,    77,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    71,    -1,    -1,
      -1,    -1,    -1,    77,    41,    42,    43,    44,    -1,    46,
      -1,    48,    -1,    50,    51,    52,    -1,    54,    -1,    41,
      42,    43,    44,    -1,    46,    -1,    48,    -1,    50,    51,
      52,    -1,    -1,    -1,    71,    -1,    -1,    -1,    -1,    -1,
      77,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    71,
      -1,    -1,    -1,    -1,    -1,    77
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    79,    84,     0,     3,     7,    80,    85,    86,     1,
       5,     8,    91,    55,    87,     8,     9,    89,    79,     1,
       7,    10,    12,    13,    14,    15,    16,    55,    90,    88,
      91,     1,    51,    95,   100,     1,    95,   102,   104,    95,
     105,    69,    95,   106,    95,   109,    95,   112,    92,     6,
       9,     1,    33,    46,   110,    33,    46,   111,    30,    31,
     103,   110,    95,   107,   108,    46,    48,     1,    50,    55,
      93,    94,    33,    17,    18,    20,    27,   101,   111,    27,
      48,    48,    27,   101,    46,   151,    70,   108,   110,    95,
     132,   133,   118,    41,    42,    43,    46,    96,    97,    98,
      99,    47,    41,    45,   115,    19,    48,   115,   117,   115,
      47,   115,    95,    95,   115,   115,    95,    47,    46,    49,
     133,     1,     7,    81,    95,   119,   117,    97,    99,    98,
     117,    19,   115,   117,    21,    22,    23,    72,    73,    74,
      75,   116,    28,   117,    28,    49,    49,    28,    47,    65,
      95,   110,   117,    95,    29,   113,    91,    55,    57,    47,
      47,   115,    49,   117,   117,   117,   117,   115,   115,   115,
     115,    95,   110,    47,    48,   114,   115,     9,    82,     1,
      33,    34,    35,    37,    38,    39,    40,    41,    46,    48,
      62,    69,    77,    94,    95,    99,   126,   127,   128,   129,
     131,   134,   117,   117,    47,    95,    24,    25,    26,   120,
      48,     1,    48,    48,    48,    33,    34,    95,   132,   128,
     129,    69,    95,   135,   136,   137,   142,    41,    94,    99,
      56,   127,    62,    62,    49,     1,    83,   121,   142,    95,
      95,    95,    95,    47,    47,    47,    49,   138,    42,    46,
      66,   151,    70,   136,    63,    55,    63,    49,    49,    63,
      64,   130,   130,   117,   117,   117,     8,    45,    58,    59,
     140,   141,    95,   115,     1,    42,    44,    46,    48,    52,
      71,    77,    94,    95,    98,    99,   143,   144,   146,   122,
     143,    94,    96,    94,    96,   139,   141,    47,    42,    46,
     117,   117,   144,    48,    71,    77,    94,    95,   115,   150,
      48,    67,    94,    95,    46,    66,   151,    46,    56,   144,
       1,     7,    56,    95,   123,   124,    56,    49,    49,    49,
      49,    70,    95,    47,   150,    67,   150,    46,   151,    49,
      72,    73,    74,    75,    76,    48,    95,   147,   148,   149,
      95,    94,    95,   115,   144,    91,    57,    47,   115,    49,
      95,    95,    46,   145,   150,   150,   150,   150,   115,   147,
     151,    49,    61,   130,    68,    47,    47,    46,    47,     9,
     125,   126,    68,    47,   115,    49,   143,   147,    96,   149,
     115,    95,   115,    56,    60,    61,   115,    47,    65,    53,
     151,    47,   126,   126,   151,   115,   143,    47,    54
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    78,    80,    81,    82,    83,    79,    84,    84,    85,
      85,    87,    88,    86,    86,    89,    89,    90,    90,    90,
      90,    90,    90,    90,    90,    90,    91,    91,    92,    92,
      93,    93,    94,    95,    96,    96,    96,    96,    96,    97,
      97,    98,    99,   100,   100,   100,   100,   100,   101,   101,
     101,   101,   102,   102,   103,   103,   104,   104,   104,   105,
     105,   105,   106,   107,   107,   108,   108,   109,   109,   109,
     109,   110,   110,   110,   111,   111,   112,   113,   114,   114,
     114,   114,   115,   115,   116,   116,   116,   117,   117,   117,
     117,   117,   117,   118,   118,   119,   119,   119,   120,   120,
     121,   121,   122,   122,   122,   123,   123,   123,   123,   124,
     125,   125,   125,   126,   126,   127,   127,   127,   127,   127,
     127,   127,   127,   127,   127,   127,   127,   127,   127,   127,
     127,   127,   127,   127,   127,   128,   128,   129,   129,   130,
     130,   131,   131,   131,   131,   132,   132,   133,   133,   134,
     135,   135,   136,   136,   138,   139,   137,   140,   140,   141,
     141,   141,   141,   142,   142,   142,   142,   142,   142,   143,
     143,   143,   143,   144,   144,   144,   144,   144,   144,   144,
     144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
     144,   145,   145,   146,   147,   147,   147,   148,   148,   149,
     149,   150,   150,   150,   150,   150,   150,   150,   150,   150,
     150,   150,   150,   150,   150,   151,   151
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     0,     0,     0,    15,     0,     2,     1,
       3,     0,     0,     6,     2,     0,     2,     2,     2,     2,
       2,     2,     2,     2,     3,     1,     2,     1,     0,     2,
       2,     1,     1,     1,     1,     1,     4,     4,     2,     2,
       1,     1,     1,     5,     3,     2,     6,     1,     1,     3,
       2,     4,     2,     1,     4,     4,     2,     6,     1,     2,
       3,     6,     4,     2,     1,     1,     2,     5,     6,     5,
       6,     1,     4,     1,     1,     4,     6,     4,     0,     2,
       2,     2,     1,     1,     1,     1,     1,     3,     3,     3,
       3,     3,     1,     0,     2,     4,     3,     1,     0,     2,
       4,     1,     0,     2,     2,     4,     3,     1,     1,     3,
       3,     3,     1,     2,     1,     1,     4,     3,     2,     2,
       2,     2,     4,     4,     2,     1,     2,     1,     2,     1,
       2,     1,     1,     1,     1,     6,     6,     6,     6,     1,
       1,     1,     4,     1,     4,     2,     1,     1,     4,     3,
       2,     1,     4,     1,     0,     0,     5,     2,     1,     1,
       1,     1,     1,     1,     4,     2,     2,     6,     4,     2,
       5,     1,     4,     2,     4,     4,     6,     2,     1,     1,
       5,     6,     1,     2,     1,     1,     2,     2,     4,     3,
       1,     3,     5,     8,     3,     3,     1,     3,     3,     1,
       2,     3,     3,     3,     3,     3,     2,     3,     1,     1,
       5,     6,     1,     4,     2,     3,     5
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULL, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULL;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULL, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 177 "program_parser_v2020.yy" /* yacc.c:1646  */
    { log("type_declarations\n"); }
#line 1733 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 3:
#line 181 "program_parser_v2020.yy" /* yacc.c:1646  */
    { Memories->Initialize();  log("memory_layout\n"); }
#line 1739 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 4:
#line 183 "program_parser_v2020.yy" /* yacc.c:1646  */
    { ParsingMacros=true; }
#line 1745 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 5:
#line 185 "program_parser_v2020.yy" /* yacc.c:1646  */
    { ParsingMacros=false; log("action_macros\n"); }
#line 1751 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 6:
#line 188 "program_parser_v2020.yy" /* yacc.c:1646  */
    { 
			sprintf(log_str,"END OF FILE\n");
			log(log_str);
		  }
#line 1760 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 10:
#line 201 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   PackageCode->AddMembers((yyvsp[-1].TargetCode));
		   delete (yyvsp[-1].TargetCode);
		}
#line 1769 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 11:
#line 208 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
	   // Switching between files is handled by LEX
	   fprintf(stderr,"Opened include file %s\n",(yyvsp[0].string));
	   file_name_stack[file_name_stack_ptr++]=current_file_name;
	   current_file_name=(yyvsp[0].string);
	}
#line 1780 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 12:
#line 215 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
	   // Switching between files is handled by LEX
	   fprintf(stderr,"Closed include file %s\n",current_file_name);
	   delete current_file_name;
           current_file_name=file_name_stack[--file_name_stack_ptr];
	}
#line 1791 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 14:
#line 223 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Include file name must be enclosed in brackets, at line %d:\n   <%s>",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 1800 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 17:
#line 234 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"INPUT %s\n",(yyvsp[0].Input)->Name());
		   log(log_str);
		   Inputs->AddMember((yyvsp[0].Input));
		}
#line 1810 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 18:
#line 240 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"INTERNAL %s\n",(yyvsp[0].Internal)->Name());
		   log(log_str);
		   Internals->AddMember((yyvsp[0].Internal));
		}
#line 1820 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 19:
#line 246 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"OUTPUT %s\n",(yyvsp[0].Output)->Name());
		   log(log_str);
		   Outputs->AddMember((yyvsp[0].Output));
		}
#line 1830 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 20:
#line 252 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"Name=%s\n",(yyvsp[0].string));
		log(log_str);
		   Entity_Name=(yyvsp[0].string);
		}
#line 1840 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 21:
#line 258 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   Aliases->AddMember((yyvsp[0].Alias));
		}
#line 1848 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 22:
#line 262 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   Memories->AddMember((yyvsp[0].Memory));
		}
#line 1856 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 23:
#line 266 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"START %s %s clock %s\n",(yyvsp[0].Start)->Name(),(yyvsp[0].Start)->Stream()->Name(),(yyvsp[0].Start)->ClockName());
		   log(log_str);
		   Starts->AddMember((yyvsp[0].Start));
		}
#line 1866 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 24:
#line 272 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   UseClauses->AddMembers((yyvsp[-1].TargetCode));
		   delete (yyvsp[-1].TargetCode);
		}
#line 1875 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 25:
#line 277 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Interface Parameter error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 1884 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 26:
#line 284 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		log("target_code (1)\n");
		   (yyval.TargetCode)=(yyvsp[-1].TargetCode);
		   (yyval.TargetCode)->AddMember((yyvsp[0].string));
		}
#line 1894 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 27:
#line 290 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		log("target_code (2)\n");
		   (yyval.TargetCode)=new target_code();
		   (yyval.TargetCode)->AddMember((yyvsp[0].string));
		}
#line 1904 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 29:
#line 299 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   Constants->AddMember((yyvsp[0].Constant));
		}
#line 1912 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 30:
#line 305 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Constant)=new constant((yyvsp[-1].string),(yyvsp[0].string));
		}
#line 1920 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 31:
#line 309 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Constant Parameter error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 1929 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 32:
#line 316 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=cpystr((yyvsp[0].string));
//		   delete $<string>1;
		}
#line 1938 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 33:
#line 323 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=cpystr((yyvsp[0].string));
//		   delete $<string>1;
		}
#line 1947 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 34:
#line 330 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=(yyvsp[0].string);
		}
#line 1955 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 35:
#line 334 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=(yyvsp[0].string);
		}
#line 1963 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 36:
#line 338 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-2].string));
		   };
		   (yyval.string)=new char[strlen(tmp)+1];
		   strcpy((yyval.string),tmp);
		}
#line 1977 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 37:
#line 348 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-2].string));
		   };
		   (yyval.string)=new char[strlen(tmp)+1];
		   strcpy((yyval.string),tmp);
		}
#line 1991 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 38:
#line 358 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-1].string));
		   };
		   (yyval.string)=new char[strlen(tmp)+1];
		   strcpy((yyval.string),tmp);
		}
#line 2005 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 39:
#line 370 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=catstr((yyvsp[-1].string),(yyvsp[0].string));
sprintf(log_str,"bit_strings: %s\n",(yyval.string));
log(log_str);
		   delete (yyvsp[-1].string);
		   delete (yyvsp[0].string);
		}
#line 2017 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 40:
#line 378 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=(yyvsp[0].string);
sprintf(log_str,"bit_strings %s\n",(yyval.string));
log(log_str);
		}
#line 2027 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 41:
#line 386 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"%s\n",(yyvsp[0].string));
		   log(log_str);
		   (yyval.string)=cpystr((yyvsp[0].string));
		}
#line 2037 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 42:
#line 394 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,hex2bits((yyvsp[0].string)));
		   (yyval.string)=new char[strlen(tmp)+1];
		   strcpy((yyval.string),tmp);
		}
#line 2047 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 43:
#line 402 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Input)=new input((yyvsp[-4].string),new array_type(1,(yyvsp[-3].number)),(yyvsp[-1].number),(yyvsp[0].number));
		}
#line 2055 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 44:
#line 406 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Input)=new input((yyvsp[-2].string),new array_type(1,(yyvsp[-1].number)),(yyvsp[0].Driver));
		}
#line 2063 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 45:
#line 410 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Input)=new input((yyvsp[-1].string),new array_type(1,(yyvsp[0].number)));
		}
#line 2071 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 46:
#line 414 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Input)=new input((yyvsp[-5].string),new array_type(1,(yyvsp[-4].number)),new range_class((yyvsp[-2].number),(yyvsp[0].number)));
		}
#line 2079 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 47:
#line 418 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Lexem error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2088 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 48:
#line 425 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Driver)=new device_driver(new software_driver());
		}
#line 2096 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 49:
#line 429 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Driver)=new device_driver(new software_driver((yyvsp[0].number)));
		}
#line 2104 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 50:
#line 433 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Driver)=new device_driver(new hardware_driver((yyvsp[0].number)));
		}
#line 2112 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 51:
#line 437 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Driver)=new device_driver(new hardware_driver((yyvsp[-2].number),(yyvsp[0].number)));
		}
#line 2120 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 52:
#line 443 "program_parser_v2020.yy" /* yacc.c:1646  */
    { (yyval.Internal)=(yyvsp[-1].Internal); }
#line 2126 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 53:
#line 445 "program_parser_v2020.yy" /* yacc.c:1646  */
    { (yyval.Internal)=(yyvsp[0].Internal); }
#line 2132 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 56:
#line 453 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Internal)=new internal((yyvsp[-1].string),new array_type(1,(yyvsp[0].number)));
		}
#line 2140 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 57:
#line 457 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Internal)=new internal((yyvsp[-5].string),new array_type(1,(yyvsp[-4].number)),new range_class((yyvsp[-2].number),(yyvsp[0].number)));
		}
#line 2148 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 58:
#line 461 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Lexem error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2157 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 59:
#line 468 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Output)=new output((yyvsp[-1].string),new array_type(1,(yyvsp[0].number)));
		}
#line 2165 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 60:
#line 472 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Output)=new output((yyvsp[-2].string),new array_type(1,(yyvsp[-1].number)),(yyvsp[0].Driver));
		}
#line 2173 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 61:
#line 476 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Output)=new output((yyvsp[-5].string),new array_type(1,(yyvsp[-4].number)),new range_class((yyvsp[-2].number),(yyvsp[0].number)));
		}
#line 2181 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 62:
#line 482 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Alias)=new alias((yyvsp[0].string),(yyvsp[-2].Aliased_Signals));
		}
#line 2189 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 63:
#line 488 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Aliased_Signals)=(yyvsp[-1].Aliased_Signals);
		   (yyval.Aliased_Signals)->AddMember((yyvsp[0].Aliased_Signal));
		}
#line 2198 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 64:
#line 493 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Aliased_Signals)=new aliased_signal_names((yyvsp[0].Aliased_Signal));
		}
#line 2206 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 65:
#line 499 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Aliased_Signal)=new aliased_signal_name((yyvsp[0].string));
		}
#line 2214 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 66:
#line 503 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Aliased_Signal)=new aliased_signal_name((yyvsp[-1].string),(yyvsp[0].Range));
		}
#line 2222 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 67:
#line 509 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Memory)=new memory((yyvsp[-4].string),(yyvsp[-2].number),1,(yyvsp[0].string));
		}
#line 2230 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 68:
#line 513 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Memory)=new memory((yyvsp[-5].string),(yyvsp[-3].number),(yyvsp[-1].number),(yyvsp[0].string));
		}
#line 2238 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 69:
#line 517 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Memory)=new memory((yyvsp[-4].string),(yyvsp[-2].number),1,(yyvsp[0].number));
		}
#line 2246 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 70:
#line 521 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Memory)=new memory((yyvsp[-5].string),(yyvsp[-3].number),(yyvsp[-1].number),(yyvsp[0].number));
		}
#line 2254 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 71:
#line 527 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=1;
		}
#line 2262 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 72:
#line 531 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number);
		}
#line 2270 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 73:
#line 535 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Bit Size error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2279 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 74:
#line 542 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=1;
		}
#line 2287 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 75:
#line 546 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)*(yyvsp[0].number);
		}
#line 2295 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 76:
#line 552 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Start)=new start((yyvsp[-5].string),(yyvsp[-3].Input_Stream),(yyvsp[-1].string),(yyvsp[0].number));
		}
#line 2303 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 77:
#line 558 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=cpystr((yyvsp[-1].string));
		}
#line 2311 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 78:
#line 564 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=0;
		}
#line 2319 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 79:
#line 568 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number)*1000;
		}
#line 2327 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 80:
#line 572 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number)*1000000;
		}
#line 2335 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 81:
#line 576 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number)*1000000000;
		}
#line 2343 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 82:
#line 582 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		  // In case of mixed 0:s to 9:s
		  (yyval.number)=atoi((yyvsp[0].string));
		}
#line 2352 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 83:
#line 587 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		  // In case of only 0:s and 1:s
		  (yyval.number)=atoi((yyvsp[0].string));
		}
#line 2361 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 84:
#line 594 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		  (yyval.number)=KBPS;
		}
#line 2369 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 85:
#line 598 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		  (yyval.number)=MBPS;
		}
#line 2377 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 86:
#line 602 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		  (yyval.number)=GBPS;
		}
#line 2385 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 87:
#line 608 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)+(yyvsp[0].number);
		}
#line 2393 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 88:
#line 612 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)-(yyvsp[0].number);
		}
#line 2401 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 89:
#line 616 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)*(yyvsp[0].number);
		}
#line 2409 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 90:
#line 620 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)/(yyvsp[0].number);
		}
#line 2417 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 91:
#line 624 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-1].number);
		}
#line 2425 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 92:
#line 628 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number);
		}
#line 2433 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 94:
#line 635 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   Layouts->AddMember((yyvsp[0].Layout));
		}
#line 2441 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 95:
#line 641 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Layout)=new layout((yyvsp[-3].string),(yyvsp[-1].Prod_Line));
		}
#line 2449 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 96:
#line 645 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   SignalDeclarations->AddMembers((yyvsp[-1].TargetCode));
		   delete (yyvsp[-1].TargetCode);
		}
#line 2458 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 97:
#line 650 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected a Memory declaration or Start of Action section at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2467 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 99:
#line 658 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   Actions->AddMember((yyvsp[0].Action));
		}
#line 2475 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 100:
#line 664 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action)=new action((yyvsp[-3].Action_Target),(yyvsp[-1].Action_Line));
		}
#line 2483 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 101:
#line 668 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected an Action declaration or Start of Grammar section at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2492 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 103:
#line 676 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"code_grammar->Production: %s\n",(yyvsp[0].Production)->Name());
		   log(log_str);
		   Grammars->AddMember((yyvsp[0].Production));
		}
#line 2502 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 104:
#line 682 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"code_grammar->architecture_target_code\n");
		   log(log_str);
		}
#line 2511 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 105:
#line 689 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
			sprintf(log_str,"grammar_production %s\n",(yyvsp[-3].string));
			log(log_str);
		   if (Grammars->IsMember((yyvsp[-3].string)))
		   {
		      sprintf(tmp,"Error: Duplicate Definition of Production %s at line %d\n",(yyvsp[-3].string),program_lines);
		      yyerror2(tmp); return 1;
		   }
		   else
		   {
		      (yyval.Production)=new production((yyvsp[-3].string),(yyvsp[-1].Prod_Lines));
		   };
		   //log("BAKAYARO\n");
		}
#line 2530 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 106:
#line 704 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected semicolon at line %d.\n",program_lines);
		   yyerror2(tmp); return 1;
		}
#line 2539 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 107:
#line 709 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Stray semicolon at line %d.\n",program_lines);
		   yyerror2(tmp); return 1;
		}
#line 2548 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 108:
#line 714 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected a Grammar declaration at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2557 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 109:
#line 721 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   log("architecture_target_code(1)\n");
		   ArchitectureCode->AddMembers((yyvsp[-1].TargetCode));
		   delete (yyvsp[-1].TargetCode);
		   log("architecture_target_code(2)\n");
		}
#line 2568 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 110:
#line 730 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Lines)=(yyvsp[-2].Prod_Lines);
		   (yyval.Prod_Lines)->AddMember((yyvsp[0].Prod_Line));
		}
#line 2577 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 112:
#line 736 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Lines)=new production_lines((yyvsp[0].Prod_Line));
		}
#line 2585 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 113:
#line 742 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Line)=(yyvsp[-1].Prod_Line);
		   (yyval.Prod_Line)->AddMember((yyvsp[0].Prod_Item));
		}
#line 2594 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 114:
#line 747 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Line)=new production_line((yyvsp[0].Prod_Item));
		}
#line 2602 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 115:
#line 753 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"(1) Production %s\n",(yyvsp[0].string));
		   log(log_str);
		   (yyval.Prod_Item)=new production_item(new production_lexem((yyvsp[0].string)));
		}
#line 2612 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 116:
#line 759 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"(2) Production %s x %d\n",(yyvsp[-2].string),(yyvsp[0].number));
		   log(log_str);
		   (yyval.Prod_Item)=new production_item(new production_lexem((yyvsp[-2].string),(yyvsp[0].number)));
		   log("BAKA\n");
		}
#line 2623 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 117:
#line 766 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"Stream redirection %s %s\n",(yyvsp[-1].string));
		   log(log_str);
		   (yyval.Prod_Item)=new production_item(new production_redirection((yyvsp[-1].Input_Stream)));
		}
#line 2633 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 118:
#line 772 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Left Associative Condition
		   sprintf(log_str,"Left Conditional AND\n");
		   log(log_str);
		   (yyval.Prod_Item)=new production_item((yyvsp[0].Cond));
		}
#line 2644 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 119:
#line 779 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Right Associative Condition
		   sprintf(log_str,"Right Conditional AND\n");
		   log(log_str);
		   (yyval.Prod_Item)=new production_item((yyvsp[-1].Cond));
		}
#line 2655 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 120:
#line 786 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Left Associative Synchronisation
		   (yyval.Prod_Item)=new production_item((yyvsp[0].Cond));
		}
#line 2664 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 121:
#line 791 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Right Associative Synchronisation
		   (yyval.Prod_Item)=new production_item((yyvsp[-1].Cond));
		}
#line 2673 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 122:
#line 796 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_interrupt((yyvsp[-1].string)));
		}
#line 2681 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 123:
#line 800 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_reset((yyvsp[-1].string)));
		}
#line 2689 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 124:
#line 804 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Error in Reset statement at line %d:\n   %s",program_lines,(yyvsp[-1].string));
		   yyerror2(tmp); return 1;
		}
#line 2698 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 125:
#line 809 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"CONSTANT %s\n", Constants->Member(i)->Name());
		log(log_str);
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 (yyvsp[0].string))==0)
		      {
		         (yyval.Prod_Item)=new production_item(
				       new production_terminal(Constants->Member(i)->Value(),false));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[0].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
#line 2724 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 126:
#line 831 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 (yyvsp[0].string))==0)
		      {
		         (yyval.Prod_Item)=new production_item(
				       new production_terminal(Constants->Member(i)->Value(),true));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[0].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
#line 2748 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 127:
#line 851 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
			sprintf(log_str,"BIT_STRING %s\n",(yyvsp[0].string));
			log(log_str);
		   (yyval.Prod_Item)=new production_item(
				 new production_terminal(cpystr((yyvsp[0].string)),false));
		}
#line 2759 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 128:
#line 863 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(
				 new production_terminal(cpystr((yyvsp[0].string)),true));
		}
#line 2768 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 129:
#line 868 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(
				 new production_terminal((yyvsp[0].string),false));
		}
#line 2777 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 130:
#line 873 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(
				 new production_terminal((yyvsp[0].string),true));
		}
#line 2786 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 131:
#line 878 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item((yyvsp[0].Actions));
		   log("Action\n");
		}
#line 2795 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 132:
#line 883 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=(yyvsp[0].Prod_Item);
		}
#line 2803 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 133:
#line 887 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_error());
		}
#line 2811 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 134:
#line 891 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected a Lexem or a Semicolon at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2820 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 135:
#line 898 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
	           constant *cons;
		   cons=Constants->Member((yyvsp[-1].string));
		   if (cons==NULL)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[-1].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		   (yyval.Cond)=new production_cond(new production_signal(new action_signal((yyvsp[-3].string))),(yyvsp[-2].boolean),cons->Value());
		}
#line 2835 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 136:
#line 909 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Cond)=new production_cond(new production_signal(new action_signal((yyvsp[-3].string))),(yyvsp[-2].boolean),(yyvsp[-1].string));
		}
#line 2843 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 137:
#line 915 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
	           constant *cons;
		   cons=Constants->Member((yyvsp[-1].string));
		   if (cons==NULL)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[-1].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		   (yyval.Cond)=new production_cond(new production_signal(new action_signal((yyvsp[-3].string))),(yyvsp[-2].boolean),cons->Value());
		}
#line 2858 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 138:
#line 926 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Cond)=new production_cond(new production_signal(new action_signal((yyvsp[-3].string))),(yyvsp[-2].boolean),(yyvsp[-1].string));
		}
#line 2866 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 139:
#line 932 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.boolean)=true;
		}
#line 2874 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 140:
#line 936 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.boolean)=false;
		}
#line 2882 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 141:
#line 942 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_terminal(OTHER_BIT,1,false));
		}
#line 2890 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 142:
#line 946 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_terminal(OTHER_BIT,(yyvsp[0].number),false));
		}
#line 2898 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 143:
#line 950 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_terminal(DONT_CARE_BIT,1,false));
		}
#line 2906 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 144:
#line 954 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_terminal(DONT_CARE_BIT,(yyvsp[0].number),false));
		}
#line 2914 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 145:
#line 960 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Input_Stream)=(yyvsp[-1].Input_Stream);
		   (yyval.Input_Stream)->AddMember((yyvsp[0].Stream_Item));
		}
#line 2923 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 146:
#line 965 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Input_Stream)=new input_stream((yyvsp[0].Stream_Item));
		}
#line 2931 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 147:
#line 971 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Stream_Item)=new stream_item((yyvsp[0].string));
		}
#line 2939 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 148:
#line 975 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Stream_Item)=new stream_item((yyvsp[-3].string),(yyvsp[-1].string));
		}
#line 2947 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 149:
#line 981 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Actions)=(yyvsp[-1].Actions);
		   log("Action\n");
		}
#line 2956 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 150:
#line 988 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   log("Adding new Actions\n");
		   (yyval.Actions)=(yyvsp[-1].Actions);
		   (yyval.Actions)->AddMember((yyvsp[0].Action));
		}
#line 2966 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 151:
#line 994 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   log("Creating new Actions\n");
		   (yyval.Actions)=new actions((yyvsp[0].Action));
		}
#line 2975 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 152:
#line 1001 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   log("action_target OK\n");
		   (yyval.Action)=new action((yyvsp[-3].Action_Target),(yyvsp[-1].Action_Line));
		   log("action_production OK\n");
		}
#line 2985 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 153:
#line 1007 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   log("vhdl_action ok\n");
		   (yyvsp[0].VHDLCode)->AddMember(new vhdl_atom("\n"));
		   log("Adding VHDLCode newline\n");
		   (yyval.Action)=new action((yyvsp[0].VHDLCode));
		   log("action_production OK\n");
		}
#line 2997 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 154:
#line 1016 "program_parser_v2020.yy" /* yacc.c:1646  */
    { ParsingVHDL=true; log("VHDL\n"); }
#line 3003 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 155:
#line 1016 "program_parser_v2020.yy" /* yacc.c:1646  */
    { ParsingVHDL=false; log("VHDL OK\n"); }
#line 3009 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 156:
#line 1017 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"VHDL Action (1) %08x\n",(yyvsp[-2].VHDLCode));
		   log(log_str);
		   log("VHDL Action\n");
		   (yyval.VHDLCode)=(yyvsp[-2].VHDLCode);
		   log("VHDL Action OK\n");
//		   $<VHDLCode>$->PrintVHDL(error_log);
//		   log("VHDL Action OK (2)\n");
		}
#line 3023 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 157:
#line 1029 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"vhdl_code (2) %08x\n",(yyvsp[-1].VHDLCode));
		   log(log_str);
		   sprintf(log_str,"vhdl_code (2) %08x\n",(yyvsp[0].VHDL_Atom));
		   log(log_str);
		   (yyval.VHDLCode)=(yyvsp[-1].VHDLCode);
		   (yyval.VHDLCode)->AddMember((yyvsp[0].VHDL_Atom));
		   sprintf(log_str,"vhdl_code (2) %08x\n",(yyval.VHDLCode));
		   log(log_str);
		}
#line 3038 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 158:
#line 1040 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"vhdl_atom (1) %08x\n",(yyvsp[0].VHDL_Atom));
		   log(log_str);
		   (yyval.VHDLCode)=new vhdl_code();
		   (yyval.VHDLCode)->AddMember(new vhdl_atom("            "));
		   (yyval.VHDLCode)->AddMember((yyvsp[0].VHDL_Atom));
		}
#line 3050 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 159:
#line 1050 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"STRING %s\n",(yyvsp[0].string));
		log(log_str);
		   (yyval.VHDL_Atom)=new vhdl_atom((yyvsp[0].string));
		 sprintf(log_str,"(STRING) vhdl_atom %08x\n",(yyval.VHDL_Atom));
		   log(log_str);
		}
#line 3062 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 160:
#line 1058 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"NUMBER %s\n",(yyvsp[0].string));
		log(log_str);
		   (yyval.VHDL_Atom)=new vhdl_atom((yyvsp[0].string));
		}
#line 3072 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 161:
#line 1064 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"(newline)\n");
		log(log_str);
		   (yyval.VHDL_Atom)=new vhdl_atom("\n            ");
		}
#line 3082 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 162:
#line 1070 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		sprintf(log_str,"(VARIABLE)\n");
		log(log_str);
		   (yyval.VHDL_Atom)=new vhdl_atom((yyvsp[0].Variable));
		}
#line 3093 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 163:
#line 1079 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Target)=new action_target((yyvsp[0].string));
		}
#line 3101 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 164:
#line 1083 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Target)=new action_target((yyvsp[-3].string),new action_address(new action_signal((yyvsp[-1].string))));
		}
#line 3109 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 165:
#line 1087 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Target)=new action_target((yyvsp[-1].string),new action_address((yyvsp[0].Range)));
		}
#line 3117 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 166:
#line 1091 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   char *tmp1=FormatBitString((yyvsp[0].string));
		   if (tmp1==NULL)
		   {
		      sprintf(tmp,"Address for memory access %s at line %d has not been defined\n",(yyvsp[-1].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		   char *tmp2=catstr("std_logic_vector'(B\"",tmp1);
		   char *tmp3=catstr(tmp2,"\")");
		   (yyval.Action_Target)=new action_target((yyvsp[-1].string),new action_address(new action_constant(tmp3)));
		   delete tmp1;
		   delete tmp2;
		   delete tmp3;
		}
#line 3136 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 167:
#line 1106 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Target)=new action_target((yyvsp[-5].string),(yyvsp[-3].number),new action_address(new action_signal((yyvsp[-1].string))));
		}
#line 3144 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 168:
#line 1110 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   char *tmp1=FormatBitString((yyvsp[0].string));
		   if (tmp1==NULL)
		   {
		      sprintf(tmp,"Address for memory access %s at line %d has not been defined\n",(yyvsp[-3].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		   char *tmp2=catstr("std_logic_vector'(B\"",tmp1);
		   char *tmp3=catstr(tmp2,"\")");
		   (yyval.Action_Target)=new action_target((yyvsp[-3].string),(yyvsp[-1].number),new action_address(new action_constant(tmp3)));
		   delete tmp1;
		   delete tmp2;
		   delete tmp3;
		}
#line 3163 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 169:
#line 1127 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Line)=(yyvsp[-1].Action_Line);
		   (yyval.Action_Line)->AddMember((yyvsp[0].Action_Item));
		}
#line 3172 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 170:
#line 1132 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
			// this production results in 3 shift-reduce conflicts. It does not help to introduce another hierarchy.
			// I don't understand why...
		   (yyval.Action_Line)=(yyvsp[-4].Action_Line);
		   for(int i=0;i<(yyvsp[0].number);i++) 
		   { 
			  (yyval.Action_Line)->AddMember((yyvsp[-2].Action_Item)->Copy());
		   };
		   //sprintf(log_str,"BAKAYARO\n",$<Action_Item>3);
		   //log(log_str);
		   //delete $<Action_Item>3;
		   //log("SKEBE\n");
		}
#line 3190 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 171:
#line 1146 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Line)=new action_line((yyvsp[0].Action_Item));
		}
#line 3198 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 172:
#line 1150 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
 		   (yyval.Action_Line)=new action_line((yyvsp[-2].Action_Item));
		   for(int i=0;i<((yyvsp[0].number))-1;i++)
		   {
			   (yyval.Action_Line)->AddMember((yyvsp[-2].Action_Item)->Copy());
		   }
		   //delete $<Action_Item>2;
		}
#line 3211 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 173:
#line 1161 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(new action_signal((yyvsp[0].string),true));
		}
#line 3219 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 174:
#line 1165 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(new action_signal((yyvsp[-3].string),1,new action_address(new action_signal((yyvsp[-1].string)))));
		}
#line 3227 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 175:
#line 1169 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   constant *con=Constants->Member((yyvsp[-1].string));
		   if (con==NULL)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[-3].string),program_lines);
		      yyerror2(tmp); return 1;
		   }
		   else
		   {
			   (yyval.Action_Item)=new action_item(new action_signal((yyvsp[-3].string),1,new action_address(new action_constant((yyvsp[-1].string)))));
		   };
		}
#line 3244 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 176:
#line 1182 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(new action_signal((yyvsp[-5].string),(yyvsp[-3].number),new action_address(new action_signal((yyvsp[-1].string)))));
		}
#line 3252 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 177:
#line 1186 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
	          (yyval.Action_Item)=new action_item(new action_signal((yyvsp[-1].string),(yyvsp[0].Range)));
		}
#line 3260 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 178:
#line 1190 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Action macro
		   if (Actions->Member((yyvsp[0].string))!=NULL)
		   {
		      (yyval.Action_Item)=new action_item(new action_macro((yyvsp[0].string)));
		   }
		   else
		   {
		      (yyval.Action_Item)=new action_item(new action_signal((yyvsp[0].string)));
		   };
		}
#line 3276 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 179:
#line 1236 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item((yyvsp[0].Action_Mux));
		}
#line 3284 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 180:
#line 1245 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		   sprintf(log_str,"Data field %s (1)\n",(yyvsp[-2].string));
		   log(log_str);
		   (yyval.Action_Item)=new action_item(new action_variable((yyvsp[-2].string),(yyvsp[0].number)));
		}
#line 3295 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 181:
#line 1252 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		   sprintf(log_str,"Data field %s (2)\n",(yyvsp[-3].string));
		   log(log_str);
		   (yyval.Action_Item)=new action_item(new action_variable((yyvsp[-3].string),(yyvsp[-1].number),(yyvsp[0].Range)));
		}
#line 3306 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 182:
#line 1259 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 (yyvsp[0].string))==0)
		      {
		         (yyval.Action_Item)=new action_item(
				       new action_constant(Constants->Member(i)->Value()));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[0].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
#line 3330 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 183:
#line 1279 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 (yyvsp[0].string))==0)
		      {
		         (yyval.Action_Item)=new action_item(
				       new action_constant(Negate(Constants->Member(i)->Value())));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[-1].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
#line 3354 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 184:
#line 1299 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(
				 new action_constant(cpystr((yyvsp[0].string))));
		}
#line 3363 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 185:
#line 1304 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(
				 new action_constant((yyvsp[0].string)));
		}
#line 3372 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 186:
#line 1309 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-1].string));
		   };
		   (yyval.Action_Item)=new action_item(
				 new action_constant(cpystr(tmp)));
		}
#line 3386 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 187:
#line 1320 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-1].string));
		   };
		   (yyval.Action_Item)=new action_item(
				 new action_constant(cpystr(tmp)));
		}
#line 3400 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 188:
#line 1330 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyvsp[-2].CDFG)->BitRange((yyvsp[0].Range));
		   (yyval.Action_Item)=new action_item((yyvsp[-2].CDFG));
		}
#line 3409 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 189:
#line 1335 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item((yyvsp[-1].CDFG));
		}
#line 3417 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 190:
#line 1339 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected an Action or a Semicolon at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 3426 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 191:
#line 1346 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Range)=new range_class((yyvsp[-1].number),(yyvsp[-1].number));
		}
#line 3434 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 192:
#line 1350 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Range)=new range_class((yyvsp[-3].number),(yyvsp[-1].number));
		}
#line 3442 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 193:
#line 1356 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Mux)=new action_mux((yyvsp[-5].Mux_Expression),(yyvsp[-3].Action_Line),(yyvsp[-1].Action_Line));
		}
#line 3450 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 194:
#line 1362 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Expression)=(yyvsp[-1].Mux_Expression);
		}
#line 3458 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 195:
#line 1366 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Expression)=new mux_expression(new mux_and((yyvsp[-2].Mux_Expression),(yyvsp[0].Mux_Expression)));
		}
#line 3466 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 196:
#line 1370 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Expression)=new mux_expression((yyvsp[0].Mux_Condition));
		}
#line 3474 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 197:
#line 1376 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Condition)=new mux_condition((yyvsp[-2].Signal),(yyvsp[-1].boolean),(yyvsp[0].string));
		}
#line 3482 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 198:
#line 1380 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Condition)=new mux_condition((yyvsp[-2].Signal),(yyvsp[-1].boolean),(yyvsp[0].Signal));
		}
#line 3490 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 199:
#line 1386 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Signal)=new action_signal((yyvsp[0].string));
		}
#line 3498 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 200:
#line 1390 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Signal)=new action_signal((yyvsp[-1].string),(yyvsp[0].Range));
		}
#line 3506 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 201:
#line 1396 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("add",arg);
		}
#line 3518 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 202:
#line 1404 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("subtract",arg);
		}
#line 3530 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 203:
#line 1412 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("multiply",arg);
		}
#line 3542 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 204:
#line 1420 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("divide",arg);
		}
#line 3554 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 205:
#line 1428 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
//BUG!!!! Arg 3 har fel typ
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("shift_right",arg);
		}
#line 3567 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 206:
#line 1437 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[0].CDFG)); 
		   (yyval.CDFG)=new action_cdfg("not",arg);
		}
#line 3578 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 207:
#line 1444 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.CDFG)=(yyvsp[-1].CDFG);
		}
#line 3586 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 208:
#line 1448 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.CDFG)=new action_cdfg(new cdfg_constant((yyvsp[0].number)));
		}
#line 3594 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 209:
#line 1452 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   found=false;
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),
				 (yyvsp[0].string))==0)
		      {
		         (yyval.CDFG)=new action_cdfg(
				  new cdfg_constant(Constants->
						    Member(i)->
						    Value()));
			 found=true;
			 break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[0].string),program_lines);
		      yyerror2(tmp); return 1;
		   };
		}
#line 3620 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 210:
#line 1478 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		   (yyval.CDFG)=new action_cdfg(new cdfg_variable((yyvsp[-2].string),(yyvsp[0].number)));
		}
#line 3629 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 211:
#line 1483 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		   (yyval.CDFG)=new action_cdfg(new cdfg_variable((yyvsp[-3].string),(yyvsp[-1].number),(yyvsp[0].Range)));
		}
#line 3638 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 212:
#line 1488 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.CDFG)=new action_cdfg(new cdfg_signal((yyvsp[0].string)));
		}
#line 3646 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 213:
#line 1492 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.CDFG)=new action_cdfg(new cdfg_signal((yyvsp[-3].string),new action_address(new action_signal((yyvsp[-1].string)))));
		}
#line 3654 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 214:
#line 1496 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   cdfg_signal *new_signal;
		   new_signal=new cdfg_signal((yyvsp[-1].string),(yyvsp[0].Range));
		   (yyval.CDFG)=new action_cdfg(new_signal);
		}
#line 3664 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 215:
#line 1504 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   (yyval.Range)=new range_class((yyvsp[-1].number),(yyvsp[-1].number));
		}
#line 3672 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;

  case 216:
#line 1508 "program_parser_v2020.yy" /* yacc.c:1646  */
    {
		   // MSB-first, i.e., parsed as [TO..FROM] 
		   (yyval.Range)=new range_class((yyvsp[-3].number),(yyvsp[-1].number));
		}
#line 3681 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
    break;


#line 3685 "program_parser_v2020.tab.cc" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 1514 "program_parser_v2020.yy" /* yacc.c:1906  */


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




