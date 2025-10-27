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
#line 1 "..\\program_parser_v2024.yy" /* yacc.c:339  */

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
   

#line 126 "../program_parser_v2024.tab.cpp" /* yacc.c:339  */

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
   by #include "program_parser_v2024.tab.hpp".  */
#ifndef YY_PROGRAM_PROGRAM_PARSER_V2024_TAB_HPP_INCLUDED
# define YY_PROGRAM_PROGRAM_PARSER_V2024_TAB_HPP_INCLUDED
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
#line 52 "..\\program_parser_v2024.yy" /* yacc.c:355  */

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

#line 284 "../program_parser_v2024.tab.cpp" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE program_lval;

int program_parse (void);

#endif /* !YY_PROGRAM_PROGRAM_PARSER_V2024_TAB_HPP_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 299 "../program_parser_v2024.tab.cpp" /* yacc.c:358  */

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
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   735

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  78
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  74
/* YYNRULES -- Number of rules.  */
#define YYNRULES  217
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  410

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
       0,   177,   177,   181,   183,   185,   177,   192,   199,   200,
     203,   204,   212,   219,   211,   226,   233,   234,   237,   243,
     249,   255,   261,   265,   269,   275,   280,   287,   293,   301,
     302,   308,   323,   330,   337,   344,   348,   352,   362,   372,
     384,   392,   400,   408,   416,   420,   424,   428,   432,   439,
     443,   447,   451,   457,   459,   463,   464,   467,   471,   475,
     482,   486,   490,   496,   502,   507,   513,   517,   523,   527,
     531,   535,   541,   545,   549,   556,   560,   566,   572,   579,
     582,   586,   590,   596,   601,   608,   612,   616,   622,   626,
     630,   634,   638,   642,   648,   649,   655,   659,   664,   671,
     672,   679,   683,   690,   691,   697,   704,   720,   725,   730,
     737,   746,   751,   752,   758,   763,   769,   775,   782,   788,
     795,   802,   809,   816,   822,   828,   834,   859,   879,   891,
     898,   905,   912,   917,   922,   927,   935,   946,   952,   963,
     969,   973,   979,   983,   987,   991,   997,  1002,  1008,  1012,
    1018,  1025,  1031,  1038,  1044,  1054,  1054,  1054,  1066,  1077,
    1087,  1095,  1101,  1107,  1116,  1120,  1124,  1128,  1143,  1147,
    1164,  1169,  1183,  1187,  1198,  1202,  1206,  1219,  1223,  1227,
    1273,  1282,  1289,  1296,  1316,  1336,  1341,  1346,  1357,  1367,
    1372,  1376,  1383,  1387,  1393,  1399,  1403,  1407,  1413,  1417,
    1423,  1427,  1433,  1441,  1449,  1457,  1465,  1474,  1481,  1485,
    1489,  1515,  1520,  1525,  1529,  1533,  1541,  1545
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

#define YYPACT_NINF -343

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-343)))

#define YYTABLE_NINF -114

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      63,  -343,    37,   278,  -343,   383,    36,    49,  -343,  -343,
    -343,  -343,  -343,   340,  -343,    63,  -343,  -343,   198,  -343,
    -343,    36,    17,    31,     7,   -18,     7,     7,  -343,  -343,
     103,   355,  -343,  -343,   119,  -343,  -343,    67,  -343,   390,
     119,  -343,     7,  -343,  -343,    77,  -343,    86,  -343,    12,
    -343,  -343,  -343,  -343,   143,   234,  -343,    67,   157,   147,
     152,  -343,   248,   172,   -23,  -343,   119,     7,  -343,  -343,
    -343,  -343,   324,   194,   345,   231,   142,   345,  -343,   216,
     345,     7,     7,   345,  -343,   345,  -343,     7,  -343,   229,
     249,   368,  -343,    56,  -343,   142,  -343,   -14,  -343,   242,
    -343,  -343,   142,  -343,  -343,   307,   345,   142,  -343,   159,
     308,   142,   313,   306,   334,   364,     9,  -343,   226,     7,
     370,  -343,  -343,    36,   350,   367,  -343,   303,   130,   382,
    -343,   303,   345,  -343,   256,  -343,  -343,  -343,   142,   142,
     142,   142,  -343,   345,   303,   345,  -343,  -343,   345,  -343,
     345,  -343,  -343,   171,   395,   399,   345,   418,  -343,   591,
     142,   142,  -343,  -343,   356,   356,  -343,  -343,  -343,  -343,
    -343,   402,  -343,  -343,  -343,     7,  -343,   132,  -343,  -343,
    -343,  -343,  -343,  -343,   411,    13,   422,   423,  -343,   191,
       7,   405,    78,   284,  -343,  -343,  -343,   550,  -343,   410,
     412,  -343,  -343,   303,   303,  -343,   404,  -343,  -343,  -343,
     123,     7,  -343,     7,     7,     7,   426,   428,   429,   374,
    -343,  -343,  -343,   120,   -30,  -343,  -343,   416,  -343,  -343,
    -343,  -343,  -343,  -343,  -343,  -343,  -343,   425,  -343,   419,
     432,   434,   391,   391,   142,   142,   142,  -343,   211,  -343,
     247,   345,  -343,  -343,  -343,   658,  -343,   658,  -343,  -343,
    -343,  -343,   372,   372,   303,   303,   303,  -343,  -343,  -343,
    -343,   211,  -343,   431,   347,  -343,   142,   142,    51,   246,
     436,   420,   415,  -343,   -20,  -343,  -343,    35,  -343,  -343,
      24,   606,   437,   440,   444,   450,   441,  -343,  -343,  -343,
       7,   303,   303,   438,   246,   435,   246,  -343,   455,  -343,
     237,   207,     7,  -343,  -343,   185,   345,  -343,    51,  -343,
    -343,  -343,    36,  -343,   447,  -343,  -343,  -343,  -343,  -343,
    -343,  -343,  -343,   465,   345,   336,     7,  -343,   247,  -343,
     460,   246,   246,   246,   246,   345,   207,   172,    99,  -343,
     391,   446,   473,   474,   476,   477,   459,   591,  -343,  -343,
    -343,   464,   478,   345,  -343,   328,   328,   451,   451,  -343,
     100,  -343,   658,   207,   296,   345,  -343,  -343,     7,   345,
    -343,    28,   400,   345,  -343,    85,  -343,   487,  -343,  -343,
    -343,   172,   489,  -343,  -343,   591,   591,   172,  -343,   345,
     658,  -343,  -343,   457,   509,  -343,   494,   643,  -343,  -343
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     7,     0,     2,     1,     0,     0,     0,     9,    10,
      15,    12,    28,     0,    16,     0,    27,    11,     0,    13,
      26,     0,     0,     0,     0,     0,     0,     0,    29,    17,
       0,     0,    48,    34,     0,    18,    59,     0,    19,    54,
       0,    20,     0,    21,    22,     0,    23,     0,    24,     0,
      14,    25,    74,    72,     0,    46,    75,     0,    57,     0,
       0,    53,    60,    66,     0,    65,     0,     0,    32,    33,
      94,    30,     0,     0,     0,    49,     0,     0,    45,     0,
       0,     0,     0,     0,    61,     0,    67,     0,    64,     0,
     148,     0,   147,     0,    42,     0,    43,     0,    31,    35,
      41,    36,     0,    84,    83,    51,     0,     0,    93,     0,
       0,     0,     0,     0,     0,     0,     0,    63,     0,     0,
       0,   146,    98,     0,     0,     0,    95,    39,     0,     0,
      40,    73,     0,    50,     0,    85,    86,    87,     0,     0,
       0,     0,    44,     0,    76,     0,    55,    56,     0,   216,
       0,    68,    70,     0,     0,     0,    79,     0,     4,     0,
       0,     0,    52,    92,    88,    89,    90,    91,    47,    58,
      62,     0,    69,    71,   149,     0,    77,     0,    97,    99,
     135,   144,   142,   134,     0,     0,     0,     0,   128,     0,
       0,     0,     0,     0,   126,   116,   130,     0,   115,     0,
       0,   133,   132,    37,    38,   217,     0,    80,    81,    82,
       0,     0,   125,     0,     0,     0,     0,     0,     0,     0,
     119,   121,   155,   164,     0,   152,   154,     0,   129,   127,
     131,    96,   114,   120,   122,    78,   102,     0,   100,     0,
       0,     0,     0,     0,     0,     0,     0,   118,     0,   167,
       0,     0,   166,   150,   151,     0,   103,     0,   123,   124,
     140,   141,     0,     0,   145,   143,   117,   160,   161,   162,
     163,   156,   159,     0,     0,   191,     0,     0,     0,     0,
       0,     0,     0,   183,   179,   185,   186,     0,   172,   180,
       0,     0,     0,     0,     0,     0,     0,   158,   165,   169,
       0,   187,   188,     0,     0,     0,     0,   210,   213,   209,
       0,     0,     0,   184,   174,     0,     0,   178,     0,   153,
     170,   109,     0,   108,     0,   104,   105,   101,   138,   139,
     136,   137,   157,     0,     0,     0,     0,   207,     0,   215,
     190,     0,     0,     0,     0,     0,     0,   200,     0,   197,
       0,     0,     0,     0,     0,     0,     0,     0,   168,   173,
     208,     0,     0,     0,   189,   202,   203,   204,   205,   206,
       0,   201,     0,     0,     0,     0,   176,   175,     0,     0,
     110,   107,     0,     0,   214,     0,   195,     0,   196,   198,
     199,   181,     0,   171,   106,     0,     0,   211,   192,     0,
       0,   182,   177,     0,     0,   212,     0,     0,   193,   194
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -343,   508,  -343,  -343,  -343,  -343,  -343,  -343,  -343,  -343,
    -343,  -343,  -343,   -15,  -343,  -343,   -42,   -22,  -228,   448,
     -56,   -24,  -343,   491,  -343,  -343,  -343,  -343,  -343,  -343,
     490,  -343,   -28,   499,  -343,  -343,  -343,    53,  -343,     3,
    -343,  -343,  -343,  -343,  -343,  -343,  -343,  -343,  -342,  -188,
     371,   375,  -235,  -343,   373,   -74,  -343,  -343,   337,  -343,
    -343,  -343,  -343,   297,   357,  -246,  -268,  -343,  -343,  -324,
    -343,   199,     2,  -168
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     7,   124,   179,   237,     3,     8,     9,    15,
      30,    18,    29,    13,    49,    71,   283,   284,    98,    99,
     285,   286,    35,    78,    38,    61,    39,    41,    44,    64,
      65,    46,    55,    58,    48,   156,   176,   108,   142,   109,
      93,   126,   210,   238,   290,   325,   326,   381,   197,   198,
     199,   200,   262,   201,    91,    92,   202,   224,   225,   226,
     248,   296,   271,   272,   227,   287,   288,   364,   289,   348,
     349,   350,   310,    86
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      34,    37,    40,    43,    45,    47,    31,    72,   263,   232,
     303,   291,    62,    68,   212,   382,   100,   121,    32,   320,
      63,    33,   370,   320,    -6,   321,   315,    94,    33,    96,
      -6,   322,    36,    33,   293,   295,   275,     4,    89,   222,
     253,   100,    63,   130,    12,    90,   316,    87,   101,   388,
     355,    42,   275,   403,   404,   252,   149,   122,    33,   113,
     114,   213,    69,   123,     1,   117,    -8,    70,    33,    90,
      -8,   125,   130,   129,   150,    33,    94,   276,    96,   277,
     323,   318,    33,   279,   394,    69,    33,   280,   395,   396,
     152,   319,    94,   276,    96,   277,   151,   154,   127,   279,
      56,    69,    33,   280,    14,   131,   281,    33,   157,    50,
     134,    -3,   282,    57,   144,   374,   317,   194,    -8,   320,
      52,   153,   281,    66,   236,   173,   387,   105,   282,    33,
     110,   172,   398,   112,    67,   196,   115,   195,   116,   320,
     339,   164,   165,   166,   167,   121,   389,   222,   372,   386,
     399,   229,    53,   206,   407,   194,   207,   208,   209,   133,
     373,   373,   249,   203,   204,    54,   250,   218,    90,   230,
     223,    94,    52,   196,    33,   195,    73,   160,    -5,   371,
     135,   136,   137,   103,    80,   162,   251,   104,   223,   240,
     107,   241,   242,   243,   232,    81,   168,    90,   169,    20,
      82,   170,   223,   171,    53,    21,   100,   100,    22,   177,
      23,    24,    25,    26,    27,   232,   232,    54,    85,   267,
     292,   294,    33,   401,   216,   217,   103,    52,   273,   405,
     104,   138,   139,   140,   141,    69,    33,   307,   101,   101,
     313,   102,    33,   138,   139,   140,   141,   264,   265,   266,
     106,    74,    75,    28,    76,   346,   268,   308,    33,    53,
     314,    77,   307,   111,   307,    74,    75,   103,   324,   269,
     270,   104,    54,   352,   107,    83,   118,    33,   333,   301,
     302,     5,   308,    94,   308,     6,   340,   103,   103,   347,
     351,   104,   104,   353,   304,   119,    69,    33,    33,   307,
     307,   307,   307,   116,   274,   163,   335,   356,   337,   341,
     342,   343,   344,   345,   361,   194,   362,   305,   100,   308,
     308,   308,   308,   306,   347,   228,   132,    96,   138,   139,
     140,   141,   309,   196,    69,   195,   143,    94,    95,    96,
     194,   145,    97,   365,   366,   367,   368,    33,    16,    17,
     101,   347,   347,   194,   194,   146,   392,   309,   196,   309,
     195,   194,   194,    16,    51,    94,    95,    96,   116,   354,
      97,   196,   196,   195,   195,   138,   139,   140,   141,   196,
     196,   195,   195,   147,    10,   360,   103,   359,    11,   299,
     104,   116,   148,   300,   309,   309,   309,   309,   369,   155,
    -113,   180,   343,   344,   345,   158,  -113,  -113,   341,   342,
     343,   344,   345,    94,    95,    96,   385,   120,    97,    33,
      59,    60,    69,   247,   159,    33,    16,   178,   391,   161,
     140,   141,   393,   181,   182,   183,   397,   184,   185,   186,
     187,   188,   174,    96,   186,   187,   189,   175,   190,   205,
      69,    33,   406,   235,   260,   261,  -113,  -111,   180,   211,
    -113,  -113,   191,  -111,  -111,    69,    33,    16,   380,   192,
     214,   215,   233,   244,   234,   245,   246,   193,   298,   255,
     256,   258,   257,   259,   311,   334,   328,   312,   275,   329,
     181,   182,   183,   330,   184,   185,   186,   187,   188,   331,
      96,   338,   336,   189,   357,   190,   363,    69,    33,  -112,
     180,   332,   358,  -111,   375,  -112,  -112,  -111,  -111,   191,
     376,   377,   378,    19,   379,   384,   192,   345,    94,   276,
      96,   277,   383,   318,   193,   279,   402,    69,    33,   280,
     400,   408,   181,   182,   183,   128,   184,   185,   186,   187,
     188,   180,    96,    84,    88,   189,    79,   190,   281,    69,
      33,   254,   220,   219,   282,  -112,   221,   239,   297,  -112,
    -112,   191,     0,   390,     0,     0,     0,     0,   192,     0,
       0,     0,     0,   181,   182,   183,   193,   184,   185,   186,
     187,   188,   180,    96,     0,     0,   189,     0,   190,     0,
      69,    33,     0,     0,     0,     0,   231,   275,     0,     0,
       0,     0,   191,     0,     0,     0,     0,     0,     0,   192,
       0,     0,     0,     0,   181,   182,   183,   193,   184,   185,
     186,   187,   188,     0,    96,     0,     0,   189,     0,   190,
       0,    69,    33,     0,   275,     0,     0,    94,   276,    96,
     277,     0,   318,   191,   279,     0,    69,    33,   280,   275,
     192,     0,   327,     0,     0,     0,     0,     0,   193,     0,
       0,     0,     0,     0,     0,     0,     0,   281,     0,     0,
       0,     0,     0,   282,    94,   276,    96,   277,     0,   318,
       0,   279,     0,    69,    33,   280,     0,   409,     0,    94,
     276,    96,   277,     0,   278,     0,   279,     0,    69,    33,
     280,     0,     0,     0,   281,     0,     0,     0,     0,     0,
     282,     0,     0,     0,     0,     0,     0,     0,     0,   281,
       0,     0,     0,     0,     0,   282
};

static const yytype_int16 yycheck[] =
{
      22,    23,    24,    25,    26,    27,    21,    49,   243,   197,
     278,   257,    40,     1,     1,   357,    72,    91,     1,   287,
      42,    51,   346,   291,     0,     1,    46,    41,    51,    43,
       6,     7,     1,    51,   262,   263,     1,     0,    66,    69,
      70,    97,    64,    99,     8,    67,    66,    70,    72,   373,
     318,    69,     1,   395,   396,   223,    47,     1,    51,    81,
      82,    48,    50,     7,     1,    87,     3,    55,    51,    91,
       7,    93,   128,    97,    65,    51,    41,    42,    43,    44,
      56,    46,    51,    48,    56,    50,    51,    52,    60,    61,
     118,    56,    41,    42,    43,    44,   118,   119,    95,    48,
      33,    50,    51,    52,    55,   102,    71,    51,   123,     6,
     107,    55,    77,    46,   111,   350,   284,   159,    55,   387,
       1,   118,    71,    46,     1,   153,   372,    74,    77,    51,
      77,   153,    47,    80,    48,   159,    83,   159,    85,   407,
     308,   138,   139,   140,   141,   219,   374,    69,    49,    49,
      65,   193,    33,   175,   400,   197,    24,    25,    26,   106,
      61,    61,    42,   160,   161,    46,    46,   189,   190,   193,
     192,    41,     1,   197,    51,   197,    33,    47,    55,   347,
      21,    22,    23,    41,    27,   132,    66,    45,   210,   211,
      48,   213,   214,   215,   382,    48,   143,   219,   145,     1,
      48,   148,   224,   150,    33,     7,   262,   263,    10,   156,
      12,    13,    14,    15,    16,   403,   404,    46,    46,     8,
     262,   263,    51,   391,    33,    34,    41,     1,   250,   397,
      45,    72,    73,    74,    75,    50,    51,   279,   262,   263,
     282,    47,    51,    72,    73,    74,    75,   244,   245,   246,
      19,    17,    18,    55,    20,    48,    45,   279,    51,    33,
     282,    27,   304,    47,   306,    17,    18,    41,   290,    58,
      59,    45,    46,   315,    48,    27,    47,    51,   300,   276,
     277,     3,   304,    41,   306,     7,    49,    41,    41,   311,
     312,    45,    45,   315,    48,    46,    50,    51,    51,   341,
     342,   343,   344,   250,   251,    49,   304,   322,   306,    72,
      73,    74,    75,    76,   336,   357,   338,    71,   374,   341,
     342,   343,   344,    77,   346,    41,    19,    43,    72,    73,
      74,    75,   279,   357,    50,   357,    28,    41,    42,    43,
     382,    28,    46,   341,   342,   343,   344,    51,     8,     9,
     374,   373,   374,   395,   396,    49,   378,   304,   382,   306,
     382,   403,   404,     8,     9,    41,    42,    43,   315,   316,
      46,   395,   396,   395,   396,    72,    73,    74,    75,   403,
     404,   403,   404,    49,     1,    49,    41,   334,     5,    42,
      45,   338,    28,    46,   341,   342,   343,   344,   345,    29,
       0,     1,    74,    75,    76,    55,     6,     7,    72,    73,
      74,    75,    76,    41,    42,    43,   363,    49,    46,    51,
      30,    31,    50,    49,    57,    51,     8,     9,   375,    47,
      74,    75,   379,    33,    34,    35,   383,    37,    38,    39,
      40,    41,    47,    43,    39,    40,    46,    48,    48,    47,
      50,    51,   399,    49,    63,    64,    56,     0,     1,    48,
      60,    61,    62,     6,     7,    50,    51,     8,     9,    69,
      48,    48,    62,    47,    62,    47,    47,    77,    47,    63,
      55,    49,    63,    49,    48,    47,    49,    67,     1,    49,
      33,    34,    35,    49,    37,    38,    39,    40,    41,    49,
      43,    46,    67,    46,    57,    48,    46,    50,    51,     0,
       1,    70,    47,    56,    68,     6,     7,    60,    61,    62,
      47,    47,    46,    15,    47,    47,    69,    76,    41,    42,
      43,    44,    68,    46,    77,    48,    47,    50,    51,    52,
      53,    47,    33,    34,    35,    97,    37,    38,    39,    40,
      41,     1,    43,    62,    64,    46,    57,    48,    71,    50,
      51,   224,   191,   190,    77,    56,   191,   210,   271,    60,
      61,    62,    -1,   374,    -1,    -1,    -1,    -1,    69,    -1,
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
       0,     1,    79,    84,     0,     3,     7,    80,    85,    86,
       1,     5,     8,    91,    55,    87,     8,     9,    89,    79,
       1,     7,    10,    12,    13,    14,    15,    16,    55,    90,
      88,    91,     1,    51,    95,   100,     1,    95,   102,   104,
      95,   105,    69,    95,   106,    95,   109,    95,   112,    92,
       6,     9,     1,    33,    46,   110,    33,    46,   111,    30,
      31,   103,   110,    95,   107,   108,    46,    48,     1,    50,
      55,    93,    94,    33,    17,    18,    20,    27,   101,   111,
      27,    48,    48,    27,   101,    46,   151,    70,   108,   110,
      95,   132,   133,   118,    41,    42,    43,    46,    96,    97,
      98,    99,    47,    41,    45,   115,    19,    48,   115,   117,
     115,    47,   115,    95,    95,   115,   115,    95,    47,    46,
      49,   133,     1,     7,    81,    95,   119,   117,    97,    99,
      98,   117,    19,   115,   117,    21,    22,    23,    72,    73,
      74,    75,   116,    28,   117,    28,    49,    49,    28,    47,
      65,    95,   110,   117,    95,    29,   113,    91,    55,    57,
      47,    47,   115,    49,   117,   117,   117,   117,   115,   115,
     115,   115,    95,   110,    47,    48,   114,   115,     9,    82,
       1,    33,    34,    35,    37,    38,    39,    40,    41,    46,
      48,    62,    69,    77,    94,    95,    99,   126,   127,   128,
     129,   131,   134,   117,   117,    47,    95,    24,    25,    26,
     120,    48,     1,    48,    48,    48,    33,    34,    95,   132,
     128,   129,    69,    95,   135,   136,   137,   142,    41,    94,
      99,    56,   127,    62,    62,    49,     1,    83,   121,   142,
      95,    95,    95,    95,    47,    47,    47,    49,   138,    42,
      46,    66,   151,    70,   136,    63,    55,    63,    49,    49,
      63,    64,   130,   130,   117,   117,   117,     8,    45,    58,
      59,   140,   141,    95,   115,     1,    42,    44,    46,    48,
      52,    71,    77,    94,    95,    98,    99,   143,   144,   146,
     122,   143,    94,    96,    94,    96,   139,   141,    47,    42,
      46,   117,   117,   144,    48,    71,    77,    94,    95,   115,
     150,    48,    67,    94,    95,    46,    66,   151,    46,    56,
     144,     1,     7,    56,    95,   123,   124,    56,    49,    49,
      49,    49,    70,    95,    47,   150,    67,   150,    46,   151,
      49,    72,    73,    74,    75,    76,    48,    95,   147,   148,
     149,    95,    94,    95,   115,   144,    91,    57,    47,   115,
      49,    95,    95,    46,   145,   150,   150,   150,   150,   115,
     147,   151,    49,    61,   130,    68,    47,    47,    46,    47,
       9,   125,   126,    68,    47,   115,    49,   143,   147,    96,
     149,   115,    95,   115,    56,    60,    61,   115,    47,    65,
      53,   151,    47,   126,   126,   151,   115,   143,    47,    54
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    78,    80,    81,    82,    83,    79,    79,    84,    84,
      85,    85,    87,    88,    86,    86,    89,    89,    90,    90,
      90,    90,    90,    90,    90,    90,    90,    91,    91,    92,
      92,    93,    93,    94,    95,    96,    96,    96,    96,    96,
      97,    97,    98,    99,   100,   100,   100,   100,   100,   101,
     101,   101,   101,   102,   102,   103,   103,   104,   104,   104,
     105,   105,   105,   106,   107,   107,   108,   108,   109,   109,
     109,   109,   110,   110,   110,   111,   111,   112,   113,   114,
     114,   114,   114,   115,   115,   116,   116,   116,   117,   117,
     117,   117,   117,   117,   118,   118,   119,   119,   119,   120,
     120,   121,   121,   122,   122,   122,   123,   123,   123,   123,
     124,   125,   125,   125,   126,   126,   127,   127,   127,   127,
     127,   127,   127,   127,   127,   127,   127,   127,   127,   127,
     127,   127,   127,   127,   127,   127,   128,   128,   129,   129,
     130,   130,   131,   131,   131,   131,   132,   132,   133,   133,
     134,   135,   135,   136,   136,   138,   139,   137,   140,   140,
     141,   141,   141,   141,   142,   142,   142,   142,   142,   142,
     143,   143,   143,   143,   144,   144,   144,   144,   144,   144,
     144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
     144,   144,   145,   145,   146,   147,   147,   147,   148,   148,
     149,   149,   150,   150,   150,   150,   150,   150,   150,   150,
     150,   150,   150,   150,   150,   150,   151,   151
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     0,     0,     0,    15,     1,     0,     2,
       1,     3,     0,     0,     6,     2,     0,     2,     2,     2,
       2,     2,     2,     2,     2,     3,     1,     2,     1,     0,
       2,     2,     1,     1,     1,     1,     1,     4,     4,     2,
       2,     1,     1,     1,     5,     3,     2,     6,     1,     1,
       3,     2,     4,     2,     1,     4,     4,     2,     6,     1,
       2,     3,     6,     4,     2,     1,     1,     2,     5,     6,
       5,     6,     1,     4,     1,     1,     4,     6,     4,     0,
       2,     2,     2,     1,     1,     1,     1,     1,     3,     3,
       3,     3,     3,     1,     0,     2,     4,     3,     1,     0,
       2,     4,     1,     0,     2,     2,     4,     3,     1,     1,
       3,     3,     3,     1,     2,     1,     1,     4,     3,     2,
       2,     2,     2,     4,     4,     2,     1,     2,     1,     2,
       1,     2,     1,     1,     1,     1,     6,     6,     6,     6,
       1,     1,     1,     4,     1,     4,     2,     1,     1,     4,
       3,     2,     1,     4,     1,     0,     0,     5,     2,     1,
       1,     1,     1,     1,     1,     4,     2,     2,     6,     4,
       2,     5,     1,     4,     2,     4,     4,     6,     2,     1,
       1,     5,     6,     1,     2,     1,     1,     2,     2,     4,
       3,     1,     3,     5,     8,     3,     3,     1,     3,     3,
       1,     2,     3,     3,     3,     3,     3,     2,     3,     1,
       1,     5,     6,     1,     4,     2,     3,     5
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
#line 177 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { log("type_declarations\n"); }
#line 1733 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 3:
#line 181 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { Memories->Initialize();  log("memory_layout\n"); }
#line 1739 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 4:
#line 183 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { ParsingMacros=true; }
#line 1745 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 5:
#line 185 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { ParsingMacros=false; log("action_macros\n"); }
#line 1751 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 6:
#line 188 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { 
			sprintf(log_str,"END OF FILE\n");
			log(log_str);
		  }
#line 1760 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 7:
#line 193 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown keyword %s, at line %d:\n   <%s>",(yyvsp[0].string),program_lines);
		   yyerror2(tmp); return 1;
		}
#line 1769 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 11:
#line 205 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   PackageCode->AddMembers((yyvsp[-1].TargetCode));
		   delete (yyvsp[-1].TargetCode);
		}
#line 1778 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 12:
#line 212 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
	   // Switching between files is handled by LEX
	   fprintf(stderr,"Opened include file %s\n",(yyvsp[0].string));
	   file_name_stack[file_name_stack_ptr++]=current_file_name;
	   current_file_name=(yyvsp[0].string);
	}
#line 1789 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 13:
#line 219 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
	   // Switching between files is handled by LEX
	   fprintf(stderr,"Closed include file %s\n",current_file_name);
	   delete current_file_name;
           current_file_name=file_name_stack[--file_name_stack_ptr];
	}
#line 1800 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 15:
#line 227 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Include file name must be enclosed in brackets, at line %d:\n   <%s>",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 1809 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 18:
#line 238 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"INPUT %s\n",(yyvsp[0].Input)->Name());
		   log(log_str);
		   Inputs->AddMember((yyvsp[0].Input));
		}
#line 1819 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 19:
#line 244 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"INTERNAL %s\n",(yyvsp[0].Internal)->Name());
		   log(log_str);
		   Internals->AddMember((yyvsp[0].Internal));
		}
#line 1829 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 20:
#line 250 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"OUTPUT %s\n",(yyvsp[0].Output)->Name());
		   log(log_str);
		   Outputs->AddMember((yyvsp[0].Output));
		}
#line 1839 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 21:
#line 256 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"Name=%s\n",(yyvsp[0].string));
		log(log_str);
		   Entity_Name=(yyvsp[0].string);
		}
#line 1849 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 22:
#line 262 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   Aliases->AddMember((yyvsp[0].Alias));
		}
#line 1857 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 23:
#line 266 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   Memories->AddMember((yyvsp[0].Memory));
		}
#line 1865 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 24:
#line 270 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"START %s %s clock %s\n",(yyvsp[0].Start)->Name(),(yyvsp[0].Start)->Stream()->Name(),(yyvsp[0].Start)->ClockName());
		   log(log_str);
		   Starts->AddMember((yyvsp[0].Start));
		}
#line 1875 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 25:
#line 276 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   UseClauses->AddMembers((yyvsp[-1].TargetCode));
		   delete (yyvsp[-1].TargetCode);
		}
#line 1884 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 26:
#line 281 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Interface Parameter error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 1893 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 27:
#line 288 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		log("target_code (1)\n");
		   (yyval.TargetCode)=(yyvsp[-1].TargetCode);
		   (yyval.TargetCode)->AddMember((yyvsp[0].string));
		}
#line 1903 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 28:
#line 294 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		log("target_code (2)\n");
		   (yyval.TargetCode)=new target_code();
		   (yyval.TargetCode)->AddMember((yyvsp[0].string));
		}
#line 1913 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 30:
#line 303 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   Constants->AddMember((yyvsp[0].Constant));
		}
#line 1921 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 31:
#line 309 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
           // Check if constant already exists
		   (yyval.Constant)=new constant((yyvsp[-1].string),(yyvsp[0].string));
		   sprintf(log_str,"%s %s\n",(yyvsp[-1].string),(yyvsp[0].string));
		   log(log_str);
		   for(int i=0;i<Constants->NrOfMembers();i++)
		   {
		       if (strcmp(Constants->Member(i)->Name(),(yyvsp[-1].string))==0)
			   {
			   	  sprintf(tmp,"Constant Parameter already defined. Line %d:\n   %s",program_lines,(yyvsp[-1].string));
				  yyerror2(tmp); return 1;
			   }
		   }
		}
#line 1940 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 32:
#line 324 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Constant Parameter error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 1949 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 33:
#line 331 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=cpystr((yyvsp[0].string));
//		   delete $<string>1;
		}
#line 1958 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 34:
#line 338 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=cpystr((yyvsp[0].string));
//		   delete $<string>1;
		}
#line 1967 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 35:
#line 345 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=(yyvsp[0].string);
		}
#line 1975 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 36:
#line 349 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=(yyvsp[0].string);
		}
#line 1983 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 37:
#line 353 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-2].string));
		   };
		   (yyval.string)=new char[strlen(tmp)+1];
		   strcpy((yyval.string),tmp);
		}
#line 1997 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 38:
#line 363 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-2].string));
		   };
		   (yyval.string)=new char[strlen(tmp)+1];
		   strcpy((yyval.string),tmp);
		}
#line 2011 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 39:
#line 373 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-1].string));
		   };
		   (yyval.string)=new char[strlen(tmp)+1];
		   strcpy((yyval.string),tmp);
		}
#line 2025 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 40:
#line 385 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=catstr((yyvsp[-1].string),(yyvsp[0].string));
//sprintf(log_str,"bit_strings: %s\n",$<string>$);
//log(log_str);
		   delete (yyvsp[-1].string);
		   delete (yyvsp[0].string);
		}
#line 2037 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 41:
#line 393 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=(yyvsp[0].string);
//sprintf(log_str,"bit_strings %s\n",$<string>$);
//log(log_str);
		}
#line 2047 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 42:
#line 401 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
//		   sprintf(log_str,"%s\n",$<string>1);
//		   log(log_str);
		   (yyval.string)=cpystr((yyvsp[0].string));
		}
#line 2057 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 43:
#line 409 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,hex2bits((yyvsp[0].string)));
		   (yyval.string)=new char[strlen(tmp)+1];
		   strcpy((yyval.string),tmp);
		}
#line 2067 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 44:
#line 417 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Input)=new input((yyvsp[-4].string),new array_type(1,(yyvsp[-3].number)),(yyvsp[-1].number),(yyvsp[0].number));
		}
#line 2075 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 45:
#line 421 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Input)=new input((yyvsp[-2].string),new array_type(1,(yyvsp[-1].number)),(yyvsp[0].Driver));
		}
#line 2083 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 46:
#line 425 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Input)=new input((yyvsp[-1].string),new array_type(1,(yyvsp[0].number)));
		}
#line 2091 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 47:
#line 429 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Input)=new input((yyvsp[-5].string),new array_type(1,(yyvsp[-4].number)),new range_class((yyvsp[-2].number),(yyvsp[0].number)));
		}
#line 2099 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 48:
#line 433 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Lexem error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2108 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 49:
#line 440 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Driver)=new device_driver(new software_driver());
		}
#line 2116 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 50:
#line 444 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Driver)=new device_driver(new software_driver((yyvsp[0].number)));
		}
#line 2124 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 51:
#line 448 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Driver)=new device_driver(new hardware_driver((yyvsp[0].number)));
		}
#line 2132 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 52:
#line 452 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Driver)=new device_driver(new hardware_driver((yyvsp[-2].number),(yyvsp[0].number)));
		}
#line 2140 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 53:
#line 458 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { (yyval.Internal)=(yyvsp[-1].Internal); }
#line 2146 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 54:
#line 460 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { (yyval.Internal)=(yyvsp[0].Internal); }
#line 2152 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 57:
#line 468 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Internal)=new internal((yyvsp[-1].string),new array_type(1,(yyvsp[0].number)));
		}
#line 2160 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 58:
#line 472 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Internal)=new internal((yyvsp[-5].string),new array_type(1,(yyvsp[-4].number)),new range_class((yyvsp[-2].number),(yyvsp[0].number)));
		}
#line 2168 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 59:
#line 476 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Lexem error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2177 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 60:
#line 483 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Output)=new output((yyvsp[-1].string),new array_type(1,(yyvsp[0].number)));
		}
#line 2185 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 61:
#line 487 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Output)=new output((yyvsp[-2].string),new array_type(1,(yyvsp[-1].number)),(yyvsp[0].Driver));
		}
#line 2193 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 62:
#line 491 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Output)=new output((yyvsp[-5].string),new array_type(1,(yyvsp[-4].number)),new range_class((yyvsp[-2].number),(yyvsp[0].number)));
		}
#line 2201 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 63:
#line 497 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Alias)=new alias((yyvsp[0].string),(yyvsp[-2].Aliased_Signals));
		}
#line 2209 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 64:
#line 503 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Aliased_Signals)=(yyvsp[-1].Aliased_Signals);
		   (yyval.Aliased_Signals)->AddMember((yyvsp[0].Aliased_Signal));
		}
#line 2218 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 65:
#line 508 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Aliased_Signals)=new aliased_signal_names((yyvsp[0].Aliased_Signal));
		}
#line 2226 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 66:
#line 514 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Aliased_Signal)=new aliased_signal_name((yyvsp[0].string));
		}
#line 2234 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 67:
#line 518 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Aliased_Signal)=new aliased_signal_name((yyvsp[-1].string),(yyvsp[0].Range));
		}
#line 2242 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 68:
#line 524 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Memory)=new memory((yyvsp[-4].string),(yyvsp[-2].number),1,(yyvsp[0].string));
		}
#line 2250 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 69:
#line 528 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Memory)=new memory((yyvsp[-5].string),(yyvsp[-3].number),(yyvsp[-1].number),(yyvsp[0].string));
		}
#line 2258 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 70:
#line 532 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Memory)=new memory((yyvsp[-4].string),(yyvsp[-2].number),1,(yyvsp[0].number));
		}
#line 2266 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 71:
#line 536 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Memory)=new memory((yyvsp[-5].string),(yyvsp[-3].number),(yyvsp[-1].number),(yyvsp[0].number));
		}
#line 2274 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 72:
#line 542 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=1;
		}
#line 2282 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 73:
#line 546 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number);
		}
#line 2290 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 74:
#line 550 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Unknown Bit Size error at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2299 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 75:
#line 557 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=1;
		}
#line 2307 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 76:
#line 561 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)*(yyvsp[0].number);
		}
#line 2315 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 77:
#line 567 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Start)=new start((yyvsp[-5].string),(yyvsp[-3].Input_Stream),(yyvsp[-1].string),(yyvsp[0].number));
		}
#line 2323 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 78:
#line 573 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.string)=cpystr((yyvsp[-1].string));
		}
#line 2331 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 79:
#line 579 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=0;
		}
#line 2339 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 80:
#line 583 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number)*1000;
		}
#line 2347 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 81:
#line 587 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number)*1000000;
		}
#line 2355 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 82:
#line 591 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number)*1000000000;
		}
#line 2363 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 83:
#line 597 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		  // In case of mixed 0:s to 9:s
		  (yyval.number)=atoi((yyvsp[0].string));
		}
#line 2372 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 84:
#line 602 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		  // In case of only 0:s and 1:s
		  (yyval.number)=atoi((yyvsp[0].string));
		}
#line 2381 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 85:
#line 609 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		  (yyval.number)=KBPS;
		}
#line 2389 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 86:
#line 613 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		  (yyval.number)=MBPS;
		}
#line 2397 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 87:
#line 617 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		  (yyval.number)=GBPS;
		}
#line 2405 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 88:
#line 623 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)+(yyvsp[0].number);
		}
#line 2413 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 89:
#line 627 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)-(yyvsp[0].number);
		}
#line 2421 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 90:
#line 631 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)*(yyvsp[0].number);
		}
#line 2429 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 91:
#line 635 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-2].number)/(yyvsp[0].number);
		}
#line 2437 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 92:
#line 639 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[-1].number);
		}
#line 2445 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 93:
#line 643 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.number)=(yyvsp[0].number);
		}
#line 2453 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 95:
#line 650 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   Layouts->AddMember((yyvsp[0].Layout));
		}
#line 2461 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 96:
#line 656 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Layout)=new layout((yyvsp[-3].string),(yyvsp[-1].Prod_Line));
		}
#line 2469 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 97:
#line 660 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   SignalDeclarations->AddMembers((yyvsp[-1].TargetCode));
		   delete (yyvsp[-1].TargetCode);
		}
#line 2478 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 98:
#line 665 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected a Memory declaration or Start of Action section at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2487 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 100:
#line 673 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Check Action if already defined?
		   Actions->AddMember((yyvsp[0].Action));
		}
#line 2496 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 101:
#line 680 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action)=new action((yyvsp[-3].Action_Target),(yyvsp[-1].Action_Line));
		}
#line 2504 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 102:
#line 684 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected an Action declaration or Start of Grammar section at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2513 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 104:
#line 692 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"code_grammar->Production: %s\n",(yyvsp[0].Production)->Name());
		   log(log_str);
		   Grammars->AddMember((yyvsp[0].Production));
		}
#line 2523 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 105:
#line 698 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"code_grammar->architecture_target_code\n");
		   log(log_str);
		}
#line 2532 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 106:
#line 705 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
			sprintf(log_str,"grammar_production %s\n",(yyvsp[-3].string));
			log(log_str);
		   if (Grammars->IsMember((yyvsp[-3].string)))
		   {
		      sprintf(tmp,"Error: Duplicate Definition of Production %s at line %d\n",(yyvsp[-3].string),program_lines);
			  log(log_str);
		      yyerror2(tmp); return 1;
		   }
		   else
		   {
		      (yyval.Production)=new production((yyvsp[-3].string),(yyvsp[-1].Prod_Lines));
		   };
		   //log("BAKAYARO\n");
		}
#line 2552 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 107:
#line 721 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected semicolon at line %d.\n",program_lines);
		   yyerror2(tmp); return 1;
		}
#line 2561 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 108:
#line 726 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Stray semicolon at line %d.\n",program_lines);
		   yyerror2(tmp); return 1;
		}
#line 2570 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 109:
#line 731 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected a Grammar declaration at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 2579 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 110:
#line 738 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   log("architecture_target_code(1)\n");
		   ArchitectureCode->AddMembers((yyvsp[-1].TargetCode));
		   delete (yyvsp[-1].TargetCode);
		   log("architecture_target_code(2)\n");
		}
#line 2590 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 111:
#line 747 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Lines)=(yyvsp[-2].Prod_Lines);
		   (yyval.Prod_Lines)->AddMember((yyvsp[0].Prod_Line));
		}
#line 2599 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 113:
#line 753 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Lines)=new production_lines((yyvsp[0].Prod_Line));
		}
#line 2607 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 114:
#line 759 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Line)=(yyvsp[-1].Prod_Line);
		   (yyval.Prod_Line)->AddMember((yyvsp[0].Prod_Item));
		}
#line 2616 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 115:
#line 764 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Line)=new production_line((yyvsp[0].Prod_Item));
		}
#line 2624 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 116:
#line 770 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"(1) Production %s\n",(yyvsp[0].string));
		   log(log_str);
		   (yyval.Prod_Item)=new production_item(new production_lexem((yyvsp[0].string)));
		}
#line 2634 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 117:
#line 776 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"(2) Production %s x %d\n",(yyvsp[-2].string),(yyvsp[0].number));
		   log(log_str);
		   (yyval.Prod_Item)=new production_item(new production_lexem((yyvsp[-2].string),(yyvsp[0].number)));
		   log("BAKA\n");
		}
#line 2645 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 118:
#line 783 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"Stream redirection %s %s\n",(yyvsp[-1].string));
		   log(log_str);
		   (yyval.Prod_Item)=new production_item(new production_redirection((yyvsp[-1].Input_Stream)));
		}
#line 2655 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 119:
#line 789 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Left Associative Condition
		   sprintf(log_str,"Left Conditional AND\n");
		   log(log_str);
		   (yyval.Prod_Item)=new production_item((yyvsp[0].Cond));
		}
#line 2666 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 120:
#line 796 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Right Associative Condition
		   sprintf(log_str,"Right Conditional AND\n");
		   log(log_str);
		   (yyval.Prod_Item)=new production_item((yyvsp[-1].Cond));
		}
#line 2677 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 121:
#line 803 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Left Associative Synchronisation
		   sprintf(log_str,"Left Sync\n");
		   log(log_str);
		   (yyval.Prod_Item)=new production_item((yyvsp[0].Cond));
		}
#line 2688 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 122:
#line 810 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Right Associative Synchronisation
		   sprintf(log_str,"Right Sync\n");
		   log(log_str);
		   (yyval.Prod_Item)=new production_item((yyvsp[-1].Cond));
		}
#line 2699 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 123:
#line 817 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"Interrupt\n");
		   log(log_str);
		   (yyval.Prod_Item)=new production_item(new production_interrupt((yyvsp[-1].string)));
		}
#line 2709 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 124:
#line 823 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"Reset\n");
		   log(log_str);
		   (yyval.Prod_Item)=new production_item(new production_reset((yyvsp[-1].string)));
		}
#line 2719 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 125:
#line 829 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Error in Reset statement at line %d:\n   %s",program_lines,(yyvsp[-1].string));
		   log(tmp);
		   yyerror2(tmp); return 1;
		}
#line 2729 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 126:
#line 835 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   //sprintf(log_str,"CONSTANT %s\n", Constants->Member(i)->Name());
		   //log(log_str);
		   found=false;
		   //sprintf(log_str,"Exist %s?\n",$<string>1);
           //log(log_str);
		   for(i=0;i<Constants->NrOfMembers();i++)
		   {
		      if (strcmp(Constants->Member(i)->Name(),(yyvsp[0].string))==0)
		      {
		         // sprintf(log_str,"Y!\n");
                 // log(log_str);
		         (yyval.Prod_Item)=new production_item(new production_terminal(Constants->Member(i)->Value(),false));
			     found=true;
			     break;
		      };
		   };
		   if (!found)
		   {
		      sprintf(tmp,"Constant %s at line %d has not been defined\n",(yyvsp[0].string),program_lines);
			  log(tmp);
		      yyerror2(tmp); return 1;
		   };
		}
#line 2758 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 127:
#line 860 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 2782 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 128:
#line 880 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
//			sprintf(log_str,"BIT_STRING %s\n",$<string>1);
//			log(log_str);
		   (yyval.Prod_Item)=new production_item(
				 new production_terminal(cpystr((yyvsp[0].string)),false));
		}
#line 2793 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 129:
#line 892 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		      sprintf(log_str,"Not bit_string\n");
              log(log_str);
		   (yyval.Prod_Item)=new production_item(
				 new production_terminal(cpystr((yyvsp[0].string)),true));
		}
#line 2804 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 130:
#line 899 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		      sprintf(log_str,"hex_number\n");
              log(log_str);
		   (yyval.Prod_Item)=new production_item(
				 new production_terminal((yyvsp[0].string),false));
		}
#line 2815 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 131:
#line 906 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		      sprintf(log_str,"Not hex_number\n");
              log(log_str);
		   (yyval.Prod_Item)=new production_item(
				 new production_terminal((yyvsp[0].string),true));
		}
#line 2826 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 132:
#line 913 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   log("Action\n");
		   (yyval.Prod_Item)=new production_item((yyvsp[0].Actions));
		}
#line 2835 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 133:
#line 918 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   log("Size definition\n");
		   (yyval.Prod_Item)=(yyvsp[0].Prod_Item);
		}
#line 2844 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 134:
#line 923 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   log("Error\n");
		   (yyval.Prod_Item)=new production_item(new production_error());
		}
#line 2853 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 135:
#line 928 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected a Lexem or a Semicolon at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   log(tmp);
		   yyerror2(tmp); return 1;
		}
#line 2863 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 136:
#line 936 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 2878 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 137:
#line 947 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Cond)=new production_cond(new production_signal(new action_signal((yyvsp[-3].string))),(yyvsp[-2].boolean),(yyvsp[-1].string));
		}
#line 2886 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 138:
#line 953 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 2901 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 139:
#line 964 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Cond)=new production_cond(new production_signal(new action_signal((yyvsp[-3].string))),(yyvsp[-2].boolean),(yyvsp[-1].string));
		}
#line 2909 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 140:
#line 970 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.boolean)=true;
		}
#line 2917 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 141:
#line 974 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.boolean)=false;
		}
#line 2925 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 142:
#line 980 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_terminal(OTHER_BIT,1,false));
		}
#line 2933 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 143:
#line 984 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_terminal(OTHER_BIT,(yyvsp[0].number),false));
		}
#line 2941 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 144:
#line 988 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_terminal(DONT_CARE_BIT,1,false));
		}
#line 2949 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 145:
#line 992 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Prod_Item)=new production_item(new production_terminal(DONT_CARE_BIT,(yyvsp[0].number),false));
		}
#line 2957 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 146:
#line 998 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Input_Stream)=(yyvsp[-1].Input_Stream);
		   (yyval.Input_Stream)->AddMember((yyvsp[0].Stream_Item));
		}
#line 2966 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 147:
#line 1003 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Input_Stream)=new input_stream((yyvsp[0].Stream_Item));
		}
#line 2974 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 148:
#line 1009 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Stream_Item)=new stream_item((yyvsp[0].string));
		}
#line 2982 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 149:
#line 1013 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Stream_Item)=new stream_item((yyvsp[-3].string),(yyvsp[-1].string));
		}
#line 2990 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 150:
#line 1019 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Actions)=(yyvsp[-1].Actions);
		   log("Action\n");
		}
#line 2999 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 151:
#line 1026 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   log("Adding new Actions\n");
		   (yyval.Actions)=(yyvsp[-1].Actions);
		   (yyval.Actions)->AddMember((yyvsp[0].Action));
		}
#line 3009 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 152:
#line 1032 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   log("Creating new Actions\n");
		   (yyval.Actions)=new actions((yyvsp[0].Action));
		}
#line 3018 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 153:
#line 1039 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   log("action_target OK\n");
		   (yyval.Action)=new action((yyvsp[-3].Action_Target),(yyvsp[-1].Action_Line));
		   log("action_production OK\n");
		}
#line 3028 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 154:
#line 1045 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   log("vhdl_action ok\n");
		   (yyvsp[0].VHDLCode)->AddMember(new vhdl_atom("\n"));
		   log("Adding VHDLCode newline\n");
		   (yyval.Action)=new action((yyvsp[0].VHDLCode));
		   log("action_production OK\n");
		}
#line 3040 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 155:
#line 1054 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { ParsingVHDL=true; log("VHDL\n"); }
#line 3046 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 156:
#line 1054 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    { ParsingVHDL=false; log("VHDL OK\n"); }
#line 3052 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 157:
#line 1055 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"VHDL Action (1) %08x\n",(yyvsp[-2].VHDLCode));
		   log(log_str);
		   log("VHDL Action\n");
		   (yyval.VHDLCode)=(yyvsp[-2].VHDLCode);
		   log("VHDL Action OK\n");
//		   $<VHDLCode>$->PrintVHDL(error_log);
//		   log("VHDL Action OK (2)\n");
		}
#line 3066 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 158:
#line 1067 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3081 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 159:
#line 1078 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(log_str,"vhdl_atom (1) %08x\n",(yyvsp[0].VHDL_Atom));
		   log(log_str);
		   (yyval.VHDLCode)=new vhdl_code();
		   (yyval.VHDLCode)->AddMember(new vhdl_atom("            "));
		   (yyval.VHDLCode)->AddMember((yyvsp[0].VHDL_Atom));
		}
#line 3093 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 160:
#line 1088 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"STRING %s\n",(yyvsp[0].string));
		log(log_str);
		   (yyval.VHDL_Atom)=new vhdl_atom((yyvsp[0].string));
		 sprintf(log_str,"(STRING) vhdl_atom %08x\n",(yyval.VHDL_Atom));
		   log(log_str);
		}
#line 3105 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 161:
#line 1096 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"NUMBER %s\n",(yyvsp[0].string));
		log(log_str);
		   (yyval.VHDL_Atom)=new vhdl_atom((yyvsp[0].string));
		}
#line 3115 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 162:
#line 1102 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		sprintf(log_str,"(newline)\n");
		log(log_str);
		   (yyval.VHDL_Atom)=new vhdl_atom("\n            ");
		}
#line 3125 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 163:
#line 1108 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		sprintf(log_str,"(VARIABLE)\n");
		log(log_str);
		   (yyval.VHDL_Atom)=new vhdl_atom((yyvsp[0].Variable));
		}
#line 3136 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 164:
#line 1117 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Target)=new action_target((yyvsp[0].string));
		}
#line 3144 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 165:
#line 1121 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Target)=new action_target((yyvsp[-3].string),new action_address(new action_signal((yyvsp[-1].string))));
		}
#line 3152 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 166:
#line 1125 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Target)=new action_target((yyvsp[-1].string),new action_address((yyvsp[0].Range)));
		}
#line 3160 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 167:
#line 1129 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3179 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 168:
#line 1144 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Target)=new action_target((yyvsp[-5].string),(yyvsp[-3].number),new action_address(new action_signal((yyvsp[-1].string))));
		}
#line 3187 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 169:
#line 1148 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3206 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 170:
#line 1165 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Line)=(yyvsp[-1].Action_Line);
		   (yyval.Action_Line)->AddMember((yyvsp[0].Action_Item));
		}
#line 3215 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 171:
#line 1170 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3233 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 172:
#line 1184 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Line)=new action_line((yyvsp[0].Action_Item));
		}
#line 3241 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 173:
#line 1188 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
 		   (yyval.Action_Line)=new action_line((yyvsp[-2].Action_Item));
		   for(int i=0;i<((yyvsp[0].number))-1;i++)
		   {
			   (yyval.Action_Line)->AddMember((yyvsp[-2].Action_Item)->Copy());
		   }
		   //delete $<Action_Item>2;
		}
#line 3254 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 174:
#line 1199 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(new action_signal((yyvsp[0].string),true));
		}
#line 3262 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 175:
#line 1203 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(new action_signal((yyvsp[-3].string),1,new action_address(new action_signal((yyvsp[-1].string)))));
		}
#line 3270 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 176:
#line 1207 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3287 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 177:
#line 1220 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(new action_signal((yyvsp[-5].string),(yyvsp[-3].number),new action_address(new action_signal((yyvsp[-1].string)))));
		}
#line 3295 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 178:
#line 1224 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
	          (yyval.Action_Item)=new action_item(new action_signal((yyvsp[-1].string),(yyvsp[0].Range)));
		}
#line 3303 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 179:
#line 1228 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3319 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 180:
#line 1274 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item((yyvsp[0].Action_Mux));
		}
#line 3327 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 181:
#line 1283 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		   sprintf(log_str,"Data field %s (1)\n",(yyvsp[-2].string));
		   log(log_str);
		   (yyval.Action_Item)=new action_item(new action_variable((yyvsp[-2].string),(yyvsp[0].number)));
		}
#line 3338 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 182:
#line 1290 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		   sprintf(log_str,"Data field %s (2)\n",(yyvsp[-3].string));
		   log(log_str);
		   (yyval.Action_Item)=new action_item(new action_variable((yyvsp[-3].string),(yyvsp[-1].number),(yyvsp[0].Range)));
		}
#line 3349 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 183:
#line 1297 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3373 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 184:
#line 1317 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3397 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 185:
#line 1337 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(
				 new action_constant(cpystr((yyvsp[0].string))));
		}
#line 3406 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 186:
#line 1342 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item(
				 new action_constant((yyvsp[0].string)));
		}
#line 3415 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 187:
#line 1347 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-1].string));
		   };
		   (yyval.Action_Item)=new action_item(
				 new action_constant(cpystr(tmp)));
		}
#line 3429 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 188:
#line 1358 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   strcpy(tmp,"");
		   for (i=0;i<(yyvsp[0].number);i++)
		   {
		      strcat(tmp,(yyvsp[-1].string));
		   };
		   (yyval.Action_Item)=new action_item(
				 new action_constant(cpystr(tmp)));
		}
#line 3443 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 189:
#line 1368 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyvsp[-2].CDFG)->BitRange((yyvsp[0].Range));
		   (yyval.Action_Item)=new action_item((yyvsp[-2].CDFG));
		}
#line 3452 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 190:
#line 1373 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Item)=new action_item((yyvsp[-1].CDFG));
		}
#line 3460 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 191:
#line 1377 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   sprintf(tmp,"Expected an Action or a Semicolon at line %d:\n   %s",program_lines,(yyvsp[0].string));
		   yyerror2(tmp); return 1;
		}
#line 3469 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 192:
#line 1384 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Range)=new range_class((yyvsp[-1].number),(yyvsp[-1].number));
		}
#line 3477 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 193:
#line 1388 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Range)=new range_class((yyvsp[-3].number),(yyvsp[-1].number));
		}
#line 3485 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 194:
#line 1394 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Action_Mux)=new action_mux((yyvsp[-5].Mux_Expression),(yyvsp[-3].Action_Line),(yyvsp[-1].Action_Line));
		}
#line 3493 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 195:
#line 1400 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Expression)=(yyvsp[-1].Mux_Expression);
		}
#line 3501 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 196:
#line 1404 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Expression)=new mux_expression(new mux_and((yyvsp[-2].Mux_Expression),(yyvsp[0].Mux_Expression)));
		}
#line 3509 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 197:
#line 1408 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Expression)=new mux_expression((yyvsp[0].Mux_Condition));
		}
#line 3517 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 198:
#line 1414 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Condition)=new mux_condition((yyvsp[-2].Signal),(yyvsp[-1].boolean),(yyvsp[0].string));
		}
#line 3525 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 199:
#line 1418 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Mux_Condition)=new mux_condition((yyvsp[-2].Signal),(yyvsp[-1].boolean),(yyvsp[0].Signal));
		}
#line 3533 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 200:
#line 1424 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Signal)=new action_signal((yyvsp[0].string));
		}
#line 3541 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 201:
#line 1428 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Signal)=new action_signal((yyvsp[-1].string),(yyvsp[0].Range));
		}
#line 3549 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 202:
#line 1434 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("add",arg);
		}
#line 3561 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 203:
#line 1442 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("subtract",arg);
		}
#line 3573 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 204:
#line 1450 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("multiply",arg);
		}
#line 3585 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 205:
#line 1458 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("divide",arg);
		}
#line 3597 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 206:
#line 1466 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[-2].CDFG)); 
//BUG!!!! Arg 3 har fel typ
		   arg->AddMember((yyvsp[0].CDFG));
		   (yyval.CDFG)=new action_cdfg("shift_right",arg);
		}
#line 3610 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 207:
#line 1475 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // arguments MUST BE stored from the left to the right
		   action_arguments *arg=new action_arguments();
		   arg->AddMember((yyvsp[0].CDFG)); 
		   (yyval.CDFG)=new action_cdfg("not",arg);
		}
#line 3621 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 208:
#line 1482 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.CDFG)=(yyvsp[-1].CDFG);
		}
#line 3629 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 209:
#line 1486 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.CDFG)=new action_cdfg(new cdfg_constant((yyvsp[0].number)));
		}
#line 3637 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 210:
#line 1490 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
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
#line 3663 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 211:
#line 1516 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		   (yyval.CDFG)=new action_cdfg(new cdfg_variable((yyvsp[-2].string),(yyvsp[0].number)));
		}
#line 3672 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 212:
#line 1521 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // Source variable;
		   (yyval.CDFG)=new action_cdfg(new cdfg_variable((yyvsp[-3].string),(yyvsp[-1].number),(yyvsp[0].Range)));
		}
#line 3681 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 213:
#line 1526 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.CDFG)=new action_cdfg(new cdfg_signal((yyvsp[0].string)));
		}
#line 3689 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 214:
#line 1530 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.CDFG)=new action_cdfg(new cdfg_signal((yyvsp[-3].string),new action_address(new action_signal((yyvsp[-1].string)))));
		}
#line 3697 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 215:
#line 1534 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   cdfg_signal *new_signal;
		   new_signal=new cdfg_signal((yyvsp[-1].string),(yyvsp[0].Range));
		   (yyval.CDFG)=new action_cdfg(new_signal);
		}
#line 3707 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 216:
#line 1542 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   (yyval.Range)=new range_class((yyvsp[-1].number),(yyvsp[-1].number));
		}
#line 3715 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;

  case 217:
#line 1546 "..\\program_parser_v2024.yy" /* yacc.c:1646  */
    {
		   // MSB-first, i.e., parsed as [TO..FROM] 
		   (yyval.Range)=new range_class((yyvsp[-3].number),(yyvsp[-1].number));
		}
#line 3724 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
    break;


#line 3728 "../program_parser_v2024.tab.cpp" /* yacc.c:1646  */
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
#line 1552 "..\\program_parser_v2024.yy" /* yacc.c:1906  */


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




