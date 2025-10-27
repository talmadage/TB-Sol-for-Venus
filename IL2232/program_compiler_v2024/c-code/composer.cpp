#include "program.h"
#include "composer.h"
#include "lib/rli_string.h"

char *CADD="add";
char *CSUB="subtract";
char *CMUL="multiply";
char *CDIV="divide";
char *CSHR="shift_right";
char *COR="\"or\"";
char *CAND="\"and\"";
char *CXOR="\"xor\"";
char *CXNOR="\"xnor\"";
char *CNOR="\"nor\"";
char *CNAND="\"nand\"";
char *CNOT="\"not\"";

extern internals *Internals;
/*
char *int2bits(int number)
{
   char s[129];
   int j=0;
   for(int tmp=number;tmp>0;tmp=tmp>>1,j++)
   {
      if (tmp%2==1)
      {
	 s[j]='1';
	 tmp--;
      }
      else
      {
	 s[j]='0';
      };
   };
   s[j]=0;
   return mirror(s);
};
*/
/*
void Cadd(action_arguments *arg,int output_stream_width,int offset, int result_size)
{
  fprintf(error_log,"ADD(");
  Composer(arg->Member(0),output_stream_width,offset,result_size);
  Composer(arg->Member(1),output_stream_width,offset,result_size);
  fprintf(error_log,")\n",output_stream_width,offset);
};

void Csub(action_arguments *arg,int output_stream_width,int offset, int result_size)
{
};

void Cmul(action_arguments *arg,int output_stream_width,int offset, int result_size)
{
};

void Cdiv(action_arguments *arg,int output_stream_width,int offset, int result_size)
{
};

void Cshr(action_arguments *arg,int output_stream_width,int offset, int result_size)
{
};

void Cconst(cdfg_constant *c,int output_stream_width, int offset, int result_size)
{
   if (c->IsNumeric())
   {
      fprintf(error_log,"%s",int2bits(c->Number()));
   }
   else
   {
      fprintf(error_log,"%s",c->C_Number());
   };
};

void Cvar(action_variable *v,int output_stream_width, int offset, int result_size)
{

   production *prod;
   action_target *target;
   action_variable *var;
   action_item *item;
   action_line *line;
   action *act;
   action_schedule *ret;

   var=new action_variable(v->Name(),v->Number());
   Internals->AddMember(new internal("tmp",output_stream_width));
   target=new action_target("tmp");
   input_stream *tmp=new input_stream(new stream_item("tmp"));
   fprintf(error_log,"<%s>%d ",v->Name(),v->Number());
   ret=var->WordAlignAction(offset,target);
   for(int i=0;i<ret->NrOfMembers();i++)
   {
      ret->PrintAction(error_log,0,tmp,offset);
   };
};

void Composer(action_cdfg *cdfg,int output_stream_width,int offset,int result_size)
{
  if (cdfg->IsFunction())
  {
     char *function=cdfg->Function();
     if (strcmp(function,CADD)==0)
     {
        Cadd(cdfg->Arguments(),output_stream_width,offset,result_size);
     }
     else if (strcmp(function,CSUB)==0)
     {
        Csub(cdfg->Arguments(),output_stream_width,offset,result_size);
     }
     else if (strcmp(function,CMUL)==0)
     {
        Cmul(cdfg->Arguments(),output_stream_width,offset,result_size);
     }
     else if (strcmp(function,CDIV)==0)
     {
        Cdiv(cdfg->Arguments(),output_stream_width,offset,result_size);
     }
     else if (strcmp(function,CSHR)==0)
     {
        Cshr(cdfg->Arguments(),output_stream_width,offset,result_size);
     };
  }
  else if (cdfg->IsConstant())
  {
    Cconst(cdfg->Constant(),output_stream_width,offset,result_size);
  }
  else if (cdfg->IsVariable())
  {
    Cvar(cdfg->Variable(),output_stream_width,offset,result_size);
  };
};








*/
