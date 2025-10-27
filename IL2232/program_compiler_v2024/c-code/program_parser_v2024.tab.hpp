/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

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
#line 52 "..\\program_parser_v2024.yy" /* yacc.c:1909  */

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

#line 172 "../program_parser_v2024.tab.hpp" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE program_lval;

int program_parse (void);

#endif /* !YY_PROGRAM_PROGRAM_PARSER_V2024_TAB_HPP_INCLUDED  */
