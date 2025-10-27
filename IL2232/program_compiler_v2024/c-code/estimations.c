#include <string.h>
#include <math.h>
#include "program.h"
#include "lib/rli_string.h"
#include "espresso_format.h"

extern productions *Grammars;
extern internals *Internals;
extern inputs *Inputs;
extern outputs *Outputs;
extern aliases *Aliases;
extern starts *Starts;
extern fifos *Fifos;
extern lexems *AllLexems;

extern int espresso_parse(void);
extern FILE *espresso_in;
extern bool DETAILED_ESTIMATE_MODE,STATE_COUNTER_MODE;

char *int2bits(int number,int size)
{
   int i,ret_number;
   char *ret;
   ret=new char[size+1];
   for(i=0;i<=size;i++) ret[i]='\0';
   if (number<0)
   {
      // two's complement
      ret_number=((int)pow(2.0,size+1))+number;
   }
   else
   {
      ret_number=number;
   };
   for(i=0;i<size;i++)
   {
      if ((ret_number % 2)==0)
      {
	 ret[size-i-1]='0';
      }
      else
      {
	 ret[size-i-1]='1';
      };
      ret_number=ret_number >> 1;
   };
   return ret;
};

int ilog2(int i)
{
   return (int)ceil(log((double)i)/log(2.0));
};

int technology::FSMCore(int nr_of_bits)
{
   int reset_area,incr_area,mux_area;
   incr_area=(And()+Xor())*(nr_of_bits-1)+Inv();
   mux_area=Mux(2,nr_of_bits);
   reset_area=And()*nr_of_bits;
   return incr_area+mux_area+reset_area;
};

int technology::PLA(int nr_of_inputs,int nr_of_outputs,int nr_of_products)
{
   int and_plane,or_plane;
   and_plane=Nor()*nr_of_inputs*nr_of_products;
   or_plane=Nand()*(nr_of_products-1);
   return (and_plane+or_plane)*nr_of_outputs;
};

int CountZerosAndOnes(char *s)
{
   int count=0;
   for(int i=0;i<strlen(s);i++)
   {
      if (s[i]=='0')
      {
	 count++;
      }
      else if (s[i]=='1')
      {
	 count++;
      };
   };
   return count;
};

int technology::PLA(char **pla_inputs,char **pla_outputs,int nr_of_products)
{
   int and_area=0;
   for(int i=0;i<nr_of_products;i++)
   {
      and_area+=CountZerosAndOnes(pla_inputs[i])*Nor();
   };
   int or_area=0;
   for(int j=0;j<strlen(pla_outputs[0]);j++)
   {
      char *s=new char[nr_of_products+1];
      for(int i=0;i<nr_of_products;i++)
      {
	 s[i]=pla_outputs[i][j];
      };
      s[nr_of_products]=0;
      or_area+=CountZerosAndOnes(s)*Nand();
      delete s;
   };
   return and_area+or_area;
};

int technology::EQU(char *s)
{
   int nr_of_invs=0;
   for(int i=0;i<strlen(s);i++)
   {
      if (s[i]='0') nr_of_invs++;
   };
   int and_plane=strlen(s)*Nor();
   return nr_of_invs*Inv()+and_plane;
};

int start::Estimate(FILE *file,technology *tech,int fsm)
{
   int state_vector_size,total_area,output_decode_area,state_area;
   int register_area;
   fsm_estimates *state_estimate;
   output_estimates *output_assignments;

   fprintf(file,"\n");
   fprintf(file,"Estimated State Machine for %s_%d\n",Name(),fsm);
   fprintf(file,"------------------------------------------------------------\n");
   state_vector_size=ilog2(end_state);
   fprintf(file,"   %d States => %d bits\n",end_state,state_vector_size);
   AllLexems->SetAllVisited(false);
   state_estimate=new fsm_estimates();
   output_assignments=new output_estimates();
   entry_lexem->BuildEstimate(state_estimate,output_assignments);
   fprintf(file,"   %d transitions\n",state_estimate->NrOfMembers());
   fprintf(file,"   %d output assignments\n",output_assignments->NrOfMembers());
   fprintf(file,"------------------------------------------------------------\n");
   // Inputs are currently not estimated since they are not latched
   // Inputs->Estimate(file,fsm);
   register_area=Outputs->Estimate(file,tech,fsm);
   register_area+=Internals->Estimate(file,tech,fsm);
   int state_register_area=state_vector_size*tech->Fd();
   fprintf(file,"   %d State Register D-flipflops\n",state_vector_size);
   register_area+=state_register_area;
   fprintf(file,"\n");
   fprintf(file,"Total Register Area %d\n",register_area);
   fprintf(file,"------------------------------------------------------------\n");
   int pad_area=Inputs->EstimatePadArea(file,tech);
   pad_area+=Outputs->EstimatePadArea(file,tech);
   fprintf(file,"\n");
   fprintf(file,"Total Pad Area %d\n",pad_area);
   fprintf(file,"------------------------------------------------------------\n");
   int fifo_area=Fifos->Estimate(tech,fsm);
   fprintf(file,"   Fifo Area is %d\n",fifo_area);
   fprintf(file,"------------------------------------------------------------\n");
   state_estimate->Initiate(state_vector_size);
   output_assignments->Initiate(state_vector_size);
   if (state_vector_size>1)
   {
      state_area=state_estimate->Estimate(file,tech);
   }
   else
   {
      state_area=0;
   }
   fprintf(file,"Total State Table Area %d\n",state_area);
   output_partitions *op=output_assignments->Partition();
   output_decode_area=op->Estimate(file,tech);
   total_area=state_area+output_decode_area+fifo_area+register_area;
   fprintf(file,"------------------------------------------------------------\n");
   fprintf(file,"   Total Core Area is %d\n",total_area);
   fprintf(file,"   Total Chip Area is %d\n",total_area+pad_area);
};

int starts::Estimate(FILE *file,technology *tech)
{
   int i,total_area;
   total_area=0;
   for(i=0;i<NrOfMembers();i++)
   {
      total_area+=Member(i)->Estimate(file,tech,i);
   };
   return total_area;
};

int inputs::EstimatePadArea(FILE *file,technology *tech)
{
   int i,count;
   count=0;
   for(i=0;i<NrOfMembers();i++)
   {
      count+=Member(i)->BitSize();
   };
   fprintf(file,"   %d Input Pads\n",count);
   return tech->Pad()*count;
};
int outputs::EstimatePadArea(FILE *file,technology *tech)
{
   int i,count;
   count=0;
   for(i=0;i<NrOfMembers();i++)
   {
      count+=Member(i)->BitSize();
   };
   fprintf(file,"   %d Output Pads\n",count);
   return tech->Pad()*count;
};

int outputs::Estimate(FILE *file,technology *tech,int fsm)
{
   int i,count;
   count=0;
   for(i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->IsWrittenBy(fsm))
      {
	 count+=Member(i)->BitSize();
      };
   };
   fprintf(file,"   %d Output D-flipflops\n",count);
   return tech->Fd()*count;
};

int internals::Estimate(FILE *file,technology *tech,int fsm)
{
   int i,count;
   count=0;
   for(i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->IsWrittenBy(fsm))
      {
	 count+=Member(i)->BitSize();
      };
   };
   fprintf(file,"   %d Internal D-flipflops\n",count);
   return tech->Fd()*count;
};

int fifo::Estimate(technology *tech, int fsm)
{
   if (IsReadBy(fsm))
   {
      return Stream()->BitSize()*Depth()*tech->Fd();
   }
   return 0;
}

int fifos::Estimate(technology *tech, int fsm)
{
   int fifo_area=0;
   for(int i=0;i<NrOfMembers();i++)
   {
      fifo_area+=Member(i)->Estimate(tech,fsm);
   };
   return fifo_area;
};

void lexem::BuildEstimate(fsm_estimates *fes,output_estimates *oes)
{
   int i;
   if (Visited()) return;
   Visited(true);
   for(i=0;i<NrOfSuccs();i++)
   {
      if (!Succ(i)->IsExit())
      {
	 if (Succ(i)->State()!=0)
	 {
	    fsm_estimate *new_fsm_estimate;
	    new_fsm_estimate=new fsm_estimate(State(),Succ(i));
	    fes->AddMember(new_fsm_estimate);
	 };
	 // Check Successor
	 Succ(i)->BuildEstimate(fes,oes);
      };
      // output_estimate
      for(int j=0;j<Succ(i)->NrOfActScheds();j++)
      {
	 output_estimate *new_output_estimate;
	 new_output_estimate=new output_estimate(State(),Succ(i),Succ(i)->ActSched(j));
	 oes->AddMember(new_output_estimate);
      };
   };
};

fsm_estimate::fsm_estimate(int s,lexem *t)
{
   state=s;
   transition=t;
};

void fsm_estimate::Initiate(int state_vector_size)
{ 
   from_state=int2bits(State(),state_vector_size);
//   if (State()==-1)
//   {
//      to_state=cpystr("+1");
//   }
//   else
//   {
   to_state=int2bits(Transition()->State(),state_vector_size);
//   };
}

void fsm_estimates::Initiate(int state_vector_size)
{ 
   int i;
   StateVectorSize(state_vector_size);
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->Initiate(state_vector_size);
   };
};

void fsm_estimate::DumpKISS(FILE *file)
{
   int i;
   if (State()==-1)
   {
      for(i=0;i<strlen(FromState());i++)
      {
	 fprintf(file,"*");
      }
      fprintf(file,"\t *** \t  1\t  1\t");
      for(i=0;i<strlen(FromState());i++)
      {
	 fprintf(file,"-");
      }
      fprintf(file," // incr 1\n");
   }
   else
   {
      if (Transition()->State()==0)
      {
	 fprintf(file,"%s\t %s\t  -\t  0\t",
		 FromState(),
		 Transition()->Value());
	 for(i=0;i<strlen(FromState());i++)
	 {
	    fprintf(file,"-");
	 }
	 fprintf(file," // reset to 0\n");
      }
      else
      {
	 fprintf(file,"%s\t %s\t  0\t  1\t%s",
		 FromState(),
		 Transition()->Value(),
		 ToState());
	 fprintf(file," // jump to %d\n",Transition()->State());
      }
   }
}

void fsm_estimate::Estimate(FILE *file,technology *tech)
{
   if (State()==-1)
   {
      fprintf(file,"State \t DEF. \tincr \t 1\n");
   }
   else
   {
      if (Transition()->State()==0)
      {
	 fprintf(file,"State \t %d \tRESET to 0\n",State());
      }
      else
      {
	 fprintf(file,"State \t %d \tNextState \t %d \t%s\n",
		 State(),
		 Transition()->State(),
		 ToState());
      };
   };
};

int HammingDistance(char *a,char *b)
{
   int i,count;
   count=0;
   for(i=0;i<strlen(a);i++)
   { 
      if (strncmp(a+i,b+i,1)!=0)
      {
	 count++;
      };
   };
   return count;
};

void fsm_estimates::Sort(void)
{
   int i,j,nr;
   nr=NrOfMembers();
   for(i=0;i<nr;i++)
   {
      // Skip the default state
      if (Member(i)->State()!=-1)
      {
	 // Move RESET to 0 last in the set
	 while (Member(i)->Transition()->State()==0)
	 {
	    AddMember(Member(i));
	    Replace(i,NULL);
	    DelMember(i);
	    nr--;
	 };
      };
   };
   // Sort the rest
   for(i=0;i<nr;i++)
   {
      for(j=i+2;j<nr;j++)
      {
	 if (HammingDistance(Member(i)->FromState(),Member(i+1)->FromState())>
	     HammingDistance(Member(i)->FromState(),Member(j)->FromState()))
	 {
	    fsm_estimate *tmp;
	    tmp=Member(i+1);
	    Replace(i+1,Member(j));
	    Replace(j,tmp);
	 };
      };
   };
};

fsm_estimates *fsm_estimates::Partition(bool incr)
{
   int i;
   fsm_estimates *ret;
   ret=new fsm_estimates();
   for(i=0;i<NrOfMembers();i++)
   {
      if ((incr) && (Member(i)->Transition()->State()-Member(i)->State()==1))
      {
	 ret->AddMember(Member(i));
      }
      else if ((!incr) && 
	       (Member(i)->Transition()->State()!=0) &&
	       (Member(i)->Transition()->State()-Member(i)->State()!=1))
      {
	 ret->AddMember(Member(i));
      };
   };
   ret->StateVectorSize(StateVectorSize());
   return ret;
 };

void fsm_estimates::DumpKISS(FILE *file)
{
   int i;
   fprintf(file,"------------------------------------------------------------\n");
   fprintf(file,"State \t\tInput \tIncr \tZero \t NextState\n");
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->DumpKISS(file);
   };
};

int fsm_estimates::Estimate(FILE *file, technology *tech)
{
   int total_area;
   if (STATE_COUNTER_MODE) 
   {
      fsm_estimates *Increments,*Jumps;
      //   Sort();
      Increments=Partition(true);
      Jumps=Partition(false);
      // I have not yet taken decode area into account
      int inv_decode_area=tech->Inv()*StateVectorSize();
      int fsm_core_area=tech->FSMCore(StateVectorSize())+inv_decode_area;
      int jump_table_area=Jumps->EstimateJumpArea(tech);
      int incr_decode_area=Increments->EstimateIncrArea(tech);
      total_area=jump_table_area+fsm_core_area+incr_decode_area;

      fprintf(stderr," nextstate, %d increments %d \n",Increments->NrOfMembers(),incr_decode_area);
      fprintf(stderr," nextstate, %d jumps %d\n",Jumps->NrOfMembers(),jump_table_area);
      fprintf(stderr," fsm core area %d\n",fsm_core_area);
   }
   else
   {
      if (DETAILED_ESTIMATE_MODE)
      {
	 FILE *file=fopen("program_fsm_estimate.pla","w");
	 fprintf(file,".i %d\n",Member(0)->Transition()->BitSize()+StateVectorSize());
	 fprintf(file,".o %d\n",StateVectorSize());
	 fprintf(file,".p %d\n",NrOfMembers());
	 for(int i=0;i<NrOfMembers();i++)
	 {
	    fprintf(file,"%s%s %s\n",
		    Member(i)->Transition()->Value(),
		    Member(i)->FromState(),
		    Member(i)->ToState());
	 };
	 fprintf(file,".e\n");
	 fclose(file);
	 system("espresso program_fsm_estimate.pla > program_fsm_estimate_minimized.pla");
	 espresso_in=fopen("program_fsm_estimate_minimized.pla","r");
	 espresso_parse();
	 fclose(espresso_in);
	 total_area=Function->Estimate(tech);
	 Function->DelAllMembers();
      }
      else
      {
	 int inv_area=StateVectorSize()*tech->Inv();
	 total_area=inv_area+tech->PLA(StateVectorSize(),1,NrOfMembers());
      };
   };
   return total_area;
};

int fsm_estimates::EstimateIncrArea(technology *tech)
{
   int decode_area;
   if (DETAILED_ESTIMATE_MODE)
   {
      FILE *file=fopen("program_fsm_estimate.pla","w");
      fprintf(file,".i %d\n",Member(0)->Transition()->BitSize()+StateVectorSize());
      fprintf(file,".o 1\n");
      fprintf(file,".p %d\n",NrOfMembers());
      for(int i=0;i<NrOfMembers();i++)
      {
	 fprintf(file,"%s%s 1\n",Member(i)->Transition()->Value(),Member(i)->FromState());
      };
      fprintf(file,".e\n");
      fclose(file);
      system("espresso program_fsm_estimate.pla > program_fsm_estimate_minimized.pla");
      espresso_in=fopen("program_fsm_estimate_minimized.pla","r");
      espresso_parse();
      fclose(espresso_in);
      decode_area=Function->Estimate(tech);
      Function->DelAllMembers();
   }
   else
   {
      decode_area=tech->PLA(StateVectorSize(),1,NrOfMembers());
   };
   return decode_area;
};

int fsm_estimates::EstimateJumpArea(technology *tech)
{
   int mux_area,decode_area;
   mux_area=tech->Mux(NrOfMembers(),StateVectorSize());
   if (DETAILED_ESTIMATE_MODE)
   {
      int nr_of_bits=ilog2(NrOfMembers());
      FILE *file=fopen("program_jumps_estimate.pla","w");
      fprintf(file,".i %d\n",Member(0)->Transition()->BitSize()+StateVectorSize());
      fprintf(file,".o %d\n",1+nr_of_bits);
      fprintf(file,".p %d\n",NrOfMembers());
      for(int i=0;i<NrOfMembers();i++)
      {
	 fprintf(file,"%s%s 1%s\n",Member(i)->Transition()->Value(),Member(i)->FromState(),int2bits(i,nr_of_bits));
      };
      fprintf(file,".e\n");
      fclose(file);
      system("espresso program_jumps_estimate.pla > program_jumps_estimate_minimized.pla");
      espresso_in=fopen("program_jumps_estimate_minimized.pla","r");
      espresso_parse();
      fclose(espresso_in);
      decode_area=Function->Estimate(tech);
      Function->DelAllMembers();
   }
   else
   {
      decode_area=tech->PLA(StateVectorSize(),1+ilog2(NrOfMembers()),NrOfMembers());
   };
   return mux_area+decode_area;
};

output_estimate::output_estimate(int s, lexem *t, actions *a)
{
   state=s;
   transition=t;
   assignment=a;
   name=NULL;
};

void output_estimate::Initiate(int state_vector_size)
{
   state_bits=int2bits(State(),state_vector_size);
};

void output_estimate::DumpKISS(FILE *file,int fsm,int state_vector_size)
{
   fprintf(file,"%s \t%s\t",
	   StateBits(),
	   Transition()->Value());
   Transition()->ActScheds()->PrintAction(file,fsm,Transition()->Stream(),Transition()->BitPos());
};

void output_estimates::Initiate(int state_vector_size)
{ 
   int i;
   StateVectorSize(state_vector_size);
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->Initiate(state_vector_size);
   };
};

void output_estimates::DumpKISS(FILE *file,int fsm,int state_vector_size)
{
   int i;
   fprintf(file,"------------------------------------------------------------\n");
   fprintf(file,"State \t\tInput \tValue\n");
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->DumpKISS(file,fsm,state_vector_size);
   };
};

output_estimates *output_estimates::Partition(internal *intp)
{
   output_estimates *ret;
   int i;
   ret=new output_estimates;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(Member(i)->Actions()->Member(0)->Target()->Dest(),intp->Name())==0)
      {
	 Member(i)->Name(intp->Name());
	 Member(i)->Width(intp->BitSize());
	 ret->AddMember(Member(i));
      };
   };
   ret->StateVectorSize(StateVectorSize());
   return ret;
};

void output_bits::AddMember(action_item *ai)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->Compare(ai))
      {
	 return;
      };
   };
   List<action_item>::AddMember(ai);
};

int output_bits::Find(action_item *ai)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->Compare(ai))
      {
	 return i;
      };
   };
   fprintf(stderr,"BUG! Could not find member %08x\n",ai);
   exit(1);
};

int output_estimates::Estimate(technology *tech)
{
   int pla_area=0;
   int mux_area=0;
   if (DETAILED_ESTIMATE_MODE)
   {
      int pla_output_width=0;
      char **pla_outputs;
      pla_outputs=(char **)malloc(sizeof(char *)*NrOfMembers());
      for(int i=0;i<NrOfMembers();i++)
      {
	 pla_outputs[i]="";
      };
      for(int j=0;j<Member(0)->Width();j++)
      {
	 output_bits *bits=new output_bits();
	 // Add the Memory value. Should always be first. It corresponds to
	 // no output at all
	 bits->AddMember(new action_item(new action_constant("M")));
	 for(int i=0;i<NrOfMembers();i++)
	 {
	    bits->AddMember(Member(i)->Split()->Member(0)->Member(j)->Line()->Member(0));
	 };
	 if(NrOfMembers()>2)
	 {
	    for(int i=0;i<NrOfMembers();i++)
	    {
	       int where=bits->Find(Member(i)->Split()->Member(0)->Member(j)->Line()->Member(0));
	       pla_outputs[i]=catstr(pla_outputs[i],int2bits(where,ilog2(bits->NrOfMembers())));
	    };
	    pla_output_width+=ilog2(bits->NrOfMembers());
	    mux_area+=tech->Mux(bits->NrOfMembers(),1);
	 }
	 else
	 {
	    // Assuming always constant output is not exactly correct.
	    // In case of FIFO input, a Mux is actually needed.
	    for(int i=0;i<NrOfMembers();i++)
	    {
	       pla_outputs[i]=catstr(pla_outputs[i],"1");
	    };
	    pla_output_width++;
	 };
	 delete bits;
      };
      FILE *file=fopen("program_output_estimate.pla","w");
      fprintf(file,".i %d\n",Member(0)->Transition()->BitSize()+StateVectorSize());
      fprintf(file,".o %d\n",pla_output_width);
      fprintf(file,".p %d\n",NrOfMembers());
      for(int i=0;i<NrOfMembers();i++)
      {
//fprintf(stderr,"%s-%s-%s\n",Member(i)->Transition()->Value(),Member(i)->StateBits(),pla_outputs[i]);
	 fprintf(file,"%s%s %s\n",
		 Member(i)->Transition()->Value(),Member(i)->StateBits(),
		 pla_outputs[i]);
	 delete pla_outputs[i];
      };
      delete pla_outputs;
      fprintf(file,".e\n");
      fclose(file);
      system("espresso program_output_estimate.pla > program_output_estimate_minimized.pla");
      espresso_in=fopen("program_output_estimate_minimized.pla","r");
      espresso_parse();
      fclose(espresso_in);
      pla_area+=Function->Estimate(tech);
      Function->DelAllMembers();
   }
   else
   {
      mux_area=0;
      pla_area=tech->PLA(StateVectorSize(),1,NrOfMembers())*Member(0)->Width();
   };
   return pla_area+mux_area;
};

output_estimates *output_estimates::Partition(output *oput)
{
   output_estimates *ret;
   int i;
   ret=new output_estimates;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(Member(i)->Actions()->Member(0)->Target()->Dest(),oput->Name())==0)
      {
	 Member(i)->Name(oput->Name());
	 Member(i)->Width(oput->BitSize());
	 ret->AddMember(Member(i));
      };
   };
   ret->StateVectorSize(StateVectorSize());
   return ret;
};

output_partitions *output_estimates::Partition(void)
{
   int i;
   output_partitions *op;
   op=new output_partitions();
   for(i=0;i<Outputs->NrOfMembers();i++)
   {
      output_estimates *ret;
      ret=Partition(Outputs->Member(i));
      if (ret->NrOfMembers()>0)
      {
	 op->AddMember(ret);
      };
   };
   for(i=0;i<Internals->NrOfMembers();i++)
   {
      output_estimates *ret;
      ret=Partition(Internals->Member(i));
      if (ret->NrOfMembers()>0)
      {
	 op->AddMember(ret);
      };
   };
   return op;
};

void output_estimate::SplitAssignment(void)
{
   action_target *target;
   target=Actions()->Member(0)->Target();
   int bit_pos=Transition()->BitPos();
   split=Actions()->Member(0)->Line()->WordAlignAction(bit_pos,target);
}

void output_estimates::SplitAssignment(void)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->SplitAssignment();
   };
};

int output_partitions::Estimate(FILE *file,technology *tech)
{
   int output_area=0;
   fprintf(file,"------------------------------------------------------------\n");
   fprintf(file,"Output \t\tNrOfAssignments\t Area\n");
   if (DETAILED_ESTIMATE_MODE)
   {
      for(int i=0;i<NrOfMembers();i++)
      {
	 int member_area=0;
	 Member(i)->SplitAssignment();
	 member_area=Member(i)->Estimate(tech);
	 output_area+=member_area;
	 fprintf(file," %s \t %d \t\t%d\n",
		 Member(i)->Member(0)->Name(),
		 Member(i)->NrOfMembers(),
		 member_area);
      };
   }
   else
   {
      for(int i=0;i<NrOfMembers();i++)
      {
	 int member_area;
	 member_area=Member(i)->Estimate(tech);
	 output_area+=member_area;
	 fprintf(file," %s \t %d \t\t%d\n",
		 Member(i)->Member(0)->Name(),
		 Member(i)->NrOfMembers(),
		 member_area);
      };
   };
   fprintf(file,"Total Output Area %d\n",output_area);
   return output_area;
};


