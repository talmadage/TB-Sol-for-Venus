#include <string.h>
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>

#include "license_generator.h"
#include "lib/vhdl_packages.h"
#include "program.h"
#include "estimations.h"

FILE *vhdl_out,*script_out;
bool SIM_MODE,DEBUG_MODE,DEMO_MODE;
bool DUMP_FSM_DAG,DUMP_FSM_AS_DRIVER,DUMP_FSM_AS_VERILOG;
bool WRITE_TO_OUTPUT,WRITE_SCRIPT,DUMP_FSM_AS_XFC,DUMP_SCRIPT;
bool SPLIT_TREE,ESTIMATE_MODE,DETAILED_ESTIMATE_MODE,STATE_COUNTER_MODE;
int  SCHEDULE_HEURISTIC;

int Version = 2024;
FILE *error_log = stderr;

char *ForSyDePath;
key_struct *KEY_PROGRAM_COMPILER,*KEY_XILINX_BACKEND,*KEY_ALTERA_BACKEND;

extern char *current_file_name;

// Error log functions...
extern char log_str[1024];
extern void log(char *s);
extern void clr_logfiles(void);

char *Entity_Name;
inputs *Inputs=new inputs();
internals *Internals=new internals();
outputs *Outputs=new outputs();
aliases *Aliases=new aliases();
memories *Memories=new memories();
types *Types=new types();
fifos *Fifos=new fifos();
conversion_functions *ConversionFunctions=new conversion_functions();
starts *Starts=new starts();
constants *Constants=new constants();
layouts *Layouts=new layouts();
actions *Actions=new actions();
productions *Grammars=new productions();
elaborations *Elaborations=new elaborations();

lexem *Negate(char *r, input_stream *s,production_terminal *t,lexem *prev_lexem)
{
   int i;
   production_terminal *new_value;
   lexem *new_lexem,*exit_lexem;
   exit_lexem=new lexem();
   for(i=0;i<t->NrOfBits();i++)
   {
      int j;
      new_value=t->Copy();
      new_value->Negated(false);
      for(j=0;j<t->NrOfBits();j++)
      {
	 if (j==i)
	 {
	    new_value->FlipBit(j);
	 }
	 else if (j>i)
	 {
	    new_value->Bit(j,DONT_CARE_BIT);
	 };
      };
      new_lexem=new lexem(s,new_value);
      new_lexem->Rule(r);
      prev_lexem->AddSucc(new_lexem);
      new_lexem->AddPred(prev_lexem);
      new_lexem->AddSucc(exit_lexem);
      exit_lexem->AddPred(new_lexem);
   };
   return exit_lexem;
};

void AddInterrupts(lexem *l,lexems *i_list)
{
   int i;
   if (i_list->NrOfMembers()==0) return;
   // Interrupts should not be added to the last lexem in the hierarchy
   if (l->NrOfSuccs()==0) return;
   if ((!l->IsInterrupt()) && (!l->IsExit()))
   {
      l->AddInterrupts(i_list);
   };
   for(i=0;i<l->NrOfSuccs();i++)
   {
      // Interrupt Exceptions cannot be interrupted again
      if (!l->Succ(i)->IsInterrupt())
      {
	 AddInterrupts(l->Succ(i),i_list);
      };
   };
};

lexem *build_grammar_DAG(input_stream *stream,char *rule,lexem *prev_lexem)
{
   int i,j,nr_of_lines,nr_of_items,*sizes;
   lexem *next_lexem,*exit_lexem,*last_lexem,*cond_lexem;
   lexem **branch_lexem,**first_lexem;
   lexems *interrupt_list=new lexems();
   lexems *reset_list=new lexems();
   input_stream *current_stream;
//   char *value;
   production *prod;
   production_line *line;
   production_item *item;

   if (DEBUG_MODE)
   {
      fprintf(error_log,"%s\n",rule);
   };
   //      fprintf(error_log,"%s\n",rule);
   prod=Grammars->Member(rule);
   //   prod->Stream(stream->Copy());
   if (prod==NULL)
   {
      fprintf(error_log,"Error: Unknown production %s\n",rule);
      exit(1);
   };
   prod->Stream(stream);
   prod->IsReferenceable(true);

//   if (prod->BitPos()!=-1)
//   {
//      fprintf(error_log,"Error:Illegal recursive call to rule %s\n",rule);
//      fprintf(error_log,"      Rule %s was previously used at bit position %d\n",
//	      prod->BitPos());
//      exit(1);
//   };

   prod->BitPos(prev_lexem->BitPos()+prev_lexem->BitSize());

   nr_of_lines=prod->NrOfLines();
   // Initialize pointers
   branch_lexem=(lexem **)malloc(sizeof(lexem *)*nr_of_lines);
   first_lexem=(lexem **)malloc(sizeof(lexem *)*nr_of_lines);
   sizes=(int *)malloc(sizeof(int)*nr_of_lines);
   // Loop over the rule's branches
   for (i=0;i<nr_of_lines;i++)
   {
      next_lexem=prev_lexem;
      cond_lexem=prev_lexem;
      line=prod->Line(i);
      // Last member is the branch width
      nr_of_items=line->NrOfMembers();
      // Loop over the rule's branch's items
      current_stream=stream;
      sizes[i]=0;
      productions *this_alternative=new productions();
      lexem *void_lexem=new lexem(); // temporary lexem for storing right associative conditions
      int first_lexem_is_at=0;
      for (j=0;j<nr_of_items;j++)
      {
	 item=line->Member(j);
	 if (item->IsLexem() &&
	     (strcmp(item->Name(),rule)==0)) // recursive lexem
	 {
            if (item->Lexem()->Multiplicity()!=1)
            {
               fprintf(error_log,"Error: Lexems with Multiplicity cannot be recursive\n");
               exit(1);
            };
            next_lexem->IsLoop(true);
            first_lexem[i]->IsLoopEntry(true);
	 }
	 else if (item->IsLexem()) // lexem is hierarchical
	 {
            lexem *new_lexem;
            int k;
            for(k=0;k<item->Lexem()->Multiplicity();k++)
            {
               new_lexem=new lexem(); // temporary entry_lexem
               new_lexem->BitPos(next_lexem->BitPos()+next_lexem->BitSize());
               if (k==0)
               {
		  // Move conditions
		  void_lexem->Conds()->BitPos(this_alternative,new_lexem->BitPos()+new_lexem->BitSize());
		  void_lexem->MoveAllConds(new_lexem);
		  delete void_lexem;
		  void_lexem=new lexem();
               };
               new_lexem->AddPred(next_lexem);
               next_lexem->AddSucc(new_lexem);
	       last_lexem=build_grammar_DAG(current_stream,item->Name(),new_lexem);
	       production *this_production=new production(item->Name(),current_stream);
	       production *prod=Grammars->Member(item->Name());
	       this_production->BitPos(prod->BitPos());
	       this_production->BitSize(prod->BitSize());
	       this_alternative->AddMember(this_production);
               //last_lexem->BitPos(new_lexem->BitPos()+new_lexem->BitSize());
               sizes[i]=sizes[i]+last_lexem->BitPos()-new_lexem->BitPos();
	       //	       fprintf(error_log,"Parsed rule %s with %d bits\n",item->Name(),last_lexem->BitPos()-new_lexem->BitPos());
               if ((j==first_lexem_is_at) && (k==0))
               { 
                  first_lexem[i]=new_lexem;
               };
               next_lexem=last_lexem;
            };
	    cond_lexem=last_lexem;
         }
	 //	 else if (item->IsRedirection() &&
	 //    (strcmp(item->Redirection()->Lexem(),rule)==0)) // recursive lexem
	 //{
         //   next_lexem->IsLoop(true);
         //   first_lexem[i]->IsLoopEntry(true);
	 //}
	 else if (item->IsRedirection()) // lexem is a macro with a new stream
	 {
	    current_stream=item->Redirection()->Stream();
  //            lexem *new_lexem;
  //          new_lexem=new lexem(); // temporary entry_lexem
  //          new_lexem->BitPos(next_lexem->BitPos()+next_lexem->BitSize());
  //          new_lexem->AddPred(next_lexem);
  //          next_lexem->AddSucc(new_lexem);
  //	    last_lexem=build_grammar_DAG(item->Redirection()->Stream(),item->Redirection()->Lexem(),new_lexem);
  //         //last_lexem->BitPos(new_lexem->BitPos()+new_lexem->BitSize());
  //        cond_lexem=new_lexem;
  //        if (j==first_lexem_is_at)
  //        { 
  //           first_lexem[i]=new_lexem;
  //        };
  //        next_lexem=last_lexem;
	 }
         else if (item->IsTerminal())
	 {
            if (item->Terminal()->IsNegated())
            {
               lexem *new_lexem;
               new_lexem=new lexem(); // temporary entry_lexem
               last_lexem->BitPos(next_lexem->BitPos()+next_lexem->BitSize());
fprintf(error_log,"Warning: Feature (bug?) detected - Negated terminals (could) have miscalculated bitsize values!");
               new_lexem->AddPred(next_lexem);
               next_lexem->AddSucc(new_lexem);
	       last_lexem=Negate(rule,current_stream,item->Terminal(),new_lexem);
	       // Move conditions
	       void_lexem->Conds()->BitPos(this_alternative,new_lexem->BitPos()+new_lexem->BitSize());
	       void_lexem->MoveAllConds(new_lexem);
	       delete void_lexem;
	       void_lexem=new lexem();
               cond_lexem=last_lexem;
               if (j==first_lexem_is_at)
               { 
                  first_lexem[i]=new_lexem;
               };
               next_lexem=last_lexem;
            }
            else
            {
               last_lexem=new lexem(current_stream,item->Terminal()->Copy());
               last_lexem->BitPos(next_lexem->BitPos()+next_lexem->BitSize());
               sizes[i]=sizes[i]+last_lexem->BitSize();
               last_lexem->AddPred(next_lexem);
               next_lexem->AddSucc(last_lexem);
               last_lexem->Rule(rule);
	       // Move conditions
	       void_lexem->Conds()->BitPos(this_alternative,last_lexem->BitPos()+last_lexem->BitSize());
	       void_lexem->MoveAllConds(last_lexem);
	       delete void_lexem;
	       void_lexem=new lexem();
               cond_lexem=last_lexem;
               if (j==first_lexem_is_at)
               { 
                  first_lexem[i]=last_lexem;
               };
               next_lexem=last_lexem;
	    };
         }
	 else if (item->IsAction())
	 {
            next_lexem->AddActions(item->Actions());
            item->Actions()->BitPos(this_alternative,next_lexem->BitPos());
	 }
         else if (item->IsCond())
	 {
	    if (item->Cond()->LeftAssoc())
	    {
	       item->Cond()->BitPos(this_alternative,cond_lexem->BitPos()+cond_lexem->BitSize());
	       cond_lexem->AddCond(item->Cond());
	    }
	    else
	    {
	       void_lexem->AddCond(item->Cond());
	    };
	    if (j==first_lexem_is_at)
	    {
	       first_lexem_is_at++;
	    };
	 }
	 else if (item->IsInterrupt())
	 {
            last_lexem=new lexem(item->Interrupt());
            last_lexem->BitPos(next_lexem->BitPos()+next_lexem->BitSize());
            current_stream=item->Interrupt()->Stream();
            interrupt_list->AddMember(last_lexem);
            if (j==first_lexem_is_at)
            { 
               first_lexem[i]=last_lexem;
            };
            next_lexem=last_lexem;
	 }
	 else if (item->IsReset())
	 {
            last_lexem=new lexem(item->Reset());
            last_lexem->BitPos(next_lexem->BitPos()+next_lexem->BitSize());
            current_stream=item->Reset()->Stream();
            reset_list->AddMember(last_lexem);
            if (j==first_lexem_is_at)
            { 
               first_lexem[i]=last_lexem;
            };
            next_lexem=last_lexem;
	 }
	 else if (item->IsError())
	 {
            last_lexem=new lexem(item->Error());
            last_lexem->BitPos(next_lexem->BitPos()+next_lexem->BitSize());
            last_lexem->AddPred(next_lexem);
            next_lexem->AddSucc(last_lexem);
            if (j==first_lexem_is_at)
            { 
               first_lexem[i]=last_lexem;
            };
            next_lexem=last_lexem;
	 }
	 else
	 {
            fprintf(error_log,"Fatal Error - Unknown type\n");
            exit(1);
	 };
      };
      branch_lexem[i]=last_lexem;
      delete this_alternative;
   };
   exit_lexem=new lexem();
   for (i=0;i<nr_of_lines;i++)
   {
      if (branch_lexem[i]!=NULL)
      {
         if ((!first_lexem[i]->IsInterrupt()) && 
             (!first_lexem[i]->IsReset()) &&
             (!first_lexem[i]->IsError()))
         {
            AddInterrupts(first_lexem[i],interrupt_list);
            if (!branch_lexem[i]->IsLoop())
            {
               exit_lexem->AddPred(branch_lexem[i]);
               branch_lexem[i]->AddSucc(exit_lexem);
            }
            else
            {
               for(j=0;j<nr_of_lines;j++)
               {
                  branch_lexem[i]->AddSucc(first_lexem[j]);
                  first_lexem[j]->AddPred(branch_lexem[i]);
               };
            };
         };
      };
   };
   // I assume same bit-length in all branches (not true in all cases)
   // If it is not true, the branches must be split and the bit-positions
   // recalculated (for later implementation).
   exit_lexem->BitPos(exit_lexem->Pred(0)->BitPos()+exit_lexem->Pred(0)->BitSize());
   for(i=reset_list->NrOfMembers()-1;i>=0;i--)
   {
      prev_lexem->Succs()->AddFirst(reset_list->Member(i));
      reset_list->Member(i)->AddPred(prev_lexem);
   };
   for(i=1;i<nr_of_lines;i++)
   {
      if (sizes[i]!=sizes[i-1])
      {
         fprintf(error_log,"Warning: %s - branch %d and %d have different sizes (%d,%d)\n",rule,i,i-1,sizes[i],sizes[i-1]);
		 prod->IsReferenceable(false);
      };
   };
   prod->BitSize(sizes[0]);
   free(sizes);
   free(branch_lexem);
   free(first_lexem);
//   prod->BitPos(-1);
   return exit_lexem;
};

int initialize_fsm(char *rule,int bit_pos)
{
   int bit_size,nr_of_lines,nr_of_items;
   int i,j,value,ret,size1,size2;
//   int recursive;
   production *prod;
   production_line *line;
   production_item *item;
   prod=Grammars->Member(rule);
   if (prod==NULL)
   {
      fprintf(error_log,"\nError in PROGRAM Description\n");
      fprintf(error_log,"\n   Cannot find Grammar reference %s\n",rule);
      return -1;
   };
//   bit_size=prod->BitSize();
//   if (bit_size!=0)
//   {
//      // bit pattern has already been checked by previous PROGRAM statements
//      return bit_size;
//   };
   nr_of_lines=prod->NrOfLines();
//   recursive=0;
   for (i=0;i<nr_of_lines;i++)
   {
      line=prod->Line(i);
      nr_of_items=line->NrOfMembers();
      ret=0;
      for (j=0;j<nr_of_items;j++)
      {
	 item=line->Member(j);
	 if (item->IsLexem() &&
	     (strcmp(item->Name(),rule)==0))
	 {
	    // Recursive FSM, loops forever, skip loop
//	    recursive=1;
	    continue;
	 }
	 else if (item->IsLexem())
	 {
	    value=initialize_fsm(item->Name(),bit_pos+ret);
	    if (value==-1)
	    {
	       fprintf(error_log,"   Referenced from Grammar Rule: %s\n",rule);
	       return -1;
	    }
	    else
	    {
	       item->BitSize(value);
	       ret=ret+value;
	    };
	 }
	 else if (item->IsRedirection())
	 {
	   //	    value=initialize_fsm(item->Redirection()->Lexem(),bit_pos+ret);
	   //	    if (value==-1)
	   //{
	   //    fprintf(error_log,"   Referenced from Grammar Rule: %s\n",rule);
	   //    return -1;
	   //}
	    // Nr of bits in input stream is sum of bits in PGM_STREAM
	    bit_size=item->Redirection()->Stream()->BitSize();
	    if (bit_size==0)
	    {
	       fprintf(error_log,"\nError in PROGRAM Description\n");
	       fprintf(error_log,"   Bit_size of Redirection was zero bits\n\n");
	       fprintf(error_log,"   Referenced from Grammar Rule: %s\n",rule);
	       return -1;
	    };
	    //	    item->BitSize(value);
//	    item->CtrlSteps(value/bit_size);
	 }
	 else if (item->IsInterrupt())
	 {
	    // Nr of bits in input stream is sum of bits in PGM_STREAM
	    bit_size=item->Interrupt()->Stream()->BitSize();
	    if (bit_size==0)
	    {
	       fprintf(error_log,"\nError in PROGRAM Description\n");
	       fprintf(error_log,"   Referenced from Grammar Rule: %s\n",rule);
	       return -1;
	    };
	 }
	 else if (item->IsConstant())
	 {
	    value=item->BitSize();
	    ret=ret+value;
	 }
	 else if (item->IsOthers())
         {
	    value=item->BitSize();
	    ret=ret+value;
	 }
	 else if (item->IsBits())
         {
	    value=item->BitSize();
	    ret=ret+value;
	 };
      };
      line->BitSize(ret);
   };
   ret=prod->Line(0)->BitSize();
   for(i=1;i<nr_of_lines;i++)
   {
      size1=prod->Line(i-1)->BitSize();
      size2=prod->Line(i)->BitSize();
      if (size2>ret)
      {
	 ret=size2;
      };
      if (size1!=size2)
      {
	 if (prod->Line(i-1)->Member(0)->IsInterrupt()) continue;
	 if (prod->Line(i)->Member(0)->IsInterrupt()) continue;
	 fprintf(error_log,"Warning::Branch %d of grammar production rule %s has size %d\n",i-1,rule,size1);
	 fprintf(error_log,"         while branch %d has size %d\n",i,size2);
      };
   };
   prod->BitPos(bit_pos);
   prod->BitSize(ret);
   return ret;
};

int nr_of_memory_bits(char *name)
{
   int ret,nr_of_members,i,value;
   layout *lay;
   production_item *item;
   ret=0;
   lay=Layouts->Member(name);
   if (lay==NULL)
   {
      fprintf(error_log,"\nError in PROGRAM Description\n");
      fprintf(error_log,"\n   Cannot find Layout reference %s\n",name);
      exit(1);
   };
   nr_of_members=lay->NrOfMembers();
   for(i=0;i<nr_of_members;i++)
   {
      item=lay->Member(i);
      if (item->IsLexem())
      {
	 value=nr_of_memory_bits(item->Name());
	 if (value==-1)
	 {
	    fprintf(error_log,"   Referenced from Grammar Rule: %s\n",name);
	    return -1;
	 }
	 else
	 {
	    ret=ret+value;
	 };
      }
      else if (item->IsConstant())
      {
	 ret=ret+item->BitSize();
      }
      else if (item->IsBits())
      {
	 ret=ret+item->BitSize();
      };
   };
   return ret;
}

void write_driver(FILE *file)
{
   fprintf(file,"driver %s {\n",Entity_Name);
   fprintf(file,"   signals {\n");
   Inputs->write_driver(file);
   Internals->write_driver(file);
   Outputs->write_driver(file);
   fprintf(file,"   }\n");
   Starts->write_vhdl(file);
   fprintf(file,"}\n");
};

extern target_code *PackageCode;
extern target_code *UseClauses;
void write_user_packages(FILE *file)
{
   if (PackageCode->NrOfMembers()>0)
   {
      fprintf(file,"-- Included User packages\n");
      PackageCode->PrintTargetCode(file);
   };
   if (UseClauses->NrOfMembers()>0)
   {
      fprintf(file,"-- Included Use clauses\n");
      UseClauses->PrintTargetCode(file);
   };
};

void write_top_entity(FILE *file)
{
   write_user_packages(file);
   write_ieee_packages(file);
   fprintf(file,"ENTITY %s IS\n",Entity_Name);
   int nr_ports = Inputs->NrOfMembers() + Outputs->NrOfMembers();
   if (nr_ports > 0)
   {
	   fprintf(file, "   PORT(");
	   Inputs->write_clocks(file);
	   Inputs->write_vhdl(file, -1);
	   Outputs->write_vhdl(file, -1);
   };
   fprintf(file,"END %s;\n",Entity_Name);
};

extern target_code *SignalDeclarations;
extern target_code *ArchitectureCode;
void write_top_architecture(FILE *file)
{
   fprintf(file,"\nARCHITECTURE program OF %s IS\n\n",Entity_Name);
   fprintf(file,"\n");
   Starts->write_components(file);
   Memories->write_signals(file);
   Internals->write_signals(file);
   Outputs->write_signals(file);
   if (SignalDeclarations->NrOfMembers() > 0)
   {
	   fprintf(file, "   -- Included VHDL signals\n");
	   SignalDeclarations->PrintTargetCode(file);
   };
   fprintf(file,"BEGIN\n");
   if (ArchitectureCode->NrOfMembers()>0)
   {
      fprintf(file,"   -- Included Top Architecture Code\n");
      ArchitectureCode->PrintTargetCode(file);
   };
   Memories->write_vhdl(file);
   Starts->write_portmaps(file);
   Outputs->write_to_ports(file);
   fprintf(file,"END program;\n");
};

void write_vhdl(FILE *file)
{
    // Check all FSMs
    Starts->write_vhdl(file);
    write_top_entity(file);
    write_top_architecture(file);
};

void write_verilog(FILE *file)
{
   // Check all FSMs
   Starts->write_vhdl(file);
   //   write_top_module(file);
};

extern int program_parse(void);
extern int program_lines;
extern FILE *program_in;

void checkout_license(void)
{
	char comment[1024];
	char feature[21];
	char date[11];
	char key[2*SIZE_OF_KEY+1];

	KEY_PROGRAM_COMPILER=NULL;
    KEY_ALTERA_BACKEND=NULL;
    KEY_XILINX_BACKEND=NULL;
	ForSyDePath=getenv("FORSYDE_PATH");
	FILE *file;
	if (ForSyDePath==NULL)
	{
		fprintf(error_log,"\n");
		fprintf(error_log,"Warning: Environment variable FORSYDE_PATH is not set!\n");
		fprintf(error_log,"\n");
		//#ifdef _WIN32
		file=NULL;
		//#endif
	}
	else
	{
		char file_name[256];
		sprintf(file_name,"%s/license.dat",ForSyDePath);
		file=fopen(file_name,"r");
	};
	fprintf(stdout,"\n");
    fprintf(stdout,"The ProGram Compiler (demo-)version %d\n",Version);
	fprintf(stdout,"\n");
	//#ifdef _WIN32	
	if (file==NULL)
	{
		fprintf(stdout,"# Warning: license file not found\n");
		fprintf(stdout,"           Tool will be run in Demo Mode, restricted to max 100 lines of ProGram code\n");
		fprintf(stdout,"\n");
		//exit(1);
		DEMO_MODE=true;
	}
	else
	{
		DEMO_MODE=false;
		fgets(comment,1023,file); // Skip 1st comment line
		fgets(comment,1023,file); // Skip 2nd comment line
		bool finished=false;
	
		while(!finished)
		{
			if (fscanf(file,"%s %s %s",&feature,&date,&key)==3)
			{
				if (strcmp(feature,"noc_generator")==0)
				{
					KEY_PROGRAM_COMPILER=(key_struct *)malloc(sizeof(key_struct));
					sprintf(KEY_PROGRAM_COMPILER->key,"%s",key);
					sprintf(KEY_PROGRAM_COMPILER->date,"%s",date);
					sprintf(KEY_PROGRAM_COMPILER->feature,"%s",feature);
				}
				else if (strcmp(feature,"xilinx_backend")==0)
				{
					KEY_XILINX_BACKEND=(key_struct *)malloc(sizeof(key_struct));
					sprintf(KEY_XILINX_BACKEND->key,"%s",key);
					sprintf(KEY_XILINX_BACKEND->date,"%s",date);
					sprintf(KEY_XILINX_BACKEND->feature,"%s",feature);
				}
				else if (strcmp(feature,"altera_backend")==0)
				{
					KEY_ALTERA_BACKEND=(key_struct *)malloc(sizeof(key_struct));
					sprintf(KEY_ALTERA_BACKEND->key,"%s",key);
					sprintf(KEY_ALTERA_BACKEND->date,"%s",date);
					sprintf(KEY_ALTERA_BACKEND->feature,"%s",feature);
				}
			}
			else
			{
				finished=true;
			}
		}
		fclose(file);
	}
}

void usage(void)
{
   // Print usage message
   fprintf(error_log,"\n/********************************************************************/");
   fprintf(error_log,"\n/* The ProGram Compiler is an IP-generator. It takes a port-size    */"); 
   fprintf(error_log,"\n/* independent ProGram description, elaborates the design according */");
   fprintf(error_log,"\n/* to the port size constraints, extracts an FSM and converts it    */");
   fprintf(error_log,"\n/* into a VHDL-description suitable for logic synthesis.            */");
   fprintf(error_log,"\n/*                                                                  */");
   fprintf(error_log,"\n/* Currently, the following backend tools are supported:            */");
   fprintf(error_log,"\n/*                                                                  */");
   fprintf(error_log,"\n/*   Synopsys' Design Compiler, Mentor's Leonardo, and              */");
   fprintf(error_log,"\n/*   Altera's Quartus II program package                            */");
   fprintf(error_log,"\n/********************************************************************/");
   fprintf(error_log,"\n\nUsage: program_compiler [-opt] [-out outfile [-script scriptfile]] infile1 [-opt] [-out outfile2 [-script scriptfile2]] infile2 ...\n");
   fprintf(error_log,"\n       Options: -symbolic outputs a symbolic FSM instead of a state counter");

   /* The next five options should not be available in the Demo version */
   // fprintf(error_log,"\n                -sim outputs VHDL for simulation.");
   // fprintf(error_log,"\n                -syn outputs VHDL for synthesis. This is the default setting.");
   // fprintf(error_log,"\n                -driver outputs a Hw/Sw-driver instead of in VHDL-format.");
   // fprintf(error_log,"\n                -xfc outputs the design in XFC-format instead of in VHDL-format.");
   // fprintf(error_log,"\n                -fsm dumps the Transition Diagram of the FSM in the daVinci format.");

   fprintf(error_log,"\n");
   fprintf(error_log,"\n                -out <filename> writes the output into file <filename>.");
   fprintf(error_log,"\n                -script <filename> writes a Synopsys synthesis script into file <filename>.");
   fprintf(error_log,"\n                 This option can only be used in conjunction with the -out option.");
   fprintf(error_log,"\n");
};

char *working_directory=cpystr("");
int main(int argc,char **argv)
{
   int ret_val;
   char *tmp,*script_file,*vhdl_file,*program_file; // ,*library_name;

   ++argv,--argc; /* skip program name */
   SCHEDULE_HEURISTIC=0;
   SPLIT_TREE=false;
   SIM_MODE=false;
   DEBUG_MODE=false;
   STATE_COUNTER_MODE=true;
   DUMP_FSM_DAG=false;
   DUMP_FSM_AS_DRIVER=false;
   DUMP_FSM_AS_VERILOG=false;
   WRITE_TO_OUTPUT=false;
   WRITE_SCRIPT=false;
   DUMP_FSM_AS_XFC=false;
   DUMP_SCRIPT=false;
   ESTIMATE_MODE=false;
   DETAILED_ESTIMATE_MODE=false;

   bool GUI_LIST_PORTS=false;

   checkout_license();
   clr_logfiles();

   if (argc > 0)
   {
      while(argc>0)
      {
		 if (strcmp(argv[0],"--version")==0)
		 {
			// Query from ProGram Compiler GUI
			fprintf(error_log,"The ProGram Compiler (demo-)version 0.8\n");
			exit(1);
		 }
		 else if (strcmp(argv[0],"--list_ports")==0)
		 {
			// Query from ProGram Compiler GUI
			GUI_LIST_PORTS=true;
		 }
		 else if (strcmp(argv[0],"--dir")==0)
		 {
			// Query from ProGram Compiler GUI
			++argv; --argc;
			if (argc==0)
			{
			   exit(1);
			};
			working_directory=cpystr(argv[0]);
		 }
		 else if (strncmp(argv[0],"--error=",8) == 0)
		 {
			 //log("BAKAYARO\n");
			 char *error_file = midstr(argv[0], 8, strlen(argv[0]) - 8);
			 sprintf(log_str, "Error file is %s\n",error_file);
			 log(log_str);
			 fclose(error_log);
			 error_log = fopen(error_file, "w");
		 }
	 else if (strcmp(argv[0],"-syn")==0)
	 {
	    SIM_MODE=false;
	 }
	 else if (strcmp(argv[0],"-sim")==0)
	 {
	    SIM_MODE=true;
	 }
	 else if (strcmp(argv[0],"-debug")==0)
	 {
	    DEBUG_MODE=true;
	 }
	 else if (strcmp(argv[0],"-symbolic")==0)
	 {
	    STATE_COUNTER_MODE=false;
	 }
	 else if (strcmp(argv[0],"-crude")==0)
	 {
	    DETAILED_ESTIMATE_MODE=false;
	 }
	 else if (strcmp(argv[0],"-detailed")==0)
	 {
	    DETAILED_ESTIMATE_MODE=true;
	 }
	 else if (strcmp(argv[0],"-estimate")==0)
	 {
	    ESTIMATE_MODE=true;
	 }
	 else if (strcmp(argv[0],"-override")==0)
	 {
	    ++argv; --argc;
	    if (argc==0)
	    {
	       usage();
	       return 0;
	    }
	    char *port_name=cpystr(argv[0]);
	    ++argv; --argc;
	    if (argc==0)
	    {
	       usage();
	       return 0;
	    }
	    int port_width=atoi(argv[0]);
	    Elaborations->AddMember(new elaboration(port_name,port_width));
	    delete port_name;
	 }
//	 else if (strcmp(argv[0],"-technology")==0)
//	 {
//	    ++argv; --argc;
//	    if (argc==0)
//	    {
//	       usage();
//	       return 0;
//	    }
//	    library_name=cpystr(argv[0]);
//	 }
	 else if (strcmp(argv[0],"-fsm")==0)
	 {
	    DUMP_FSM_DAG=true;
	 }
	 else if (strcmp(argv[0],"-driver")==0)
	 {
	    DUMP_FSM_AS_DRIVER=true;
	 }
	 else if (strcmp(argv[0],"-verilog")==0)
	 {
	    DUMP_FSM_AS_VERILOG=true;
	 }
	 else if (strcmp(argv[0],"-xfc")==0)
	 {
	    DUMP_FSM_AS_XFC=true;
	 }
	 else if (strcmp(argv[0],"-tree")==0)
	 {
	    SPLIT_TREE=true;
	 }
	 else if (strcmp(argv[0],"-sched")==0)
	 {
	    ++argv; --argc;
	    if (argc==0)
	    {
	       usage();
	       return 0;
	    }
	    SCHEDULE_HEURISTIC=atoi(argv[0]);
	 }
	 else if (strcmp(argv[0],"-script")==0)
	 {
	    WRITE_SCRIPT=true;
	    ++argv; --argc;
	    if (argc==0)
	    {
	       usage();
	       return 0;
	    }
	    script_file=cpystr(argv[0]);
	    script_out=fopen( script_file, "w" );
	 }
	 else if (strcmp(argv[0],"--out")==0)
	 {
	    WRITE_TO_OUTPUT=true;
	    ++argv; --argc;
	    if (argc==0)
	    {
	       usage();
	       return 0;
	    }
	    vhdl_file=cpystr(argv[0]);
	    vhdl_out=fopen( vhdl_file, "w" );
	 }
	 else if (strncmp(argv[0],"-",1)==0)
	 {
     	fprintf(error_log, "%s is not recognized\n",argv[0]);
	    usage();
	    return 0;
	 }
	 else
	 {
	    program_file=cpystr(argv[0]);
		fprintf(stdout, "Parsing file: %s\n", program_file);
		program_in=fopen(program_file, "r" );
		if (program_in == NULL)
		{
			fprintf(stdout, "Could not open %s for reading\n", program_file);
		}
	    current_file_name=program_file;
	    if (!WRITE_TO_OUTPUT)
	    {
	       vhdl_out=stdout;
	    }
	    Entity_Name=NULL;
		//log("BAKAYARO\n");
		//fprintf(error_log, "BAKAYARO\n");
	    ret_val=program_parse();
		//log("SKEBE\n");
		//fprintf(error_log, "SKEBE %s\n",Entity_Name);
		if (Entity_Name==NULL)
	    {
	       tmp=strpbrk(argv[0],".");
	       if (tmp==NULL)
	       {
		      Entity_Name=cpystr(argv[0]);
	       }
	       else
	       {
		      Entity_Name=cpystr(strtok(argv[0],"."));
	       };
		   int place = find(Entity_Name, '\\', 0);
		   if (place<strlen(Entity_Name))
		   {
				int slash = place;
				while (place<strlen(Entity_Name))
				{
					slash = place;
					place = find(Entity_Name, '\\', place + 1);
				};
				Entity_Name = midstr(Entity_Name, slash+1, strlen(Entity_Name)-1);
		    }
		}; 
		sprintf(log_str, "Entity_name %s\n", Entity_Name);
		log(log_str);
		if (ret_val!=0) return ret_val;
	    fclose(program_in);
	    if (GUI_LIST_PORTS)
	    {
	       Inputs->GUI_ListPorts(error_log);
	       Internals->GUI_ListPorts(error_log);
	       Outputs->GUI_ListPorts(error_log);
	       exit(1);
	    };
	    Elaborations->Elaborate();
	    //      if (Actions!=NULL) Actions->ExpandActionMacros();
	    if (DUMP_FSM_AS_DRIVER)
	    {
	       fprintf(vhdl_out,"-- Driver extracted from PROGRAM file %s\n", argv[0]);
	    }
	    else
	    {
	       if (DUMP_FSM_AS_VERILOG)
	       {
		  fprintf(vhdl_out,"// Verilog extracted from PROGRAM file %s\n", argv[0]);
	       }
	       else
	       {
		  fprintf(vhdl_out,"-- VHDL extracted from PROGRAM file %s\n", argv[0]);
	       };
	    };
	    if (DUMP_FSM_AS_DRIVER)
	    {
	       write_driver(vhdl_out);
	    }
	    else
	    {
	       if (DUMP_FSM_AS_VERILOG)
	       {
		  write_verilog(vhdl_out);
	       }
	       else
	       {
		  write_vhdl(vhdl_out);
	       };
	    };
	    if (WRITE_SCRIPT)
	    {
	       if (!WRITE_TO_OUTPUT)
	       {
		  fprintf(error_log,"ERROR: Script options must be used in conjunction with the output file option\n");
		  usage();
		  return 0;
	       };
	       Starts->write_script(script_out,vhdl_file);
	       fclose(script_out);
	    };
	    if (WRITE_TO_OUTPUT)
	    {
	       fclose(vhdl_out);
	    };
	    // Estimate mode should not be included in the demo-version...
	    //if (ESTIMATE_MODE)
	    //{
	    //   FILE *library_file;
	    //   technology *lsi_10k=new technology("lsi_10k");
	    //   lsi_10k->Nand(1);
	    //   lsi_10k->And(2);
	    //   lsi_10k->Nor(1);
	    //   lsi_10k->Or(2);
	    //   lsi_10k->Inv(1);
	    //   lsi_10k->Xor(4);
	    //   lsi_10k->Fa(10);
	    //   lsi_10k->Ha(5);
	    //   lsi_10k->Mux(4);
	    //   lsi_10k->Fd(7);
	    //   lsi_10k->Ld(5);
	    //   lsi_10k->Pad(112);
	       // library_file=fopen(library_name,"r");
	       // technology_parse(library_file)
	       // fclose(library_file);
	    //   Starts->Estimate(error_log,lsi_10k);
	    //};
	    SPLIT_TREE=false;
	    SCHEDULE_HEURISTIC=0;
	    WRITE_TO_OUTPUT=false;
	    WRITE_SCRIPT=false;
	    SIM_MODE=false;
	    DEBUG_MODE=false;
	    DUMP_FSM_DAG=false;
	    DUMP_FSM_AS_DRIVER=false;
	    DUMP_FSM_AS_XFC=false;
	    DUMP_SCRIPT=false;
	    ESTIMATE_MODE=false;
	    DETAILED_ESTIMATE_MODE=false;
	    STATE_COUNTER_MODE=true;
	    delete Elaborations;
	    Elaborations=new elaborations();
	 };
	 ++argv; --argc;
      };
   }
   else
   {
      usage();
   };
   return 0;
};



