#include <stdio.h>

int ipow2 (int arg)
{
   int i,ret_value;
   if (arg>31)
   {
      printf(" Warning : Bad arguments for function pow2_of \n"); 
      return -1;
   };
   if (arg<0) return 0;
   for (i=0,ret_value=1;i<arg;i++,ret_value<<=1);
   return ret_value;
};

int ilog2 (int arg)
{
   int i,tmp;
   if (arg<=0)
   {
      printf(" Warning : Bad arguments for function log2_of \n"); 
      return -1;
   };
   for(i=0,tmp=arg;tmp>0;i++,tmp>>=1);
   return (i-1);
};
