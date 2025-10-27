#include <string.h>
#include <stdio.h>
#include "rli_string.h"

char *FormatBitString(char *s)
{
   char *tmp=cpystr(s);
   bool found_a_zero_or_a_one=false;
   for(int i=0;i<strlen(s);i++)
   {
      if (tmp[i]==' ')
      {
	 tmp[i]='_';
      }
      else
      {
	 found_a_zero_or_a_one=true;
      };
   };
   if (!found_a_zero_or_a_one) return NULL;
   return tmp;
};

char *NatToUnsigned(int nat)
{
   int i;
   int btos;
   char *str;
   btos=nat;
   str=NULL;
   for(i=0;btos!=0;i++)
   {
      if ((btos && (1<<i))!=0)
      {
	 str=catstr("1",str);
	 btos=btos-(1<<i);
      }
      else
      {
	 str=catstr("0",str);
      };
   };
   if (str==NULL)
   {
      str=cpystr("0");
   }
   return str;
};

void write_ieee_packages(FILE *file)
{
   fprintf(file,"LIBRARY IEEE;\n");
   fprintf(file,"USE IEEE.STD_LOGIC_1164.ALL;\n");
//   fprintf(file,"-- USE IEEE.NUMERIC_STD.ALL;\n");
   fprintf(file, "USE IEEE.STD_LOGIC_ARITH.ALL;\n");
   fprintf(file, "USE IEEE.STD_LOGIC_UNSIGNED.ALL;\n");
 //  fprintf(file,"-- LIBRARY SYNT;\n");
 //  fprintf(file,"-- USE SYNT.STD_LOGIC_ARITH.ALL;\n");
   fprintf(file,"USE WORK.ALL;\n");
   fprintf(file,"USE WORK.PROGRAM_PACKAGE.ALL;\n");
}
