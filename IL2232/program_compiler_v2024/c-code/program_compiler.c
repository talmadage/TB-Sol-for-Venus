#include <string.h>
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>

#include "lib/vhdl_packages.h"
#include "program.h"
#include "estimations.h"

FILE *vhdl_out,*script_out;
bool SIM_MODE,DEBUG_MODE,DUMP_FSM_DAG,DUMP_FSM_AS_DRIVER,DUMP_FSM_AS_VERILOG;
bool WRITE_TO_OUTPUT,WRITE_SCRIPT,DUMP_FSM_AS_XFC,DUMP_SCRIPT;
bool SPLIT_TREE,ESTIMATE_MODE,DETAILED_ESTIMATE_MODE,STATE_COUNTER_MODE;
int  SCHEDULE_HEURISTIC;

extern char *current_file_name;

char *Name;
inputs *Inputs=new inputs();
internals *Internals=new internals();
outputs *Outputs=new outputs();
aliases *Aliases=new aliases();
memories *Memories=new memories();
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
   int i,j;
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
   char *value;
   production *prod;
   production_line *line;
   production_item *item;

   if (DEBUG_MODE)
   {
      fprintf(stderr,"%s\n",rule);
   };
   prod=Grammars->Member(rule);
   //   prod->Stream(stream->Copy());
   if (prod==NULL)
   {
      fprintf(stderr,"Error: Unknown production %s\n",rule);
      exit(1);
   };
   prod->Stream(stream);
   prod->IsReferenceable(true);

//   if (prod->BitPos()!=-1)
//   {
//      fprintf(stderr,"Error:Illegal recursive call to rule %s\n",rule);
//      fprintf(stderr,"      Rule %s was previously used at bit position %d\n",
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
      for (j=0;j<nr_of_items;j++)
      {
	 item=line->Member(j);
	 if (item->IsLexem() &&
	     (strcmp(item->Name(),rule)==0)) // recursive lexem
	 {
            if (item->Lexem()->Multiplicity()!=1)
            {
               fprintf(stderr,"Error: Lexems with Multiplicity cannot be recursive\n");
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
                  cond_lexem=new_lexem;
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
               if ((j==0) && (k==0))
               { 
                  first_lexem[i]=new_lexem;
               };
               next_lexem=last_lexem;
            };
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
  //        if (j==0)
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
fprintf(stderr,"Warning: Feature detected - Negated terminals (could) have miscalculated bitsize values!");
               new_lexem->AddPred(next_lexem);
               next_lexem->AddSucc(new_lexem);
	       last_lexem=Negate(rule,current_stream,item->Terminal(),new_lexem);
               cond_lexem=new_lexem;
               if (j==0)
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
               cond_lexem=last_lexem;
               if (j==0)
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
            cond_lexem->AddCond(item->Cond());
	 }
	 else if (item->IsInterrupt())
	 {
            last_lexem=new lexem(item->Interrupt());
            last_lexem->BitPos(next_lexem->BitPos()+next_lexem->BitSize());
            current_stream=item->Interrupt()->Stream();
            interrupt_list->AddMember(last_lexem);
            if (j==0)
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
            if (j==0)
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
            if (j==0)
            { 
               first_lexem[i]=last_lexem;
            };
            next_lexem=last_lexem;
	 }
	 else
	 {
            fprintf(stderr,"Fatal Error - Unknown type\n");
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
         fprintf(stderr,"Warning: %s - branch %d and %d have different sizes\n",rule,i,i-1);
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
   int i,j,k,recursive,value,ret,size1,size2;
   production *prod;
   production_line *line;
   production_item *item;
   prod=Grammars->Member(rule);
   if (prod==NULL)
   {
      fprintf(stderr,"\nError in PROGRAM Description\n");
      fprintf(stderr,"\n   Cannot find Grammar reference %s\n",rule);
      return -1;
   };
   bit_size=prod->BitSize();
//   if (bit_size!=0)
//   {
//      // bit pattern has already been checked by previous PROGRAM statements
//      return bit_size;
//   };
   nr_of_lines=prod->NrOfLines();
   recursive=0;
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
	    recursive=1;
	    continue;
	 }
	 else if (item->IsLexem())
	 {
	    value=initialize_fsm(item->Name(),bit_pos+ret);
	    if (value==-1)
	    {
	       fprintf(stderr,"   Referenced from Grammar Rule: %s\n",rule);
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
	   //    fprintf(stderr,"   Referenced from Grammar Rule: %s\n",rule);
	   //    return -1;
	   //}
	    // Nr of bits in input stream is sum of bits in PGM_STREAM
	    bit_size=item->Redirection()->Stream()->BitSize();
	    if (bit_size==0)
	    {
	       fprintf(stderr,"\nError in PROGRAM Description\n");
	       fprintf(stderr,"   Bit_size of Redirection was zero bits\n\n");
	       fprintf(stderr,"   Referenced from Grammar Rule: %s\n",rule);
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
	       fprintf(stderr,"\nError in PROGRAM Description\n");
	       fprintf(stderr,"   Referenced from Grammar Rule: %s\n",rule);
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
	 fprintf(stderr,"Warning::Branch %d of grammar production rule %s has size %d\n",i-1,rule,size1);
	 fprintf(stderr,"         while branch %d has size %d\n",i,size2);
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
      fprintf(stderr,"\nError in PROGRAM Description\n");
      fprintf(stderr,"\n   Cannot find Layout reference %s\n",name);
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
	    fprintf(stderr,"   Referenced from Grammar Rule: %s\n",name);
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
   fprintf(file,"driver %s {\n",Name);
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
   int i;

   write_user_packages(file);
   write_ieee_packages(file);
   fprintf(file,"ENTITY %s IS\n",Name);
   fprintf(file,"   PORT(");
   Inputs->write_clocks(file);
   Inputs->write_vhdl(file,-1);
   Outputs->write_vhdl(file,-1);
   fprintf(file,"END %s;\n",Name);
};

extern target_code *ArchitectureCode;
void write_top_architecture(FILE *file)
{
   fprintf(file,"\nARCHITECTURE program OF %s IS\n\n",Name);
   fprintf(file,"\n");
   Starts->write_components(file);
   Memories->write_signals(file);
   Internals->write_signals(file);
   fprintf(file,"BEGIN\n");
   if (ArchitectureCode->NrOfMembers()>0)
   {
      fprintf(file,"   -- Included Top Architecture Code\n");
      ArchitectureCode->PrintTargetCode(file);
   };
   Memories->write_vhdl(file);
   Starts->write_portmaps(file);
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

void usage(void)
{
   // Print usage message
   fprintf(stderr,"\nprogram2vhdl takes a ProGram description, extracts an FSM");
   fprintf(stderr,"\nand converts it into a VHDL-description suitable for");
   fprintf(stderr,"\nsynthesis in Synopsys.");
   fprintf(stderr,"\n\nUsage: program2vhdl [-opt] [-out outfile [-script scriptfile]] infile1 [-opt] [-out outfile2 [-script scriptfile2]] infile2 ...\n");
   fprintf(stderr,"\n       Options: -sim outputs VHDL for simulation");
   fprintf(stderr,"\n                -syn outputs VHDL for synthesis. This is the default setting.");
   fprintf(stderr,"\n                -driver outputs a Hw/Sw-driver instead of in VHDL-format.");
   fprintf(stderr,"\n                -xfc outputs the design in XFC-format instead of in VHDL-format.");
   fprintf(stderr,"\n                -fsm dumps the Transition Diagram of the FSM in the daVinci format.");
   fprintf(stderr,"\n");
   fprintf(stderr,"\n                -out <filename> writes the output into file <filename>.");
   fprintf(stderr,"\n                -script <filename> writes a Synopsys synthesis script into file <filename>.");
   fprintf(stderr,"\n                 This option can only be used in conjunction with the -out option.");
   fprintf(stderr,"\n");
};

int main(int argc,char **argv)
{
   int ret_val;
   char *tmp,*script_file,*vhdl_file,*program_file,*library_name;

   ++argv,--argc; /* skip program name */
   SCHEDULE_HEURISTIC=0;
   SPLIT_TREE=false;
   SIM_MODE=false;
   DEBUG_MODE=false;
   DUMP_FSM_DAG=false;
   DUMP_FSM_AS_DRIVER=false;
   DUMP_FSM_AS_VERILOG=false;
   WRITE_TO_OUTPUT=false;
   WRITE_SCRIPT=false;
   DUMP_FSM_AS_XFC=false;
   DUMP_SCRIPT=false;
   ESTIMATE_MODE=false;
   DETAILED_ESTIMATE_MODE=false;
   STATE_COUNTER_MODE=false;

   if (argc > 0)
   {
      while(argc>0)
      {
	 if (strcmp(argv[0],"-syn")==0)
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
	 else if (strcmp(argv[0],"-counter")==0)
	 {
	    STATE_COUNTER_MODE=true;
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
	 else if (strcmp(argv[0],"-technology")==0)
	 {
	    ++argv; --argc;
	    if (argc==0)
	    {
	       usage();
	       return 0;
	    }
	    library_name=cpystr(argv[0]);
	 }
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
	 else if (strcmp(argv[0],"-out")==0)
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
	    usage();
	    return 0;
	 }
	 else
	 {
	    program_file=cpystr(argv[0]);
	    program_in=fopen(program_file, "r" );
	    current_file_name=program_file;
	    if (!WRITE_TO_OUTPUT)
	    {
	       vhdl_out=stdout;
	    }
	    Name=NULL;
	    ret_val=program_parse();
	    if (Name==NULL)
	    {
	       tmp=strpbrk(argv[0],".");
	       if (tmp==NULL)
	       {
		  Name=cpystr(argv[0]);
	       }
	       else
	       {
		  Name=cpystr(strtok(argv[0],"."));
	       };
	    };
	    if (ret_val!=0) return ret_val;
	    fclose(program_in);
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
		  fprintf(stderr,"ERROR: Script options must be used in conjunction with the output file option\n");
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
	    if (ESTIMATE_MODE)
	    {
	       FILE *library_file;
	       technology *lsi_10k=new technology("lsi_10k");
	       lsi_10k->Nand(1);
	       lsi_10k->And(2);
	       lsi_10k->Nor(1);
	       lsi_10k->Or(2);
	       lsi_10k->Inv(1);
	       lsi_10k->Xor(4);
	       lsi_10k->Fa(10);
	       lsi_10k->Ha(5);
	       lsi_10k->Mux(4);
	       lsi_10k->Fd(7);
	       lsi_10k->Ld(5);
	       lsi_10k->Pad(112);
	       // library_file=fopen(library_name,"r");
	       // technology_parse(library_file)
	       // fclose(library_file);
	       Starts->Estimate(stderr,lsi_10k);
	    };
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
	    STATE_COUNTER_MODE=false;
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



