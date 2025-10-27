#include <stdio.h>
#include "rli_types.h"

extern int external_parse();
extern int external_lines;

int external_error(char *s)
{
   fprintf(stderr,"%s\n   Syntax error on line %d\n",s,external_lines);
   exit(1);
};

extern FILE *external_in;
extern Dyn_Var *Parameters;

main()
{
   int i,j;
   external_in = fopen("param_test","r");
   external_parse();
   fprintf(stderr,"Found %d parameter(s)\n",Parameters->NrOfMembers());
   for (i=0;i<Parameters->NrOfMembers();i++)
   {
      fprintf(stderr,"Member %d is of type %d\n",i,Parameters->Member(i)->Type());
      fprintf(stderr,"   and has %d member(s)\n",Parameters->Member(i)->NrOfMembers());
      for (j=0;j<Parameters->Member(i)->NrOfMembers();j++)
      {
	 fprintf(stderr,"      Member %d is of type %d\n",j,Parameters->Member(i)->Member(j)->Type());
	 fprintf(stderr,"         and is named %s and has value %s\n",
		 Parameters->Member(i)->Member(j)->Name(),
		 Parameters->Member(i)->Member(j)->Value());
      };
   };
};
