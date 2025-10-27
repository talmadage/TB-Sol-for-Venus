#include <string.h>
#include <stdio.h>

int minimum(int a,int b)
{
  if (a<b) return a;
  return b;
};

int find(char *s,char c,int start)
{
  for(int i=start;i<strlen(s);i++)
  {
     if (s[i]==c)
     {
        return i;
     };
  };
  return strlen(s);
};

char *midstr(char *s,int start,int bits)
{
   char *tmp;
   tmp=new char[bits+1];
   strncpy(tmp,s+start,bits);
   tmp[bits]=NULL;
   return tmp;   
};

char *cpystr(char *s)
{
   char *tmp;
   if (s==NULL) return NULL;
   tmp=new char[strlen(s)+1];
   strcpy(tmp,s);
   return tmp;   
};

char *c2s(char c)
{
   char *tmp;
   tmp=new char[2];
   tmp[0]=c;
   tmp[1]=0;
   return tmp;   
};

char *catstr(char *s1,char *s2)
{
   char *tmp;
   tmp=new char[strlen(s1)+strlen(s2)+1];
   strcpy(tmp,s1);
   strcat(tmp,s2);
   return tmp;
};

char *itoa(int i)
{
   char tmp[32];
   sprintf(tmp,"%d",i);
   return cpystr(tmp);
};

char *ltoa(long l)
{
   char tmp[32];
   sprintf(tmp,"%ld",l);
   return cpystr(tmp);
};

/*
char *lltoa(long long ll)
{
   char tmp[64];
   sprintf(tmp,"%lld",ll);
   return cpystr(tmp);
};
*/

char *repeat(char c,int nr)
{
   char *tmp;
   tmp=new char[nr+1];
   for(int i=0;i<nr;i++) tmp[i]=c;
   tmp[nr]=0;
   return tmp;
};

char *mirror(char *s)
{
   char *ret=new char(strlen(s)+1);
   int length=strlen(s);
   for(int i=0;i<length;i++)
   {
     ret[i]=s[length-i-1];
   };
   ret[length]=0;
   return ret;
};



