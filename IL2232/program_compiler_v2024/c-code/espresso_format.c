#include <stdio.h>
#include <string.h>
#include "espresso_format.h"

parsed_cubes *Function;
parsed_labels *InputLabels;
parsed_labels *OutputLabels;

void parsed_cube::Write(FILE *file)
{
   fprintf(stderr,"%s %s\n",Input(),Output());
};

int parsed_cubes::Estimate(technology *tech)
{
   char **pla_inputs;
   pla_inputs=(char **)malloc(sizeof(char *)*NrOfMembers());
   for(int i=0;i<NrOfMembers();i++)
   {
      pla_inputs[i]=Member(i)->Input();
   };
   char **pla_outputs;
   pla_outputs=(char **)malloc(sizeof(char *)*NrOfMembers());
   for(int i=0;i<NrOfMembers();i++)
   {
      pla_outputs[i]=Member(i)->Output();
   };
   int pla_area=tech->PLA(pla_inputs,pla_outputs,NrOfMembers());
   delete pla_inputs;
   delete pla_outputs;
   return pla_area;
};



void parsed_cubes::Write(FILE *file)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->Write(file);
   };
};

void parsed_labels::Write(FILE *file)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      fprintf(stderr," %s",Member(i));
   };
};

