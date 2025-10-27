#include <string.h> 
#include "program.h" 
#include "composer.h"
#include "lib/rli_string.h"
#include "lib/vhdl_packages.h"
extern char *int2bits(int number);

extern lexem *build_grammar_DAG(input_stream *stream,char *rule,lexem *prev_lexem);
extern productions *Grammars;
extern internals *Internals;
extern inputs *Inputs;
extern outputs *Outputs;
extern memories *Memories;
extern types *Types;
extern aliases *Aliases;
extern starts *Starts;
extern fifos *Fifos;
extern conversion_functions *ConversionFunctions;
extern elaborations *Elaborations;

extern char *Entity_Name;
extern bool SIM_MODE, DEBUG_MODE;
extern bool DUMP_FSM_DAG,DUMP_FSM_AS_DRIVER,DUMP_FSM_AS_VERILOG;
extern bool SPLIT_TREE,STATE_COUNTER_MODE,ESTIMATE_MODE;
extern int  SCHEDULE_HEURISTIC;
extern int Version;
extern char *ForSyDePath;

int NrOfRemainingNulls;

bool first_if_statement;
bool no_top_error;
bool printed_a_transition;
int nr_of_states;
lexems *AllLexems=new lexems();

// Error log functions...
char log_str[1024];
void log(char *s)
{
	char file_name[1024];
	sprintf(file_name, "%s/program_compiler_v%d_test.txt", ForSyDePath, Version);
	FILE *log_file = fopen(file_name, "a");
	fprintf(log_file,"%s",s);
	fclose(log_file);
};
void clr_logfiles(void)
{
	char file_name[1024];
	sprintf(file_name, "%s/program_compiler_v%d_test.txt", ForSyDePath,Version);
	FILE *log_file=fopen(file_name,"w");
	fprintf(log_file,"\n");
	fclose(log_file);
};
void clr_error_files(void)
{
	char file_name[1024];
	sprintf(file_name, "%s/forsyde.stderr.txt", ForSyDePath); // , Version);
	FILE *log_file = fopen(file_name, "w");
	fprintf(log_file, "\n");
	fclose(log_file);
}

// Global functions
void indent(FILE *file,int nr_of_indents)
{
   int i;
   for(i=0;i<nr_of_indents;i++)
   {
      fprintf(file,"   ");
   };
};

char *int2bits(int i)
{
	char tmp[32];
	char ret[32];
	if (i==0) sprintf(ret,"0");
	else 
	{
		int val=i;
		while(val>=0)
		{
			if ((val%2)==1) sprintf(tmp,"1%s",ret);
			else sprintf(tmp,"0%s",ret);
			val=val>>1;
			sprintf(ret,"%s",tmp);
		}
	}
	return cpystr(ret);
};

// Methods for Range
/*
range_class::range(int l,int r)
{
   left=l
   if (f>t)
   {
      from=t; to=f; lsb_first=true;
   }
   else
   {
      from=f; to=t; lsb_first=false;
   };
   pointer=NULL;
};
*/

range_class *range_class::Copy(void)
{ 
   return new range_class(Left(),Right(),Pointer(),LSBFirst());
};

// Methods for Target code
void target_code::AddMember(char *s)
{
   nr_of_members++;
   if (nr_of_members==1)
   {
      members=(char **)malloc(sizeof(char *));
   }
   else
   {
      members=(char **)realloc(members,sizeof(char *)*nr_of_members);
   };
   members[nr_of_members-1]=s;
};

void target_code::AddMembers(target_code *tc)
{
   for(int i=0;i<tc->NrOfMembers();i++)
   {
      AddMember(cpystr(tc->Member(i)));
   };
};

char *target_code::Member(int i)
{
   if ((i<0) || (i>=NrOfMembers()))
   {
      fprintf(error_log,"BUG! Target_Code Member out of range\n");
      exit(1);
   }; 
   return members[i];
};

void target_code::PrintTargetCode(FILE *target_file)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      fprintf(target_file,"%s\n",Member(i));
   };
   fprintf(target_file,"\n");
};

// Methods for constant lexem
constant *constants::Member(char *s)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(Member(i)->Name(),s)==0)
      {
	 return Member(i);
      };
   };
   return NULL;
};

// Methods for production group
production_terminal::production_terminal(char *v,bool b)
{ 
   value=v; 
   if (v[0]==OTHER_BIT)
   {
      type=PGM_OTHERS;
   }
   else if (v[0]==DONT_CARE_BIT)
   {
      type=PGM_BITS;
   }
   else
   {
      type=PGM_CONSTANT;
   };
   is_negated=b;
};

production_terminal::production_terminal(char c,int i,bool b)
{
   int j;
   value=(char *)malloc(sizeof(char)*(i+1));
   for(j=0;j<i;j++) value[j]=c;
   value[i]=0;
   if (c==OTHER_BIT)
   {
      type=PGM_OTHERS;
   }
   else if (c==DONT_CARE_BIT)
   {
      type=PGM_BITS;
   }
   else
   {
      type=PGM_CONSTANT;
   }
   is_negated=b;
};

int production_terminal::NrOfBits(void)
{
   int ret;
   if (IsSignal())
   {
      ret=Signal()->BitSize();
   }
   else
   {
      ret=strlen(value);
   };
   return ret;
};

production_cond *production_cond::Copy(void)
{
   production_cond *ret;
   if (IsSignal())
   {
      ret=new production_cond(Signal1()->Copy(),Condition(),Signal2()->Copy());
   }
   else
   {
      ret=new production_cond(Signal1()->Copy(),Condition(),Value());
   };
   return ret;
};

production_signal *production_signal::Copy(void)
{
   if (IsSignal())
   {
      return new production_signal(Signal()->Copy());
   }
   else
   {
      return new production_signal(Variable()->Copy());
   };
};

production_terminal *production_terminal::Copy(void)
{
   production_terminal *ret;
   if (IsSignal())
   {
      ret=new production_terminal(Signal()->Copy());
   }
   else
   {
      ret=new production_terminal(cpystr(Value()),IsNegated());
   };
   return ret;
};

void production_signal::BitPos(productions *p,int bp)
{
   if (IsSignal())
   {
      Signal()->BitPos(p,bp);
   }
   else
   {
      Variable()->BitPos(p,bp);
   }
};

void production_signal::CheckConsistency(int fsm,input_stream *stream,int bp)
{
  if (IsSignal())
  {
     Signal()->CheckConsistency(fsm,stream,bp);
     BitSize(Signal()->BitSize());
  }
  else
  {
     Variable()->CheckConsistency(fsm,stream,bp);
     // Bit size of variables in CDFGs and Expressions are not wordaligned
     // and is therefore equal to the size of the referenced production rule
     BitSize(Variable()->ProdSize());
  };
};

void production_cond::BitPos(productions *p,int bp)
{
   Signal1()->BitPos(p,bp);
   if (IsSignal())
   {
     Signal2()->BitPos(p,bp);
   };
};

void production_conds::BitPos(productions *p,int bp)
{
  for(int i=0;i<NrOfMembers();i++)
  {
     Member(i)->BitPos(p,bp);
  };
};

void production_cond::CheckConsistency(int fsm,input_stream *stream,int bp)
{
   Signal1()->CheckConsistency(fsm,stream,bp);
   if (IsSignal())
   {
      Signal2()->CheckConsistency(fsm,stream,bp);
      if (Signal1()->BitSize()!=Signal2()->BitSize())
      {
	fprintf(error_log,"Warning: Condition signals has different widths!\n");
	fprintf(error_log,"         Signals \'");
	Signal1()->PrintSignal(error_log,fsm,stream,bp);
	fprintf(error_log,"\' and \'");
	Signal2()->PrintSignal(error_log,fsm,stream,bp);
	fprintf(error_log,"\'\n");
      };
   }
   else
   {
      if (Signal1()->BitSize()!=strlen(Value()))
      {
	fprintf(error_log,"Warning: Condition value on signal \'");
	Signal1()->PrintSignal(error_log,fsm,stream,bp);
	fprintf(error_log,"\' is inconsistent with its width!\n");
      };
   };
};

void production_conds::CheckConsistency(int fsm,input_stream *stream,int bp)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->CheckConsistency(fsm,stream,bp);
   };
};

bool production_signal::Compare(production_signal *signal)
{
   if (Type()!=signal->Type()) return false;
   if (IsSignal())
   {
     return Signal()->Compare(signal->Signal());
   }
   else
   {
     return Variable()->Compare(signal->Variable());
   };
};

bool production_cond::Compare(production_cond *cond)
{
   if (!Signal1()->Compare(cond->Signal1()))
   {
      return false;
   };
   if ((cond->Condition()!=Condition()) ||
       (cond->Type()!=Type()))
   {
      return false;
   }
   else
   {
      if (IsConstant())
      {
	 if (strcmp(cond->Value(),Value())!=0)
	 {
	    return false;
	 };
      }
      else
      {
	 if (!cond->Signal2()->Compare(Signal2()))
	 {
	    return false;
	 };
      };
   };
   return true;
};

bool production_conds::Compare(production_conds *conds)
{
   int i;
   if (conds->NrOfMembers()!=NrOfMembers()) return false;
   for(i=0;i<NrOfMembers();i++)
   {
      if(!Member(i)->Compare(conds->Member(i))) return false;
   };
   return true;
};

char *production_conds::DumpDaVinci(void)
{
   int i;
   char *ret;
   ret=cpystr("");
   for(i=0;i<NrOfMembers();i++)
   {
      char tmp[256];
      //      sprintf(tmp," && cond(%s=%s)",Member(i)->Signal(),Member(i)->Value());
      sprintf(tmp," && cond(??=??)");
      ret=catstr(ret,cpystr(tmp));
   };
   return ret;
};

int COND_EQU=0;
int COND_NEQ=1;
int COND_GTE=2;
int COND_GT=3;
int COND_LT=4;
int COND_LTE=5;
void production_conds::write_driver(FILE *file,int fsm,input_stream *stream,int bp)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      if ((nr_of_states>1) || (i>0))
      {
	 fprintf(file," AND\n                ");
      };
      if (Member(i)->Condition()==COND_EQU)
      {
	 fprintf(file,"(equ(");
      }
      else if (Member(i)->Condition()==COND_NEQ)
      {
	 fprintf(file,"(neq(");
      }
      else if (Member(i)->Condition()==COND_GTE)
      {
	 fprintf(file,"(gte(");
      }
      else if (Member(i)->Condition()==COND_GT)
      {
	 fprintf(file,"(gt(");
      }
      else if (Member(i)->Condition()==COND_LTE)
      {
	 fprintf(file,"(lte(");
      }
      else if (Member(i)->Condition()==COND_LT)
      {
	 fprintf(file,"(lt(");
      }
      else
      {
	 fprintf(error_log,"BUG!!! Unknown condition detected\n");
	 exit(1);
      };
      Member(i)->Signal1()->PrintSignal(file,fsm,stream,bp);
      fprintf(file,",");
      if (Member(i)->IsConstant())
      {
	 fprintf(file,"std_logic_vector'(\"%s\")",Member(i)->Value());
      }
      else
      {
	 Member(i)->Signal2()->PrintSignal(file,fsm,stream,bp);
      };
      fprintf(file,"))");
   };
};

void production_cond::PrintCondition(FILE *file,int fsm,input_stream *stream,int bp)
{
   if (Condition()==COND_EQU)
      {
	 fprintf(file,"(equ(");
      }
      else if (Condition()==COND_NEQ)
      {
	 fprintf(file,"(neq(");
      }
      else if (Condition()==COND_GTE)
      {
	 fprintf(file,"(gte(");
      }
      else if (Condition()==COND_GT)
      {
	 fprintf(file,"(gt(");
      }
      else if (Condition()==COND_LTE)
      {
	 fprintf(file,"(lte(");
      }
      else if (Condition()==COND_LT)
      {
	 fprintf(file,"(lt(");
      }
      else
      {
	 fprintf(error_log,"BUG!!! Unknown condition detected\n");
	 exit(1);
      };
      Signal1()->PrintSignal(file,fsm,stream,bp);
      fprintf(file,",");
      if (IsConstant())
      {
	 fprintf(file,"std_logic_vector'(\"%s\")",Value());
      }
      else
      {
	 Signal2()->PrintSignal(file,fsm,stream,bp);
      };
      fprintf(file,"))");
};

void production_conds::PrintTransitions(FILE *file,int fsm,input_stream *stream,int bp)
{
   int i;
   //   fprintf(file,"BAKAYARO %d conds\n",NrOfMembers());
   for(i=0;i<NrOfMembers();i++)
   {
      if ((nr_of_states>1) || (i>0))
      {
	 fprintf(file," AND\n                ");
      };
      Member(i)->PrintCondition(file,fsm,stream,bp);
   };
};

void production_interrupt::CheckConsistency(int fsm)
{
   int i;
   internal *intern;
   input *inp;
   inp=Inputs->Member(Signal());
   if (inp==NULL)
   {
      intern=Internals->Member(Signal());
      if (intern==NULL)
      {
	 fprintf(error_log,"The signal %s is not defined\n",Signal());
	 exit(1);
      }
      else
      {
	 intern->IsReadBy(fsm,true);
      };
   }
   else
   {
      inp->IsReadBy(fsm,true);
   };
};

/* Node-limited version ONLY !!!! */
void productions::AddMember(production *p)
{
  if (NrOfMembers()>50)
  {
    fprintf(error_log,"\n   Error: Production rule limit exceeded\n");
    fprintf(error_log,"          # of rules limited to 50 in evaluation version\n");
    exit(1);
  };
  List<production>::AddMember(p);
};

production *productions::Member(char *s)
{
   int i;
   production *ret;
   ret=NULL;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
	 ret=Member(i);
	 break;
      };
   };
   return ret;
};

bool productions::IsMember(char *s)
{
   int i;
   bool ret;
   ret=false;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
	 ret=true;
	 break;
      }
   };
   return ret;
};

production_signal::~production_signal()
{
   if (IsSignal())
   {
     delete Signal();
   }
   else
   {
     delete Variable();
   };
};

production_cond::~production_cond()
{
   delete Signal1();
   if (IsSignal())
   {
      delete Signal2();
   }
   else
   {
      delete Value();
   };
};

production_item::~production_item()
{
   if (IsLexem()) delete item.lexeme;
   if (IsRedirection()) delete item.redirection;
   if (IsTerminal()) delete item.terminal;
   if (IsError()) delete item.error;
   if (IsAction()) delete item.acts;
};

//***************************************************************************
// Methods for the GUI Query Handler
//***************************************************************************
void inputs::GUI_ListPorts(FILE *file)
{
   for(int i=0;i<NrOfMembers();i++)
   {
     fprintf(file,"IN %s %d\n",Member(i)->Name(),Member(i)->BitSize());
   };
};

void internals::GUI_ListPorts(FILE *file)
{
   for(int i=0;i<NrOfMembers();i++)
   {
     fprintf(file,"INTERNAL %s %d\n",Member(i)->Name(),Member(i)->BitSize());
   };
};

void outputs::GUI_ListPorts(FILE *file)
{
   for(int i=0;i<NrOfMembers();i++)
   {
     fprintf(file,"OUT %s %d\n",Member(i)->Name(),Member(i)->BitSize());
   };
};

//***************************************************************************
// Methods for inputs
//***************************************************************************
int device_driver::RelativeAddress(void)
{
   if (IsSW())
   {
      fprintf(error_log,"BUG: Software Drivers cannot have a relative address\n");
      exit(1);
   }
   else
   {
      return driver.hwd->RelativeAddress();
   };
};

int device_driver::ArrayLength(void)
{
   if (IsSW())
   {
      return driver.swd->ArrayLength();
   }
   else
   {
      return driver.hwd->ArrayLength();
   };
};

input *inputs::Member(char *s)
{
   int i;
   input *ret;
   ret=NULL;
 //  sprintf(log_str, "BAKA %s %08x %d\n", s, this, NrOfMembers());
 //  log(log_str);
   for(i=0;i<NrOfMembers();i++)
   {
//	   sprintf(log_str, "%08x %d\n", Member(i),i);
//	   log(log_str);
	   if (strcmp(s,Member(i)->Name())==0)
      {
	 ret=Member(i);
	 break;
      };
   };
   return ret;
};

void input::InitFlags(int nr)
{
   int i;
   is_read_by=(bool *)malloc(sizeof(bool)*nr);
   is_clock_in=(bool *)malloc(sizeof(bool)*nr);
   for(i=0;i<nr;i++)
   {
      is_read_by[i]=false;
      is_clock_in[i]=false;
   };
   bool_vector_size=nr;
}

bool input::IsClock(void)
{
  for(int i=0;i<bool_vector_size;i++)
  {
     if (IsClockIn(i)) return true;
  };
  return false;
};

void input::write_driver(FILE *file)
{
   if (HasDriver())
   {
      if (Driver()->IsSW())
      {
	 fprintf(file,"      %s %d %d sw in;\n",
		 Name(),BitSize(),
		 Driver()->ArrayLength());
      }
      else
      {
	 fprintf(file,"      %s %d %d hw in %d;\n",
		 Name(),BitSize(),
		 Driver()->ArrayLength(),
		 Driver()->RelativeAddress());
      };
   }
   else
   {
      fprintf(file,"      %s %d 0 external in;\n",Name(),BitSize());
   };
};

bool input::write_clocks(FILE *file,bool first)
{
   bool ret=first;
   if (IsClock())
   {
      if (first)
      {
    	 fprintf(file,"%s:IN std_logic",Name());
      }
      else
      {
    	 fprintf(file,";\n        %s:IN std_logic",Name());
      };
      ret=false;
   };
   return ret;
};

void inputs::write_clocks(FILE *file)
{
   bool first=true;
   for(int i=0;i<NrOfMembers();i++)
   {
      first=Member(i)->write_clocks(file,first);
   };
};

void input::write_vhdl(FILE *file,int fsm)
{
   if (fsm==-1)
   {
      if (!IsClock())
      {
    	 fprintf(file,";\n");
    	 fprintf(file,"        %s:IN std_logic_vector(%d downto 0)",Name(),ArraySize()*BitSize()-1);
      }
      return;
   };
   if (IsReadBy(fsm))
   {
     if (!IsClockIn(fsm))
     {
        fprintf(file,";\n");
        fprintf(file,"        %s:IN std_logic_vector(%d downto 0)",Name(),ArraySize()*BitSize()-1);
     };
   };
};

void input::write_portmap(FILE *file,int fsm)
{
   if (IsReadBy(fsm))
   {
	   if (!IsClock())
	   {
		   fprintf(file, ",\n");
		   fprintf(file, "               %s", Name());
	   }
   };
};

bool comma_before_input;
void input::write_process_list(FILE *file,int fsm)
{
   if (IsReadBy(fsm))
   {
      if (comma_before_input)
      {
	 fprintf(file,",\n");
	 fprintf(file,"               %s",Name());
      }
      else
      {
	 fprintf(file,"%s",Name());
      };
      comma_before_input=true;
   };
};

void inputs::write_driver(FILE *file)
{
   int i;
   // Check the inputs
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_driver(file);
      };
   };
};

void inputs::write_vhdl(FILE *file,int fsm)
{
   int i;
   // Check the inputs
   if (NrOfMembers()==0) 
   {
      fprintf(error_log,"\n Error: No inputs specified\n");
      return;
   }
   else
   {
      for (i=0;i<NrOfMembers();i++)
      {
    	 Member(i)->write_vhdl(file,fsm);
      };
   };
};

void inputs::write_portmaps(FILE *file,int fsm)
{
   int i;
   // Check the inputs
   if (NrOfMembers()==0) 
   {
      fprintf(error_log,"\n Error: No inputs specified\n");
      return;
   }
   else
   {
      for (i=0;i<NrOfMembers();i++)
      {
		 Member(i)->write_portmap(file,fsm);
      };
   };
};

void inputs::write_process_list(FILE *file,int fsm)
{
   int i;
   // Check the inputs
   if (NrOfMembers()==0) 
   {
      fprintf(error_log,"\n Error: No inputs specified\n");
      return;
   }
   else
   {
      if (nr_of_states>1)
      {
	     comma_before_input=true;
      }
      else
      {
    	 comma_before_input=false;
      };
      for (i=0;i<NrOfMembers();i++)
      {
    	 Member(i)->write_process_list(file,fsm);
      };
   };
};

/***************************************************************************/
// Methods for Output
/***************************************************************************/
output *outputs::Member(char *s)
{
   int i;
   output *ret;
   ret=NULL;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
    	 ret=Member(i);
	     break;
      };
   };
   return ret;
};

void output::InitFlags(int nr)
{
   int i;
   is_read_by=(bool *)malloc(sizeof(bool)*nr);
   is_written_by=(bool *)malloc(sizeof(bool)*nr);
   nr_of_fsms=nr;
   for(i=0;i<nr;i++)
   {
      is_read_by[i]=false;
      is_written_by[i]=false;
   };
}

bool output::IsRead(void)
{
   bool ret;
   int i;
   ret=false;
   for(i=0;i<nr_of_fsms;i++)
   {
     ret=ret || is_read_by[i];
   };
   return ret;
};

void output::write_driver(FILE *file)
{
   if (HasDriver())
   {
      if (Driver()->IsSW())
      {
    	 fprintf(file,"      %s %d %d sw out;\n",
    		 Name(),BitSize(),
    		 Driver()->ArrayLength());
      }
      else
      {
    	 fprintf(file,"      %s %d %d hw out %d;\n",
    		 Name(),BitSize(),
    		 Driver()->ArrayLength(),
    		 Driver()->RelativeAddress());
      };
   }
   else
   {
      fprintf(file,"      %s %d 0 external out;\n",Name(),BitSize());
   };
};

void output::write_vhdl(FILE *file,int fsm)
{
   if (fsm==-1)
   {
      fprintf(file,";\n");
      fprintf(file,"        %s:OUT std_logic_vector(%d downto 0)",Name(),ArraySize()*BitSize()-1);
      return;
   };
   if (IsWrittenBy(fsm))
   {
      fprintf(file,";\n");
      fprintf(file,"        %s:OUT std_logic_vector(%d downto 0)",Name(),ArraySize()*BitSize()-1);
   }
   else if (IsReadBy(fsm))
   {
      fprintf(file,";\n");
      fprintf(file,"        %s:IN std_logic_vector(%d downto 0)",Name(),ArraySize()*BitSize()-1);
   };
};

void output::write_portmap(FILE *file,int fsm)
{
   if (IsReadBy(fsm) || IsWrittenBy(fsm))
   {
      fprintf(file,",\n");
      if (IsRead())
      {
	 fprintf(file,"               %s_internal",Name());
      }
      else
      {
	 fprintf(file,"               %s",Name());
      }
   };
};

void output::write_signal(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,"   SIGNAL %s_register: std_logic_vector(%d downto 0);\n",Name(),ArraySize()*BitSize()-1);
      fprintf(file,"   SIGNAL %s_internal: std_logic_vector(%d downto 0);\n",Name(),ArraySize()*BitSize()-1);
   };
};

void output::write_register(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,"            %s_internal<=%s_register;\n",Name(),Name());
   };
};

void memory::write_default(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm) || IsReadBy(fsm))
   {
      fprintf(file,"         %s_address<=(others=>'Z');\n",Name());
      fprintf(file,"         %s_data<=(others=>'Z');\n",Name());
      fprintf(file,"         %s_rw<=(others=>'Z');\n",Name());
      fprintf(file,"         %s_ae<=(others=>'Z');\n",Name());
   };
};

void output::write_default(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,"         %s_register<=%s_internal;\n",Name(),Name());
   };
};

void output::write_to_port(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,"      %s<=%s_internal;\n",Name(),Name());
   };
};

void output::write_to_port(FILE *file)
{
   if (IsRead())
   {
      fprintf(file,"      %s<=%s_internal;\n",Name(),Name());
   };
};

void output::write_process_list(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      if (comma_before_input)
      {
	 fprintf(file,",\n");
	 fprintf(file,"               %s_internal",Name());
      }
      else
      {
	 fprintf(file,"%s_internal",Name());
      };
      comma_before_input=true;
   }
   else if (IsReadBy(fsm))
   {
      if (comma_before_input)
      {
	 fprintf(file,",\n");
	 fprintf(file,"               %s",Name());
      }
      else
      {
	 fprintf(file,"%s",Name());
      };
      comma_before_input=true;
   };
};

void memory::write_process_list(FILE *file,int fsm)
{
   if (IsReadBy(fsm))
   {
      if (comma_before_input)
      {
	    fprintf(file,",\n");
	    fprintf(file,"               %s_data",Name());
      }
      else
      {
	 fprintf(file,"%s",Name());
      };
      comma_before_input=true;
   };
};

void outputs::write_driver(FILE *file)
{
   int i;
   // Check the Outputs
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_driver(file);
      };
   };
};

void output::write_signal(FILE *file)
{
   if (IsRead())
   {
      fprintf(file,"   SIGNAL %s_internal: std_logic_vector(%d downto 0);\n",Name(),ArraySize()*BitSize()-1);
   };
};

void outputs::write_signals(FILE *file)
{
   int i;
   // Check the Internals
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_signal(file);
      };
   };
};

void outputs::write_vhdl(FILE *file,int fsm)
{
   int i;
   // Check the Outputs
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_vhdl(file,fsm);
      };
   };
   fprintf(file,");\n");
};

void outputs::write_signals(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      fprintf(file,"\n   -- Output registers\n");
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_signal(file,fsm);
      };
   };
};

void outputs::write_registers(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_register(file,fsm);
      };
   };
};

void outputs::write_defaults(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_default(file,fsm);
      };
   };
};

void memories::write_defaults(FILE *file,int fsm)
{
   if (NrOfMembers()!=0) 
   {
      for (int i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_default(file,fsm);
      };
   };
};

void outputs::write_to_ports(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_to_port(file,fsm);
      };
   };
};

void outputs::write_to_ports(FILE *file)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_to_port(file);
      };
   };
};

void outputs::write_portmaps(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_portmap(file,fsm);
      };
   };
};

void outputs::write_process_list(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_process_list(file,fsm);
      };
   };
};

void memories::write_process_list(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_process_list(file,fsm);
      };
   };
};

/***************************************************************************/
// Methods for internals
/***************************************************************************/
internal *internals::Member(char *s)
{
   int i;
   internal *ret;
   ret=NULL;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
	 ret=Member(i);
	 break;
      };
   };
   return ret;
};

void internal::InitFlags(int nr)
{
   int i;
   is_read_by=(bool *)malloc(sizeof(bool)*nr);
   is_clock_in=(bool *)malloc(sizeof(bool)*nr);
   is_written_by=(bool *)malloc(sizeof(bool)*nr);
   for(i=0;i<nr;i++)
   {
      is_read_by[i]=false;
      is_clock_in[i]=false;
      is_written_by[i]=false;
   };
   bool_vector_size=nr;
};

void memory::InitFlags(int nr)
{
   int i;
   is_read_by=(bool *)malloc(sizeof(bool)*nr);
   is_clock_in=(bool *)malloc(sizeof(bool)*nr);
   is_written_by=(bool *)malloc(sizeof(bool)*nr);
   for(i=0;i<nr;i++)
   {
      is_read_by[i]=false;
      is_clock_in[i]=false;
      is_written_by[i]=false;
   };
   bool_vector_size=nr;
};

bool internal::IsWrittenByOthers(int fsm)
{
   for(int i=0;i<bool_vector_size;i++)
   {
      if (IsWrittenBy(fsm) && (fsm!=i)) return true;
   };
   return false;
};

void internal::write_driver(FILE *file)
{
   fprintf(file,"      %s %d 0 internal;\n",Name(),BitSize());
};

void internal::write_to_port(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,"      %s<=%s_internal;\n",Name(),Name());
   };
};

void internal::write_process_list(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      if (comma_before_input)
      {
         fprintf(file,",\n");
		 fprintf(file,"               %s_internal",Name());
      }
      else
      {
	 fprintf(file,"%s_internal",Name());
      };
      comma_before_input=true;
   }
   else if (IsReadBy(fsm))
   {
      if (comma_before_input)
      {
	 fprintf(file,",\n");
	 fprintf(file,"               %s",Name());
      }
      else
      {
	 fprintf(file,"%s",Name());
      };
      comma_before_input=true;
   };
};

void internals::write_driver(FILE *file)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_driver(file);
      };
   };
};

void internals::write_to_ports(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_to_port(file,fsm);
      };
   };
};

void internals::write_process_list(FILE *file,int fsm)
{
   int i;
   // Check the inputs
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_process_list(file,fsm);
      };
   };
};

void internal::write_register(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,"            %s_internal<=%s_register;\n",Name(),Name());
   };
};

void internals::write_registers(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_register(file,fsm);
      };
   };
};

void internal::write_default(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,"         %s_register<=%s_internal;\n",Name(),Name());
   };
};

void internals::write_defaults(FILE *file,int fsm)
{
   int i;
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_default(file,fsm);
      };
   };
};

void internal::write_signal(FILE *file)
{
   fprintf(file,"   SIGNAL %s: std_logic_vector(%d downto 0);\n",Name(),ArraySize()*BitSize()-1);
};

void internal::write_signal(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,"   SIGNAL %s_register: std_logic_vector(%d downto 0);\n",Name(),ArraySize()*BitSize()-1);
      fprintf(file,"   SIGNAL %s_internal: std_logic_vector(%d downto 0);\n",Name(),ArraySize()*BitSize()-1);
   };
};

void internals::write_signals(FILE *file)
{
   int i;
   // Check the Internals
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_signal(file);
      };
   };
};

void internals::write_signals(FILE *file,int fsm)
{
   int i;
   // Check the Outputs
   if (NrOfMembers()!=0) 
   {
      fprintf(file,"\n   -- Internal registers\n");
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_signal(file,fsm);
      };
   };
};

void internal::write_vhdl(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm))
   {
      fprintf(file,";\n");
      if (IsReadBy(fsm))
      {
	 if (!IsClockIn(fsm))
	 {
	    if (IsWrittenByOthers(fsm))
	    {
	       fprintf(file,"        %s:INOUT std_logic_vector(%d downto 0)",Name(),ArraySize()*BitSize()-1);
	    }
	    else
	    {
	       fprintf(file,"        %s:OUT std_logic_vector(%d downto 0)",Name(),ArraySize()*BitSize()-1);
	    };
	 }
	 else
	 {
	    fprintf(error_log,"Error: A process cannot control it's own clock: Internal %s, clock in start rule # %d\n",Name(),fsm);
	    exit(1);
	 };
      }
      else
      {
	 fprintf(file,"        %s:OUT std_logic_vector(%d downto 0)",Name(),ArraySize()*BitSize()-1);
      };
   }
   else if (IsReadBy(fsm))
   {
      if (!IsClockIn(fsm))
      {
		 fprintf(file,";\n");
		 fprintf(file,"        %s:IN std_logic_vector(%d downto 0)",Name(),BitSize()-1);
      };
   };
};

void internals::write_vhdl(FILE *file,int fsm)
{
   int i;
   // Check the Internals
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_vhdl(file,fsm);
      };
   };
};

void internal::write_portmap(FILE *file,int fsm)
{
   if (IsReadBy(fsm) || IsWrittenBy(fsm))
   {
	   if (!IsClockIn(fsm))
	   {
		   fprintf(file, ",\n");
		   fprintf(file, "               %s", Name());
	   };
   };
};
void internals::write_portmaps(FILE *file,int fsm)
{
   int i;
   // Check the Internals
   if (NrOfMembers()>0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
		 Member(i)->write_portmap(file,fsm);
      };
   };
};

/***************************************************************************/
// Methods for Aliases
/***************************************************************************/
alias *aliases::Member(char *s)
{
   int i;
   alias *ret;
   ret=NULL;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
	 ret=Member(i);
	 break;
      };
   };
   return ret;
};

void alias::InitFlags(int nr)
{
   int i;
   is_read_by=(bool *)malloc(sizeof(bool)*nr);
   is_written_by=(bool *)malloc(sizeof(bool)*nr);
   nr_of_fsms=nr;
   for(i=0;i<nr;i++)
   {
      is_read_by[i]=false;
      is_written_by[i]=false;
   };
}

/***************************************************************************/
// Methods for memory
/***************************************************************************/
memory *memories::Member(char *s)
{
   int i;
   memory *ret;
   ret=NULL;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
	 ret=Member(i);
	 break;
      };
   };
   return ret;
};

void memory::write_vhdl(int i, FILE *file)
{
   fprintf(file,"   Memory_%d:memory\n",i);
   fprintf(file,"         GENERIC MAP(%d,%d,%d,%d)\n",NrOfPorts(),MemorySize(),AddressSize(),DataSize());
   fprintf(file,"         PORT MAP(address => %s_address,\n",Name());
   fprintf(file,"                  data    => %s_data,\n",Name());
   fprintf(file,"                  ce      => %s_ae,\n",Name());
   fprintf(file,"                  rw      => %s_rw);\n",Name());
};

void memories::write_vhdl(FILE *file)
{
   int i;
   // Extract the Memories
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_vhdl(i,file);
      };
   };
};

void memory::write_vhdl(FILE *file,int fsm)
{
   if (IsWrittenBy(fsm) || IsReadBy(fsm))
   {
      fprintf(file,";\n");
      fprintf(file,"        %s_address:INOUT std_logic_vector(%d downto 0);\n",Name(),NrOfPorts()*AddressSize()-1);
      fprintf(file,"        %s_data:INOUT std_logic_vector(%d downto 0);\n",Name(),NrOfPorts()*BitSize()-1);
      fprintf(file,"        %s_ae:INOUT std_logic_vector(%d downto 0);\n",Name(),NrOfPorts()-1);
      fprintf(file,"        %s_rw:INOUT std_logic_vector(%d downto 0)",Name(),NrOfPorts()-1);
   };
};

void memories::write_vhdl(FILE *file,int fsm)
{
   int i;
   // Extract the Memories
   if (NrOfMembers()!=0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_vhdl(file,fsm);
      };
   };
};

void memory::write_portmap(FILE *file,int fsm)
{
   if (IsReadBy(fsm) || IsWrittenBy(fsm))
   {
      fprintf(file,",\n");
      fprintf(file,"               %s_address,\n",Name());
      fprintf(file,"               %s_data,\n",Name());
      fprintf(file,"               %s_ae,\n",Name());
      fprintf(file,"               %s_rw",Name());
   };
};

void memories::write_portmaps(FILE *file,int fsm)
{
   int i;
   // Check the Internals
   if (NrOfMembers()>0) 
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_portmap(file,fsm);
      };
   };
};

extern int nr_of_memory_bits(char *name);
memory::memory(char *n, int a, int p, char *l)
{ 
   name=cpystr(n);
   address_size=a;
   nr_of_ports=p;
   layout=cpystr(l);
   // BitSize is initialized later, after the memory layout has been parsed
   bit_size=-1;
};

void memory::Initialize(void)
{
  if (Layout()!=NULL) BitSize(nr_of_memory_bits(Layout()));
};

void memories::Initialize(void)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->Initialize();
   };
};

void memory::write_signals(FILE *file)
{
   fprintf(file,"\n   -- Memory signal %s's control signals\n",Name());
   //   fprintf(file,"   SUBTYPE %s_subtype IS std_logic_vector(%d downto 0);\n",Name(),BitSize()-1);
   fprintf(file,"   SIGNAL %s_address: std_logic_vector(%d downto 0);\n",Name(),NrOfPorts()*AddressSize()-1);
   fprintf(file,"   SIGNAL %s_data: std_logic_vector(%d downto 0);\n",Name(),NrOfPorts()*BitSize()-1);
   fprintf(file,"   SIGNAL %s_rw: std_logic_vector(%d downto 0);\n",Name(),NrOfPorts()-1);
   fprintf(file,"   SIGNAL %s_ae: std_logic_vector(%d downto 0);\n",Name(),NrOfPorts()-1);
};


void memories::write_signals(FILE *file)
{
   // Check the Memories for signals
   if (NrOfMembers()!=0) 
   {
      fprintf(file,"   COMPONENT memory\n");
      fprintf(file,"      GENERIC(Nr_Of_Ports:INTEGER;\n");
      fprintf(file,"              Mem_Size:INTEGER;\n");
      fprintf(file,"              Address_Size:INTEGER;\n");
      fprintf(file,"              Data_Size:INTEGER);\n");
      fprintf(file,"      PORT(address:IN std_logic_vector(Nr_Of_Ports*Address_Size-1 downto 0);\n");
      fprintf(file,"           data:INOUT std_logic_vector(Nr_Of_Ports*Data_Size-1 downto 0);\n");
      fprintf(file,"           ce:IN std_logic_vector(Nr_Of_Ports-1 downto 0);\n");
      fprintf(file,"           rw:IN std_logic_vector(Nr_Of_Ports-1 downto 0));\n");
      fprintf(file,"   END COMPONENT;\n");
      for (int i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_signals(file);
      };
   };
};

// Methods for fifos
fifo *fifos::AddMember(fifo *f)
{
   int i;
   fifo *current;
   current=Member(f->Name());
   if (current!=NULL)
   {
      if (f->Depth()>current->Depth())
      {
		 current->Depth(f->Depth());
      };
      return current;
   };
   List<fifo>::AddMember(f);
   return f;
};

fifo *fifos::Member(char *s)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(Member(i)->Name(),s)==0)
      {
	 return Member(i);
      };
   };
   return NULL;
};

void fifos::write_vhdl(FILE *file,int fsm)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->IsReadBy(fsm))
      {
	 Member(i)->write_vhdl(i,file);
      };
   };
};

void fifos::write_signals(FILE *file,int fsm)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->IsReadBy(fsm))
      {
	 Member(i)->write_signals(file);
      };
   };
};

void fifos::write_process_list(FILE *file,int fsm)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->IsReadBy(fsm))
      {
	 Member(i)->write_process_list(file);
      };
   };
};

void fifo::InitFlags(int nr)
{
   int i;
   is_read_by=(bool *)malloc(sizeof(bool)*nr);
   for(i=0;i<nr;i++)
   {
      is_read_by[i]=false;
   };
};

fifo::fifo(input_stream *s, char *c, int d)
{
   stream=s; 
   depth=d; 
   name=catstr("FIFO_",stream->Name());
   clk_name=cpystr(c);
   InitFlags(Starts->NrOfMembers());
//   is_read_by=NULL;
};

fifo::~fifo()
{
   stream=NULL;
   if (is_read_by!=NULL) delete is_read_by;
   if (name!=NULL) delete name;
};

void fifo::write_vhdl(int nr,FILE *file)
{
   if (Depth()>0)
   {
      fprintf(file,"   FIFO_%d:\n",nr);
      fprintf(file,"      -- Extracted FIFO with %d stages of %d bits\n",Depth(),Stream()->BitSize());
      fprintf(file,"      PROCESS(%s)\n",ClockName());
      fprintf(file,"      BEGIN\n");
      fprintf(file,"         IF %s'event AND (%s='1') THEN\n",ClockName(),ClockName());
      if (Depth()>1)
      {
	 fprintf(file,"            FOR i IN %d downto 2 LOOP\n",Depth());
	 fprintf(file,"                  %s(i)<=%s(i-1);\n",Name(),Name());
	 fprintf(file,"            END LOOP;\n");
      };
      fprintf(file,"            %s(1)<=%s;\n",Name(),Stream()->Name());
      fprintf(file,"         END IF;\n");
      fprintf(file,"      END PROCESS;\n");
   };
//   fprintf(file,"      %s(0)<=%s;\n",Name(),Stream()->Name());
};

void fifo::write_signals(FILE *file)
{
  //  fprintf(error_log,"-- FIFO DEPTH %d\n",Depth());
   if (Depth()>0)
   {
      fprintf(file,"\n");
      fprintf(file,"   -- Extracted FIFO signals\n");
      fprintf(file,"   SUBTYPE fifo_type is std_logic_vector(%d downto 0);\n",Stream()->BitSize()-1);
      fprintf(file,"   TYPE fifo_array is array (%d downto 1) of fifo_type;\n",Depth());
      fprintf(file,"   SIGNAL %s:fifo_array;\n",Name());
   };
};

void fifo::write_process_list(FILE *file)
{
   if (Depth()>0)
   {
      if (comma_before_input)
      {
	 fprintf(file,",\n");
	 fprintf(file,"               %s",Name());
      }
      else
      {
	 fprintf(file,"%s",Name());
      };
      comma_before_input=true;
   };
};

// Methods for conversion_functions
void conversion_function::InitFlags(int nr)
{
   int i;
   is_used_by=(bool *)malloc(sizeof(bool)*nr);
   for(i=0;i<nr;i++)
   {
      is_used_by[i]=false;
   };
};

conversion_function::conversion_function(char *s,range_class *r,int b)
{
   if (r==NULL)
   {
      fprintf(error_log,"The signal %s has no range constraints set\n",s);
      exit(1);
   };
   left=r->Left();
   right=r->Right();
   bit_size=b;
   InitFlags(Starts->NrOfMembers());
};

void conversion_function::write_function(FILE *file)
{
   fprintf(file,"\n");
   if (bit_size==1)
   {
      fprintf(file,"   SUBTYPE std_logic_1 IS std_logic_vector(0 downto 0);\n");
      fprintf(file,"   FUNCTION to_std_logic_vector(inp:std_logic) return std_logic_1 IS\n");
      fprintf(file,"      -- pragma built_in SYN_FEED_THRU\n");
      fprintf(file,"      variable ret:std_logic_1;\n");
      fprintf(file,"   BEGIN\n");
      fprintf(file,"      ret(0):=inp;\n");
      fprintf(file,"      return ret;\n");
      fprintf(file,"   END;\n");
      fprintf(file,"\n");
   }
   else
   {
      fprintf(file,"   SUBTYPE bit%d IS bit_vector(%d downto 0);\n",bit_size,bit_size-1);
      fprintf(file,"   FUNCTION int_to_bit%d(inp:integer) return bit%d IS\n",bit_size,bit_size);
      fprintf(file,"      -- pragma built_in SYN_FEED_THRU\n");
      fprintf(file,"      variable tmp:integer;\n");
      fprintf(file,"      variable ret:std_logic%d;\n",bit_size);
      fprintf(file,"      variable test:integer;\n");
      fprintf(file,"   BEGIN\n");
      fprintf(file,"      tmp:=inp;\n");
      fprintf(file,"      FOR i IN 0 TO %d LOOP\n",bit_size-1);
      fprintf(file,"         test:=tmp mod 2;\n");
      fprintf(file,"         IF (test=1) THEN\n");
      fprintf(file,"            ret(i):='1';\n");
      fprintf(file,"         ELSE\n");
      fprintf(file,"            ret(i):='0';\n");
      fprintf(file,"         END IF;\n");
      fprintf(file,"         tmp:=tmp/2;\n");
      fprintf(file,"      END LOOP;\n");
      fprintf(file,"      RETURN ret;\n");
      fprintf(file,"   END;\n");
      fprintf(file,"\n");
      fprintf(file,"   FUNCTION bit%d_to_int(inp:std_logic%d) return integer IS\n",bit_size,bit_size);
      fprintf(file,"      -- pragma built_in SYN_FEED_THRU\n");
      fprintf(file,"      variable ret:integer;\n");
      fprintf(file,"   BEGIN\n");
      fprintf(file,"      ret:=0;\n");
      fprintf(file,"      FOR i IN 0 TO %d LOOP\n",bit_size-1);
      fprintf(file,"         IF (inp(i)='1') THEN\n");
      fprintf(file,"            ret:=2*ret+1;\n");
      fprintf(file,"         ELSE\n");
      fprintf(file,"            ret:=2*ret;\n");
      fprintf(file,"         END IF;\n");
      fprintf(file,"      END LOOP;\n");
      fprintf(file,"      RETURN ret;\n");
      fprintf(file,"   END;\n");
   };
};

conversion_function *conversion_functions::AddMember(conversion_function *f)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      if ((Member(i)->Left()==f->Left()) &&
	  (Member(i)->Right()==f->Right()) &&
	  (Member(i)->BitSize()==f->BitSize()))
      {
	 return Member(i);
      };
   };
   List<conversion_function>::AddMember(f);
   return f;
};

void conversion_functions::write_functions(FILE *file,int fsm)
{
   int i;
   fprintf(file,"\n   -- Conversion Functions\n");
   for(i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->IsUsedBy(fsm))
      {
	 Member(i)->write_function(file);
      };
   };
};

// Methods for layouts
layout *layouts::Member(char *s)
{
   int i;
   layout *ret;
   ret=NULL;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
	 ret=Member(i);
	 break;
      };
   };
   return ret;
};

void start::write_driver(FILE *file,int fsm)
{
   fprintf(file,"   fsm %s_%d {\n",Name(),fsm);
   fprintf(file,"      entry S0;\n");
   entry_lexem->write_driver(file,fsm,0);
   fprintf(file,"   }\n");
};

void start::write_entity(FILE *file,int fsm)
{
   write_ieee_packages(file);
   fprintf(file,"ENTITY %s_%d IS\n",Name(),fsm);
   fprintf(file,"   PORT(%s:IN std_logic",ClockName());
   Inputs->write_vhdl(file,fsm);
   Internals->write_vhdl(file,fsm);
   Memories->write_vhdl(file,fsm);
   Outputs->write_vhdl(file,fsm);
   fprintf(file,"END %s_%d;\n",Name(),fsm);
};

void start::write_component(FILE *file,int fsm)
{
   fprintf(file,"   COMPONENT %s_%d\n",Name(),fsm);
   fprintf(file,"      PORT(%s:IN std_logic",ClockName());
   Inputs->write_vhdl(file,fsm);
   Internals->write_vhdl(file,fsm);
   Memories->write_vhdl(file,fsm);
   Outputs->write_vhdl(file,fsm);
   fprintf(file,"   END COMPONENT;\n");
};

void start::write_portmap(FILE *file,int fsm)
{
   fprintf(file,"   U%d:%s_%d \n",fsm,Name(),fsm);
   fprintf(file,"      PORT MAP(%s",ClockName());
   Inputs->write_portmaps(file,fsm);
   Internals->write_portmaps(file,fsm);
   Memories->write_portmaps(file,fsm);
   Outputs->write_portmaps(file,fsm);
   fprintf(file,");\n");
};

void start::write_signals(FILE *file,int fsm)
{
   int i;
   if (end_state>1)
   {
      if (STATE_COUNTER_MODE)
      {
		 fprintf(file,"   SUBTYPE state_type IS INTEGER RANGE %d TO %d;\n",
		 entry_lexem->State(),end_state-1); 
      }
      else
      {
	 fprintf(file,"   TYPE state_type IS (\n");
	 for(i=entry_lexem->State();i<end_state;i++)
	 {
	    if (i!=end_state-1)
	    {
	       fprintf(file,"            state_%d,\n",i);
	    }
	    else
	    {
	       fprintf(file,"            state_%d\n",i);
	    };
	 };
         fprintf(file,"                      );\n"); 
      };
      fprintf(file,"   -- Reduced to a total of %d states\n",end_state);
      if (STATE_COUNTER_MODE)
      {
		 fprintf(file,"   SIGNAL pres_state,pres_state_plus_1,next_state:state_type;\n");
      }
      else
      {
		 fprintf(file,"   SIGNAL pres_state,next_state:state_type;\n");
      };
      fprintf(file,"   ATTRIBUTE state_vector:string;\n");
      fprintf(file,"   ATTRIBUTE state_vector OF program:ARCHITECTURE IS \"pres_state\";\n");
      nr_of_states=end_state;
   }
   else
   {
      fprintf(file,"   -- Statemachine reduced out, only 1 state required\n",end_state);
      nr_of_states=1;
   };
//   ConversionFunctions->write_functions(file,fsm);
   Fifos->write_signals(file,fsm);
   Outputs->write_signals(file,fsm);
   Internals->write_signals(file,fsm);
};

void start::write_fsm(FILE *file,int fsm)
{
   int i;
   fprintf(file,"   FSM:\n");
   fprintf(file,"      -- Finite State Machine extracted from start symbol %s\n",Name());
   if (nr_of_states>1)
   {
      if (STATE_COUNTER_MODE)
      {
	 fprintf(file,"      PROCESS (pres_state, pres_state_plus_1");
      }
      else
      {
	 fprintf(file,"      PROCESS (pres_state");
      };
	  comma_before_input = true;
   }
   else
   {
      fprintf(file,"      PROCESS (");
   };
   Inputs->write_process_list(file,fsm);
   Internals->write_process_list(file,fsm);
   Outputs->write_process_list(file,fsm);
   Memories->write_process_list(file,fsm);
   Fifos->write_process_list(file,fsm);
   fprintf(file,")\n");
   fprintf(file,"      BEGIN\n");
   Internals->write_defaults(file,fsm);
   Outputs->write_defaults(file,fsm);
   Memories->write_defaults(file,fsm);
   if (nr_of_states>1)
   {
      fprintf(file,"         next_state<=pres_state;\n");
   };
   first_if_statement=true;
   no_top_error=true;
   printed_a_transition=false;
   NrOfRemainingNulls = 0;
   AllLexems->SetAllVisited(false);
   // fprintf(file, "NrOfLexems %d NrOfNulls %d\n",AllLexems->NrOfMembers(), NrOfRemainingNulls);
   /*
   for (int i = 0; i < AllLexems->NrOfMembers(); i++)
   {
	   if (AllLexems->Member(i)->NrOfSuccs() > 0) // All lexems that is not optimised away
	   {
		   fprintf(file, "%d %08x (%d) %d\n", i, AllLexems->Member(i), AllLexems->Member(i)->NrOfSuccs(), AllLexems->Member(i)->Type());
		   for (int j = 0; j < AllLexems->Member(i)->NrOfSuccs(); j++)
		   {
			   fprintf(file, "   %d %08x\n", j, AllLexems->Member(i)->Succ(j));
		   }
	   };
   };
   */
   // print process converted to a loop
   //for (int i = 0; i < AllLexems->NrOfMembers(); i++)
   //{
	//   if (AllLexems->Member(i)->NrOfSuccs() > 0)
	//   {
	//      AllLexems->Member(i)->PrintAllTransitions(file, fsm);
	//   };
   //};
   // Recursion function does not work for some reason. Workaround: loop version
   entry_lexem->PrintAllTransitions(file,fsm);
   if ((nr_of_states>1) && (no_top_error))
   {
      fprintf(file,"         ELSE -- DEFAULT ERROR STATE\n");
      if (STATE_COUNTER_MODE)
      {
		  fprintf(file,"            next_state<=%d;\n",entry_lexem->State());
      }
      else
      {
		  fprintf(file,"            next_state<=state_%d;\n",entry_lexem->State());
      };
   };
   if (printed_a_transition)
   {
      fprintf(file,"         END IF;\n");
   };
   fprintf(file,"      END PROCESS;\n");
};

void start::write_registers(FILE *file,int fsm)
{
   fprintf(file,"   REGISTERS:\n");
   fprintf(file,"      -- Output and State Registers\n");
   fprintf(file,"      PROCESS(%s)\n",ClockName());
   fprintf(file,"      BEGIN\n");
   fprintf(file,"         IF rising_edge(%s) THEN\n",ClockName());
   if (nr_of_states>1)
   {
      fprintf(file,"            pres_state<=next_state;\n");
   }
   Outputs->write_registers(file,fsm);
   Internals->write_registers(file,fsm);
   fprintf(file,"         END IF;\n");
   fprintf(file,"      END PROCESS;\n");
   Outputs->write_to_ports(file,fsm);
   Internals->write_to_ports(file,fsm);
   if (STATE_COUNTER_MODE)
   {
      if (nr_of_states>1)
      {
	 fprintf(file,"      process(pres_state)\n");
	 fprintf(file,"      begin\n");
	 fprintf(file,"         if (pres_state<%d) then\n",nr_of_states-1);
	 fprintf(file,"            pres_state_plus_1<=pres_state+1;\n");
	 fprintf(file,"         else\n");
	 fprintf(file,"            pres_state_plus_1<=pres_state;\n");
	 fprintf(file,"         end if;\n");
	 fprintf(file,"      end process;\n");
      };
   };
   return;
};

void start::build_fsm(int fsm)
{
   int bit_size;

   // extract the FSM
   fprintf(error_log,"\n%s_%d:\n",Name(),fsm);
   bit_size=Stream()->BitSize();

   entry_lexem=new lexem(); // Creates an Exit Lexem instead of an Entry
   entry_lexem->Rule("ENTRY");

   fprintf(error_log,"BuildGrammar\n");
   exit_lexem=build_grammar_DAG(Stream(),Name(),entry_lexem);
   exit_lexem->Rule("EXIT");
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("BuildGrammar_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };
   fprintf(error_log,"ConnectInterruptEnds\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->ConnectInterruptEnds(exit_lexem);
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("ConnectInterruptEnds_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"ReduceExits\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->ReduceExits();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("ReduceExits_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"AtomizeTerminals\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->AtomizeTerminals();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("AtomizeTerminals_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"WordAlignTerminals\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->WordAlignTerminals(0);
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("WordAlignTerminals_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"LinkInterrupts\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->LinkInterrupts();
   AllLexems->SetAllVisited(false);
   entry_lexem->UnlinkInterruptHolders();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("LinkInterrupts_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"ReduceGrammar\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->ReduceGrammar();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("ReduceGrammar_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"WordAlignActions\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->WordAlignActions();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("WordAlignActions_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"LinkOthers\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->LinkOthers();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("LinkOthers_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   if (SPLIT_TREE)
   {
      fprintf(error_log,"SplitDAGintoTree\n");
      AllLexems->SetAllVisited(false);
      entry_lexem->SplitDAGintoTree();
      if (DEBUG_MODE)
      {
	 char *file_name;
	 FILE *file;
	 AllLexems->SetAllVisited(false);
	 file_name=catstr(catstr("SplitDAGintoTree_",itoa(fsm)),".daVinci");
	 file=fopen(file_name,"w");
	 entry_lexem->DumpDaVinci(file);
	 fclose(file);
      };
   };

   fprintf(error_log,"LinkErrors\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->LinkErrors();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("LinkErrors_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   if (SCHEDULE_HEURISTIC==0)
   {
      fprintf(error_log,"ScheduleUpwards\n");
      AllLexems->SetAllVisited(false);
      entry_lexem->ScheduleUpwards();
	  fprintf(error_log, "Exit ScheduleUpwards\n");
	  if (DEBUG_MODE)
      {
		 char *file_name;
		 FILE *file;
		 AllLexems->SetAllVisited(false);
		 file_name=catstr(catstr("ScheduleUpwards_",itoa(fsm)),".daVinci");
		 file=fopen(file_name,"w");
		 entry_lexem->DumpDaVinci(file);
		 fclose(file);
      };
      fprintf(error_log,"ScheduleDownwards\n");
      AllLexems->SetAllVisited(false);
      entry_lexem->ScheduleDownwards();
      if (DEBUG_MODE)
      {
	 char *file_name;
	 FILE *file;
	 AllLexems->SetAllVisited(false);
	 file_name=catstr(catstr("ScheduleDownwards_",itoa(fsm)),".daVinci");
	 file=fopen(file_name,"w");
	 entry_lexem->DumpDaVinci(file);
	 fclose(file);
      };
   };

   fprintf(error_log,"CreateHyperStates\n");
   AllLexems->SetAllVisited(false);
   entry_lexem->CreateHyperStates();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("CreateHyperStates_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"MergeHyperStates\n");
   AllLexems->SetAllVisited(false);
//   exit_lexem->MergeHyperStates();
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("MergeHyperStates_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };

   fprintf(error_log,"CheckConsistency\n");
   Stream()->ResetPos();
   AllLexems->SetAllVisited(false);
   entry_lexem->SetAllBitPos(0);
   //   entry_lexem->BitPos(-1);
   AllLexems->SetAllVisited(false);
   entry_lexem->CheckConsistency(fsm);

   fprintf(error_log,"MarkAllStates\n");
   AllLexems->SetAllVisited(false);
   exit_lexem->State(0);
   end_state=entry_lexem->MarkAllStates(0);
   if (DEBUG_MODE)
   {
      char *file_name;
      FILE *file;
      AllLexems->SetAllVisited(false);
      file_name=catstr(catstr("MarkAllStates_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };
   if (DUMP_FSM_DAG)
   {
      char *file_name;
      FILE *file;
      file_name=catstr(catstr("TransitionDiagram_",itoa(fsm)),".daVinci");
      file=fopen(file_name,"w");
      AllLexems->SetAllVisited(false);
      entry_lexem->DumpDaVinci(file);
      fclose(file);
   };
   AllLexems->SetAllVisited(false);
   return;
};

void start::write_architecture(FILE *file,int fsm)
{
   fprintf(file,"\nARCHITECTURE program OF %s_%d IS\n\n",Name(),fsm);
   write_signals(file,fsm);
   fprintf(file,"BEGIN\n");
   write_fsm(file,fsm);
   Fifos->write_vhdl(file,fsm);
   write_registers(file,fsm);
   fprintf(file,"END program;\n");
};

//extern int initialize_fsm(char *rule,int bit_pos);
void start::write_vhdl(FILE *file,int fsm)
{
   //int nr_of_states;
   // Get pointer to the Input Stream Grammar
   Stream()->CheckConsistency(fsm);
   bit_size=Stream()->BitSize();
   if (DEBUG_MODE)
   { 
      fprintf(error_log,"Building fsm %d\n",fsm);
   };
   build_fsm(fsm);
   if (DUMP_FSM_AS_DRIVER)
   {
      write_driver(file,fsm);
   }
   else
   {
     if (DUMP_FSM_AS_VERILOG)
     {
       //        write_module(file,fsm);
     }
     else
     {
        write_entity(file,fsm);
	write_architecture(file,fsm);
	fprintf(file,"\n");
     };
   };
};

void starts::write_script(FILE *file, char *vhdl_file_name)
{
   fprintf(file,"time\n");
   fprintf(file,"read -format vhdl {%s}\n",vhdl_file_name);
   fprintf(file,"write -format db -hierarchy -output \"%s.db\" %s\n",Entity_Name,Entity_Name);

   fprintf(file,"time\n");
   fprintf(file,"current_design %s\n",Entity_Name);
   fprintf(file,"create_clock -name \"clk\" -period \"%f\" -waveform {\"0\" \"%f\"} {\"clk\"}\n");
   fprintf(file,"compile -map_effort low\n");

   fprintf(file,"time\n");
   fprintf(file,"report_area > %s.out\n",Entity_Name);
   fprintf(file,"report_timing -path full -delay max -max_paths 1 -nworst 1 >> %s.out\n",Entity_Name);
   fprintf(file,"report_hierarchy >> %s.out\n",Entity_Name);
   fprintf(file,"report_reference >> %s.out\n",Entity_Name);
   fprintf(file,"current_design %s\n",Entity_Name);
   fprintf(file,"report_reference >> %s.out\n",Entity_Name);

   fprintf(file,"time\n");
   fprintf(file,"write -format db -hierarchy -output \"%s_opt.db\" %s\n",Entity_Name,Entity_Name);

   fprintf(file,"time\n");
   fprintf(file,"quit\n");
};

void starts::write_vhdl(FILE *file)
{
   int i;
   if (NrOfMembers()==0) 
   {
      fprintf(error_log,"\nError: No input streams specified\n");
   }
   else
   {
      if (Inputs!=NULL)
      {
	 for(i=0;i<Inputs->NrOfMembers();i++)
	 {
	    Inputs->Member(i)->InitFlags(NrOfMembers());
	 };
      };
      if (Internals!=NULL)
      {
	 for(i=0;i<Internals->NrOfMembers();i++)
	 {
	    Internals->Member(i)->InitFlags(NrOfMembers());
	 };
      };
      if (Outputs!=NULL)
      {
	 for(i=0;i<Outputs->NrOfMembers();i++)
	 {
	    Outputs->Member(i)->InitFlags(NrOfMembers());
	 };
      };
      if (Memories!=NULL)
      {
	 for(i=0;i<Memories->NrOfMembers();i++)
	 {
	    Memories->Member(i)->InitFlags(NrOfMembers());
	 };
      };
      for(i=0;i<NrOfMembers();i++)
      {
	 input *inp=Inputs->Member(Member(i)->ClockName());
	 if (inp==NULL)
	 {
	    internal *intern=Internals->Member(Member(i)->ClockName());
	    intern->IsClockIn(i,true);
	 }
	 else
	 {
	    inp->IsClockIn(i,true);
	 };
	 Member(i)->write_vhdl(file,i);
      };
   };
};

void starts::write_components(FILE *file)
{
   int i;
   if (NrOfMembers()==0) 
   {
      fprintf(error_log,"\nError: No input streams specified\n");
   }
   else
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_component(file,i);
      };
   };
};

void starts::write_portmaps(FILE *file)
{
   int i;
   if (NrOfMembers()==0) 
   {
      fprintf(error_log,"\nError: No input streams specified\n");
   }
   else
   {
      for (i=0;i<NrOfMembers();i++)
      {
	 Member(i)->write_portmap(file,i);
      };
   };
};

/**************************************************************************
*
* Methods for stream_item
*
**************************************************************************/
extern inputs *Inputs;
extern internals *Internals;
extern outputs *Outputs;

int STREAM_INP=0;
int STREAM_INTERN=1;
int STREAM_OUTP=2;
int input_stream::BitSize(void)
{
   if (bit_size==0)
   {
      int i,res;
      char *name;
      input *inp;
      internal *intern;
      output *outp;
      bool error;
      res=0;
      error=false;
      bit_sizes=(int *)malloc(sizeof(int)*NrOfMembers());
      for(i=0;i<NrOfMembers();i++)
      {
	 name=Member(i)->Name();
	 inp=Inputs->Member(name);
	 if (inp==NULL)
	 {
	    intern=Internals->Member(name);
	    if (intern==NULL)
	    {
	       outp=Outputs->Member(name);
	       if (outp==NULL)
	       {
		  fprintf(error_log,"The referenced input stream %s is not defined\n",name);
		  error=true;
	       }
	       else
	       {
		  bit_sizes[i]=outp->BitSize();
	       };
	    }
	    else
	    {
	       bit_sizes[i]=intern->BitSize();
	    };
	 }
	 else
	 {
	    bit_sizes[i]=inp->BitSize();
	 };
	 res=res+bit_sizes[i];
      };
      if (error)
      {
	 bit_size=0;
      }
      else
      {
	 bit_size=res;
      };
   };
   return bit_size;
};

input_stream *input_stream::Copy(void)
{
  return this; //Cheating a bit...
};

bool input_stream::Compare(input_stream *stream)
{
   int i;
   if (stream->NrOfMembers()!=NrOfMembers()) return false;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(stream->Member(i)->Name(),
		 Member(i)->Name())!=0)
      {
	 return false;
      };
   };
   return true;
};

char *input_stream::Name(void)
{
   char *tmp;
   int i;
   tmp=cpystr(Member(0)->Name());
   for(i=1;i<NrOfMembers();i++)
   {
      tmp=catstr(tmp,"_");
      tmp=catstr(tmp,Member(i)->Name());
   };
   return tmp;
};

void input_stream::CheckConsistency(int fsm)
{
   int i;
   char *name;
   input *inp;
   internal *intern;
   output *outp;
   for(i=0;i<NrOfMembers();i++)
   {
      name=Member(i)->Name();
      inp=Inputs->Member(name);
      if (inp==NULL)
      {
	 intern=Internals->Member(name);
	 if (intern==NULL)
	 {
	    outp=Outputs->Member(name);
	    if (outp==NULL)
	    {
	       fprintf(error_log,"The referenced input stream %s is not defined\n",name);
	       // (It might be a memory reference,
	       // this is not currently allowed)
	    }
	    else
	    {
	       Member(i)->Type(STREAM_OUTP);
	       outp->IsReadBy(fsm,true);
	    };
	 }
	 else
	 {
	    Member(i)->Type(STREAM_INTERN);
	    intern->IsReadBy(fsm,true);
	 };
      }
      else
      {
	 Member(i)->Type(STREAM_INP);
	 inp->IsReadBy(fsm,true);
      };
   };
};

void input_stream::write_driver(FILE *file,bool write_first_and,char *value,bool not_flag)
{
   int i,where;
   char *val;
   bool write_and;
   where=0;
   write_and=false;
   if (strlen(value)!=BitSize())
   {
      fprintf(error_log,"BUG %p::Stream has %d bits whereas the transition has %d bits\n",this,BitSize(),strlen(value));
      exit(1);
   };
   for(i=0;i<NrOfMembers();i++)
   {
      int bits_to_print;
      int nr_of_bits_to_print;
      int start_bit;
      val=midstr(value,where,BitSize(i));
      where=where+BitSize(i);
      bits_to_print=BitSize(i);
      start_bit=0;
      while(bits_to_print>0)
      {
	 char *print_value;
	 unsigned int j;
	 nr_of_bits_to_print=strlen(val)-start_bit;
	 for(j=start_bit;j<strlen(val)-1;j++)
	 {
	    if (val[j]!=val[j+1])
	    {
	       if ((val[j]==DONT_CARE_BIT) || 
		   (val[j]==OTHER_BIT) ||
		   (val[j+1]==DONT_CARE_BIT) ||
		   (val[j+1]==OTHER_BIT))
	       {
		  nr_of_bits_to_print=j+1;
		  break;
	       };
	    };
	 };
	 print_value=midstr(val,start_bit,nr_of_bits_to_print);
	 bits_to_print-=nr_of_bits_to_print;
	 start_bit+=nr_of_bits_to_print;
	 if ((print_value[0]!=DONT_CARE_BIT) &&
	     (print_value[0]!=OTHER_BIT))
	 {
	    if ((write_and) || (write_first_and))
	    {
	       if (not_flag)
	       {
		  fprintf(file," AND NOT\n                   ");
	       }
	       else
	       {
		  fprintf(file," AND\n                   ");
	       };
	    };
	    write_and=true;
	    fprintf(file,"(%s=\"%s\")",Member(i)->Name(),print_value);
	 };
      };
   };
};

extern bool printed_a_transition;
void input_stream::write_transition(FILE *file,int fsm,bool write_first_and,production_terminal *terminal)
{
   char *value=terminal->Value();
   bool not_flag=terminal->IsNegated();
   int i,where;
   char *val;
   bool write_and;
   where=0;
   write_and=false;
   if (strlen(value)!=BitSize())
   {
      fprintf(error_log,"BUG %p::Stream has %d bits whereas the transition has %d bits %s\n",this,BitSize(),strlen(value),value);
      exit(1);
   };
   for(i=0;i<NrOfMembers();i++)
   {
      int bits_to_print;
      //int nr_of_bits_to_print;
      int start_bit;
      val=midstr(value,where,BitSize(i));
      where=where+BitSize(i);
      bits_to_print=BitSize(i);
      start_bit=0;
      while(bits_to_print>0)
      {
	 char *print_value;
	 int skip_to=strlen(val);
	 // eat up white spaces (DONT_CARE_BITs and OTHER_BITs)
	 for(unsigned int j=start_bit;j<strlen(val);j++)
	 {
	    if (val[j]!=DONT_CARE_BIT)
	    {
	       if (val[j]!=OTHER_BIT)
	       {
		  skip_to=j;
		  break;
	       };
	    };
	 };
	 if (skip_to==BitSize(i))
	 {
	    bits_to_print=0;
	 }
	 else
	 {
	    if ((write_and) || (write_first_and))
	    {
	       if (not_flag)
	       {
		  fprintf(file," AND NOT\n                ");
	       }
	       else
	       {
		  fprintf(file," AND\n                ");
	       };
	    };
	    write_and=true;
	    if (printed_a_transition==false)
	    {
	       fprintf(file,"         IF (");
	    };
	    if (val[skip_to]=='S')
	    {
	       fprintf(file,"(%s(%d DOWNTO %d)=",
		       Member(i)->Name(),
		       BitSize(i)-skip_to-1,
		       BitSize(i)-skip_to-1);
	       terminal->Signal(skip_to)->PrintSignal(file,fsm,this,0);
	       fprintf(file,")");
	       bits_to_print--;
	       start_bit=skip_to+1;
	    }
	    else
	    {
	       start_bit=skip_to;
	       int end_bit=minimum(minimum(find(val,DONT_CARE_BIT,start_bit),
				   find(val,OTHER_BIT,start_bit)),
				   find(val,'S',start_bit));
	       print_value=midstr(val,start_bit,end_bit-start_bit);
	       fprintf(file,"(%s(%d DOWNTO %d)=std_logic_vector'(\"%s\"))",
		       Member(i)->Name(),
		       BitSize(i)-start_bit-1,
		       BitSize(i)-end_bit,
		       print_value);
	       bits_to_print-=end_bit;
	       start_bit=end_bit;
	       delete print_value;
	    };
	    printed_a_transition=true;
	 };
      };
      delete val;
   };
};

// Methods for lexem
lexem::~lexem()
{
   int m;
//   if (succs!=NULL) delete succs;
//   if (preds!=NULL) delete preds;
   m=AllLexems->Find(this);
   AllLexems->Replace(m,NULL);
   AllLexems->DelMember(m);
};

lexem *lexem::Copy()
{
   lexem *ret;
   if (IsTerminal())
   {
      ret=new lexem(Stream(),Terminal());
   }
   else if (IsInterrupt())
   {
      ret=new lexem(Interrupt());
   }
   else if (IsReset())
   {
      ret=new lexem(Reset());
   }
   else if (IsError())
   {
      ret=new lexem(Error());
   }
   else
   {
      ret=new lexem();
   }
   ret->AddActions(Actions()->Copy());
   return ret;
};

void lexem::AddCond(production_cond *s)
{
   if (conds==NULL)
   {
      conds=new production_conds(s);
   }
   else
   {
      conds->AddMember(s);
   };
};
void lexem::AddSucc(lexem *l)
{
   if (succs==NULL)
   {
      succs=new lexems(l);
   }
   else
   {
      succs->AddMember(l);
   };
};
void lexem::AddPred(lexem *l)
{
   if (preds==NULL)
   {
      preds=new lexems(l);
   }
   else
   {
      preds->AddMember(l);
   };
};

void lexem::AddAction(action *a)
{
   if (acts==NULL)
   {
      acts=new actions(a);
   }
   else
   {
      acts->AddMember(a);
   };
};

void lexem::AddActions(actions *a)
{
   int i;
   for(i=0;i<a->NrOfMembers();i++)
   {
      if (acts==NULL)
      {
	 acts=new actions(a->Member(i));
      }
      else
      {
	 acts->AddMember(a->Member(i));
      };
   };
};

void lexem::AddActSched(actions *a)
{
   if (a->Member(0)->IsVHDL())
   {
      act_scheds->AddMember(a);
   }
   else
   {
      actions *found=act_scheds->Member(a->Member(0)->Target());
      if (found==NULL)
      {
	 act_scheds->AddMember(a);
      }
      else
      {
	 found->AddMembers(a);
      };
   };
};

void lexem::AddActScheds(action_schedule *a)
{
   int i;
   for(i=0;i<a->NrOfMembers();i++)
   {
      actions *as=a->Member(i);
      if (as->Member(0)->IsVHDL())
      {
	 act_scheds->AddMember(as);
      }
      else
      {
	 actions *found=act_scheds->Member(as->Member(0)->Target());
	 if (found==NULL)
	 {
	    act_scheds->AddMember(as);
	 }
	 else
	 {
	    found->AddMembers(as);
	 };
      };
   };
};

int lexem::BitSize(void)
{
   if (IsTerminal())
   {
      return lexeme.terminal->NrOfBits();
   }
   else
   {
      return 0;
   };
};

void lexems::SetAllVisited(bool flag)
{
   int j;
   for(j=0;j<NrOfMembers();j++)
   {
     //    fprintf(error_log,"Member %d %08x\n",j,Member(j));
      if (Member(j)!=NULL) Member(j)->Visited(flag);
	  if (Member(j) == NULL) NrOfRemainingNulls++;
   };
};

bool lexem::ReduceExits(void)
{
   int i,j,m;
   //lexem *succ,*pred;
   if (Visited())
   {
      // This node has already been checked
      return false;
   };
   Visited(true);
   // The last state must be an EXIT state
   if (NrOfSuccs()==0)
   {
      return false;
   };
//   if (IsLoop())
//   {
//      return false;
//   };
   Succs()->ReduceExits();
   if (NrOfInterrupts()>0)
   {
      Interrupts()->ReduceExits();
   };
   if (IsExit())
   {
      if (NrOfPreds()==0)
      {
	 // first entry_lexem
	 return false;
      };
      if (NrOfSuccs()==0)
      {
	 // last exit_lexem
	 return false;
      };
      // Copy Right Assoc Conditions to successor terminals
      for(i=0;i<NrOfConds();i++)
      {
	 // entry_lexem may have conds attached
	 if (!Cond(i)->LeftAssoc())
	 {
	    for(j=0;j<NrOfSuccs();j++)
	    {
	       if ((!Succ(j)->IsInterrupt()) && (!Succ(j)->IsReset()))
	       {
		  Succ(j)->AddCond(Cond(i)->Copy());
	       };
	    };
	 };
      };
      for (i=0;i<NrOfPreds();i++)
      {
	 // Find the pointer of the predecessors that points to this state
	 m=Pred(i)->Succs()->Find(this);
	 Pred(i)->Succs()->Replace(m,NULL);
	 Pred(i)->Succs()->DelMember(m);
	 for(j=0;j<NrOfSuccs();j++)
	 {
	    if (!Pred(i)->Succs()->IsMember(Succ(j)))
	    {
	       Pred(i)->AddSucc(Succ(j));
	    };
	 };
	 // Copy Left Assoc Conditions to predecessors
	 for(j=0;j<NrOfConds();j++)
	 {
	    // exit_lexem may have conds attached
	    if (Cond(j)->LeftAssoc())
	    {
	       if ((!Pred(i)->IsInterrupt()) && (!Pred(i)->IsReset()))
	       {
		  Pred(i)->AddCond(Cond(j)->Copy());
	       };
	    };
	 };
	 // Copy the actions to the predecessors
	 Pred(i)->AddActions(Actions());
	 // Set Loop flag in predecessors if set here
	 if (IsLoop()) Pred(i)->IsLoop(true);
      };
      for(i=0;i<NrOfSuccs();i++)
      {
	 // Find the pointer of the successors that points to this state
	 m=Succ(i)->Preds()->Find(this);
	 Succ(i)->Preds()->Replace(m,NULL);
	 Succ(i)->Preds()->DelMember(m);
	 for(j=0;j<NrOfPreds();j++)
	 {
	    if (!Succ(i)->Preds()->IsMember(Pred(j)))
	    {
	       Succ(i)->AddPred(Pred(j));
	    };
	 }
      };
      // Disconnect this node
      for(i=0;i<NrOfConds();i++)
      {
	 Conds()->Replace(i,NULL);
      };
      for(i=0;i<NrOfActions();i++)
      {
	 Actions()->Replace(i,NULL);
      };
      for(i=0;i<NrOfPreds();i++)
      {
	 Preds()->Replace(i,NULL);
      };
      for(i=0;i<NrOfSuccs();i++)
      {
	 Succs()->Replace(i,NULL);
      };
      return true;
   };
   return false;
};

void lexems::ReduceExits(void)
{
   int i;
   lexem *succ;
   for (i=NrOfMembers()-1;i>=0;i--)
   {
      succ=Member(i);
      if (succ!=NULL)
      {
	 if (succ->ReduceExits())
	 {
	    // The successor was an Exit and was reduced
	    // Added successors have already been visited
	    // The successor has already been disconnected
	    delete succ;
	 };
      };
   };
};

void lexem::ReduceGrammar(void)
{
   //int i,j,k,m,succ1_succs;
   //lexem *succ1,*succ2,*succ2_ptr;

   if (Visited()) return;
   Visited(true);
   if (NrOfSuccs()==0)
   {
      return;
   };
//   if (IsLoop())
//   {
//      return;
//   };
   if (NrOfSuccs()==1)
   {
      Succ(0)->ReduceGrammar();
   }
   else
   {
      for(int i=0;i<NrOfSuccs()-1;i++)
      {
	 for(int j=i+1;j<NrOfSuccs();)
	 {
	    if (CompareSuccs(i,j))
	    {
	       // The two successor(s) are identical
	       MergeSuccs(i,j);
	    }
            else
            {
	       j++;
	    };
	 };
      };
      Succs()->RemoveNullPointers();
      for (int i=0;i<NrOfSuccs();i++)
      {
	 Succ(i)->ReduceGrammar();
      };
   };
};

bool lexem::CompareSuccs(int i,int j)
{
   lexem *succ1,*succ2;
   //int k;

   succ1=Succ(i);
   if (succ1==NULL) return false;
   succ2=Succ(j);
   if (succ2==NULL) return false;
   if (succ1==succ2) return true;
   if ((succ1->Type()==succ2->Type()) && 
       (strcmp(succ1->Value(),succ2->Value())==0) &&
       (succ1->IsNegated()==succ2->IsNegated()) &&
       (succ1->Conds()->Compare(succ2->Conds())))
   {
      if (!succ1->Actions()->Compare(succ2->Actions()))
      {
	 fprintf(error_log,"Error: Reduce conflict in Grammar DAG\n");
	 fprintf(error_log,"       Actions do not match\n");
	 fprintf(error_log,"       Rule: %s and: %s\n",succ1->Rule(),succ2->Rule());
	 exit(1);
      };
      return true;
   };
   return false;
};

void lexem::MergeSuccs(int i, int j)
{
   lexem *succ1,*succ2,*new_lexem;
   //int k,l,m;
   bool split,identical_loops;
   succ1=Succ(i);
   succ2=Succ(j);
   if (succ1==succ2)
   {
      fprintf(error_log,"!!! BUG: IDENTICAL SUCCESSORS !!!\n");
      DumpNode(error_log);
      exit(1);
   };
   split=false;
   identical_loops=false;
   if ((succ1->IsLoop()) && (succ2->IsLoop()))
   {
      identical_loops=true;
   };
   if (!identical_loops)
   {
      new_lexem=succ1->Copy();
      new_lexem->AddPred(this);
      Succs()->Replace(i,new_lexem);
      Succs()->Replace(j,NULL);
      int m=succ1->Preds()->Find(this);
      succ1->Preds()->Replace(m,NULL);
      succ1->Preds()->DelMember(m);
      m=succ2->Preds()->Find(this);
      succ2->Preds()->Replace(m,NULL);
      succ2->Preds()->DelMember(m);
      for(int k=0;k<succ2->NrOfPreds();k++)
      {
	 if (!(succ1->Preds()->IsMember(succ2->Pred(k))))
	 {
	    // if Pred(k) of succ2 is not also a predecessor of succ1 then
	    // then succ2 must be split
	       split=true;
	 }
	 else
	 {
	    //int m;
	    // Pred k of succ2 is also a predecessor of succ1
	    // Since the two successors are to be merged,
	    // the reference to succ2 must therefore be deleted
	    // to avoid references to a NULL node
	    succ2->MovePred(k,new_lexem);
	 };
      };
      for(int k=0;k<succ1->NrOfPreds();k++)
      {
	 if (!(new_lexem->Preds()->IsMember(succ1->Pred(k))))
	 {
	    // if Pred(k) of succ1 was not a predecessor of succ2 then
	    // then succ1 must be split
	       split=true;
	 }
	 else
	 {
	    int m;
	    // Pred k of succ1 was also a predecessor of succ2
	    // Since the two successors are to be merged,
	    // the reference to succ1 must therefore be deleted
	    // to avoid references to a NULL node
	    m=succ1->Pred(k)->Succs()->Find(succ1);
	    succ1->Pred(k)->Succs()->Replace(m,NULL);
	    succ1->Pred(k)->Succs()->DelMember(m);
	    succ1->Preds()->Replace(k,NULL);
	 };
      };
      if (!split)
      {
	 for(int k=0;k<succ1->NrOfSuccs();k++)
	 {
	    // Move all successors of succ1
	    succ1->MoveSucc(k,new_lexem);
	 };
	 for(int k=0;k<succ2->NrOfSuccs();k++)
	 {
	    // if Succ(k) of succ2 is not a successor of new_lexem then
	    // it must be moved
	    if (!new_lexem->Succs()->IsMember(succ2->Succ(k)))
	    {
	       succ2->MoveSucc(k,new_lexem);
	    }
	    else
	    {
	       succ2->Succs()->Replace(k,NULL);
	    };
	 };
	 delete succ1;
	 delete succ2;
      }
      else
      {
	 for(int k=0;k<succ1->NrOfSuccs();k++)
	 {
	    // Copy all successors of succ1
	    succ1->CopySucc(k,new_lexem);
	 };
	 for(int k=0;k<succ2->NrOfSuccs();k++)
	 {
	    // if Succ(k) of succ2 is not a successor of new_lexem then
	    // it must be copied
	    if (!new_lexem->Succs()->IsMember(succ2->Succ(k)))
	    {
	       succ2->CopySucc(k,new_lexem);
	    };
	 };
	 succ2->Preds()->RemoveNullPointers();
	 succ1->Preds()->RemoveNullPointers();
      };
   }
   else
   {
      lexem *loop1,*loop2;
      for(int k=0;k<succ1->NrOfSuccs();k++)
      {
	 if (succ1->Succ(k)->IsLoopEntry())
	 {
	    loop1=succ1->Succ(k);
	    break;
	 };
      };
      for(int k=0;k<succ2->NrOfSuccs();k++)
      {
	 if (succ2->Succ(k)->IsLoopEntry())
	 {
	    loop2=succ2->Succ(k);
	    break;
	 };
      };
      if ((loop1->NrOfPreds()==1) && (loop2->NrOfPreds()==1))
      {
	 lexem *loop1_ptr,*loop2_ptr;
	 int depth1, depth2;
	 // Check Loop Equivalence
	 loop1_ptr=loop1;
	 depth1=1;
	 while(loop1_ptr!=succ1)
	 {
	    if (loop1_ptr->NrOfSuccs()!=1)
	    {
	       fprintf(error_log,"Error: Cannot Merge Multiple Path Loops (YET)\n");
	       exit(1);
	    };
	    loop1_ptr=loop1_ptr->Succ(0);
	    depth1++;
	 };
	 loop2_ptr=loop2;
	 depth2=1;
	 while(loop2_ptr!=succ2)
	 {
	    if (loop2_ptr->NrOfSuccs()!=1)
	    {
	       fprintf(error_log,"Error: Cannot Merge Multiple Path Loops (YET)\n");
	       exit(1);
	    };
	    loop2_ptr=loop2_ptr->Succ(0);
	    depth2++;
	 };
	 if (depth1!=depth2)
	 {
	    fprintf(error_log,"Error: Loop 1 has %d nodes and Loop 2 has %d nodes\n",depth1,depth2);
	    fprintf(error_log,"       Cannot merge identical transitions in loops of different lengths (YET)\n");
	    fprintf(error_log,"       Rule: %s and: %s\n",succ1->Rule(),succ2->Rule());
	    exit(1);
	 };
      }
      else
      {
	 if ((loop1!=succ1) || (loop2!=succ2))
	 {
	    loop1->DumpNode(error_log);
	    loop2->DumpNode(error_log);
	    fprintf(error_log,"Error: Cannot Merge Multiple Inner Loops (YET)\n");
	    exit(1);
	 };
      };
      // Disconnect the second loop
      for(int k=0;k<succ2->NrOfSuccs();k++)
      {
	 if (succ2->Succ(k)!=loop2)
	 {
	    succ2->MoveSucc(k,succ1);
	 };
      };
      Succs()->Replace(j,NULL);
      int m=succ2->Preds()->Find(this);
      succ2->Preds()->Replace(m,NULL);
      succ2->Preds()->DelMember(m);
   };
   // The actions are identical and should NOT be moved
};

void lexem::MovePred(int i,lexem *l)
{
   int m;
   l->AddPred(Pred(i));
   m=Pred(i)->Succs()->Find(this);
   Pred(i)->Succs()->Replace(m,l);
   Preds()->Replace(i,NULL);
};

void lexem::MoveSucc(int i,lexem *l)
{
   int m;
   // Move successor i from this lexem to lexem l
   l->AddSucc(Succ(i));
   m=Succ(i)->Preds()->Find(this);
   Succ(i)->Preds()->Replace(m,l);
   Succs()->Replace(i,NULL);
};

void lexem::MoveInterrupts(lexem *l)
{
   l->Interrupts(Interrupts());
   Interrupts(NULL);
};

void lexem::MoveSuccs(lexem *l)
{
   int i;
   for(i=0;i<NrOfSuccs();i++)
   {
      MoveSucc(i,l);
   };
   for(i=NrOfSuccs()-1;i>=0;i--)
   {
      DelSucc(i);
   };
};

void lexem::CopySucc(int i,lexem *l)
{
   //int m;
   // Copy successor i from this lexem to lexem l
   l->AddSucc(Succ(i));
   Succ(i)->AddPred(l);
};

void lexem::CopySuccs(lexem *l)
{
   int i;
   for(i=0;i<NrOfSuccs();i++)
   {
      CopySucc(i,l);
   };
};

void lexem::CopyCond(int i,lexem *l)
{
    // Move cond i from this lexem to lexem l
    l->AddCond(Cond(i)->Copy());
};

void lexem::MoveCond(int i,lexem *l)
{
    // Move cond i from this lexem to lexem l
    l->AddCond(Cond(i));
    Conds()->Replace(i,NULL);
};

void lexem::CopyAllConds(lexem *l)
{
   for(int i=0;i<NrOfConds();i++)
   {
      CopyCond(i,l);
   };
};

void lexem::MoveAllConds(lexem *l)
{
   for(int i=0;i<NrOfConds();i++)
   {
      MoveCond(i,l);
   };
   for(int i=NrOfConds()-1;i>=0;i--)
   {
      DelCond(i);
   };
};

void lexem::MoveLeftConds(lexem *l)
{
   for(int i=0;i<NrOfConds();i++)
   {
      if (Cond(i)!=NULL)
      {
         if (Cond(i)->LeftAssoc())
	 {
	    MoveCond(i,l);
	 }; 
      };
   };
   for(int i=NrOfConds()-1;i>=0;i--)
   {
     if (Cond(i)==NULL)
     {
       DelCond(i);
     };
   };
};

void lexem::MoveRightConds(lexem *l)
{
   for(int i=0;i<NrOfConds();i++)
   {
      if (Cond(i)!=NULL)
      {
	 if (!Cond(i)->LeftAssoc())
	 {
	    MoveCond(i,l);
	 };
      };
   };
   for(int i=NrOfConds()-1;i>=0;i--)
   {
     if (Cond(i)==NULL)
     {
       DelCond(i);
     };
   };
};

void lexem::CopyAction(int i,lexem *l)
{
   // Copy action i from this lexem to lexem l
   l->AddAction(Action(i)->Copy());
};

void lexem::MoveAction(int i,lexem *l)
{
   // Move action i from this lexem to lexem l
   l->AddAction(Action(i));
   Actions()->Replace(i,NULL);
};

void lexem::CopyActions(lexem *l)
{
   int i;
   for(i=0;i<NrOfActions();i++)
   {
      CopyAction(i,l);
   };
};

void lexem::MoveActions(lexem *l)
{
   int i;
   for(i=0;i<NrOfActions();i++)
   {
      MoveAction(i,l);
   };
   for(i=NrOfActions()-1;i>=0;i--)
   {
      DelAction(i);
   };
};

void lexem::AddInterrupts(lexems *l)
{
   int i;
   for(i=0;i<l->NrOfMembers();i++)
   {
      int j;
      lexem *new_lexem;
      new_lexem=new lexem(l->Member(i)->Interrupt());
      Interrupts()->AddMember(new_lexem);
      for(j=0;j<l->Member(i)->NrOfSuccs();j++)
      {
	 l->Member(i)->Succ(j)->AddPred(new_lexem);
	 new_lexem->AddSucc(l->Member(i)->Succ(j));
      };
   };
};

lexem *lexem::AtomizeTerminals(void)
{
   // If it is not a terminal it is the exit_lexem or an Interrupt
   if (Visited()) return NULL;
   if (IsTerminal())
   {
      //int nr_of_bits;
      lexem *next_lexem,*first_lexem,*prev_lexem;
	  // fprintf(error_log, "%08x:Rule %s %d bits\n", this, Rule(), BitSize());
	  sprintf(log_str, "%08x:Rule %s %d bits\n", this, Rule(), BitSize());
	  log(log_str);
      for(int i=0;i<BitSize();i++)
      {
		  char *new_value;
		  action_signals *list_of_signals=new action_signals();
		  if (Terminal()->IsSignal())
		  {  
			  new_value=cpystr("S");
			  action_signal *new_signal=Terminal()->Signal()->Copy();
			  int left=new_signal->Range()->Left();
			  new_signal->Range()->Left(left-i);
			  new_signal->Range()->Right(left-i);
			  list_of_signals->AddMember(new_signal);
		  }
		  else
		  {
			  new_value=midstr(Value(),i,1);
			  list_of_signals->AddMember(NULL);
		  };
		  production_terminal *new_terminal=new production_terminal(new_value,IsNegated());
		  new_terminal->ListOfSignals(list_of_signals);
		  next_lexem=new lexem(Stream(),new_terminal);
		  next_lexem->Rule(Rule());
		  next_lexem->Visited(true);
		  //	 fprintf(error_log,"Created %d at %08x\n",i,new_terminal);
		  if (i==0) 
		  {
			  first_lexem=next_lexem;
		  }
		  else
		  {
			  prev_lexem->AddSucc(next_lexem);
			  next_lexem->AddPred(prev_lexem);
			  sprintf(log_str, "   %d %08x->%08x (%d)\n", i, prev_lexem, next_lexem, prev_lexem->NrOfSuccs());
			  log(log_str);
		  };
		  prev_lexem=next_lexem;
	  };
	  first_lexem->IsLoopEntry(IsLoopEntry());
      next_lexem->IsLoop(IsLoop());
	  sprintf(log_str, "   Entry %08x Exit %08x\n", first_lexem, next_lexem);
	  log(log_str);
      MoveActions(next_lexem);
      MoveLeftConds(next_lexem);
      MoveRightConds(first_lexem);
      for(int i=0;i<NrOfPreds();i++)
      {
		  MovePred(i,first_lexem);
      };
      MoveSuccs(next_lexem);
      if (IsLoop()) return this;
      for(int i=0;i<NrOfInterrupts();i++)
      {
		  Interrupts()->Member(i)->AtomizeTerminals();
      };
      MoveInterrupts(next_lexem);
      for(int i=0;i<next_lexem->NrOfSuccs();i++)
      {
		  lexem *old_terminal=next_lexem->Succ(i)->AtomizeTerminals();
		  if (old_terminal!=NULL)
		  {
			  if (old_terminal->IsTerminal()) delete old_terminal;
		  };
      };
   }
   else // not terminal
   {
      if (IsLoop()) return this;
      for(int i=0;i<NrOfInterrupts();i++)
      {
		  Interrupts()->Member(i)->AtomizeTerminals();
      };
      for(int i=0;i<NrOfSuccs();i++)
      {
		  lexem *old_terminal=Succ(i)->AtomizeTerminals();
		  if (old_terminal!=NULL)
		  {
			  if (old_terminal->IsTerminal()) delete old_terminal;
		  };
      };
   };
   return this;
}

void lexem::WordAlignTerminals(int bit_pos)
{
   int i;
   // If it is not a terminal it is the exit_lexem or an Interrupt
   if (IsTerminal())
   {
      int nr_of_bits,bit_width,byte_offset,bits2copy,input_stream_width;
      lexem *next_lexem;

      nr_of_bits=BitSize();
      input_stream_width=Stream()->BitSize();
      // fprintf(error_log,"Rule %s - %d\n",Rule(),nr_of_bits);
      if (nr_of_bits<input_stream_width)
      {
	 if (!IsLoop())
	{
	    for(i=0;i<NrOfSuccs();i++)
	    {
	       if ((Succ(i)->IsTerminal()) &&
		   (Succ(i)->Stream()==Stream()))
	       {
		  char *new_value;
		  //int where,j;
		  new_value=catstr(Value(),Succ(i)->Value());
		  production_terminal *new_terminal=new production_terminal(new_value,IsNegated());
		  new_terminal->ListOfSignals(new action_signals());
		  for(int j=0;j<ListOfSignals()->NrOfMembers();j++)
		  {
		    if (Signal(j)==NULL)
		    {
		       new_terminal->ListOfSignals()->AddMember(NULL);
		    }
		    else
		    {
		      new_terminal->ListOfSignals()->AddMember(Signal(j)->Copy());
		    };
		  };
		  if (Succ(i)->Signal(0)==NULL)
		  {
		     new_terminal->ListOfSignals()->AddMember(NULL);
		  }
		  else
		  {
		     new_terminal->ListOfSignals()->AddMember(Succ(i)->Signal(0)->Copy());
		  };
		  next_lexem=new lexem(Stream(),new_terminal);
		  next_lexem->Rule(Rule());
//		  next_lexem->Visited(false);
		  MoveActions(next_lexem);
		  MoveAllConds(next_lexem);
		  // The successor may have multiple predecessors
		  if (Succ(i)->NrOfPreds()>1)
		  {
		     Succ(i)->CopyActions(next_lexem);
		     Succ(i)->CopyAllConds(next_lexem);
		     Succ(i)->CopySuccs(next_lexem);
		     int m=Succ(i)->Preds()->Find(this);
		     Succ(i)->Preds()->Replace(m,NULL);
		     Succ(i)->Preds()->DelMember(m);
		  }
		  else
		  {
		     Succ(i)->MoveActions(next_lexem);
		     Succ(i)->MoveSuccs(next_lexem);
		     Succ(i)->MoveAllConds(next_lexem);
		  };
		  if (Succ(i)->IsLoop())
		  {
		     next_lexem->IsLoop(true);
		  };
		  for(int j=0;j<NrOfPreds();j++)
		  {
		     int m;
		     next_lexem->AddPred(Pred(j));
		     if (i==0)
		     {
		        m=Pred(j)->Succs()->Find(this);
			Pred(j)->Succs()->Replace(m,next_lexem);
		     }
		     else
		     {
		        Pred(j)->AddSucc(next_lexem);
		     };
		  };
	       }
	       else if (Succ(i)->IsError())
	       {
		  fprintf(error_log,
			  "Attempting to merge Terminal %s Rule %s with an Error statement\n",
			  Value(),Rule());
		  exit(1);
	       }
	       else if (Succ(i)->IsExit())
	       {
		  fprintf(error_log,
			  "Error: Not Enough Bits in Description - Terminal %s Rule %s cannot be merged with the Exit node\n",
			  Value(),Rule());
		  exit(1);
	       }
	       else
	       {
		  fprintf(error_log,"Impossible to merge Terminals Over Stream Boundaries\n");
		  fprintf(error_log,
			  "   Stream %s Rule %s, Stream %s Rule %s\n",
			  Stream()->Name(),Rule(),
			  Succ(i)->Stream()->Name(),Succ(i)->Rule());
		  exit(1);
	       };
	       next_lexem->WordAlignTerminals(bit_pos);
	    };
	    return;
	}
	else
	{
	   fprintf(error_log,"Impossible to merge Terminals over Loop Boundaries\n");
	   fprintf(error_log,
		   "   Stream %s Rule %s, Stream %s Rule %s\n",
		   Stream()->Name(),Rule(),
		   Succ(0)->Stream()->Name(),Succ(0)->Rule());
	   exit(1);
	};
      }
      else
      {
	 byte_offset=bit_pos % input_stream_width;
	 bits2copy=input_stream_width-byte_offset;
	 if (nr_of_bits>bits2copy)
	 {
	    bit_width=nr_of_bits-bits2copy;
	    next_lexem=new lexem(Stream(),new production_terminal(midstr(Value(),bits2copy,bit_width),IsNegated()));
	    next_lexem->Rule(Rule());
	    Value(midstr(Value(),0,bits2copy));
	    MoveSuccs(next_lexem);
	    next_lexem->AddInterrupts(Interrupts());
	    MoveActions(next_lexem);
	    next_lexem->AddPred(this);
	    if (IsLoop())
	    {
	       next_lexem->IsLoop(true);
	       IsLoop(false);
	    };
	    AddSucc(next_lexem);
	 };
      };
   };
//   if (Visited()) return;
//   Visited(true);
   if (IsLoop()) return;
   for(i=0;i<NrOfSuccs();i++)
   {
      int next_pos;
      if (Succ(i)->Stream()!=Stream())
      {
	 next_pos=0;
      }
      else
      {
	 next_pos=bit_pos+BitSize();
      };
      Succ(i)->WordAlignTerminals(next_pos);
   };
   for(i=0;i<NrOfInterrupts();i++)
   {
      Interrupts()->Member(i)->WordAlignTerminals(0);
   };
};

void lexem::WordAlignActions(void)
{
   int i;
   if (Visited()) return;
   Visited(true);
   //fprintf(error_log,"Node %08x of Type %d\n",this,Type());
   for(i=0;i<NrOfActions();i++)
   {
      action_schedule *tmp;
      tmp=Action(i)->WordAlignAction();
      //      fprintf(error_log,"Word Aligned Schedule at %08x with %d member(s) added to %08x\n",tmp,tmp->NrOfMembers(),act_scheds);
      act_scheds->AddMembers(tmp);
   };
//   if (IsLoop()) return;
   for(i=0;i<NrOfSuccs();i++)
   {
      if (!Succ(i)->IsExit())
      {
	 Succ(i)->WordAlignActions();
      };
   };
};

void lexem::write_driver(FILE *file,int fsm,int bit_pos)
{
   int i;
   if (Visited()) return;
   Visited(true);
   if (Succ(0)->IsExit()) return;
   fprintf(file,"      state S%d {\n",State());
   fprintf(file,"         transitions {\n");
   for(i=0;i<NrOfSuccs();i++)
   {
      if (Succ(i)->State()==0)
      {
	 fprintf(file,"            => exit ");
      }
      else
      {
	 fprintf(file,"            => S%d ");
      };
      if (Succ(i)->IsError())
      {
	 fprintf(file," default");
      }
      else if (Succ(i)->IsTerminal())
      {
	 fprintf(file,"(");
	 Succ(i)->Conds()->write_driver(file,fsm,stream,bit_pos+Succ(i)->BitSize());
	 if ((nr_of_states>1) || (Succ(i)->NrOfConds()>0))
	 {
	    Succ(i)->Stream()->write_driver(file,true,Succ(i)->Value(),Succ(i)->IsNegated());
	 }
	 else
	 {
	    Succ(i)->Stream()->write_driver(file,false,Succ(i)->Value(),Succ(i)->IsNegated());
	 };
	 fprintf(file,")");
      };
      if (Succ(i)->NrOfActScheds()>0)
      {
	 fprintf(file,"\n               code VHDL {\n");
	 Succ(i)->ActScheds()->write_driver(file,fsm,stream,bit_pos+Succ(i)->BitSize());
	 fprintf(file,"               };\n");
      }
      else
      {
	 fprintf(file,";\n");
      };
   };
   fprintf(file,"         }\n");
   fprintf(file,"      }\n");
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->write_driver(file,fsm,bit_pos+Succ(i)->BitSize());
   };
};

void lexem::PrintTransition(FILE *file,char *stream,int stream_width)
{
   if (Visited()) return;
   Visited(true);

   int sync_pos,bit_start,bit_stop;
   sync_pos=(BitPos()+BitSize()) / stream_width-1;
   bit_start=(BitPos()+BitSize()) % stream_width;
   bit_stop=bit_start+BitSize()-1;
   fprintf(file,"                   (%s_sync_fsm(%d)='1') AND\n",stream,sync_pos);
   if (IsNegated())
   {
      fprintf(file,"                   NOT(%s_sync_dp(0)(%d downto %d)=\"%s\"))\n",stream,bit_stop,bit_start,Value());
   }
   else
   {
      fprintf(file,"                   (%s_sync_dp(0)(%d downto %d)=\"%s\")) THEN\n",stream,bit_stop,bit_start,Value());
   };
   fprintf(file,"                   -- bitpos %d\n",BitPos());
};

int lexem::MarkAllStates(int next_state)
{
   int i,this_state;

   // If the Successor has already been visited by the StateMarker then
   // it has already got a state assigned to it.
   if (Visited()) return next_state;
   Visited(true);
   if (NrOfSuccs()==0) return next_state; // bugfix cause unknown
   if (Succ(0)->Visited()) return next_state;

   // If the State has already been set by the StateMarker then all its
   // Successors' States has also been set
   //   if (HyperState()->IsMarked()) return next_state;
   if (Succ(0)->IsExit())
   {
      State(0);
      return next_state;
   }
   State(next_state);
   // Mark successor states
   this_state=next_state+1;
   for(i=0;i<NrOfSuccs();i++)
   {
      this_state=Succ(i)->MarkAllStates(this_state);
   };
   return this_state;
};
//**************************************************************************
//*
//* Copy methods
//*
//**************************************************************************

cdfg_constant *cdfg_constant::Copy()
{
   if (IsNumeric())
   {
      return new cdfg_constant(Number());
   }
   else
   {
      return new cdfg_constant(C_Number());
   };
};

cdfg_signal *cdfg_signal::Copy(void)
{ 
   cdfg_signal *ret;
   if (Range()==NULL)
   {
      ret=new cdfg_signal(Name());
   }
   else
   {
      ret=new cdfg_signal(Name(),Range()->Copy());
   };
   ret->BitSize(BitSize());
   ret->IsMemory(IsMemory());
   ret->IsOutput(IsOutput());
   ret->IsInput(IsInput());
   ret->IsInternal(IsInternal());
   ret->Address(Address()->Copy());
   return ret;
};

action_arguments *action_arguments::Copy(void)
{
   action_arguments *ret=new action_arguments();
   for(int i=0;i<NrOfMembers();i++)
   {
      ret->AddMember(Member(i)->Copy());
   };
   return ret;
};
mux_and *mux_and::Copy(void)
{ 
   return new mux_and(Left()->Copy(),Right()->Copy()); 
};

mux_condition *mux_condition::Copy(void)
{
   if (IsSignal())
   {
      return new mux_condition(Signal()->Copy(),Condition(),Signal2()->Copy());
   }
   else
   {
      return new mux_condition(Signal()->Copy(),Condition(),Value());
   };
};

mux_expression *mux_expression::Copy(void)
{
   if (IsAnd())
   {
      return new mux_expression(And()->Copy());
   }
   else
   {
      return new mux_expression(Condition()->Copy());
   };
};

action_variable *action_variable::Copy(void)
{
   action_variable *ret;
   sprintf(log_str,"%s::%08x %08x %s\n",Name(),Name(),FifoName(),FifoName());
   log(log_str);
   ret=new action_variable(Name());
   ret->FifoName(FifoName());
   ret->InputStreamWidth(InputStreamWidth());
   ret->SetBitPos(BitPos());
   ret->ProdPos(ProdPos());
   ret->ProdSize(ProdSize());
   ret->FirstBit(FirstBit());
   ret->LastBit(LastBit());
   ret->RefPos(RefPos());
   ret->Range(Range());
   log("ACTION_VARIABLE::COPY()\n");
   return ret;
};

action_mux *action_mux::Copy(void)
{
  return new action_mux(Expression()->Copy(),
			TrueBranch()->Copy(),
			FalseBranch()->Copy());
};

action_address *action_address::Copy(void)
{
   action_address *ret;
   if (IsVoid()) ret=new action_address();
   if (IsSignal()) ret=new action_address(Signal()->Copy());
   if (IsVariable()) ret=new action_address(Variable()->Copy());
   if (IsConstant()) ret=new action_address(Constant()->Copy());
   if (HasRange()) 
   {
      ret->Range(Range()->Copy());
   };
   return ret;
};

action_signal *action_signal::Copy(void)
{
   action_signal *ret;
   /*
   if (Range()==NULL)
   {
      ret=new action_signal(Name(),BitSize(),PortNumber(),AddressSize(),NULL,Negate());
   }
   else
   {
      ret=new action_signal(Name(),BitSize(),PortNumber(),AddressSize(),Range()->Copy(),Negate());
   };
   */
   ret=new action_signal(Name(),BitSize(),PortNumber(),AddressSize(),Negate());
   ret->IsMemory(IsMemory());
   ret->IsOutput(IsOutput());
   ret->IsInput(IsInput());
   ret->IsInternal(IsInternal());
   ret->Address(Address()->Copy());
   ret->ArraySize(ArraySize());
   return ret;
};

action_cdfg *action_cdfg::Copy(void)
{
   action_cdfg *ret;
   if (IsFunction())
   {
      ret=new action_cdfg(Function(),Arguments()->Copy());
   }
   else if (IsConstant())
   {
      ret=new action_cdfg(Constant()->Copy());
   }
   else if (IsVariable())
   {
      ret=new action_cdfg(Variable()->Copy());
   }
   else if (IsSignal())
   {
      ret=new action_cdfg(Signal()->Copy());
   };
   ret->BitRange(BitRange());
   return ret;
};

action_item *action_item::Copy(void)
{
//sprintf(log_str,"%08x %d\n",this,Type());
//log(log_str);
  if (IsMacro())
  {
     return new action_item(Macro()->Copy());
  }
  else if (IsVariable())
  {
     return new action_item(Variable()->Copy());
  }
  else if (IsConstant())
  {
     return new action_item(Constant()->Copy());
  }
  else if (IsMux())
  {
     return new action_item(Mux()->Copy());
  }
  else if (IsSignal())
  {
     return new action_item(Signal()->Copy());
  }
  else if (IsCDFG())
  {
     return new action_item(CDFG()->Copy());
  };
  sprintf(log_str,"BUG!!! action_item::Copy() - Non existing action_item %d\n",Type());
  log(log_str);
  exit(1);
};

action_line *action_line::Copy(void)
{
   action_line *ret;
   ret=new action_line();
   for(int i=0;i<NrOfMembers();i++)
   {
      ret->AddMember(Member(i)->Copy());
   };
   ret->BitSize(BitSize());
   return ret;
};

action_muxed_line *action_muxed_line::Copy(void)
{
  return new action_muxed_line(Expression()->Copy(),
			       TrueBranch()->Copy(),
			       FalseBranch()->Copy());
};

action_target *action_target::Copy(void)
{
   char *tmp_dest=cpystr(Dest());
   //range_class *tmp_range=NULL;

   action_address *tmp_addr=Address()->Copy();
   //   if (Range()!=NULL) tmp_range=Range()->Copy();
   //if (Address()==NULL)
   //{
   //   action_target *ret=new action_target(tmp_dest,tmp_range);
   //   //      fprintf(error_log,"AB: New action target %08x\n",ret);
   //   return ret;
   //};
   action_target *ret=new action_target(tmp_dest,tmp_addr);
   //   fprintf(error_log,"AC: New action target %08x\n",ret);
   if (tmp_dest==NULL)
   {
     fprintf(error_log,"BUG!!!!!\n");
     exit(1);
   };
   ret->IsMemory(IsMemory());
   ret->IsOutput(IsOutput());
   ret->IsInput(IsInput());
   ret->IsInternal(IsInternal());
   ret->PortNumber(PortNumber());
   ret->AddressSize(AddressSize());
   ret->ArraySize(ArraySize());

   return ret;
};

void action_target::Elaborate(void)
{
  elaboration *elab;
  elab=Elaborations->Member(Dest());
  if (elab==NULL) return;
  Address()->Range()->Left(elab->Width()-1);
  Address()->Range()->Right(0);
};

vhdl_atom *vhdl_atom::Copy(void)
{
   if (IsVariable()) return new vhdl_atom(Variable()->Copy());
   return new vhdl_atom(cpystr(code.code));
};

vhdl_code *vhdl_code::Copy(void)
{
   vhdl_code *ret=new vhdl_code();
   for(int i=0;i<NrOfMembers();i++)
   {
      ret->AddMember(Member(i)->Copy());
   };
   return ret;
};

action *action::Copy(void)
{
   action *ret;
   if (IsVHDL())
   {
      ret=new action(VHDLCode()->Copy());
   }
   else
   { 
      if (IsMuxed())
      {
         ret=new action(Target()->Copy(),Mux()->Copy());
      }
      else
      {
         ret=new action(Target()->Copy(),Line()->Copy());
      };
      ret->Expanded(Expanded());
      ret->BitSize(BitSize());
   };
   return ret;
};

//**************************************************************************
//*
//* Compare method
//*
//**************************************************************************

bool range_class::Compare(range_class *r)
{
   if (Left()!=r->Left()) return false; 
   if (Right()!=r->Right()) return false;
   if (LSBFirst()!=r->LSBFirst()) return false;
   if (Pointer()!=NULL)
   {
     if (r->Pointer()!=NULL)
     {
		// return strcmp(Pointer(),r->Pointer();
        if (strcmp(Pointer(),r->Pointer())==0) return true;
		else return false;
     }
     else
     {
        return false;
     };
   }
   else
   {
      if (r->Pointer()!=NULL)
      {
         return false;
      };
   };
   return true;
};

bool action_address::Compare(action_address *aa)
{
   if (Type()!=aa->Type()) return false;
   if (IsVoid()) return true;
   if (IsSignal()) return Signal()->Compare(aa->Signal());
   if (IsVariable()) return Variable()->Compare(aa->Variable());
   return Range()->Compare(aa->Range());
};

bool action_constant::Compare(action_constant *ac)
{
   if (strcmp(Value(),ac->Value())!=0) return false;
   return true;
};

bool action_variable::Compare(action_variable *av)
{
   if (strcmp(Name(),av->Name())!=0) return false;
   if (ProdPos()!=av->ProdPos()) return false;
   if (FirstBit()!=av->FirstBit()) return false;
   if (LastBit()!=av->LastBit()) return false;
   return true;
};

bool action_cdfg::Compare(action_cdfg *ac)
{
   if (Type()!=ac->Type()) return false;
   if (IsFunction())
   {
      if (strcmp(Function(),ac->Function())==0)
      {
	 return Arguments()->Compare(ac->Arguments());
      };
   }
   else if (IsConstant())
   {
      return Constant()->Compare(ac->Constant());
   }
   else if (IsVariable())
   {
      return Variable()->Compare(ac->Variable());
   }
   else if (IsSignal())
   {
      return Signal()->Compare(ac->Signal());
   };
   return false;
};

bool action_arguments::Compare(action_arguments *aa)
{
   if (NrOfMembers()!=aa->NrOfMembers()) return false;
   for(int i=0;i<NrOfMembers();i++)
   {
      if (!Member(i)->Compare(aa->Member(i))) return false;
   };
   return true;
};

bool action_line::Compare(action_line *a2)
{
   int i;
   if (NrOfMembers()!=a2->NrOfMembers())
   {
      return false;
   };
   for(i=0;i<NrOfMembers();i++)
   {
      if (!Member(i)->Compare(a2->Member(i)))
      {
	 return false;
      }
   };
   return true;
};

bool action::Compare(action *a2)
{
   int i;
   if (this==a2) return true;
   if (IsVHDL())
   {
     fprintf(error_log,"Error: Compare for VHDL code action not implemented YET!!!\n");
   };
   if (Target()->Compare(a2->Target()))
   {
      if (IsMuxed()==a2->IsMuxed())
      {
	 if (IsMuxed())
	 {
	    return Mux()->Compare(a2->Mux());
	 }
	 else
	 {
	    return Line()->Compare(a2->Line());
	 };
      };
   };
   return false;
};

bool action_target::Compare(action_target *a2)
{
  if (this==a2)
  {
    fprintf(error_log,"BUG!!! Comparing duplicated action_targets (%08x)!!!!\n",this);
    return false;
    exit(1);
  };
  if (strcmp(Dest(),a2->Dest())==0)
  {
     return Address()->Compare(a2->Address());
  };
  return false;
};

int lexem::CompareActions(actions *a1,actions *a2)
{
   int found,i;
   // Check if the actions have the same target
   if ((a1->Member(0)->IsVHDL()) | (a2->Member(0)->IsVHDL())) return 0;
   if (!a1->Member(0)->Target()->Compare(a2->Member(0)->Target())) return 0;
   if (a1->Member(0)->IsMuxed()==a2->Member(0)->IsMuxed())
   {
      found=0;
      // Count the members of the action schedule a1 that are identical
      // to the action schedule a2
      for(i=0;i<a1->NrOfMembers();i++)
      {
	 if (i>=a2->NrOfMembers())
	 {
	    break;
	 };
	 if (a1->Member(i)->IsMuxed())
	 {
	    if (a1->Member(i)->Mux()->Compare(a2->Member(i)->Mux()))
	    {
	       found++;
	    };
	 }
	 else
	 {
	    if (a1->Member(i)->Line()->Compare(a2->Member(i)->Line()))
	    {
	       found++;
	    };
	 };
      };
      return found;
   }
   else
   {
      return 0;
   };
};

// void lexem::CleanActScheds(void)
// {
//    int i;
//   // Some ActScheds are not deleted by some reason
//   // This bugfix will do for now
//   for(i=NrOfActScheds()-1;i>=0;i--)
//   {
//      if (ActSched(i)==NULL)
//      {
//	 ActScheds()->DelMember(i);
//      };
//   };
//   for(i=0;i<NrOfSuccs();i++)
//   {
//      Succ(i)->CleanActScheds();
//   };
//};

void lexem::MoveUpSchedActs(int sched,int nr)
{
   int j;
   // Check if node has Loop successors
   // fprintf(error_log,"Testing MoveUpSchedActs(int sched,int nr)\n");
   if (IsLoop())
   {
     fprintf(error_log,"Loop Node: %08x\n",this);
   };
   for(int i=0;i<NrOfSuccs();i++)
   {
     if (Succ(i)->IsLoop())
     {
        fprintf(error_log,"   Detected Loop Successor Node at %d:%08x\n",i,Succ(i));
        return;
     }
   };
   // Move the output assignments (0..nr-1) from
   // output schedule ActSched(sched) leaving one
   // assignment.
   // fprintf(error_log,"Moving %d assignments from node %08x->%08x to node %08x\n",nr,Succ(0),Succ(0)->ActSched(sched),this);
   actions *tmp=new actions();
   for(j=0;j<nr;j++)
   {
     //     fprintf(error_log,"%d: %08x\n",j,Succ(0)->ActSched(sched)->Member(j));
      tmp->AddMember(Succ(0)->ActSched(sched)->Member(j));
      Succ(0)->ActSched(sched)->Replace(j,NULL);
   };
   //   fprintf(error_log,"Moved %d assignments successfully!\n",nr);
   AddActSched(tmp);
};

bool lexem::OutputIsWrittenToByAllSuccs(action_target *target)
{
   int i;
   actions *tmp;
   //fprintf(error_log,"Is target %08x the same target for other successors?\n");
   for(i=1;i<NrOfSuccs();i++)
   {
      tmp=Succ(i)->ActScheds()->Member(target);
      if (tmp==NULL)
      {
		 return false;
      };
   }
   return true;
}

bool lexem::CompareActionWithAllSuccs(action_target *target,
				      actions *sched,
				      int nr)
{
   int i,where;
   actions *a;
   for(i=1;i<NrOfSuccs();i++)
   {
      a=Succ(i)->ActScheds()->Member(target);
      if (!sched->Member(nr)->Compare(a->Member(nr)))
      {
		return false;
      };
   };
   return true;
};

void lexem::DelMovedActionsFromAllSuccs(action_target *target,
					int nr)
{
	//fprintf(error_log, "%d Successors, %d similar actions\n", NrOfSuccs(),nr);
   for(int i=0;i<NrOfSuccs();i++)
   {
      //fprintf(error_log,"Deleting %d member(s) from target %08x at Node %08x\n",nr,target,Succ(i));
      //fprintf(error_log,"   %d:Succ %08x has %d Action Schedules\n",i,Succ(i),Succ(i)->NrOfActScheds());
      actions *acts=Succ(i)->ActScheds()->Member(target);
     //fprintf(error_log,"Target actions is at %08x with %d member(s)\n",acts,acts->NrOfMembers());
	 //for (int tmp = 0; tmp < acts->NrOfMembers(); tmp++)
	 //{ 
	 //	 fprintf(error_log,"   %08x\n", acts->Member(tmp)); 
	 //};
  //   if (i!=0) // Members from Succ(0) has been moved up one level
  //   {
		//for(int j=0;j<nr;j++)
  //      {
  //         acts->Replace(j,NULL);
  //      };
  //    };
	 acts->DelMembers(0,nr-1);
   //   fprintf(error_log,"Target actions is at %08x with %d member(s)\n",acts,acts->NrOfMembers());
   };
};

void lexem::MoveUpSchedActs(void)
{
   int items2move;
   actions *sched,*new_acts,*found;
   //fprintf(error_log,"Node %08x has %d successor(s)\n",this,NrOfSuccs());
   if (NrOfSuccs()==0) return; // Bug fix, cause unknown
   //DumpNode(error_log);
   //for(int i=0;i<NrOfSuccs();i++)
   //{
   //  fprintf(error_log,"   %d::%08x\n",i,Succ(i));
   //  Succ(i)->DumpNode(error_log);
   //};
   if (NrOfSuccs()==1)
   {
      // Move all Schedulable outputs
      //fprintf(error_log,"   Successor node %08x (type %d) has %d schedulable actions at %08x\n",Succ(0),Succ(0)->Type(),Succ(0)->NrOfActScheds(),Succ(0)->ActScheds());
      for(int i=0;i<Succ(0)->NrOfActScheds();i++)
      {
	  //fprintf(error_log,"%d %08x\n",i,Succ(0)->ActSched(i));
         if (Succ(0)->ActSched(i)->Member(0)->IsVHDL())
	 {
	    items2move=0;
	 }
	 else
	 {
	    items2move=Succ(0)->ActSched(i)->NrOfMembers()-1;
	 };
	 // fprintf(error_log,"   Moving %d actions\n",items2move);
     if (items2move>0)
		{
	   //   fprintf(error_log,"   %d:AHA! Moving %d assignments (of %d)\n",i,items2move,Succ(0)->ActSched(i)->NrOfMembers());
			MoveUpSchedActs(i,items2move);
            Succ(0)->ActSched(i)->DelMembers(0,items2move-1);
	    //	    fprintf(error_log,"  %d:%d assignments left\n",i,Succ(0)->ActSched(i)->NrOfMembers());
         };
      };
      //      fprintf(error_log,"Moving completed...\n");
   }
   else
   {
      //fprintf(error_log,"NrOfSuccs - %d \n",NrOfSuccs());
      // Check if one of the successors is a loop node
      bool found=false;
      for(int i=0;i<NrOfSuccs();i++)
      {
		if (Succ(i)->IsLoop())
		{
		   found=true;
		   //	   fprintf(error_log,"Warning: Loop detected!\n");
		   break;
		};
      };
      // Loop over the output assignments of successor 0
	  if (!found)
      {
		 for(int i=0;i<Succ(0)->NrOfActScheds();i++)
		 {
			 sched=Succ(0)->ActSched(i);
			if (!sched->Member(0)->IsVHDL())
			{
			   action_target *target;
			   target=sched->Member(0)->Target()->Copy();
			   if (OutputIsWrittenToByAllSuccs(target))
			   {
				  //fprintf(error_log,"   Yes!\n");
				  // Move up all members that are identical in all branches
				  // except the last one
				  new_acts=new actions();
				  //fprintf(error_log,"   %d::Move %d member(s)\n",i,sched->NrOfMembers()-1);
				  for(int j=0;j<sched->NrOfMembers()-1;j++)
				  {
					 if (CompareActionWithAllSuccs(target,sched,j))
					 {
						new_acts->AddMember(sched->Member(j)->Copy());
						//fprintf(error_log,"      moving (copy and delete) member %d:%08x\n",j,sched->Member(j));
					 }
					 else
					 {
						break;
					 };
				  };
				  //fprintf(error_log,"   %d::Moved %d member(s) successfully\n",i,new_acts->NrOfMembers());
				  if (new_acts->NrOfMembers()>0)
				  {
					 AddActSched(new_acts);
					 DelMovedActionsFromAllSuccs(target,new_acts->NrOfMembers());
				  };
			   };
			};
		 };
      };
   };
};

void lexem::ScheduleUpwards(void)
{
   int i;
   if (Visited()) return;
   Visited(true);
//   fprintf(error_log,"Node %08x Type %d %s\n",this,Type(),Value());
   if (IsLoop()) return;
//   if (!IsLoop())
//   {
      for(i=0;i<NrOfSuccs();i++)
      {
	 if (Succ(i)->IsExit())
	 {
	    continue;
	 }
	 else
	 {
	    Succ(i)->ScheduleUpwards();
	 };
      };
//   };
//   fprintf(error_log,"Moving Schedule of Node %08x\n",this);
   MoveUpSchedActs();
//   fprintf(error_log, "Exit Moving Schedule of Node %08x\n", this);
};

void lexem::MoveDownSchedActs(void)
{
   actions *a1,*a2,*tmp;
   int i,j,k,nr;
   action_target *target;
   for(i=0;i<NrOfActScheds();i++)
   {
      a1=ActSched(i);
	  // a1->DumpMembers(stderr);
      if (a1->NrOfMembers()>1)
      {
         if (!a1->Member(0)->IsVHDL())
	 {
	    target=a1->Member(0)->Target();
	    // fprintf(error_log,"   i=%d::Target is at %08x,NrOfSuccs is %d\n",i,target,NrOfSuccs());
	    for(j=0;j<NrOfSuccs();j++)
	    {
	       tmp=new actions();
	       // Copy the members that should be moved down
	       //	       fprintf(error_log,"   j=%d::a1(%08x) has %d Members\n",j,a1,a1->NrOfMembers());
	       for(k=1;k<a1->NrOfMembers();k++)
	       {
		 // fprintf(error_log,"   Copying member %08x\n",a1->Member(k));
	          tmp->AddMember(a1->Member(k)->Copy());
	       };
	       // fprintf(error_log,"Moving members from Node %08x to node %08x\n",this,Succ(j));
	       a2=Succ(j)->ActScheds()->Member(target);
	       // fprintf(error_log,"     a2 is at %08x\n",a2);
	       if (a2==NULL)
	       {
	          Succ(j)->AddActSched(tmp);
	       }
	       else
	       {
	          // Add the old members to the end of the members that are
	          // moved down
	          for(k=0;k<a2->NrOfMembers();k++)
	          {
		     tmp->AddMember(a2->Member(k));
	          };
	          nr=Succ(j)->ActScheds()->Find(a2);
	          Succ(j)->ActScheds()->Replace(nr,tmp);
	       };
	    };
	    a1->DelMembers(1,a1->NrOfMembers()-1);
	 };
      };
   };
};


void lexem::ScheduleDownwards(void)
{
   int i;
   if (Visited()) return;
   Visited(true);
   //fprintf(error_log,"%08x::%d %d\n",this,Type(),NrOfSuccs());
   if (NrOfSuccs()==0) return; // Bugfix cause unknown
   for(int i=0;i<NrOfSuccs();i++)
   {
      if ((Succ(i)->IsExit()) &&
	  (NrOfSuccs()>1))
      {
	 fprintf(error_log,"Error: Nondeterminism detected.\n");
	 fprintf(error_log,"       Loop unrolling across Frame boundaries not supported yet\n");
	 exit(1);
      };
   };
   if (Succ(0)->IsExit())
   {
      return;
   };
   if (IsLoop()) return;
   MoveDownSchedActs();
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->ScheduleDownwards();
   };
};

bool lexem::ComparePreds(int p1,int p2)
{
   int i,j;
   bool found;
   // The predecessors must have the same transition
   if (Pred(p1)->Type()!=Pred(p2)->Type())
   {
      return false;
   }
   else
   {
      if (Pred(p1)->IsTerminal())
      {
	 if ((strcmp(Pred(p1)->Value(),Pred(p2)->Value())!=0) ||
	     (Pred(p1)->IsNegated()!=Pred(p2)->IsNegated()) ||
	     (!Pred(p1)->Stream()->Compare(Pred(p2)->Stream())))
	 {
	    return false;
	 };
      }
      else
      {
	 return false;
      };
   };
   // The Predecessors must have identical successors
   if (Pred(p1)->HyperState()!=Pred(p2)->HyperState())
   {
      return false;
   };
   // The predecessors must have identical action schedules
   if (Pred(p1)->NrOfActScheds()!=Pred(p2)->NrOfActScheds())
   {
      return false;
   };
   for(i=0;i<Pred(p1)->NrOfActScheds();i++)
   {
      found=false;
      for(j=0;j<Pred(p2)->NrOfActScheds();j++)
      {
	 int match;
	 match=CompareActions(Pred(p1)->ActSched(i),Pred(p2)->ActSched(j));
	 if (match>0)
	 {
	    if ((Pred(p1)->ActSched(i)->NrOfMembers()==
		 Pred(p2)->ActSched(j)->NrOfMembers()) &&
		(Pred(p1)->ActSched(i)->NrOfMembers()==match))
	    {
	       found=true;
	       return true;
	    }
	    else
	    {
	       return false;
	    };
	 };
      };
      if (!found)
      {
	 return false;
      };
   };
   return true;
};

void lexem::MergePreds(int p1, int p2)
{
   lexem *pptr;
   int i,j,k,l,m;
   // Warning::
   // This routine does not check the equivalents of the two predecessors.
   // This must be done prior to calling this function.
   //
   // Move the predecessors of the second predecessor to the first
   for(i=Pred(p2)->NrOfPreds()-1;i>=0;i--)
   {
      if (Pred(p2)->Pred(i)==Pred(p2))
      {
	 // Self-Loop, Link does already exist
	 Pred(p2)->Preds()->Replace(i,NULL);
	 Pred(p2)->DelPred(i);
      }
      else
      {
	 Pred(p1)->AddPred(Pred(p2)->Pred(i));
	 m=Pred(p2)->Pred(i)->Succs()->Find(Pred(p2));
	 Pred(p2)->Pred(i)->Succs()->Replace(m,Pred(p1));
	 Pred(p2)->Preds()->Replace(i,NULL);
	 Pred(p2)->DelPred(i);
      }
   };
   // Delete the successors of the second predecessor
   for(i=Pred(p2)->NrOfSuccs()-1;i>=0;i--)
   {
      Pred(p2)->Succs()->Replace(i,NULL);
      Pred(p2)->DelSucc(i);
   };
   Preds()->Replace(p2,NULL);
   DelPred(p2);
   pptr=Pred(p1);
   // Disconnect duplicate links
   for(i=0;i<pptr->NrOfPreds();i++)
   {
      for(j=i+1;j<pptr->NrOfPreds();j++)
      {
	 if (pptr->Pred(i)==pptr->Pred(j))
	 {
	    pptr->Preds()->Replace(j,NULL);
	    // Disconnect duplicated Successor pointers
	    for(k=0;k<pptr->Pred(i)->NrOfSuccs();k++)
	    {
	       for(l=k+1;l<pptr->Pred(i)->NrOfSuccs();l++)
	       {
		  if (pptr->Pred(i)->Succ(k)==pptr->Pred(i)->Succ(l))
		  {
		     pptr->Pred(i)->Succs()->Replace(l,NULL);
		  };
	       };
	    };
	    // Delete duplicated Successors' pointer holders
	    for(k=pptr->Pred(i)->NrOfSuccs()-1;k>=0;k--)
	    {
	       if (pptr->Pred(i)->Succ(k)==NULL)
	       {
		  pptr->Pred(i)->DelSucc(k);
	       };
	    };
	 };
      };
   };
   // Delete duplicated Predecessors pointer holders
   for(i=pptr->NrOfPreds()-1;i>=0;i--)
   {
      if (pptr->Pred(i)==NULL)
      {
	 pptr->DelPred(i);
      };
   };
};

void lexem::ReduceTailStates(void)
{
   int i,j;
   for(i=0;i<NrOfPreds();i++)
   {
      for(j=NrOfPreds()-1;j>i;j--)
      {
	 if (ComparePreds(i,j))
	 {
	    MergePreds(i,j);
	 };
      };
   };
};

void lexem::SetAllBitPos(int bp)
{
   int input_stream_width;
   if (Visited()) return;
   Visited(true);
   BitPos(bp);
   if (Stream()!=NULL)
   {
      input_stream_width=Stream()->BitSize();
   }
   else
   {
     input_stream_width=1; // Parsing the clock...
   };
   for(int i=0;i<NrOfSuccs();i++)
   {
      if (!Succ(i)->IsExit())
      {
	 int next_pos;
	 if (Succ(i)->Stream()!=Stream())
	 {
	    next_pos=0;
	 }
	 else
	 {
	    next_pos=bp+input_stream_width;
	 };
	 Succ(i)->SetAllBitPos(next_pos);
      };
   };
};

extern bool first_if_statement;
void lexem::PrintAllTransitions(FILE *file,int fsm)
{
   int i,j,input_stream_width;
   //fprintf(file, "Skebe %08x\n", this);
   if (Visited()==true) return;
   Visited(true);
   if (NrOfSuccs() == 0) return;
   if (Succ(0)->Visited()==true) return;
   //   if (Stream()!=NULL)
   //{
   //   input_stream_width=Stream()->BitSize();
   //}
   //else
   //{
   //   input_stream_width=1;
   //};
   //fprintf(file, "%d\n", NrOfSuccs());
   for(i=0;i<NrOfSuccs();i++)
   {
	   if (Succ(i) == NULL) fprintf(file, "Error! Null pointer Succ(%d)\n", i);
	   if (!Succ(i)->IsExit())
	   {
         // Debug-message to check the printout of states
		 // Loops are printed twice for some reason
		 //fprintf(file,"         -- %08x %d %08x %d\n",this,i,Succ(i),Succ(i)->Type());

		 if (Succ(i)->IsReset())
		 {
		    production_reset *irq;
		    int value;
		    irq=Succ(i)->Reset();
		    if (irq->IsLow())
		    {
			   value=0;
			}
			else
			{
				value=1;
			};
		    // Must be the first state
		    if (State()==0)
			{
		       if (i==0)
		       {
				  fprintf(file,"         IF (%s=std_logic_vector'(\"%d\")) THEN -- RESET STATE\n",irq->Signal(),value);
			   }
			   else
			   {
				  fprintf(file,"         ELSIF (%s=std_logic_vector'(\"%d\")) THEN -- RESET STATE\n",irq->Signal(),value);
			   };
			}
			else
			{
				fprintf(error_log,"Current State is %d\n");
				fprintf(error_log,"Error: The reset signal must be specified at the top level\n");
				exit(1);
			};
			printed_a_transition=true;
			first_if_statement=false;
		 }
		 else if (Succ(i)->IsInterrupt())
		 {
			production_interrupt *irq;
			int value;
			irq=Succ(i)->Interrupt();
			if (irq->IsLow())
			{
				value=0;
			}
			else
			{
				value=1;
			};
			if (first_if_statement)
			{
				if (Succ(i)->State()==0)
				{
				  fprintf(file,"         IF (%s=std_logic_vector'(\"%d\")",irq->Signal(),value);
				}
				else if (nr_of_states>1)
				{
				   if (STATE_COUNTER_MODE)
				   {
					  fprintf(file,"         IF ((pres_state=%d) AND (%s=\"%d\")",State(),irq->Signal(),value);
				   }
				   else
				   {
					  fprintf(file,"         IF ((pres_state=state_%d) AND (%s=\"%d\")",State(),irq->Signal(),value);
				   };
				}
				else
				{
				   fprintf(file,"         IF (%s=std_logic_vector'(\"%d\")",irq->Signal(),value);
				};
				first_if_statement=false;
			}
			else
			{
			   if (Succ(i)->State()==0)
			   {
				  fprintf(file,"         ELSIF (%s=std_logic_vector'(\"%d\")",irq->Signal(),value);
		       }
			   else if (nr_of_states>1)
			   {
				  if (STATE_COUNTER_MODE)
				  {
					fprintf(file,"         ELSIF ((pres_state=%d) AND (%s=std_logic_vector'(\"%d\"))",State(),irq->Signal(),value);
				  }
				  else
				  {
				     fprintf(file,"         ELSIF ((pres_state=state_%d) AND (%s=std_logic_vector'(\"%d\"))",State(),irq->Signal(),value);
				  };
		       }
		       else
		       {
				  fprintf(file,"         ELSIF (%s=std_logic_vector'(\"%d\")",irq->Signal(),value);
		       };
		    }
		    fprintf(file,") THEN -- INTERRUPT STATE\n");
		    printed_a_transition=true;
		 }
		 else
		 {
		    if (first_if_statement)
		    {
		       if (nr_of_states>1)
			   {
				  if (STATE_COUNTER_MODE)
				  {
					fprintf(file,"         IF ((pres_state=%d)",State());
				  }
				  else
				  {
					fprintf(file,"         IF ((pres_state=state_%d)",State());
				  };
				  printed_a_transition=true;
			   };
	           first_if_statement=false;
			}
		    else
		    {
		       if ((Succ(i)->IsError()) && (NrOfPreds()==0))
		       {
				  no_top_error=false;
				  fprintf(file,"         ELSE");
			   }
		       else if (nr_of_states>1)
		       {
				  if (STATE_COUNTER_MODE)
				  {
				     fprintf(file,"         ELSIF ((pres_state=%d)",State());
				  }
				  else
				  {
				     fprintf(file,"         ELSIF ((pres_state=state_%d)",State());
				  };
			   }
			   else
			   {
				  fprintf(file,"         ELSIF (");
			   };
			   printed_a_transition=true;
			};
			Succ(i)->Conds()->PrintTransitions(file,fsm,stream,Succ(i)->BitPos());
			if (Succ(i)->IsError())
			{
				if (NrOfPreds()==0)
				{
					fprintf(file," -- TOP ERROR STATE\n");
				}
				else
				{
			 	   fprintf(file,") THEN -- ERROR STATE\n");
			    };
				printed_a_transition=true;
		    }
		    else if (Succ(i)->IsTerminal())
			{
				if ((nr_of_states>1) || (Succ(i)->NrOfConds()>0))
				{
				    Succ(i)->Stream()->write_transition(file,fsm,true,Succ(i)->Terminal());
				}
				else
				{
					Succ(i)->Stream()->write_transition(file,fsm,false,Succ(i)->Terminal());
				};
				if (printed_a_transition)
				{
					fprintf(file,") THEN \n");
				};
			};
	     };
	     if (nr_of_states>1)
	     {
			if (IsLoop())
			{
				fprintf(file,"            -- Loop Node\n");
			};
			if (STATE_COUNTER_MODE)
		    {
		       if ((Succ(i)->State()==State()+1) && (!Succ(i)->IsReset()))
			   {
				  fprintf(file,"            next_state<=pres_state_plus_1;\n");
			   }
		       else
		       {
				  fprintf(file,"            next_state<=%d;\n",Succ(i)->State());
		       };
		    }
		    else
		    {
		       fprintf(file,"            next_state<=state_%d;\n",Succ(i)->State());
		    };
	     };
	     //	 Succ(i)->ActScheds()->PrintAction(file,fsm,stream,bit_pos+Succ(i)->BitSize());
		 //fprintf(file, "%08x:   Succ   %d   %08x\n", this, i, Succ(i));
		 //fprintf(file,"BAKAYARO %d %d %d\n",BitPos(),Succ(i)->BitPos(),Succ(i)->BitSize());
	     Succ(i)->ActScheds()->PrintAction(file,fsm,stream,Succ(i)->BitPos());
	   };
	   if (!Succ(i)->IsExit())
	   {
	//	 int next_pos;
	//if (Succ(i)->Stream()!=Stream())
	//{
	//   next_pos=0;
	//}
	//else
	//{
	//   next_pos=input_stream_width;
	//};
	 // Bugfix in order not to print Loops twice
	 // Should not really be needed, but for some reason,
	 // Loops are built twice...
	// Leads to a new bug...?
	//if (!IsLoop())
	//{ 
		Succ(i)->PrintAllTransitions(file,fsm);
	   //};
	   };
   };
};

void lexem::DebugDataBase(FILE *file)
{
   if (Visited()) return;
   Visited(true);
   fprintf(file,"Node %08x Type %d Succs %d\n",this,Type(),NrOfSuccs());
   for(int i=0;i<NrOfSuccs();i++)
   {
      fprintf(file,"   ->%08x\n",Succ(i));
      Succ(i)->DebugDataBase(file);
   };
};

void lexem::CheckConsistency(int fsm)
{
   int next_pos;
   if (Visited()) return;
   Visited(true);
   // fprintf(error_log,"%08x %d %08x\n",this,Type(),Stream());
   if (IsInterrupt())
   {
     //      fprintf(error_log,"Interrupt!!!\n");
      Interrupt()->CheckConsistency(fsm);
   }
   else if (IsReset())
   {
     //      fprintf(error_log,"Reset!!!\n");
      Reset()->CheckConsistency(fsm);
   }
   else if (IsTerminal())
   {
      if (ListOfSignals()!=NULL)
      {
	//    fprintf(error_log,"   LoS=%08x Nr=%d\n",ListOfSignals(),ListOfSignals()->NrOfMembers());
	 for(int i=0;i<ListOfSignals()->NrOfMembers();i++)
	 {
	   //	    fprintf(error_log,"BAKAYARO %d\n",i,Signal(i));
	    if (Signal(i)!=NULL)
	    { 
	      //	       fprintf(error_log,"   %d - %08x\n",i,Signal(i));
	       Signal(i)->CheckConsistency(fsm,Stream(),0);
	    };
	 };
      };
   };
   //   fprintf(error_log,"   bp=%d bs=%d\n",BitPos(),BitSize());
   next_pos=BitPos()+BitSize();
   if (NrOfConds()>0)
   {
      Conds()->CheckConsistency(fsm,Stream(),next_pos);
   };
   ActScheds()->CheckConsistency(fsm,Stream(),next_pos);
   // fprintf(error_log,"   %d Succs\n",NrOfSuccs());
   for(int i=0;i<NrOfSuccs();i++)
   {
     // fprintf(error_log,"   -> %08x\n",Succ(i));
      if (!Succ(i)->IsExit())
      {
	 if (Succ(i)->Stream()!=Stream())
	 {
	    Succ(i)->Stream()->CheckConsistency(fsm);
//	    next_pos=0;
	 };
      };
      Succ(i)->CheckConsistency(fsm);
   };
};

/***************************************************************************/
// Methods for action group
/***************************************************************************/
int action_constant::Integer(void)
{
   int res=0;
   for(int i=0;i<BitSize();i++)
   {
      if (value[i]='1')
      {
         res=2*res+1;
      }
      else
      {
         res=2*res;
      };
   };
   return res;
};

void action_constant::write_driver(FILE *file)
{
   fprintf(file,"\"%s\"",value);
};

void action_constant::PrintConstant(FILE *file)
{
  //fprintf(error_log,"%08x\n",value);
   fprintf(file,"std_logic_vector'(\"%s\")",value);
};

void action_variable::write_driver(FILE *file, int fsm, input_stream *stream, int bp)
{
   int current_word,left_bit,right_bit;
   current_word=(bit_pos-prod_pos)/input_stream_width;
   left_bit=first_bit;
   right_bit=last_bit;
   if (current_word==0)
   {
      fprintf(file,"%s(%d downto %d)",port_name,left_bit,right_bit);
   }
   else
   {
      fprintf(file,"%s(%d)(%d downto %d)",fifo_name,current_word,left_bit,right_bit);
   };
};

void action_variable::PrintVariable(FILE *file,int fsm,input_stream *stream, int bp,int ind)
{
//   indent(file,ind);
   PrintVariable(file,fsm,stream,bp);
   if (!LastPartition())
   {
      fprintf(file," & ");
   };
};
void cdfg_variable::PrintVariable(FILE *file,int fsm,input_stream *stream, int bp)
{
	fprintf(file,"%s",name);
};
void action_variable::PrintVariable(FILE *file,int fsm,input_stream *stream, int bp)
{
   int current_word,left_bit,right_bit,index;
   index = 0;
   //fprintf(file, "-- RANGE %08x\n", Range());
   if (Range() != NULL)
   {
	   // fprintf(file, "-- %d to %d", Range()->Left(), Range()->Right());
	   index = Range()->Right();
   }
   //fprintf(file,"-- prod_pos=%d bp=%d prod_size=%d input_stream_width=%d bit_pos=%d\n",prod_pos,bp,prod_size,input_stream_width,bit_pos);
   //fprintf(file,"-- %d,%d\n",prod_pos-bp-input_stream_width,bit_pos-prod_pos);
   //current_word=(prod_pos-bp-input_stream_width)/input_stream_width;
   current_word=(bit_pos-prod_pos)/input_stream_width;
   //fprintf(file, "-- current_word=%d\n", current_word);
   current_word = abs(current_word - index);
   /*
   if (current_word<0)
   {
      // Ugly bug-fixed caused by inconsistency between printing of
      // scheduled and concatenated variables
      current_word=(bit_pos-prod_pos)/input_stream_width;
   };
   */
   left_bit=first_bit; // input_stream_width-prod_pos-1;
   right_bit=last_bit; // left_bit-prod_size+1;
   if (current_word==0)
   {
      fprintf(file,"%s(%d downto %d)",port_name,left_bit,right_bit);
   }
   else
   {
      fprintf(file,"%s(%d)(%d downto %d)",fifo_name,current_word,left_bit,right_bit);
   };
};

// Variables in condition expressions are not wordaligned as other 
// signals are. Therefore, the full reference should be printed
void action_variable::PrintExpression(FILE *file,int fsm,input_stream *stream, int bp)
{
   int current_word,left_bit,right_bit;
   for(int i=prod_pos;i<prod_pos+prod_size;i+=input_stream_width)
   {
      current_word=(bp-i)/input_stream_width;
      left_bit=first_bit; // input_stream_width-prod_pos-1;
      right_bit=last_bit; // left_bit-prod_size+1;
      if (current_word==0)
      {
	fprintf(file,"%s(%d downto %d)",port_name,left_bit,right_bit);
      }
      else
      {
	 fprintf(file,"%s(%d)(%d downto %d)",fifo_name,current_word,left_bit,right_bit);
      };
      if (i<prod_pos+prod_size-input_stream_width)
      {
	 fprintf(file,"&\n                ");
      };
   };
};
void action_signal::write_driver(FILE *file,int fsm,input_stream *stream,int bp)
{
   if (BitSize()==1)
   {
      if (Range()->Pointer()!=NULL)
      {
	 if (Negate())
	 {
	    fprintf(file,"not(%s(%s))",Name(),Range()->Pointer());
	 }
	 else
	 {
	    fprintf(file,"%s(%s)",Name(),Range()->Pointer());
	 };
      }
      else
      {
	 if (Negate())
	 {
	    fprintf(file,"not(%s)",Name());
	 }
	 else
	 {
	    fprintf(file,"%s",Name());
	 };
      };
   }
   else
   {
      int from,to;
      from=Range()->Left();
      to=Range()->Right();
      if (Negate())
      {
	 fprintf(file,"not(%s(%d downto %d))",Name(),to,from);
      }
      else
      {
	 fprintf(file,"%s(%d downto %d)",Name(),to,from);
      };
   };
};

void action_signal::write_driver(FILE *file)
{
   if (BitSize()==1)
   {
      if (Range()->Pointer()!=NULL)
      {
	 if (Negate())
	 {
	    fprintf(file,"not(%s(%s))",Name(),Range()->Pointer());
	 }
	 else
	 {
	    fprintf(file,"%s(%s)",Name(),Range()->Pointer());
	 };
      }
      else
      {
	 if (Negate())
	 {
	    fprintf(file,"not(%s)",Name());
	 }
	 else
	 {
	    fprintf(file,"%s",Name());
	 };
      };
   }
   else
   {
      int from,to;
      from=Range()->Left();
      to=Range()->Right();
      if (Negate())
      {
	 fprintf(file,"not(%s(%d downto %d))",Name(),to,from);
      }
      else
      {
	 fprintf(file,"%s(%d downto %d)",Name(),to,from);
      };
   };
};

void production_signal::write_driver(FILE *file,int fsm,input_stream *stream,int bp)
{
   if (IsSignal())
   {
     Signal()->write_driver(file);
   }
   else
   {
     Variable()->PrintVariable(file,fsm,stream,bp);
   };
};
void production_signal::PrintSignal(FILE *file,int fsm,input_stream *stream,int bp)
{
   if (IsSignal())
   {
      Signal()->PrintSignal(file,fsm,stream,bp);
   }
   else
   {
     // Variables in Expressions and CDFGs are not wordaligned as 
     // normal actions are and must therefore be treated differently
     Variable()->PrintExpression(file,fsm,stream,bp);
   };
};
void cdfg_signal::PrintSignal(FILE *file,int fsm,input_stream *stream,int bp)
{
	fprintf(file,"%s",name);
};

void action_signal::PrintSignal(FILE *file,int fsm,input_stream *stream,int bp)
{
  int high,low;
  high=Range()->High();
  low=Range()->Low();
  if (IsMemory())
  {
     // Memory read
     if (Range()->LSBFirst())
     {
        fprintf(file,"%s_data(%d to %d)",Name(),low,high);
     }
     else
     {
        fprintf(file,"%s_data(%d downto %d)",Name(),high,low);
     };
  }
  else if (IsInput())
  {
     // Input read
     if (Address()->IsVoid())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"%s(%d to %d)",Name(),low,high);
	}
	else
	{
	   fprintf(file,"%s(%d downto %d)",Name(),high,low);
	};
     }
     else if (Address()->IsSignal())
     {
       fprintf(error_log,"-- Input arrays not supported yet!\n");
     }
     else if (Address()->IsVariable())
     {
       fprintf(error_log,"-- Input arrays not supported yet!\n");
     }
     else if (Address()->IsConstant())
     {
       fprintf(error_log,"-- Input arrays not supported yet!\n");
     };
  }
  else if (IsInternal())
  {
     internal *tmp=Internals->Member(Name());
     char *input_read;
     if (tmp->IsWrittenBy(fsm))
     {
        // Internal is an output read
        input_read=cpystr("_internal");
     }
     else
     {
        // Internal is an input read 
        input_read=cpystr("");
     };
     //     fprintf(file,"\nSignal %s, Address is at %08x with type %d and range %d..%d\n",Name(),Address(),Address()->Type(),Range()->Left(),Range()->Right());
     if (Address()->IsVoid())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"%s%s(%d to %d)",Name(),input_read,low,high);
	}
	else
	{
	   fprintf(file,"%s%s(%d downto %d)",Name(),input_read,high,low);
	};
     }
     else if (Address()->IsSignal())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"GetElement(%s%s,%s,%d,%d)(%d to %d)",Name(),input_read,Address()->Signal()->Name(),ArraySize(),BitSize(),low,high);
	}
	else
	{
	   fprintf(file,"GetElement(%s%s,%s,%d,%d)(%d downto %d)",Name(),input_read,Address()->Signal()->Name(),ArraySize(),BitSize(),high,low);
	};
     }
     else if (Address()->IsVariable())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"GetElement(%s%s,",Name(),input_read);
	   Address()->Variable()->PrintVariable(file,fsm,stream,bp);
	   fprintf(file,",%d,%d)(%d to %d)",ArraySize(),BitSize(),low,high);
	}
	else
	{
	   fprintf(file,"GetElement(%s%s,",Name(),input_read);
	   Address()->Variable()->PrintVariable(file,fsm,stream,bp);
	   fprintf(file,",%d,%d)(%d downto %d)",ArraySize(),BitSize(),high,low);
	};
     }
     else if (Address()->IsConstant())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"GetElement(%s%s,%d,%d,%d)(%d to %d)",Name(),input_read,Address()->Constant()->Integer(),ArraySize(),BitSize(),low,high);
	}
	else
	{
	   fprintf(file,"GetElement(%s%s,%d,%d,%d)(%d downto %d)",Name(),input_read,Address()->Constant()->Integer(),ArraySize(),BitSize(),high,low);
	};
     };
     delete input_read;
  }
  else if (IsOutput())
  {
     output *tmp=Outputs->Member(Name());
     char *input_read;
     if (tmp->IsWrittenBy(fsm))
     {
        // Output is read as an input
        input_read=cpystr("_internal");
     }
     else
     {
        input_read=cpystr("");
     };
     //     fprintf(error_log,"Signal %s, Address is at %08x with type %d\n",Name(),Address(),Address()->Type());
     if (Address()->IsVoid())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"%s%s(%d to %d)",Name(),input_read,low,high);
	}
	else
	{
	   fprintf(file,"%s%s(%d downto %d)",Name(),input_read,high,low);
	};
     }
     else if (Address()->IsSignal())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"GetElement(%s%s,%s,%d,%d)(%d to %d)",Name(),input_read,Address()->Signal()->Name(),ArraySize(),BitSize(),low,high);
	}
	else
	{
	   fprintf(file,"GetElement(%s%s,%s,%d,%d)(%d downto %d)",Name(),input_read,Address()->Signal()->Name(),ArraySize(),BitSize(),high,low);
	};
     }
     else if (Address()->IsVariable())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"GetElement(%s%s,",Name(),input_read);
	   Address()->Variable()->PrintVariable(file,fsm,stream,bp);
	   fprintf(file,",%d,%d)(%d to %d)",ArraySize(),BitSize(),low,high);
	}
	else
	{
	   fprintf(file,"GetElement(%s%s,",Name(),input_read);
	   Address()->Variable()->PrintVariable(file,fsm,stream,bp);
	   fprintf(file,",%d,%d)(%d downto %d)",ArraySize(),BitSize(),high,low);
	};
     }
     else if (Address()->IsConstant())
     {
        if (Range()->LSBFirst())
	{
	   fprintf(file,"GetElement(%s%s,%d,%d,%d)(%d to %d)",Name(),input_read,Address()->Constant()->Integer(),ArraySize(),BitSize(),low,high);
	}
	else
	{
	   fprintf(file,"GetElement(%s%s,%d,%d,%d)(%d downto %d)",Name(),input_read,Address()->Constant()->Integer(),ArraySize(),BitSize(),high,low);
	};
     };
     delete input_read;
  }
  else
  {
     fprintf(error_log,"BUG: There is non-existent path through action_signal::PrintSignal(), which should never happen!!!\n");
     exit(1);
  };
  /*
   if (Range()->Pointer()!=NULL)
   {
      if (Negate())
      {
	 fprintf(file,"not(EXTRACT_BIT(%s,%s_internal))",
		 Name(),Range()->Pointer());
      }
      else
      {
	 fprintf(file,"EXTRACT_BIT(%s,%s_internal)",
		 Name(),Range()->Pointer());
      };
   }
   else
   {
      int high,low;
      high=Range()->High();
      low=Range()->Low();
      if (Negate())
      {
	 fprintf(file,"not(%s_internal(%d downto %d))",Name(),high,low);
      }
      else
      {
	 if (!IsInput())
	 {
	    if (!IsInternal())
	    {
	    }
	    else
	    {
	    };
	 }
	 else
	 {
	 };
      };
   };
  */
};

bool action_signal::Compare(action_signal *s2)
{
   if ((strcmp(Name(),s2->Name())==0) &&
       (Range()->Left()==s2->Range()->Left()) &&
       (Range()->Right()==s2->Range()->Right()))
   {
      return true;
   };
   return false;
};

void action_address::CheckConsistency(int fsm,input_stream *stream,int bp)
{
   if (IsSignal())
   {
      Signal()->CheckConsistency(fsm,stream,bp);
   }
   else if (IsVariable())
   {
      int first_bit=stream->BitSize()-Variable()->ProdPos()-1;
      int last_bit=first_bit-Variable()->ProdSize()+1;
      //      fprintf(error_log,"--%08x %d %d %d %d %d\n",this,stream->BitSize(),Variable()->ProdPos(),Variable()->ProdSize(),first_bit,last_bit);
      Variable()->FirstBit(first_bit);
      Variable()->LastBit(last_bit);

      // First and Last bit must be set before calling variable's CheckConsistency
      Variable()->CheckConsistency(fsm,stream,bp);
   };
};

void action_signal::CheckConsistency(int fsm,input_stream *stream,int bp)
{
   input *input_tmp;
   internal *internal_tmp;
   // fprintf(error_log,"   %08x %08x\n",this,Address());
   input_tmp=Inputs->Member(Name());
   if (Address()!=NULL) Address()->CheckConsistency(fsm,stream,bp);
   // fprintf(error_log,"Signal %s, Address %08x, Type %d\n",Name(),Address(),Address()->Type());
   if (input_tmp!=NULL)
   {
      input_tmp->IsReadBy(fsm,true);
   }
   else
   {
      internal_tmp=Internals->Member(Name());
      if (internal_tmp!=NULL)
      {
	 internal_tmp->IsReadBy(fsm,true);
      }
      else
      {
	 output *output_tmp=Outputs->Member(Name());
	 if (output_tmp!=NULL)
	 {
	    Outputs->Member(Name())->IsReadBy(fsm,true);
	 }
	 else
	 {
 	    Memories->Member(Name())->IsReadBy(fsm,true);
	 };
      };
   };
};

bool cdfg_constant::Compare(cdfg_constant *cc)
{
   if (is_numeric)
   {
      return (Number()==cc->Number());
   }
   else
   {
      if (strcmp(c_number,cc->C_Number())!=0) return false;
   };
   return true;
};

bool cdfg_variable::Compare(cdfg_variable *cv)
{
   if (strcmp(Name(),cv->Name())!=0) return false;
   return true;
};
bool cdfg_signal::Compare(cdfg_signal *cs)
{
   // A complete Compare should also take bit sizes into consideration
   if (strcmp(Name(),cs->Name())!=0) return false;
   return true;
};

void cdfg_signal::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   input *input_tmp;
   internal *internal_tmp;
   output *output_tmp;
   memory *memory_tmp;
   conversion_function *conv_fun;

   input_tmp=Inputs->Member(Name());
   if (input_tmp!=NULL)
   {
      input_tmp->IsReadBy(fsm,true);
      conv_fun=new conversion_function(Name(),input_tmp->Range(),input_tmp->BitSize());
      BitSize(input_tmp->BitSize());
      IsInput(true);
   }
   else
   {
      internal_tmp=Internals->Member(Name());
      if (internal_tmp!=NULL)
      {
	 internal_tmp->IsReadBy(fsm,true);
	 conv_fun=new conversion_function(Name(),internal_tmp->Range(),internal_tmp->BitSize());
	 BitSize(internal_tmp->BitSize());
	 IsInternal(true);
      }
      else
      {
	 output_tmp=Outputs->Member(Name());
	 if (output_tmp!=NULL)
	 {
	    output_tmp->IsReadBy(fsm,true);
	    conv_fun=new conversion_function(Name(),output_tmp->Range(),output_tmp->BitSize());
	    BitSize(output_tmp->BitSize());
	    IsOutput(true);
	 }
	 else
	 {
	    memory_tmp=Memories->Member(Name());
	    if (memory_tmp!=NULL)
	    {
	       memory_tmp->IsReadBy(fsm,true);
//	       conv_fun=new conversion_function(Name(),memory_tmp->Range(),memory_tmp->BitSize());
	       BitSize(output_tmp->BitSize());
	       IsMemory(true);
	    }
	    else
	    {
	       fprintf(error_log,"Error:The signal %s has not been declared\n",Name());
	       exit(1);
	    };
	 }
      };
   };
//      conv_fun=ConversionFunctions->AddMember(conv_fun);
//      conv_fun->IsUsedBy(fsm,true);
   if (Range()==NULL)
   {
      Range(new range_class(BitSize()-1,0));
   };
};

void action_cdfg::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   if (IsFunction())
   {
      Arguments()->CheckConsistency(fsm,stream,bit_pos);
   }
   else if (IsConstant())
   {
      Constant()->CheckConsistency(fsm,stream,bit_pos);
   }
   else if (IsVariable())
   {
      Variable()->CheckConsistency(fsm,stream,bit_pos);
   }
   else if (IsSignal())
   {
      Signal()->CheckConsistency(fsm,stream,bit_pos);
   };
};

void action_arguments::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->CheckConsistency(fsm,stream,bit_pos);
   };
};

void cdfg_constant::write_driver(FILE *file)
{
   if (is_numeric)
   {
//      fprintf(file,"\"%s\")",NatToUnsigned(number));
      fprintf(file,"\"%s\")",int2bits(number));
   }
   else
   {
      fprintf(file,"\"%s\")",c_number);
   };
};
void cdfg_variable::write_driver(FILE *file)
{
   fprintf(file,"%s",name);
};
void cdfg_variable::write_driver(FILE *file,int fsm, input_stream *stream,int bp)
{
   fprintf(file,"%s",name);
};

void cdfg_signal::write_driver(FILE *file)
{
   int from,to;
   if (Range()==NULL)
   {
      fprintf(error_log,"BUG::The range of cdfg_signal %p(%s) is missing\n",this,Name());
      exit(1);
   };
   from=Range()->Left();
   to=Range()->Right();
   if (BitSize()==1)
   {
      fprintf(file,"%s",Name());
   }
   else
   {
      fprintf(file,"%s(%d downto %d)",Name(),to,from);
   };
};

void cdfg_constant::PrintCDFG(FILE *file)
{
   if (is_numeric)
   {
//      fprintf(file,"STD_LOGIC_VECTOR'(\"%s\")",NatToUnsigned(number));
      fprintf(file,"std_logic_vector'(\"%s\")",int2bits(number));
   }
   else
   {
      fprintf(file,"\"%s\"",c_number);
   };
};
void cdfg_variable::BitPos(productions *p,int bp)
{
	return;
};
void cdfg_signal::BitPos(productions *p,int bp)
{
	return;
};
void mux_condition::BitPos(productions *p,int bp)
{
	return;
};

void cdfg_variable::PrintCDFG(FILE *file)
{
   fprintf(file,"%s",name);
};

void cdfg_signal::PrintCDFG(FILE *file)
{
   int from,to;
   if (Range()==NULL)
   {
      fprintf(error_log,"BUG::The range of cdfg_signal %p(%s) is missing\n",this,Name());
      exit(1);
   };
   from=Range()->Left();
   to=Range()->Right();
   if (BitSize()==1)
   {
      fprintf(file,"%s",Name());
   }
   else
   {
      fprintf(file,"%s(%d downto %d)",Name(),to,from);
   };
};

void action_cdfg::write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos)
{
   if (IsFunction())
   {
      fprintf(file,"%s",Function());
      Arguments()->write_driver(file,fsm,stream,bit_pos);
   }
   else if (IsConstant())
   {
      Constant()->write_driver(file);
   }
   else if (IsVariable())
   {
      Variable()->write_driver(file,fsm,stream,bit_pos);
   }
   else if (IsSignal())
   {
      Signal()->write_driver(file);
   };
};

void action_arguments::write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos)
{
   fprintf(file,"(");
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->write_driver(file,fsm,stream,bit_pos);
      if (i!=NrOfMembers()-1)
      {
	 fprintf(file,",");
      };
   };
   fprintf(file,")");
};

void action_cdfg::PrintCDFG(FILE *file,int fsm,input_stream *stream,int bit_pos)
{
   if (IsFunction())
   {
      fprintf(file,"%s",Function());
      Arguments()->PrintCDFG(file,fsm,stream,bit_pos);
   }
   else if (IsConstant())
   {
      Constant()->PrintCDFG(file);
   }
   else if (IsVariable())
   {
      Variable()->PrintVariable(file,fsm,stream,bit_pos);
   }
   else if (IsSignal())
   {
      Signal()->PrintSignal(file,fsm,stream,bit_pos);
   };
};

void action_arguments::PrintCDFG(FILE *file,int fsm,input_stream *stream,int bit_pos)
{
   fprintf(file,"(");
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->PrintCDFG(file,fsm,stream,bit_pos);
      if (i!=NrOfMembers()-1)
      {
	 fprintf(file,",");
      };
   };
   fprintf(file,")");
};

void action_cdfg::BitPos(productions *p, int bp)
{
   if (IsFunction())
   {
      Arguments()->BitPos(p,bp);
   }
   else if (IsSignal())
   {
      Signal()->BitPos(p,bp);
   }
   else if (IsVariable())
   {
      Variable()->BitPos(p,bp);
   };
};

void action_arguments::BitPos(productions *p,int bp)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->BitPos(p,bp);
   };
};

void action_target::BitPos(productions *p, int bp)
{
   Address()->BitPos(p,bp);
};


void action_address::BitPos(productions *p, int bp)
{
   if (IsVariable()) 
   {
      Variable()->BitPos(p,bp);
   };
};

void action_signal::BitPos(productions *p, int bp)
{
   Address()->BitPos(p,bp);
};

void action_variable::BitPos(productions *p, int bp)
{
   production *prod;
   prod=Grammars->Member(Name());
   if (prod==NULL)
   {
      fprintf(error_log,"Error: Production variable %s has not been defined\n",Name());
      exit(1);
   };
   if (!prod->IsReferenceable())
   {
     fprintf(error_log,"Error: Production %s contains branches with different sizes and can therefore NOT be used for variable referencing\n",Name());
     exit(1);
   };

   int match=-1;
   int matchpos=RefPos();
   //   fprintf(error_log,"%s %d::\n",Name(),RefPos());
   for(int i=0;i<p->NrOfMembers();i++)
   {
      //     fprintf(error_log,"   %s %d\n",p->Member(i)->Name(),i);
      if (strcmp(Name(),p->Member(i)->Name())==0)
      {
         matchpos--;
	 if (matchpos==0)
	 {
	    match=i;
	    break;
	 };
      };
   };
   if (match==-1)
   {
     fprintf(error_log,"Error: Reference #%d of production variable %s could NOT be found\n",RefPos(),Name());
     exit(1);
   };
   //   fprintf(error_log,"match found at %d::",match);
   prod=p->Member(match);
   //   fprintf(error_log,"   %s, %d,%d,%d\n",prod->Name(),prod->BitPos(),bp,prod->BitSize());
   //FirstBit(prod->BitSize()-1);
   //LastBit(prod->BitSize()-1);
   ProdSize(prod->BitSize());
   ProdPos(prod->BitPos());
   SetBitPos(bp);
};

void action_variable::CheckConsistency(int fsm,input_stream *stream,int bp)
{
   production *prod;
   fifo *new_fifo,*current_fifo;
   int current_word,first_word,last_word;

   prod=Grammars->Member(Name());
   if (prod==NULL)
   {
      fprintf(error_log,"Production variable %s has not been defined\n",Name());
      exit(1);
   };
   input_stream_width=stream->BitSize();

   first_word=first_bit/input_stream_width;
//asdf
   current_word=bp/input_stream_width-1;
   first_word=current_word-(first_bit+prod_pos)/input_stream_width;
   last_word=current_word-(last_bit+prod_pos)/input_stream_width;
   new_fifo=new fifo(stream,
				     Starts->Member(fsm)->ClockName(),
					 bit_pos-prod_pos);
		     //first_word+1);
   current_fifo=Fifos->AddMember(new_fifo);
//   fprintf(error_log, "Adding new fifo %s, with %d Members\n", stream->Name(),current_fifo->Depth());
//   fprintf(error_log, "   prod_pos=%d,bp=%d, first_word=%d, first_bit=%d, last_word=%d,last_bit=%d\n", prod_pos, bit_pos, first_word, first_bit, last_word, last_bit);
   if (current_fifo!=new_fifo) delete new_fifo;
   current_fifo->IsReadBy(fsm,true);

   fifo_name=cpystr(current_fifo->Name());
   port_name=cpystr(stream->Name());
   // SetBitPos(bp); // BitPos(bp);
};

void mux_condition::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   Signal()->CheckConsistency(fsm,stream,bit_pos);
   if (IsSignal())
   {
      Signal2()->CheckConsistency(fsm,stream,bit_pos);
   };
};

void mux_expression::BitPos(productions *p,int bp)
{
   if (IsAnd())
   {
      And()->BitPos(p,bp);
   }
   else
   {
      Condition()->BitPos(p,bp);
   };
};

void mux_expression::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   if (IsAnd())
   {
      And()->CheckConsistency(fsm,stream,bit_pos);
   }
   else
   {
      Condition()->CheckConsistency(fsm,stream,bit_pos);
   };
};

void mux_and::BitPos(productions *p,int bp)
{
  left->BitPos(p,bp);
  right->BitPos(p,bp);
};

void mux_and::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   left->CheckConsistency(fsm,stream,bit_pos);
   right->CheckConsistency(fsm,stream,bit_pos);
};

bool mux_and::Compare(mux_and *and2)
{
   if (Left()->Compare(and2->Left()))
   {
      return Right()->Compare(and2->Right());
   };
   return false;
};

bool mux_condition::Compare(mux_condition *cond2)
{
   if ((Signal()->Compare(cond2->Signal())) &&
       (Condition()==cond2->Condition()) &&
       (IsSignal()==cond2->IsSignal()))
   {
      if (IsSignal())
      {
	 return Signal2()->Compare(cond2->Signal2());
      }
      else if (strcmp(Value(),cond2->Value())==0)
      {
	 return true;
      };
   };
   return false;
};

bool mux_expression::Compare(mux_expression *expr2)
{
   if (Type()==expr2->Type())
   {
      if (IsAnd())
      {
	 return And()->Compare(expr2->And());
      }
      else
      {
	 return Condition()->Compare(expr2->Condition());
      };
   };
   return false;
};

void mux_expression::write_driver(FILE *file,int fsm,input_stream *stream,int bp,int ind)
{
   if (IsAnd())
   {
      fprintf(file,"(");
      And()->write_driver(file,fsm,stream,bp,ind);
      fprintf(file,")");
   }
   else
   {
      Condition()->PrintCondition(file,fsm,stream,bp);
   }
};

void mux_expression::PrintAction(FILE *file,int fsm,input_stream *stream,int bp,int ind)
{
   if (IsAnd())
   {
      fprintf(file,"(");
      And()->PrintAction(file,fsm,stream,bp,ind);
      fprintf(file,")");
   }
   else
   {
      Condition()->PrintCondition(file,fsm,stream,bp);
   }
};

void mux_and::write_driver(FILE *file,int fsm,input_stream *stream,int bp, int ind)
{
   left->write_driver(file,fsm,stream,bp,ind);
   fprintf(file," AND \n");
   indent(file,ind);
   right->write_driver(file,fsm,stream,bp,ind);
};
void mux_and::PrintAction(FILE *file, int fsm,input_stream *stream, int bp,int ind)
{
   left->PrintAction(file,fsm,stream,bp,ind);
   fprintf(file," AND \n");
   indent(file,ind);
   fprintf(file,"                ");
   right->PrintAction(file,fsm,stream,bp,ind);
};

void mux_condition::write_driver(FILE *file,int fsm,input_stream *stream,int bp)
{
   fprintf(file,"(");
   Signal()->write_driver(file,fsm,stream,bp);
   if (Condition())
   {
      fprintf(file,"=");
   }
   else
   {
      fprintf(file,"/=");
   };
   if (IsSignal())
   {
      Signal2()->write_driver(file,fsm,stream,bp);
   }
   else
   {
      fprintf(file,"\"%s\"",Value());
   };
   fprintf(file,")");
};
void mux_condition::PrintCondition(FILE *file,int fsm,input_stream *stream,int bp)
{
	//fprintf(file,"BAKAYARO mux_condition");
   fprintf(file,"(");
   Signal()->write_driver(file,fsm,stream,bp);
   if (Condition())
   {
      fprintf(file,"=");
   }
   else
   {
      fprintf(file,"/=");
   };
   if (IsSignal())
   {
      Signal2()->write_driver(file,fsm,stream,bp);
   }
   else
   {
      fprintf(file,"\"%s\"",Value());
   };
   fprintf(file,")");
};

void mux_condition::PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos)
{
   fprintf(file,"(");
   Signal()->PrintSignal(file,fsm,stream,bit_pos);
   if (Condition())
   {
      fprintf(file,"=");
   }
   else
   {
      fprintf(file,"/=");
   };
   if (IsSignal())
   {
      Signal2()->PrintSignal(file,fsm,stream,bit_pos);
   }
   else
   {
      fprintf(file,"std_logic_vector'(\"%s\")",Value());
   };
   fprintf(file,")");
};

bool action_muxed_line::Compare(action_muxed_line *mux2)
{
   if ((Expression()->Compare(mux2->Expression())) &&
       (TrueBranch()->Compare(mux2->TrueBranch())) &&
       (FalseBranch()->Compare(mux2->FalseBranch())))
   {
      return true;
   };
   return false;
};

void action_muxed_line::BitPos(productions *p,int bp)
{
   Expression()->BitPos(p,bp);
   TrueBranch()->BitPos(p,bp);
   FalseBranch()->BitPos(p,bp);
};

void action_muxed_line::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   Expression()->CheckConsistency(fsm,stream,bit_pos);
   TrueBranch()->CheckConsistency(fsm,stream,bit_pos);
   FalseBranch()->CheckConsistency(fsm,stream,bit_pos);
};

extern actions *Actions;
action_line *action_macro::ExpandActionMacros(void)
{
   action *act;
   act=Actions->Member(Name());
   if (act==NULL)
   {
      fprintf(error_log,
	      "Error:The macro name %s has not been defined\n",
	      Name());
      exit(1);
   }
   else
   {
      return act->ExpandActionMacros();
   };
};

bool action_item::Compare(action_item *a)
{
   if (Type()!=a->Type()) return false;
   if (IsConstant())
   {
      return item.constant->Compare(a->Constant());
   }
   else if (IsSignal())
   {
      return item.signal->Compare(a->Signal());
   }
   else if (IsVariable())
   {
      return item.variable->Compare(a->Variable());
   }
   else if (IsCDFG())
   {
      return item.cdfg->Compare(a->CDFG());
   };
   return false;
};

int action_item::BitSize(void)
{
   if (IsConstant())
   {
      return item.constant->BitSize();
   }
   else if (IsSignal())
   {
      return item.signal->BitSize();
   }
   else if (IsVariable())
   {
      return item.variable->BitSize();
   }
   else if (IsCDFG())
   {
      return item.cdfg->BitSize();
   };
   fprintf(error_log,"Bug in action_item::BitSize()!!! Unknown Item type %d\n",Type());
   exit(1);
};

void action_item::write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos,int target_size)
{
   if (IsConstant())
   {
      item.constant->write_driver(file);
   }
   else if (IsSignal())
   {
      item.signal->write_driver(file);
   }
   else if (IsVariable())
   {
      item.variable->write_driver(file,fsm,stream,bit_pos);
   }
   else if (IsCDFG())
   {
      item.cdfg->write_driver(file,fsm,stream,bit_pos);
   };
};
void action_item::PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int target_size)
{
   if (IsConstant())
   {
      item.constant->PrintConstant(file);
   }
   else if (IsSignal())
   {
      item.signal->PrintSignal(file,fsm,stream,bit_pos);
   }
   else if (IsVariable())
   {
      item.variable->PrintVariable(file,fsm,stream,bit_pos);
   }
   else if (IsCDFG())
   {
      item.cdfg->PrintCDFG(file,fsm,stream,bit_pos);
   };
};

void action_item::BitPos(productions *p,int bp)
{
   if (IsSignal())
   {
      Signal()->BitPos(p,bp);
   }
   else if (IsVariable())
   {
      Variable()->BitPos(p,bp);
   }
   else if (IsCDFG())
   {
      CDFG()->BitPos(p,bp);
   }
   else if (IsMux())
   {
      Mux()->BitPos(p,bp);
   };
};

void action_item::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   if (IsSignal())
   {
      Signal()->CheckConsistency(fsm,stream,bit_pos);
   }
   else if (IsVariable())
   {
      Variable()->CheckConsistency(fsm,stream,bit_pos);
   }
   else if (IsCDFG())
   {
      CDFG()->CheckConsistency(fsm,stream,bit_pos);
   }
   else if (IsMux())
   {
      Mux()->CheckConsistency(fsm,stream,bit_pos);
   };
   //   else
   //   {
   // fprintf(error_log,"Error: Type %d in CheckConsistency not implemented yet!!!\n",Type());
   // exit(1);
   // };
};

void action_line::AddMember(action_item *i)
{
   action_item *last_memb;
   if (NrOfMembers()>0)
   {
      last_memb=Member(NrOfMembers()-1);
      if ((i->IsConstant()) && 
	  (last_memb->IsConstant()))
      {
	 last_memb->Constant()->AddToValue(i->Value());
      }
      else
      {
	 List<action_item>::AddMember(i);
      };
   }
   else
   {
      List<action_item>::AddMember(i);
   };
};

void action_line::AddMembers(action_line *l)
{
   int i;
   for(i=0;i<l->NrOfMembers();i++)
   {
      AddMember(l->Member(i));
   };
};

action_line *action_item::ExpandActionMacros(void)
{
   if (IsMacro())
   {
      return item.macro->ExpandActionMacros();
   }
   else
   {
      return new action_line(this);
   };
};

void action_line::write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos,int target_size)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->write_driver(file,fsm,stream,bit_pos,target_size);
      if (i<NrOfMembers()-1)
      {
	 fprintf(file, " & \n                  ");
      };
   };
};

void action_line::PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int target_size)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->PrintAction(file,fsm,stream,bit_pos,target_size);
      if (i<NrOfMembers()-1)
      {
	 fprintf(file," & \n                  ");
      };
   };
};

action_line *action_line::ExpandActionMacros(void)
{
   int i;
   action_line *exp,*ret;
   ret=NULL;
   for(i=0;i<NrOfMembers();i++)
   {
      exp=Member(i)->ExpandActionMacros();
      if (ret==NULL)
      {
	 ret=exp;
      }
      else
      {
	 ret->AddMembers(exp);
      };
   };
   return ret;
};

void action_line::BitPos(productions *p,int bp)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->BitPos(p,bp);
   };
};

void action_line::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->CheckConsistency(fsm,stream,bit_pos);
   };
};

extern bool ParsingMacros;
action_target::action_target(char *d)
{
   address=new action_address();
   dest=cpystr(d);
   //   fprintf(error_log,"created %08x with dest %08x\n",this,dest);
   input *input_tmp;
   internal *intern_tmp;
   output *output_tmp;
   memory *memory_tmp;

   port_number=1;
   address_size=0;

   IsMemory(false);
   IsOutput(false);
   IsInternal(false);
   IsInput(false);
   input_tmp=Inputs->Member(dest);
   if (input_tmp!=NULL)
   {
      bit_size=input_tmp->BitSize();
      array_size=input_tmp->ArraySize();
      IsInput(true);
   }
   else
   {
      intern_tmp=Internals->Member(dest);
      if (intern_tmp!=NULL)
      {
	 bit_size=intern_tmp->BitSize();
	 array_size=intern_tmp->ArraySize();
	 IsInternal(true);
      }
      else
      {
	 output_tmp=Outputs->Member(dest);
	 if (output_tmp!=NULL)
	 {
	    bit_size=output_tmp->BitSize();
	    array_size=output_tmp->ArraySize();
	    IsOutput(true);
	 }
	 else
	 {
	    memory_tmp=Memories->Member(dest);
	    if (memory_tmp!=NULL)
	    {
 	       bit_size=memory_tmp->BitSize();
	       array_size=0;
	       IsMemory(true);
	    }
	    //	    else
	    //	    {
	    //  fprintf(error_log,
	    //       "Error:The macro name %s has not been defined\n",
	    //        dest);
	    // exit(1);
	    //};
	 };
      };
   };
   Address()->Range(new range_class(bit_size-1,0));
};

action_target::action_target(char *d,action_address *a)
{
   address=a;
   dest=cpystr(d);
   //   fprintf(error_log,"created %08x with dest %08x\n",this,dest);
   input *input_tmp;
   internal *intern_tmp;
   output *output_tmp;
   memory *memory_tmp;
   int left_bit,right_bit;

   port_number=1;
   address_size=0;

   IsMemory(false);
   IsOutput(false);
   IsInternal(false);
   IsInput(false);
   input_tmp=Inputs->Member(dest);
   if (input_tmp!=NULL)
   {
      left_bit=input_tmp->BitSize()-1;
      right_bit=0;
      array_size=input_tmp->ArraySize();
      IsInput(true);
   }
   else
   {
      intern_tmp=Internals->Member(dest);
      if (intern_tmp!=NULL)
      {
	 left_bit=intern_tmp->BitSize()-1;
	 right_bit=0;
	 array_size=intern_tmp->ArraySize();
	 IsInternal(true);
      }
      else
      {
	 output_tmp=Outputs->Member(dest);
	 if (output_tmp!=NULL)
	 {
	    left_bit=output_tmp->BitSize()-1;
	    right_bit=0;
	    array_size=output_tmp->ArraySize();
	    IsOutput(true);
	 }
	 else
	 {
	    memory_tmp=Memories->Member(dest);
	    if (memory_tmp!=NULL)
	    {
 	       left_bit=memory_tmp->BitSize()-1;
	       right_bit=0;
	       array_size=0;
	       IsMemory(true);
	    }
	    else
	    {
	       fprintf(error_log,
		       "Error: The macro name %s has not been defined\n",
		       dest);
	       exit(1);
	    };
	 };
      };
   };
   bit_size=left_bit+1;
   if (Address()->HasRange())
   {
      if ((Range()->High()>left_bit) || (Range()->Low()<right_bit))
      {
	fprintf(error_log,"Error: The Address range of signal %s is out of bounds\n",Dest());
	exit(1);
      }
      left_bit=Range()->Left();
      right_bit=Range()->Right();
   };
   Address()->Range(new range_class(left_bit,right_bit)); // target given by address
};

action_target::action_target(char *d,int n,action_address *a)
{
   address=a;
   dest=cpystr(d);
   input *input_tmp;
   internal *intern_tmp;
   output *output_tmp;
   memory *memory_tmp;
   int left_bit,right_bit;

   // Only multi-port memory accesses are initialized with this method
   if (n<1)
   {
     fprintf(error_log,
	     "Error: Access to multi-port memories must have a port number greater than zero\n"); 
     exit(1);
   }
   
   port_number=n;
   address_size=0;

   IsMemory(true);
   IsOutput(false);
   IsInternal(false);
   IsInput(false);

   memory_tmp=Memories->Member(dest);
   if (memory_tmp!=NULL)
   {
      if (n>memory_tmp->NrOfPorts())
      {
	fprintf(error_log,
	       "Error: Access to port %d of multi-port memory %s is out of bounds\n",n,dest);
	exit(1);
      };
      left_bit=memory_tmp->BitSize()-1;
      right_bit=0;
      address_size=memory_tmp->AddressSize();
   }
   else
   {
      fprintf(error_log,
	      "Error: The memory %s has not been defined\n",
	      dest);
      exit(1);
   };
   bit_size=left_bit+1;
   Address()->Range(new range_class(left_bit,right_bit)); // target given by address
};

/*
action_target::action_target(char *d,range_class *r)
{
   address=new action_address();
   dest=cpystr(d);
   input *input_tmp;
   internal *intern_tmp;
   output *output_tmp;
   memory *memory_tmp;

   IsMemory(false);
   IsOutput(false);
   IsInternal(false);
   IsInput(false);
   port_number=1;
   address_size=0;
   array_size=1;

   input_tmp=Inputs->Member(dest);

   if (input_tmp!=NULL)
   {
      bit_size=input_tmp->BitSize();
      array_size=input_tmp->ArraySize();
      IsInput(true);
   }
   else
   {
      intern_tmp=Internals->Member(dest);
      if (intern_tmp!=NULL)
      {
	 bit_size=intern_tmp->BitSize();
	 array_size=intern_tmp->ArraySize();
	 IsInternal(true);
      }
      else
      {
	 output_tmp=Outputs->Member(dest);
	 if (output_tmp!=NULL)
	 {
	    bit_size=output_tmp->BitSize();
	    array_size=output_tmp->ArraySize();
	    IsOutput(true);
	 }
	 else
	 {
	    memory_tmp=Memories->Member(dest);
	    if (memory_tmp!=NULL)
	    {
 	       bit_size=memory_tmp->BitSize();
	       array_size=0;
	       IsMemory(true);
	    }
	    else
	    {
	       fprintf(error_log,
		       "Error: The macro name %s has not been defined\n",
		       dest);
	       exit(1);
	    };
	 };
      };
   };
   if ((abs(r->Right()-r->Left())+1>bit_size) || (r->Right()>bit_size-1) || (r->Left()>bit_size-1))
   {
      fprintf(error_log,"Error: Range out of bounds of signal %s\n",Dest());
      exit(1);
   };
   target_range=r;
};
*/

action_item::~action_item()
{
   if (IsSignal())
   { 
      delete Signal();
   }
   else if (IsCDFG())
   {
      delete CDFG();
   }
   else if(IsVariable())
   {
      delete Variable();
   } 
   else if (IsConstant())
   {
      delete Constant();
   };	    
};

action_line::~action_line()
{
  for(int i=0;i<NrOfMembers();i++)
  {
    delete Member(i);
  };
};


action::~action()
{
   if (IsVHDL())
   {
      delete target.code;
   }
   else
   {
      delete target.signal;
      if (IsMuxed())
      {
 	 delete act.mux;
      }
      else
      {
	 delete act.line;
      };
   };
};

action_address::~action_address()
{
   if (IsSignal())
   {
      delete Signal();
   }
   else if (IsVariable())
   {
      delete Variable();
   }
   else if (IsConstant())
   {
      delete Constant();
   }
   if (HasRange()) delete Range();
};

action_target::~action_target()
{
   if (dest!=NULL) delete dest;
   delete Address();
   //if (target_range!=NULL) delete target_range;
};

action_cdfg::~action_cdfg()
{
   if (IsFunction())
   {
      delete [] rel.fun;
      delete args;
   }
   else if (IsConstant())
   {
      delete rel.con;
   }
   else if (IsVariable())
   {
      delete rel.var;
   }
   else if (IsSignal())
   {
      delete rel.sig;
   };
};

action_variable::~action_variable()
{
  if (name!=NULL) delete [] name;
  if (port_name!=NULL) delete [] port_name;
  if (fifo_name!=NULL) delete [] fifo_name;
  if (bit_range!=NULL) delete bit_range;
};


void action::write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos,int ind)
{
   if (IsVHDL())
   {
     fprintf(error_log,"Error: write_driver for VHDL code action not implemented YET!!!\n");
   };
   if (IsMuxed())
   {
      indent(file,ind);
      fprintf(file,"            IF ");
      Mux()->Expression()->write_driver(file,fsm,stream,bit_pos,ind);
      fprintf(file," THEN\n");
      Mux()->TrueBranch()->write_driver(file,fsm,stream,bit_pos,ind+1);
      indent(file,ind);
      fprintf(file,"            ELSE\n");
      Mux()->FalseBranch()->write_driver(file,fsm,stream,bit_pos,ind+1);
      indent(file,ind);
      fprintf(file,"            END IF");
   }
   else
   {
      Target()->write_driver(file,stream,bit_pos,ind);
      Line()->write_driver(file,fsm,stream,bit_pos,BitSize());
   };
   fprintf(file,";\n");
};

void action_target::write_driver(FILE *file,input_stream *stream,int bit_pos,int ind)
{
   // A driver cannot handle multiport memories YET
   indent(file,ind);
   if (Address()!=NULL)
   {
      fprintf(file, "            %s(%s) <= ",Dest(),Address());
   }
   else
   {
      fprintf(file, "            %s <= ",Dest());
   };
};

void vhdl_code::PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int ind)
{
//   indent(file,ind);
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->PrintAction(file,fsm,stream,bit_pos,ind);
   };
//   fprintf(file,"\n");
};

void vhdl_atom::PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int ind)
{
   if (IsVHDL())
   {
//      indent(file,ind+4);
      fprintf(file,"%s ",code.code);
   }
   else
   {
      Variable()->PrintVariable(file,fsm,stream,bit_pos,ind);
   };
};

void action::PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int ind)
{
   if (IsVHDL())
   {
     VHDLCode()->PrintAction(file,fsm,stream,bit_pos,0);
     return;
   };
   if (IsMuxed())
   {
      indent(file,ind);
      fprintf(file,"            IF ");
      Mux()->Expression()->PrintAction(file,fsm,stream,bit_pos,ind);
      fprintf(file," THEN\n");
      Mux()->TrueBranch()->PrintAction(file,fsm,stream,bit_pos,ind+1);
      indent(file,ind);
      fprintf(file,"            ELSE\n");
      Mux()->FalseBranch()->PrintAction(file,fsm,stream,bit_pos,ind+1);
      indent(file,ind);
      fprintf(file,"            END IF");
   }
   else
   {
     //     fprintf(file,"-- %08x\n",this);
      Target()->PrintAction(file,fsm,stream,bit_pos,ind,Line(),BitSize());
   };
   fprintf(file,";\n");
};

void action_signal::PrintMemoryAccess(FILE *file,int ind)
{
   if (IsMemory())
   {
      indent(file,ind);
      fprintf(file,"            %s_address(%d downto %d)<=%s;\n",Name(),PortNumber()*AddressSize()-1,(PortNumber()-1)*AddressSize(),Address());
      indent(file,ind);
      fprintf(file,"            %s_ae(%d downto %d)<='1';\n",Name(),PortNumber(),PortNumber());
      indent(file,ind);
      fprintf(file,"            %s_rw(%d downto %d)<='1';\n",Name(),PortNumber(),PortNumber());
   };
};

void cdfg_signal::PrintMemoryAccess(FILE *file,int ind)
{
   if (IsMemory())
   {
      indent(file,ind);
      fprintf(file,"            %s_address<=%s;\n",Name(),Address());
      indent(file,ind);
      fprintf(file,"            %s_ae<='1';\n",Name());
      indent(file,ind);
      fprintf(file,"            %s_rw<='1';\n",Name());
   };
};

void action_cdfg::PrintMemoryAccess(FILE *file,int ind)
{
   if (IsSignal())
   {
      Signal()->PrintMemoryAccess(file,ind);
   };
};

void action_item::PrintMemoryAccess(FILE *file, int ind)
{
   if (IsCDFG())
   {
      CDFG()->PrintMemoryAccess(file,ind);
   }
   else if (IsSignal())
   {
      Signal()->PrintMemoryAccess(file,ind);
   };
};

void action_line::PrintMemoryAccess(FILE *file, int ind)
{
  for(int i=0;i<NrOfMembers();i++)
  {
     Member(i)->PrintMemoryAccess(file,ind);
  };
};

void action_target::PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int ind,action_line *line,int bit_size)
{
   line->PrintMemoryAccess(file,ind);
   indent(file,ind);
   if (!IsMemory())
   {
      if (ArraySize()>1)
      {
	 if (Address()->IsVoid())
	 {
	    fprintf(error_log,"Bug!!!: Array access from %s can never have a void address\n",Dest());
	    exit(1);
	 }
	 else if (Address()->IsSignal())
	 {
	    fprintf(file,"            FOR i IN %d DOWNTO 0 LOOP\n",ArraySize()-1);
	    indent(file,ind);
	    fprintf(file,"               IF (i=CONV_INTEGER(unsigned(%s))) THEN\n",Address()->Signal());
	    indent(file,ind);
	    if (Range()!=NULL)
	    {
	       fprintf(file,
	       "                  %s_register(i*%d+%d downto (i-1)*%d+%d) <= ",
	       Dest(),
	       BitSize(),
	       Range()->High(),
	       BitSize(),
	       Range()->Low());
	    }
	    else
	    {
	       fprintf(file,"                  %s_register <= ",Dest());
	    };
	    line->PrintAction(file,fsm,stream,bit_pos,bit_size);
	    fprintf(file,";\n");
	    indent(file,ind);
	    fprintf(file,"               END IF;\n");
	    indent(file,ind);
	    fprintf(file,"            END LOOP");
 	 }
	 else if (Address()->IsVariable())
	 {
	   // fprintf(file,"-- There is a bug in the Variable printout - only debugging info will be printed\n");
	    fprintf(file,"            FOR i IN %d DOWNTO 0 LOOP\n",ArraySize()-1);
	    indent(file,ind);
	    fprintf(file,"               IF (i=CONV_INTEGER(unsigned(");
	    Address()->Variable()->PrintVariable(file,fsm,stream,bit_pos);
	    fprintf(file,"))) THEN\n");
	    indent(file,ind);
	    if (Range()!=NULL)
	    {
	       fprintf(file,
		       "                  %s_register(i*%d+%d downto i*%d+%d) <= ",
		       Dest(),
		       BitSize(),
		       Range()->High(),
		       BitSize(),
		       Range()->Low());
	    }
	    else
	    {
	       fprintf(file,"                  %s_register <= ",Dest());
	    };
	    line->PrintAction(file,fsm,stream,bit_pos,bit_size);
	    fprintf(file,";\n");
	    indent(file,ind);
	    fprintf(file,"               END IF;\n");
	    indent(file,ind);
	    fprintf(file,"            END LOOP");
	 }
	 else if (Address()->IsConstant())
	 {
	    if (Range()!=NULL)
	    {
	       fprintf(file,
		       "            %s_register(%d*%d+%d downto %d*%d+%d) <= ",
		       Dest(),
		       Address()->Constant()->Integer(),
		       BitSize(),
		       Range()->High(),
		       Address()->Constant()->Integer(),
		       BitSize(),
		       Range()->Low());
	    }
	    else
	    {
	       fprintf(file,"            %s_register(%d) <= ",Dest(),Address()->Constant()->Integer());
	    };
	    line->PrintAction(file,fsm,stream,bit_pos,bit_size);
	 }
	 else // Range
	 {
	    fprintf(error_log,"Bug!!!: Array access from %s with ranges not supported yet\n",Dest());
	    fprintf(error_log,"Unknown Address Type %d at Address %08x\n",Address()->Type(),Address());
	    exit(1);
	 };
      }
      else // Target has single element access only
      {
	 if (Address()->IsVoid())
	 {
	    if (Range()->LSBFirst())
	    {
	       fprintf(file,"            %s_register(%d to %d) <= ",Dest(),Range()->Low(),Range()->High());
	    }
	    else
	    {
	       fprintf(file,"            %s_register(%d downto %d) <= ",Dest(),Range()->High(),Range()->Low());
	    };
	    line->PrintAction(file,fsm,stream,bit_pos,bit_size);
	 }
	 else if (Address()->IsSignal())
	 {
	    fprintf(error_log,"Bug!!!: Array access requested on a single element register %s\n",Dest());
	    exit(1);
 	 }
	 else if (Address()->IsVariable())
	 {
	    fprintf(error_log,"Bug!!!: Array access requested on a single element register %s\n",Dest());
	    exit(1);
	 }
	 else if (Address()->IsConstant())
	 {
	    fprintf(error_log,"Bug!!!: Array access requested on a single element register %s\n",Dest());
	    exit(1);
	 }
	 else // Range
	 {
	    fprintf(file,"INSERT_BIT(%s_internal,",Dest());
	    line->PrintAction(file,fsm,stream,bit_pos,bit_size);
	    fprintf(file,"(0),%s);",Address());
	    fprintf(error_log,"Bug!!!: Array access from %s with ranges not supported yet",Dest());
	    exit(1);
	 };
      };
   }
   else
   {
      fprintf(file,"            %s_address(%d downto %d)<=%s;\n",Dest(),PortNumber()*AddressSize()-1,(PortNumber()-1)*AddressSize(),Address());
      indent(file,ind);
      fprintf(file,"            %s_data(%d downto %d)<=",Dest(),PortNumber()*AddressSize()-1,(PortNumber()-1)*AddressSize());
      line->PrintAction(file,fsm,stream,bit_pos,bit_size);
      fprintf(file,";\n");
      indent(file,ind);
      fprintf(file,"            %s_ae(%d)<='1';\n",Dest(),PortNumber());
      indent(file,ind);
      fprintf(file,"            %s_rw(%d)<='0'",Dest(),PortNumber());
   };
};

void vhdl_atom::BitPos(productions *p,int bit_pos)
{
   if (IsVariable())
   {
      Variable()->BitPos(p,bit_pos);
   };
};

void vhdl_code::BitPos(productions *p,int bit_pos)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->BitPos(p,bit_pos);
   };
}

void action::BitPos(productions *p,int bit_pos)
{
   Target()->BitPos(p,bit_pos);
   if (IsVHDL())
   {
      VHDLCode()->BitPos(p,bit_pos);
   }
   else
   {
      if (IsMuxed())
      {
	 Mux()->BitPos(p,bit_pos);
      }
      else
      {
	 Line()->BitPos(p,bit_pos);
      };
   };
};

void action_mux::BitPos(productions *p,int bp)
{
   Expression()->BitPos(p,bp);
   TrueBranch()->BitPos(p,bp);
   FalseBranch()->BitPos(p,bp);
};

void action_mux::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   Expression()->CheckConsistency(fsm,stream,bit_pos);
   TrueBranch()->CheckConsistency(fsm,stream,bit_pos);
   FalseBranch()->CheckConsistency(fsm,stream,bit_pos);
};

void vhdl_atom::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   if (IsVariable()) Variable()->CheckConsistency(fsm,stream,bit_pos);
};

void vhdl_code::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->CheckConsistency(fsm,stream,bit_pos);
   };
};


void action_target::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   Address()->CheckConsistency(fsm,stream,bit_pos);
};

void action::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   output *o;
   internal *i;

   if (IsVHDL())
   {
      VHDLCode()->CheckConsistency(fsm,stream,bit_pos);
   }
   else
   {
      Target()->CheckConsistency(fsm,stream,bit_pos);
      o=Outputs->Member(Target()->Dest());
      if (o!=NULL)
      {
         o->IsWrittenBy(fsm,true);
         BitSize(o->BitSize());
      }
      else
      {
         i=Internals->Member(Target()->Dest());
         if (i!=NULL)
         {
	    i->IsWrittenBy(fsm,true);
	    BitSize(i->BitSize());
	 }
	 else
	 {
 	    memory *m=Memories->Member(Target()->Dest());
	    m->IsWrittenBy(fsm,true);  
         };
      };
      if (IsMuxed())
      {
         Mux()->CheckConsistency(fsm,stream,bit_pos);
      }
      else
      {
         Line()->CheckConsistency(fsm,stream,bit_pos);
      };
   };
};

action_line *action::ExpandActionMacros(void)
{
   action_line *ret;
   if (Expanded()) return Line();
   if (IsMuxed())
   {
      fprintf(error_log,"Error: EXPANDING MUXES ARE NOT YET IMPLEMENTED!\n");
      exit(1);
   }
   else
   {
      ret=Line()->ExpandActionMacros();
      Line(ret);
      Expanded(true);
      return ret;
   };
};

actions *actions::Copy(void)
{
   int i;
   actions *ret;
   ret=new actions();
   for(i=0;i<NrOfMembers();i++)
   {
      ret->AddMember(Member(i));
   };
   return ret;
//   return this;
};

extern bool ParsingMacros;
void actions::AddMember(action *a)
{
  //    fprintf(error_log,"BAKAYARO %08x->%08x->%08x\n",a,a->Target(),a->Target()->Dest());
    //  if (a->Target()==NULL)
    //{
    //};
   if (!a->IsVHDL())
   {
      if (!ParsingMacros)
      {
	 if (Outputs->Member(a->Target()->Dest())==NULL)
	 {
	    if (Internals->Member(a->Target()->Dest())==NULL)
	    {
	       if (Memories->Member(a->Target()->Dest())==NULL)
	       {
		  fprintf(error_log,"The signal %s has not been declared\n",a->Target()->Dest());
		  exit(1);
	       };
	    };
	 };
      }
      else
      {
         if (Member(a->Target()->Dest())!=NULL)
	 {
	    fprintf(error_log,"The macro %s has already been declared\n",a->Target()->Dest());
	    exit(1);
	 };
      };
   };
   List<action>::AddMember(a);
};

void actions::AddMembers(actions *a)
{
   int i;
   for(i=0;i<a->NrOfMembers();i++)
   {
      AddMember(a->Member(i));
   };
};

action *actions::Member(char *s)
{
   int i;
   action *ret;
   ret=NULL;
   for(i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Target()->Dest())==0)
      {
	 ret=Member(i);
	 break;
      };
   };
   return ret;
};

bool actions::Compare(actions *a2)
{
   int i;
   if (NrOfMembers()!=a2->NrOfMembers()) return false;
   for(i=0;i<NrOfMembers();i++)
   {
//      if (!IsMember(a2->Member(i))) return false;
      if (!Member(i)->Compare(a2->Member(i))) return false;
   };
   return true;
};

void actions::write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->write_driver(file,fsm,stream,bit_pos,2);
   };
};

void actions::PrintAction(FILE *file,int fsm,input_stream *stream,int bp)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->PrintAction(file,fsm,stream,bp,0);
   };
};

void actions::BitPos(productions *p,int bp)
{
   int i;
   bit_pos=bp;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->BitPos(p,bp);
   };
};

void actions::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->CheckConsistency(fsm,stream,bit_pos);
   };
};

void actions::ExpandActionMacros(void)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->ExpandActionMacros();
   };
};

void actions::DumpMembers(FILE *file)
{
	for (int i = 0; i < NrOfMembers(); i++) Member(i)->DumpMember(file);
};


actions *action_schedule::Member(action_target *target)
{
   int i;
   action *act;
   actions *ret;
   for(i=0;i<NrOfMembers();i++)
   {
      ret=Member(i);
      act=ret->Member(0);
      //      fprintf(error_log,"   %d %08x %08x\n",i,Member(i),act);
      if (!act->IsVHDL())
      {
	//	fprintf(error_log,"      (%08x,%d)::Target %08x vs target %08x\n",this,i,act->Target(),target);
         if (act->Target()->Compare(target)) return ret;
      };
   };
   return NULL;
};
void action_schedule::AddMember(actions *a)
{ 
  //   fprintf(error_log,"Adding member %08x to %08x\n",a,this);
  // fprintf(error_log,"  %d Member(s)\n",NrOfMembers());
   if (a->NrOfMembers()>0)
   {
      List<actions>::AddMember(a);
   };
   // fprintf(error_log,"  %d Member(s)\n",NrOfMembers());
};

void action_schedule::AddMembers(action_schedule *as)
{
   int i;
   for(i=0;i<as->NrOfMembers();i++)
   {
      actions *tmp=as->Member(i)->Copy();
      AddMember(tmp);
      //      fprintf(error_log,"Adding member %08x\n",tmp);
   };
};

void action_schedule::write_driver(FILE *file, int fsm,input_stream *stream,int bit_pos)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->write_driver(file,fsm,stream,bit_pos);
   };
};
void action_schedule::PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->PrintAction(file,fsm,stream,bit_pos);
   };
};

void action_schedule::CheckConsistency(int fsm,input_stream *stream,int bit_pos)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->CheckConsistency(fsm,stream,bit_pos);
   };
};

action_signal::action_signal(char *n)
{
   input *input_tmp;
   internal *intern_tmp;
   output *output_tmp;
   memory *memory_tmp;

   IsMemory(false);
   IsOutput(false);
   IsInternal(false);
   IsInput(false);
   port_number=1;
   address_size=0;

   name=cpystr(n);
   address=new action_address();

   input_tmp=Inputs->Member(n);
   //   fprintf(error_log,"%s\n",Name());
   if (input_tmp!=NULL)
   {
      bit_size=input_tmp->BitSize();
      array_size=input_tmp->ArraySize();
      IsInput(true);
   }
   else
   {
      intern_tmp=Internals->Member(n);
      if (intern_tmp!=NULL)
      {
	 bit_size=intern_tmp->BitSize();
	 array_size=intern_tmp->ArraySize();
	 IsInternal(true);
      }
      else
      {
	 output_tmp=Outputs->Member(n);
	 if (output_tmp!=NULL)
	 {
	    bit_size=output_tmp->BitSize();
	    array_size=output_tmp->ArraySize();
	    IsOutput(true);
	 }
	 else
	 {
	    memory_tmp=Memories->Member(n);
	    if (memory_tmp!=NULL)
	    {
	       bit_size=memory_tmp->BitSize();
	       array_size=0;
	       IsMemory(true);
	    }
	    else
	    {
	       fprintf(error_log,
		       "Error: The macro name %s has not been defined\n",
		       n);
	       exit(1);
	    };
	 };
      };
   };
   Address()->Range(new range_class(bit_size-1,0));
   negate=false;
};

action_signal::action_signal(char *n, int p, action_address *a)
{
   input *input_tmp;
   internal *intern_tmp;
   output *output_tmp;
   memory *memory_tmp;

   IsMemory(false);
   IsOutput(false);
   IsInternal(false);
   IsInput(false);
   port_number=1;
   address_size=0;
   address=a;
   
   if (p<1)
   {
     fprintf(error_log,
	     "Error: Access to multi-port memories must have a port number greater than zero\n"); 
     exit(1);
   }

   input_tmp=Inputs->Member(n);
   if (input_tmp!=NULL)
   {
      name=cpystr(n);
      bit_size=input_tmp->BitSize();
      array_size=input_tmp->ArraySize();
      IsInput(true);
   }
   else
   {
      intern_tmp=Internals->Member(n);
      if (intern_tmp!=NULL)
      {
	 name=cpystr(n);
	 bit_size=intern_tmp->BitSize();
	 array_size=intern_tmp->ArraySize();
	 IsInternal(true);
      }
      else
      {
	 output_tmp=Outputs->Member(n);
	 if (output_tmp!=NULL)
	 {
	    name=cpystr(n);
	    bit_size=output_tmp->BitSize();
	    array_size=output_tmp->ArraySize();
	    IsOutput(true);
	 }
	 else
	 {
	    memory_tmp=Memories->Member(n);
	    if (memory_tmp!=NULL)
	    {
	       name=cpystr(n);
	       bit_size=memory_tmp->BitSize();
	       array_size=0;
//fprintf(error_log,"-- %s %d\n",name,bit_size);
	       IsMemory(true);
	       port_number=p;
	       address_size=memory_tmp->AddressSize();
	       if (p>memory_tmp->NrOfPorts())
	       {
		 fprintf(error_log,
			 "Error: Access to port %d of multi-port memory %s is out of bounds\n",p,name);
		 exit(1);
	       };
	    }
	    else
	    {
	       fprintf(error_log,
		       "Error: The macro name %s has not been defined\n",
		       n);
	       exit(1);
	    };
	 };
      };
   };
   if (Range()==NULL)
   {
      Address()->Range(new range_class(bit_size-1,0));
   }
   else
   {
      if ((Range()->Right()>=BitSize()) || (Range()->Left()<0))
      {
	 fprintf(error_log,
		 "Error: The specified bit range is wider than signal %s\n",
		 n);
	 exit(1);
      };
      bit_size=abs(Range()->Right()-Range()->Left())+1;
   };
   negate=false;
};

action_signal::action_signal(char *n, bool neg)
{
   input *input_tmp;
   internal *intern_tmp;
   output *output_tmp;
   memory *memory_tmp;

   IsMemory(false);
   IsOutput(false);
   IsInternal(false);
   IsInput(false);
   port_number=1;
   address_size=0;

   address=new action_address();

   input_tmp=Inputs->Member(n);
   if (input_tmp!=NULL)
   {
      name=cpystr(n);
      bit_size=input_tmp->BitSize();
      array_size=input_tmp->ArraySize();
      IsInput(true);
   }
   else
   {
      intern_tmp=Internals->Member(n);
      if (intern_tmp!=NULL)
      {
	 name=cpystr(n);
	 bit_size=intern_tmp->BitSize();
	 array_size=intern_tmp->ArraySize();
	 IsInternal(true);
      }
      else
      {
	 output_tmp=Outputs->Member(n);
	 if (output_tmp!=NULL)
	 {
	    name=cpystr(n);
	    bit_size=output_tmp->BitSize();
	    array_size=output_tmp->ArraySize();
	    IsOutput(true);
	 }
	 else
	 {
	    memory_tmp=Memories->Member(n);
	    if (memory_tmp!=NULL)
	    {
	       name=cpystr(n);
	       bit_size=memory_tmp->BitSize();
	       array_size=0;
	       IsMemory(true);
	    }
	    else
	    {
	       fprintf(error_log,
		       "Error: The macro name %s has not been defined\n",
		       n);
	       exit(1);
	    };
	 };
      };
   };
   Address()->Range(new range_class(bit_size-1,0));
   negate=neg;
};

action_signal::action_signal(char *n, range_class *r)
{
   input *input_tmp;
   internal *intern_tmp;
   output *output_tmp;
   memory *memory_tmp;

   IsMemory(false);
   IsOutput(false);
   IsInternal(false);
   IsInput(false);
   port_number=1;
   address_size=0;

   address=new action_address(r);

   input_tmp=Inputs->Member(n);
   if (input_tmp!=NULL)
   {
      name=cpystr(n);
      bit_size=input_tmp->BitSize();
      array_size=input_tmp->ArraySize();
      IsInput(true); 
   }
   else
   {
      intern_tmp=Internals->Member(n);
      if (intern_tmp!=NULL)
      {
	 name=cpystr(n);
	 bit_size=intern_tmp->BitSize();
	 array_size=intern_tmp->ArraySize();
	 IsInternal(true);
      }
      else
      {
	 output_tmp=Outputs->Member(n);
	 if (output_tmp!=NULL)
	 {
	    name=cpystr(n);
	    bit_size=output_tmp->BitSize();
	    array_size=output_tmp->ArraySize();
	    IsOutput(true);
	 }
	 else
	 {
	    memory_tmp=Memories->Member(n);
	    if (memory_tmp!=NULL)
	    {
	       name=cpystr(n);
	       bit_size=memory_tmp->BitSize();
	       array_size=0;
	       IsMemory(true);
	    }
	    else
	    {
	       fprintf(error_log,
		       "Error: The macro name %s has not been defined\n",
		       n);
	       exit(1);
	    }
	 };
      };
   };
   //   bit_range=r;
   if (Range()->Pointer()!=NULL)
   {
      char *test;
      bit_size=1;
      test=Range()->Pointer();
      if (Inputs->Member(test)==NULL)
      {
	 if (Internals->Member(test)==NULL)
	 {
	    if (Outputs->Member(test)==NULL)
	    {
	       if (Memories->Member(test)==NULL)
	       {
		  fprintf(error_log,
			  "Error: The signal %s has not been defined\n",
			  test);
		  exit(1);
	       };
	    };
	 };
      };
   }
   else
   {
      if ((Range()->Right()>=BitSize()) || (Range()->Left()<0))
      {
	 fprintf(error_log,
		 "Error: The specified bit range is wider than signal %s\n",
		 n);
	 exit(1);
      };
      bit_size=abs(Range()->Right()-Range()->Left())+1;
   };
   negate=false;
};

action_schedule *action_constant::WordAlignAction(int bit_pos,action_target *target)
{
   int i,bp,b_pos;
   char *new_str;
   action_item *item;
   action_line *line;
   action *act;
   actions *acts;
   action_schedule *ret;
   acts=new actions();
   b_pos=bit_pos;
   int output_stream_width=target->Width();
   for(i=0;i<BitSize();i+=output_stream_width-bp)
   {
      bp=b_pos % output_stream_width;
      b_pos+=output_stream_width-bp;
      new_str=midstr(Value(),i,output_stream_width-bp); 
      item=new action_item(new action_constant(new_str));
      line=new action_line(item);
      line->BitSize(item->BitSize());
      act=new action(target->Copy(),line);
      acts->AddMember(act);
   };
   ret=new action_schedule(acts);
   return ret;
};

action_schedule *cdfg_variable::WordAlignAction(int bit_pos,action_target *target)
{
   int bp,b_pos,pp,p_pos;
   char *new_str;
   production *prod;
   action_variable *var;
   action_item *item;
   action_line *line;
   action *act;
   actions *acts;
   acts=new actions();
   action_schedule *ret;
   int output_stream_width;
   prod=Grammars->Member(Name());
   if (prod==NULL)
   {
      fprintf(error_log,"Error: Production variable %s has not been defined\n",Name());
      exit(1);
   };
   //   ProdPos(prod->BitPos());
   int input_stream_width=prod->Stream()->BitSize();
   if (target==NULL)
   {
      output_stream_width=input_stream_width;
   }
   else
   {
      output_stream_width=target->Width();
   };

   b_pos=bit_pos; // Current writing position is in bit_pos
   bp=b_pos % output_stream_width;
   p_pos=ProdPos(); // Current Reading position is in ProdPos()
   pp=p_pos % input_stream_width;

   // fprintf(error_log,"-- %s %d %d %d %d %d\n",Name(),prod->BitSize(),ProdPos(),BitPos(),output_stream_width,input_stream_width);
 // line=new action_line();
 
   for(int i=0;(p_pos-ProdPos())<prod->BitSize();i+=output_stream_width-bp)
   {
      int bits_to_print=output_stream_width-bp;
// fprintf(error_log,"   %d %d %d %d\n",b_pos,bp,bits_to_print,pp);

      bp=b_pos % output_stream_width;
      b_pos+=output_stream_width-bp;
      for(int j=0;(p_pos-ProdPos())<prod->BitSize();j+=input_stream_width-pp)
      {
	 pp=p_pos % input_stream_width;
	 p_pos+=input_stream_width-pp;

	 var=new action_variable(Name());
	 var->SetBitPos(BitPos()); 
	 var->ProdPos(p_pos);
	 // fprintf(error_log,"%s %d,%d,%d\n",Name(),BitPos(),var->ProdPos(),j);
	 var->FirstBit(input_stream_width-pp-1);
	 int left_to_print=prod->BitSize()-(i+j);
	 //fprintf(error_log,"   -- %08x %d %d %d %d %d %d %d",var,i,j,ProdPos(),prod->BitSize(),pp,left_to_print,input_stream_width);
	 if (pp+left_to_print<input_stream_width)
	 {
	    var->LastBit(input_stream_width-left_to_print-pp);
	 }
	 else
	 {
	    var->LastBit(0);
	 };
	 var->ProdSize(var->FirstBit()-var->LastBit()+1);
	 //fprintf(error_log," %d %d %d %d\n",var->LastBit(),var->FirstBit(),var->ProdPos(),var->BitSize());
         if (target==NULL)
	 {
	    act=new action(new vhdl_code(new vhdl_atom(var)));
	 }
	 else
	 {
	    item=new action_item(var);
	    line=new action_line(item);
	    line->BitSize(var->BitSize());
	    act=new action(target->Copy(),line);
	 };
	 acts->AddMember(act);
      };
//asdf
   };
   var->LastPartition(true);
   ret=new action_schedule(acts);
   // fprintf(error_log,"Partitioned action variable %s into %d partitions\n",Name(),ret->Member(0)->NrOfMembers());
   return ret;
 };

action_schedule *action_variable::WordAlignAction(int bit_pos,action_target *target)
{
   int bp,b_pos,pp,p_pos;
   char *new_str;
   production *prod;
   action_variable *var;
   action_item *item;
   action_line *line;
   action *act;
   actions *acts;
   acts=new actions();
   action_schedule *ret;
   int output_stream_width;
   prod=Grammars->Member(Name());
   if (prod==NULL)
   {
      fprintf(error_log,"Error: Production variable %s has not been defined\n",Name());
      exit(1);
   };
   //   ProdPos(prod->BitPos());
   int input_stream_width=prod->Stream()->BitSize();
   if (target==NULL)
   {
      output_stream_width=input_stream_width;
   }
   else
   {
      output_stream_width=target->Width();
   };

   b_pos=bit_pos; // Current writing position is in bit_pos
   bp=b_pos % output_stream_width;
   p_pos=ProdPos(); // Current Reading position is in ProdPos()
   pp=p_pos % input_stream_width;

   // fprintf(error_log,"-- %s %d %d %d %d %d\n",Name(),prod->BitSize(),ProdPos(),BitPos(),output_stream_width,input_stream_width);
 // line=new action_line();
 
   for(int i=0;(p_pos-ProdPos())<prod->BitSize();i+=output_stream_width-bp)
   {
      int bits_to_print=output_stream_width-bp;
// fprintf(error_log,"   %d %d %d %d\n",b_pos,bp,bits_to_print,pp);

      bp=b_pos % output_stream_width;
      b_pos+=output_stream_width-bp;
      for(int j=0;(p_pos-ProdPos())<prod->BitSize();j+=input_stream_width-pp)
      {
	 pp=p_pos % input_stream_width;
	 p_pos+=input_stream_width-pp;

	 var=new action_variable(Name());
	 var->Range(Range());
	 var->SetBitPos(BitPos()); 
	 var->ProdPos(p_pos);
	 // fprintf(error_log,"%s %d,%d,%d\n",Name(),BitPos(),var->ProdPos(),j);
	 var->FirstBit(input_stream_width-pp-1);
	 int left_to_print=prod->BitSize()-(i+j);
	 //fprintf(error_log,"   -- %08x %d %d %d %d %d %d %d",var,i,j,ProdPos(),prod->BitSize(),pp,left_to_print,input_stream_width);
	 if (pp+left_to_print<input_stream_width)
	 {
	    var->LastBit(input_stream_width-left_to_print-pp);
	 }
	 else
	 {
	    var->LastBit(0);
	 };
	 var->ProdSize(var->FirstBit()-var->LastBit()+1);
	 //fprintf(error_log," %d %d %d %d\n",var->LastBit(),var->FirstBit(),var->ProdPos(),var->BitSize());
         if (target==NULL)
	 {
	    act=new action(new vhdl_code(new vhdl_atom(var)));
	 }
	 else
	 {
	    item=new action_item(var);
	    line=new action_line(item);
	    line->BitSize(var->BitSize());
	    act=new action(target->Copy(),line);
	 };
	 acts->AddMember(act);
      };
//asdf
   };
   var->LastPartition(true);
   ret=new action_schedule(acts);
   // fprintf(error_log,"Partitioned action variable %s into %d partitions\n",Name(),ret->Member(0)->NrOfMembers());
   return ret;
 };

void action_address::WordAlignAddress(range_class *r)
{
   delete Range();
   Range(r);
};

action_schedule *cdfg_signal::WordAlignAction(int bit_pos,action_target *target)
{
   int bp,b_pos;
   actions *acts;
   action *act;
   action_item *item;
   action_line *line;
   int from,to;
   acts=new actions();
   action_schedule *ret;
/*
   if (Range()->Pointer()!=NULL)
   {
      item=new action_item(this);
      line=new action_line(item);
      line->BitSize(item->BitSize());
      act=new action(target->Copy(),line);
      acts->AddMember(act);
      ret=new action_schedule(acts);
      return ret;
   };
*/
   if (IsMemory())
   {
      fprintf(error_log,"Warning: Splitting of Memory Accesses has not been implemented yet!\n");
/*      
      item=new action_item(Copy());
      line=new action_line(item);
      line->BitSize(item->BitSize());
      act=new action(target->Copy(),line);
      acts->AddMember(act);
      ret=new action_schedule(acts);
      return ret;
*/
	  return NULL;
   };
   b_pos=bit_pos;
   int output_stream_width=target->Width();

   bp=b_pos % output_stream_width;
   //fprintf(error_log,"Word Aligning Signal %s to %d bits\n",Name(),output_stream_width);
   for(int i=0;i<Range()->BitSize();i+=output_stream_width-bp)
   {
      bp=b_pos % output_stream_width;
      b_pos+=output_stream_width-bp;

      bool lsb_first=Range()->LSBFirst();
      if (lsb_first)
      {
	 to=Range()->Low()+i+(output_stream_width-bp)-1;
	 from=Range()->Low()+i;
	 if (to>Range()->High()) to=Range()->High();
      }
      else
      {
	 to=Range()->High()-i;
	 from=Range()->High()-i-(output_stream_width-bp)+1;
	 if (from<Range()->Low()) from=Range()->Low();
      }
      // fprintf(error_log,"to %d from %d\n",to,from);
	  fprintf(error_log,"Warning: Splitting of cdfg_signals has not been implemented yet!\n");
/*
      action_signal *new_signal=Copy();
      new_signal->Address()->WordAlignAddress(new range_class(to,from,lsb_first));
      //      fprintf(error_log,"New address is at %08x\n",Address());
      item=new action_item(new_signal);
      line=new action_line(item);
      line->BitSize(to-from+1);
      act=new action(target->Copy(),line);
      //fprintf(error_log,"Adding aligned action member %d at %08x\n",i,act);
      acts->AddMember(act);
*/
   };
   ret=new action_schedule(acts);
   //   fprintf(error_log,"Returned signal is at %08x with %d member(s)\n",ret,ret->NrOfMembers());
   return ret;
};

action_schedule *action_signal::WordAlignAction(int bit_pos,action_target *target)
{
   int bp,b_pos;
   actions *acts;
   action *act;
   action_item *item;
   action_line *line;
   int from,to;
   acts=new actions();
   action_schedule *ret;
/*
   if (Range()->Pointer()!=NULL)
   {
      item=new action_item(this);
      line=new action_line(item);
      line->BitSize(item->BitSize());
      act=new action(target->Copy(),line);
      acts->AddMember(act);
      ret=new action_schedule(acts);
      return ret;
   };
*/
   if (IsMemory())
   {
      fprintf(error_log,"Warning: Splitting of Memory Accesses has not been implemented yet!\n");
      item=new action_item(Copy());
      line=new action_line(item);
      line->BitSize(item->BitSize());
      act=new action(target->Copy(),line);
      acts->AddMember(act);
      ret=new action_schedule(acts);
      return ret;
   };
   b_pos=bit_pos;
   int output_stream_width=target->Width();

   bp=b_pos % output_stream_width;
   //fprintf(error_log,"Word Aligning Signal %s to %d bits\n",Name(),output_stream_width);
   for(int i=0;i<Range()->BitSize();i+=output_stream_width-bp)
   {
      bp=b_pos % output_stream_width;
      b_pos+=output_stream_width-bp;

      bool lsb_first=Range()->LSBFirst();
      if (lsb_first)
      {
	 to=Range()->Low()+i+(output_stream_width-bp)-1;
	 from=Range()->Low()+i;
	 if (to>Range()->High()) to=Range()->High();
      }
      else
      {
	 to=Range()->High()-i;
	 from=Range()->High()-i-(output_stream_width-bp)+1;
	 if (from<Range()->Low()) from=Range()->Low();
      }
      // fprintf(error_log,"to %d from %d\n",to,from);
      action_signal *new_signal=Copy();
      new_signal->Address()->WordAlignAddress(new range_class(to,from,lsb_first));
      //      fprintf(error_log,"New address is at %08x\n",Address());
      item=new action_item(new_signal);
      line=new action_line(item);
      line->BitSize(to-from+1);
      act=new action(target->Copy(),line);
      //fprintf(error_log,"Adding aligned action member %d at %08x\n",i,act);
      acts->AddMember(act);
   };
   ret=new action_schedule(acts);
   //   fprintf(error_log,"Returned signal is at %08x with %d member(s)\n",ret,ret->NrOfMembers());
   return ret;
};
/*
void action_cdfg::Composer(int output_stream_width,int offset)
{
   char tmp[4096];
   if (BitRange()==NULL)
   {
      fprintf(error_log,"ERROR: No range specified for %s\n",Function());
      exit(1);
   };
   if (BitRange()->LSBFirst())
   {
      sprintf(tmp,"%s %d LSB %d %d %d SCHEDULABLE_CODE\n",Function(),BitSize(),WordSize(),offset,output_stream_width);
   }
   else
   {
      sprintf(tmp,"%s %d MSB %d %d %d SCHEDULABLE_CODE\n",Function(),BitSize(),WordSize(),output_stream_width);
   }
   fprintf(error_log,tmp);
   //   system(tmp);
};
*/
int action_cdfg::WordSize(void)
{ 
   return args->WordSize(); 
};

int action_arguments::WordSize(void)
{
   int max_size=0;
   for(int i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->BitSize()>max_size)
      {
	 max_size=Member(i)->BitSize();
      };
   };
   return max_size;
};

// **************************************************************************
// * Functionality: WordAlignAction
// * Latest modification: 2001-09-27
// * 2001-09-27 Fixed a bug in the splitting of action_signal
// **************************************************************************
action_schedule *cdfg_constant::WordAlignAction(int bit_pos,action_target *target)
{
   action_cdfg *cdfg=new action_cdfg(this->Copy());
   action_item *item=new action_item(cdfg);
   action_line *line=new action_line(item);
   line->BitSize(0);
   action *act=new action(target->Copy(),line);
   actions *acts=new actions(act);
   action_schedule *ret=new action_schedule(acts);
   return ret;
};

int temporary_internals=0;
action_schedule *action_cdfg::WordAlignAction(int bit_pos,action_target *target)
{
   actions *acts;
   action *act;
   action_item *item;
   action_line *line;
   action_schedule *ret;
   int output_stream_width=target->Width();

   
   if (ESTIMATE_MODE)
   {
      item=new action_item(new action_constant(repeat('?',output_stream_width)));
      return item->WordAlignAction(bit_pos,target);
   }
   else
   {
     // CDFG should perhaps not always be scheduled...
     // Turning off CDFG scheduling...
     //item=new action_item(this);
     //line=new action_line(item);
     //line->BitSize(item->BitSize());
     //act=new action(target->Copy(),line);
     //acts=new actions(act);
     //ret=new action_schedule(acts);
     //return ret;

     if (IsFunction())
      {
	 cdfg_word_alignment *cdfg=Arguments()->WordAlignAction(bit_pos,target);
	 actions *acts=new actions();
	 int offset=bit_pos % output_stream_width;
//	 Composer(this,output_stream_width,offset,this->BitRange()->Left());

	 int target_width; // target->Width();
	 if (BitRange()!=NULL)
	 {
	    target_width=this->BitRange()->BitSize();
	 }
	 else
	 {
 	    BitRange(new range_class(output_stream_width-1,0));
	    target_width=output_stream_width;
	 };
	 int start_word=bit_pos/output_stream_width;
	 int end_word=(bit_pos+target_width)/output_stream_width;
	 //	 fprintf(error_log,"Target is at %08x::%s\n",target,target->Dest());
	 // fprintf(error_log,"%08x::CDFG target width %d output width %d offset %d::%d %d\n",this,target_width,output_stream_width,offset,start_word,end_word);

	 if (start_word==end_word)
	 {
	    item=new action_item(this);
	    line=new action_line(item);
	    line->BitSize(item->BitSize());
	    act=new action(target->Copy(),line);
	    acts=new actions(act);
	    ret=new action_schedule(acts);
	    return ret;
	 };

	 char *tmp=catstr("tmp_",itoa(temporary_internals++));
	 internal *tmp_internal=new internal(tmp,new array_type(1,target_width));
	 tmp_internal->InitFlags(Starts->NrOfMembers());
	 Internals->AddMember(tmp_internal);

	 action_target *tmp_target=new action_target(tmp);
	 //	 fprintf(error_log,"AA: New action target %08x\n",tmp_target);
	 if (tmp==NULL)
	 {
	   fprintf(error_log,"BUG!!!!\n");
	   exit(1);
	 };

	 // Assign this cdfg to the newly created temporary signal
	 item=new action_item(this->Copy());
	 line=new action_line(item);
	 line->BitSize(item->BitSize());
	 act=new action(tmp_target->Copy(),line);
	 acts->AddMember(act);

	 // int iter=target_width/output_stream_width;
	 //	 fprintf(error_log,"Splitting cdfg: target width %d, source width %d, offset %d\n",target_width,output_stream_width,offset);

	 // Schedule the temporary signal over the output assignments
	 item=new action_item(new action_signal(cpystr(tmp)));
	 ret=item->WordAlignAction(bit_pos,target);
	 int iter=ret->Member(0)->NrOfMembers();
	 //int iter=end_word-start_word;

	 //	 fprintf(error_log,"Item %08x was split into %d partitions\n",item,iter);
	 // Add a signal schedule to the temporary signal of equal size as
	 // the number of partitions of it to the output signal
	 for(int i=0;i<iter;i++)
	 {
	    item=new action_item(new action_signal(cpystr(tmp)));
	    line=new action_line(item);
	    line->BitSize(target_width);
	    act=new action(tmp_target->Copy(),line);
	    acts->AddMember(act);
	 };

	 ret->AddMember(acts);

	 delete tmp_target;
      }
      else if (IsConstant())
      {
	 ret=Constant()->WordAlignAction(bit_pos,target);
      }
      else if (IsVariable())
      {
	 ret=Variable()->WordAlignAction(bit_pos,target);
	 //	 fprintf(error_log,"Returned variable has %d partitions\n",ret->Member(0)->NrOfMembers());
	 return ret;
	 Variable()->FirstBit(Variable()->ProdSize()-1);
	 Variable()->LastBit(0);
	 item=new action_item(this);
	 line=new action_line(item);
	 line->BitSize(0); // This value should never be used
	 act=new action(target->Copy(),line);
	 acts=new actions(act);
	 ret=new action_schedule(acts);
      }
      else if (IsSignal())
      {
	 ret=Signal()->WordAlignAction(bit_pos,target);
	 //	 fprintf(error_log,"Signal Address is at %08x with type %d\n",Signal()->Address(),Signal()->Address()->Type());
      };
   };
   return ret;
};

cdfg_word_alignment *action_arguments::WordAlignAction(int bit_pos,action_target *target)
{
   action_schedule *sched=new action_schedule();
   action_arguments *arg=new action_arguments();
   for(int i=0;i<NrOfMembers();i++)
   {
      action_schedule *tmp=Member(i)->WordAlignAction(bit_pos,target);
      for(int j=0;j<tmp->NrOfMembers();j++)
      {
		  action_item *item=tmp->Member(j)->Member(0)->Line()->Member(0);
		  if (item->IsVariable())
		  {
			  arg->AddMember(new action_cdfg(new cdfg_variable(item->Variable()->Name())));
		  }
		  else if (item->IsCDFG())
		  {
			  arg->AddMember(item->CDFG());
		  }
		  else if (item->IsSignal())
		  {
			  arg->AddMember(new action_cdfg(new cdfg_signal(item->Signal()->Name())));
		  };
	//	 ret->AddMember(tmp->Member(j));
	 //	 tmp->Member(j,NULL);
      };
      //      delete tmp;
   };
   return new cdfg_word_alignment(arg,sched);
};

action_schedule *action_macro::WordAlignAction(int bit_pos,action_target *target)
{
   action_schedule *ret;
   action_line *new_line;
   action *act;

   act=Actions->Member(Name());
   if (act==NULL)
   {
      fprintf(error_log,
	      "Error:The macro name %s has not been defined\n",
	      Name());
      exit(1);
   }
   else
   {
      new_line=act->ExpandActionMacros();
   }
   ret=new_line->WordAlignAction(bit_pos,target);
   return ret;
};

extern productions *Grammars;
action_schedule *action_item::WordAlignAction(int bit_pos,action_target *target)
{
   int i,bits2copy;
   action_schedule *ret;
   action_item *item;
   action_line *line;
   action *act;
   ret=NULL;
   //   fprintf(error_log,"Action is a %d\n",Type());
   if (IsConstant())
   {
      ret=Constant()->WordAlignAction(bit_pos,target);
   }
   else if (IsVariable())
   {
      ret=Variable()->WordAlignAction(bit_pos,target);
   }
   else if (IsMacro())
   {
      ret=Macro()->WordAlignAction(bit_pos,target);
   }
   else if (IsSignal())
   {
      ret=Signal()->WordAlignAction(bit_pos,target);
   }
   else if (IsMux())
   {
      mux_expression *expr;
      action_line *tbr,*fbr;
      action_schedule *tact_sched,*fact_sched;

      tbr=Mux()->TrueBranch();
      fbr=Mux()->FalseBranch();
      expr=Mux()->Expression();

      tact_sched=tbr->WordAlignAction(bit_pos,target);
      fact_sched=fbr->WordAlignAction(bit_pos,target);
      actions *tacts,*facts;
      tacts=tact_sched->Member(0);
      facts=fact_sched->Member(0);
      ret=NULL;
      // the true and false branch of a mux must be of equal size
      // AND MAY NOT CONTAIN ANY CDFG REFERENCES.... (KNOWN BUG!)
      for(i=0;i<facts->NrOfMembers();i++)
      {
	 action *tbra,*fbra;
	 actions *acts;
	 tbra=tacts->Member(i);
	 fbra=facts->Member(i);
	 // insert a mux at every partition
	 act=new action(target->Copy(),new action_muxed_line(expr->Copy(),tbra,fbra));
	 acts=new actions(act);
	 if (ret==NULL)
	 {
	    ret=new action_schedule(acts);
	 }
	 else
	 {
	    ret->AddMember(acts);
	 };
      };
   }
   else if (IsCDFG())
   {
     //     fprintf(error_log,"Detected CDFG\n");
      ret=CDFG()->WordAlignAction(bit_pos,target);
   }
   else
   {
      fprintf(error_log,"WordAlignAction::THE TYPE %d IS NOT IMPLEMENTED YET!\n",Type());
      exit(1);
   };
   if (ret==NULL)
   {
fprintf(error_log,"BUG WARNING!!!\n");
      line=new action_line(this);
      line->BitSize(line->BitSize());
      act=new action(target->Copy(),line);
      return new action_schedule(new actions(act));
   }
   else
   {
      return ret;
   };
};

action_schedule *action_line::WordAlignAction(int bit_pos,action_target *target)
{
   action_schedule *ret;
   actions *ret_acts=new actions();
   action_line *line;
   int i,j,bp;
   ret=new action_schedule();
   //fprintf(error_log,"Return variable at %08x initiated with %d member(s)\n",ret,ret->NrOfMembers());
   bp=bit_pos;
   line=NULL;
   int output_stream_width=target->Width();
   for(i=0;i<NrOfMembers();i++)
   {
      action_schedule *tmp;
      tmp=Member(i)->WordAlignAction(bp,target);
      //fprintf(error_log,"Received schedule %d is at %08x with %d members\n",i,tmp,tmp->NrOfMembers());
      for(int k=0;k<tmp->NrOfMembers();k++)
      {
	actions *acts;
	action *act;
	acts=tmp->Member(k);
	//fprintf(error_log,"Target (%s) is at %08x\n",target->Dest(),target);
	//fprintf(error_log,"   with address at %08x and type %d\n",target->Address(),target->Address()->Type());
	//fprintf(error_log,"Actions is at %08x\n",acts);
	//fprintf(error_log,"Action Member 0 is at %08x\n",acts->Member(0));
	//fprintf(error_log,"Actions target is at %08x\n",acts->Member(0)->Target());
	// CDFG-alignment might produce temporary targets...
	if (target->Compare(acts->Member(0)->Target()))
	{
	   for(j=0;j<acts->NrOfMembers();j++)
	   {
	      if (bp % output_stream_width==0)
	      {
		 act=acts->Member(j);
		 line=act->Line();
		 ret_acts->AddMember(act);
		 //fprintf(error_log,"   Adding member %d at %08x\n",j,act);
	      }
	      else
	      {
		 // WordAligning results in one item per line and 
		 // one line per action
		 if (line==NULL)
		 {
		    fprintf(error_log,"BUG! action_line::WordAlignAction\n");
		    exit(1);
		 };
		 line->AddMembers(acts->Member(j)->Line());
		 line->BitSize(line->BitSize()+acts->Member(j)->Line()->BitSize());
		 //fprintf(error_log,"   Adding line member %d at %08x\n",j,acts->Member(j));
	      }
	      bp+=acts->Member(j)->Line()->BitSize();
	   };
	}
	else
	{
	   // WordAlignment contained a CDFG-calculation...
	   ret->AddMember(acts);
	   //for(int j=0;j<acts->NrOfMembers();j++)
	   //{
	   //   fprintf(error_log,"   Adding CDFG member %d at %08x\n",j,acts->Member(j));
	   //};
	   //fprintf(error_log,"ret at %08x has %d member(s)\n",ret,ret->NrOfMembers());
	};
      };
   };
   //   fprintf(error_log,"%08x:ret at %08x has %d member(s)\n",this,ret,ret->NrOfMembers());
   //fprintf(error_log,"ret_acts at %08x has %d member(s)\n",ret_acts,ret_acts->NrOfMembers());
   ret->AddMember(ret_acts);
//   if (bp!=ret->NrOfMembers()*output_stream_width)
//   {
//      fprintf(error_log,"Error: Size of output %s is not compatible with the width of the input stream!!!\n",target->Dest());
//      fprintf(error_log,"   ...%d bits is missing in the output assignment\n",ret->NrOfMembers()*output_stream_width-bp);
//      exit(1);
//   };
   //   fprintf(error_log,"Action_line::WordAlignAction completed successfully\n");
   //fprintf(error_log,"Returned Schedule at %08x has %d Member(s)\n\n",ret,ret->NrOfMembers());
   return ret;
};

action_schedule *vhdl_atom::WordAlignAction()
{
   if (IsVariable())
   {
      return Variable()->WordAlignAction(0,NULL);
   }
   else
   {
      return new action_schedule(new actions(new action(new vhdl_code(Copy()))));
   };
};

action_schedule *vhdl_code::WordAlignAction()
{
   action_schedule *ret=new action_schedule();
   for(int i=0;i<NrOfMembers();i++)
   {
      ret->AddMembers(Member(i)->WordAlignAction());
   };
   return ret;
}

action_schedule *action::WordAlignAction()
{
   action_schedule *ret;
   if (IsVHDL())
   {
      ret=VHDLCode()->WordAlignAction();
   }
   else
   {
     //      int output_stream_width=abs(Target()->Range()->Right()-Target()->Range()->Left())+1;
      Target()->Elaborate();
      ret=Line()->WordAlignAction(0,Target());
   };
   return ret;
};

// The MoveErrors moves error-tokens last in the list of Succs and
// checks for reduce conflicts caused by multiple error alternatives 
void lexem::MoveErrors(void)
{
   int i,count;
   count=0;
   for(i=0;i<NrOfSuccs();i++)
   {
      if (Succ(i)->IsError())
      {
	 count++;
	 if (i!=NrOfSuccs()-1)
	 {
	    if (count>1)
	    {
	       fprintf(error_log,"Error: Reduce conflict caused by multiple error alternatives\n");
	       exit(1);
	    }
	    else
	    {
	       AddSucc(Succ(i));
	       Succs()->Replace(i,NULL);
	    };
	 }
      }
   };
   Succs()->RemoveNullPointers();
}

void lexem::LinkErrors(void)
{
   int i,count;
   if (Visited()) return;
   Visited(true);
   if (NrOfSuccs()==0) return;
   if (IsLoop()) return;
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->LinkErrors();
   };
   MoveErrors();
   for(i=0;i<NrOfSuccs();i++)
   {
      // A top-level error can be trapped in a global else-statement
      if ((Succ(i)->IsError()) && (NrOfPreds()>0))
      {
	 Succs()->InsertError(Succ(i));
      };
   };
};

void lexem::InsertError(lexem *l)
{
   if (NrOfSuccs()==0) return;
   if (!IsReset())
   {
      if (Succs()->IsMember(l)) return;
      AddSucc(l);
      l->AddPred(this);
   };
   if (IsLoop()) return;
   Succs()->InsertError(l);
};

void lexems::InsertError(lexem *l)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      if (!Member(i)->IsError())
      {
	 Member(i)->InsertError(l);
      };
   };
};

void lexem::LinkOthers(void)
{
   int i;
   if (Visited()) return;
   Visited(true);
   if (NrOfSuccs()==0) return;
   if (IsLoop()) return;
   Succs()->LinkOthers();
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->LinkOthers();
   };
};

void lexems::LinkOthers(void)
{
   int i,other;
   bool found=false;
   for(i=0;i<NrOfMembers();i++)
   {
      if (Member(i)->IsOthers())
      {
	 if ((Member(i)->NrOfSuccs()==1) &&
	     (Member(i)->Succ(0)->IsOthers()))
	 {
	    other=i;
	    found=true;
	    break;
	 };
      };
   };
   if (found)
   {
      lexem *other_lexem;
      other_lexem=Member(other)->Succ(0);
      for(i=0;i<NrOfMembers();i++)
      {
	 lexem *new_lexem;
	 int j;
	 if (i==other) continue;
	 new_lexem=new lexem(other_lexem->Stream(),other_lexem->Terminal()->Copy());
	 Member(i)->AddSucc(new_lexem);
	 for(j=0;j<other_lexem->Succ(0)->NrOfSuccs();j++)
	 {
	    new_lexem->AddSucc(other_lexem->Succ(i));
	    other_lexem->Succ(i)->AddPred(new_lexem);
	 };
      };
   };
};

void lexem::ConnectInterruptEnds(lexem *exit_lexem)
{
   int i;
   if (Visited()) return;
   Visited(true);
   if ((NrOfSuccs()==0) && (this!=exit_lexem))
   {
      AddSucc(exit_lexem);
      exit_lexem->AddPred(this);
      return;
   };
   if (IsLoop()) return;
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->ConnectInterruptEnds(exit_lexem);
   };
   for(i=0;i<NrOfInterrupts();i++)
   {
      Interrupts()->Member(i)->ConnectInterruptEnds(exit_lexem);
   };
};

void lexem::LinkInterrupts(void)
{
   int i;
   // Linking of parallel interrupt constructs must be done after
   // WordAlignment but before scheduling
   if (Visited()) return;
   Visited(true);
   if (!IsLoop())
   {
      int j;
      lexems *new_interrupts=new lexems();
      for(i=0;i<NrOfSuccs();i++)
      {
	 Succ(i)->LinkInterrupts();
      };
      for(i=0;i<NrOfSuccs();i++)
      {
	 for(j=0;j<Succ(i)->NrOfInterrupts();j++)
	 {
	    if (!new_interrupts->IsMember(Succ(i)->Interrupts()->Member(j)))
	    {
	       new_interrupts->AddMember(Succ(i)->Interrupts()->Member(j));
	    };
	 };
      };
      for(i=new_interrupts->NrOfMembers()-1;i>=0;i--)
      {
	 Succs()->AddFirst(new_interrupts->Member(i));
	 Succ(0)->AddPred(this);
	 new_interrupts->Replace(i,NULL);
      };
      delete new_interrupts;
   };
};
   
void lexem::UnlinkInterruptHolders(void)
{
   if (Visited()) return;
   Visited(true);
   if (!IsLoop())
   {
      int i;
      for(i=0;i<NrOfSuccs();i++)
      {
	 Succ(i)->UnlinkInterruptHolders();
      };
      for(i=NrOfInterrupts()-1;i>=0;i--)
      {
	 Interrupts()->Replace(i,NULL);
	 Interrupts()->DelMember(i);
      };
   };
   Visited(true);
};

void lexem::DumpNode(FILE *file)
{
   int i;
   //fprintf(error_log, "%p\n", this);
   if (Type()>PGM_EXIT)
   {
      fprintf(error_log,"Bug: Referencing a Null Node\n");
      exit(1);
   };
   fprintf(error_log, "%p:: (t %d, \"%s\")\n",this,Type(),Value());
   //fprintf(file,"%p:: (t %d,%s &&(%d),L %d LE %d,S %d) (Ss %d) (Ps %d) (Is %d) (As %d) (SAs %d)\n",
	  // this,Type(),Value(),NrOfConds(),IsLoop(),IsLoopEntry(),State(),
	  // NrOfSuccs(),NrOfPreds(),NrOfInterrupts(),
	  // NrOfActions(),NrOfActScheds());
   fprintf(file,"   Succs::%d\n",NrOfSuccs());
   for(i=0;i<NrOfSuccs();i++)
   {
      fprintf(file,"      %p\n",Succ(i));
   };
   fprintf(file,"   Preds::%d\n",NrOfPreds());
   for(i=0;i<NrOfPreds();i++)
   {
      fprintf(file,"      %p\n",Pred(i));
   };
   fprintf(file,"   Interrupts::%d\n",NrOfInterrupts());
   for(i=0;i<NrOfInterrupts();i++)
   {
      fprintf(file,"      %p\n",interrupts->Member(i));
   };
   fprintf(file,"   Actions::%d\n",NrOfActions());
   for(i=0;i<NrOfActions();i++)
   {
      fprintf(file,"      %s[%s]\n",
	      Action(i)->Target()->Dest(),
	      Action(i)->Target()->Address());
   };
   fprintf(file,"   ActionSchedules::%d\n",NrOfActScheds());
   for(i=0;i<NrOfActScheds();i++)
   {
      action *a;
      a=ActScheds()->Member(i)->Member(0);
      fprintf(file,"      %s[%s] -> %d \n",
	      a->Target()->Dest(),a->Target()->Address(),
	      ActScheds()->Member(i)->NrOfMembers());
   };
}

void lexem::DumpGraph(FILE *file)
{
   int i;
   if (Visited())
   {
      fprintf(file,"**** %p **************\n",this);
      return;
   };
   Visited(true);
   DumpNode(file);
   for(i=0;i<NrOfInterrupts();i++)
   {
      Interrupts()->Member(i)->DumpGraph(file);
   };
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->DumpGraph(file);
   };
};

void lexem::DumpDaVinci(FILE *file)
{
   int i;
   if (Visited())
   {
      return;
   };
   Visited(true);
   if (NrOfPreds()==0)
   {
      fprintf(file,"[\n");
   }
   else
   {
      fprintf(file,",\n");
   };
   if (Type()!=0)
   {
      if (IsReset())
      {
	 fprintf(file,"   l(\"%p\",n(\"\",[a(\"OBJECT\",\"Reset(%s=1) -> (S%d)\"),a(\"COLOR\",\"lightgreen\"),a(\"_GO\",\"box\")],[",this,Reset()->Signal(),State());
      }
      else if (IsInterrupt())
      {
	 fprintf(file,"   l(\"%p\",n(\"\",[a(\"OBJECT\",\"Interrupt(%s=1) -> (S%d)\"),a(\"COLOR\",\"lightgreen\"),a(\"_GO\",\"box\")],[",this,Interrupt()->Signal(),State());
      }
      else if (IsError())
      {
	 fprintf(file,"   l(\"%p\",n(\"\",[a(\"OBJECT\",\"Error -> (S%d)\"),a(\"COLOR\",\"lightred\"),a(\"_GO\",\"box\")],[",this,State());
      }
      else
      {
	 fprintf(file,"   l(\"%p\",n(\"\",[a(\"OBJECT\",\"(S%d)\"),a(\"COLOR\",\"lightgreen\"),a(\"_GO\",\"box\")],[",this,State());
      };
   }
   else
   {
      fprintf(file,"   l(\"%p\",n(\"\",[a(\"OBJECT\",\"%s%s -> (S%d)\"),a(\"COLOR\",\"white\"),a(\"_GO\",\"ellipse\")],[",this,Value(),Conds()->DumpDaVinci(),State());
   };
   for(i=0;i<NrOfInterrupts();i++)
   {
      if (i>0)
      {
	 fprintf(file,",");
      };
      fprintf(file,"\n      l(\"%p->%p\",e(\"\",[],r(\"%p\")))",
	      this,
	      Interrupts()->Member(i),
	      Interrupts()->Member(i));
   };
   for(i=0;i<NrOfSuccs();i++)
   {
      if ((NrOfInterrupts()>0) || (i>0))
      {
	 fprintf(file,",");
      };
      if (IsLoop())
      {
	 fprintf(file,"\n      l(\"%p->%p\",e(\"\",[a(\"EDGEPATTERN\",\"dashed\")],r(\"%p\")))",
		 this,
		 Succ(i),
		 Succ(i));
      }
      else
      {
	 fprintf(file,"\n      l(\"%p->%p\",e(\"\",[],r(\"%p\")))",
		 this,
		 Succ(i),
		 Succ(i));
      };
   };
   fprintf(file,"]))");
   for(i=0;i<NrOfInterrupts();i++)
   {
      Interrupts()->Member(i)->DumpDaVinci(file);
   };
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->DumpDaVinci(file);
   };
   if (NrOfPreds()==0)
   {
      fprintf(file,"]\n");
   };
};

void lexem::SplitDAGintoTree(void)
{
   int i;
   if (Visited()) return;
   Visited(true);
   for(i=0;i<NrOfSuccs();i++)
   {
      if ((Succ(i)->NrOfPreds()>1) && (!Succ(i)->IsExit()))
      {
	 int m,j;
	 bool found;
	 m=Succ(i)->Preds()->Find(this);
	 found=false;
	 for(j=0;j<Succ(i)->NrOfPreds();j++)
	 {
	    if (j==m) continue;
	    if (!Succ(i)->Pred(j)->IsLoop())
	    {
	       found=true;
	       break;
	    };
	 };
	 if (found)
	 {
	    lexem *new_succ;
	    new_succ=Succ(i)->Copy();
	    Succ(i)->CopySuccs(new_succ);
	    new_succ->AddPred(this);
	    Succ(i)->Preds()->Replace(m,NULL);
	    Succ(i)->Preds()->DelMember(m);
	    Succs()->Replace(i,new_succ);
	 };
      };
   };
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->SplitDAGintoTree();
   };
};

void lexem::CreateHyperStates(void)
{
   if (Visited()) return;
   Visited(true);
   HyperState(new hyper_state());
   for(int i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->CreateHyperStates();
   }; 
};

void lexem::MergeHyperStates(void)
{
   int i;
   bool *processed;
   if (Visited()) return;
   Visited(true);
   sprintf(log_str, "this %08x type %d Preds %d\n",this, Type(),NrOfPreds());
   log(log_str);
   processed=(bool *)malloc(sizeof(bool)*NrOfPreds());
   for(i=0;i<NrOfPreds();i++) processed[i]=false;
   for(i=0;i<NrOfPreds();i++)
   {
      if (!processed[i])
      {
		  int j;
		  hyper_state *first_state;
		  /* search for identical nodes */
		  first_state=Pred(i)->HyperState();
		  for(j=i+1;j<NrOfPreds();j++)
		  {
			  if (Pred(i)->HyperState()==Pred(j)->HyperState())
			  {
				  log("SKEBE\n");
				  processed[j]=true;
			  }
			  else if (Pred(i) == Pred(j))
			  {
				  log("BAKAYARO\n");
				  // Pointing to the same place??? How is that possible?
				  processed[j] = true;
			  }
			  else
			  {
				  sprintf(log_str, "i %d (%08x) j %d (%08x)\n", i, Pred(i), j, Pred(j));
				  log(log_str);
				  sprintf(log_str, "%08x %08x\n", Pred(i)->Type(), Pred(j)->Type());
				  log(log_str);
				  if (Pred(i)->NrOfSuccs()==Pred(j)->NrOfSuccs())
				  {
					  int k;
					  bool found;
					  found=true;
					  // All Succs of Pred(j) must be contained in the Succs of Pred(i)
					  for(k=0;k<Pred(j)->NrOfSuccs();k++)
					  {
						  sprintf(log_str, "%08x = %08x?\n", Pred(i),Pred(k));
						  log(log_str);
						  if (!(Pred(i)->Succs()->IsMember(Pred(j)->Succ(k))))
						  {
							  found=false;
							  break;
						  };
					  };
					  if (found)
					  {
						  sprintf(log_str, "BAKA %08x j=%d(%08x)\n", first_state, j, Pred(j)->HyperState());
						  log(log_str);
						  // potential memory leak...
						  delete Pred(j)->HyperState();
						  Pred(j)->HyperState(first_state);
						  processed[j]=true;
						  log("Skebe\n");
					  };
				  };
				  log("Ok!\n");
			  };
		  };
      };
   };
   ReduceTailStates();
   for(i=0;i<NrOfPreds();i++)
   {
      Pred(i)->MergeHyperStates();
   }; 
};

void elaboration::Elaborate(void)
{
   input *inp=Inputs->Member(Port());
   if (inp==NULL)
   {
      internal *intern=Internals->Member(Port());
      if (intern==NULL)
      {
	 output *outp=Outputs->Member(Port());
	 // Next to check for is Aliases, 
	 // but they are not fully implemented yet
	 if (outp==NULL)
	 {
	    fprintf(error_log,
		    "Warning: Couldn't elaborate port %s - Port not found\n",
		    Port());
	 }
	 else
	 {
	    outp->BitSize(Width());
	 };
      }
      else
      {
	 intern->BitSize(Width());
      }
   }
   else
   {
      inp->BitSize(Width());
   };
};

void elaborations::Elaborate(void)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      Member(i)->Elaborate();
   };
};

elaboration *elaborations::Member(char *m)
{
   for(int i=0;i<NrOfMembers();i++)
   {
      if (strcmp(Member(i)->Port(),m)==0)
      {
	 return Member(i);
      };
   };
   return NULL;
};


/***************************************************************************/

/*
void lexem::CollectStates(lexems *states)
{
   if (Visited()) return;
   Visited(true);
   if ((IsExit()) && (NrOfSuccs()==0)) return;
   states->AddMember(this);
   for(i=0;i<NrOfSuccs();i++)
   {
      Succ(i)->CollectStates(states);
   };
};

bool lexem::StateActionEquivalence(lexem *l)
{
   int i;
   if (NrOfSuccs()!=l->NrOfSuccs()) return false;
   for(i=0;i<l->NrOfSuccs();i++)
   {
      if (strcmp(l->Succ(k)->Value(),Succ(k)->Value())!=0)
      {
	 int j;
	 for(j=
	 return false;
      }
      else if (!l->Succ(k)->ActScheds()->Compare(Succ(k)->ActScheds()))
      {
	 return false;
      };
   };
   return true;
}

bool lexem::NextStateGroupEquivalence(lexem *l)
{
   for(i=0;i<NrOfSuccs();i++)
   {
      if (Succ(i)->GroupNr()!=l->GroupNr()) return false;
   };
   return true;
};

void state_groups::AddMember(lexem *l)
{
   int i;
   bool found;
   found=false;
   for(i=0;i<NrOfMembers();i++)
   {
      int j;
      lexems *group;
      group=Member(i);
      for(j=0;j<group->NrOfMembers();j++)
      {
	 int k;
	 lexem *group_member;
	 group_member=group->Member(j);
	 if (group_member->StateActionEquivalence(l))
	 {
	    found=true;
	    break;
	 };
      };
      if (found) break;
   };
   if (found)
   {
      l->GroupNr(i);
      Member(i)->AddMember(l);
   }
   else
   {
      l->GroupNr(NrOfMembers());
      AddMember(new lexems(l));
   };
}

void state_groups::ReduceRedundantStates(void)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      int j;
      lexems *group;
      group=Member(i);
      for(j=0;j<group->NrOfMembers();j++)
      {
	 if (group->NextStateGroupEquivalence
	 int k;
	 for(k=j+1;k<group->NrOfMembers();k++)
	 {
	    if (Member(j)->???(Member(k)))
	    {
	    }
	 };

      };
   };
};

binary_transition::binary_transition(char *b,lexem *s)
{
   if (strlen(b)==1)
   {
      binary_transition(s);
   else
   {
      binary_transition(NULL);
      if (b[0]=='1')
      {
	 one=new binary_transition(b+1,s);
      }
      else if (b[0]=='0')
      {
	 zero=new binary_transition(b+1,s);
      }
      else
      {
	 dash=new binary_transition(b+1,s);
      };
   };
};

void binary_transition::AddTransition(binary_transition *b)
{
   if (b->HasZero())
   {
      if (HasZero()) zero->AddTransition(b->Zero());
      if (HasDash())
   }
   else if (HasZero() && b->HasZero())
   {
      zero->AddTransition
   }
};

*/




