#ifndef PROGRAM
#define PROGRAM

#include <string.h>om
#include <stdlib.h>
#include "lib/list.hpp"
#include "lib/rli_string.h"
//#pragma option -Jgx /* unix pragma? */

extern FILE *error_log;
extern char log_str[1024];
extern void log(char *s);
extern int NrOfRemainingNulls;

class lexem;
class input_stream;
class action_item;
class action;
class actions;
class action_schedule;
class action_cdfg;
class action_line;
class action_target;
class action_signal;
typedef List<action_signal> action_signals;
class action_variable;
class action_constant;
class mux_expression;
class technology;
class output_estimates;
class fsm_estimates;
class productions;
class production_terminal;

class type
{
private:
  char *name;
  int size;
public:
  type(char *n,int s) { name=cpystr(n); size=s; };

  int Size(void) { return size; };
};

class types:public List<type>
{
public:
   types():List<type>() {};
   types(type *t):List<type>(t) {};

   type *Member(char *s);
};

class array_type
{
private:
  int array_size,bit_size;
public:
  array_type(int a, int b) { array_size=a; bit_size=b; };
  int  BitSize(void)  { return bit_size; };
  void BitSize(int b) { bit_size=b; };
  int  ArraySize(void)  { return array_size; };
  void ArraySize(int a) { array_size=a; };
  bool IsArray(void) { return (array_size>1); };
};

class vhdl_atom
{
private:
   union {
     action_variable *var;
     char *code; 
   } code;
   enum { VHDL_VARIABLE=0,
	  VHDL_CODE=1 
   } type; 
public:
   vhdl_atom(action_variable *v) { code.var=v; type=VHDL_VARIABLE; };
   vhdl_atom(char *s) { code.code = cpystr(s); type = VHDL_CODE; };
   ~vhdl_atom() {};
   bool IsVHDL(void) { return type==VHDL_CODE; };
   bool IsVariable(void) { return type==VHDL_VARIABLE; };
   action_variable *Variable(void) { return code.var; };
   vhdl_atom *Copy(void);

   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void PrintAction(FILE *file,int fsm,input_stream *stream, int bit_pos,int ind);
   void BitPos(productions *p,int bp);
   action_schedule *WordAlignAction(void);
   void PrintVHDL(FILE *file)
   {
	   if (IsVHDL())
	   {
		   fprintf(file, "%s", code.code);
	   }
   };
};

class vhdl_code:public List<vhdl_atom>
{
public:
   vhdl_code():List<vhdl_atom>() {};
   vhdl_code(vhdl_atom *v):List<vhdl_atom>(v) {};
   vhdl_code *Copy(void);

   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void PrintAction(FILE *file,int fsm,input_stream *stream, int bit_pos,int ind);
   void BitPos(productions *p,int bp);
   action_schedule *WordAlignAction(void);
   void PrintVHDL(FILE *file)
   {
	   for (int i = 0; i < NrOfMembers(); i++)
	   {
		   Member(i)->PrintVHDL(file);
	   }
   };
};

class target_code
{
private:
   int nr_of_members;
   char **members;
public:
   target_code() { members=NULL; nr_of_members=0; }
   ~target_code() { if (members!=NULL) delete [] members; }

   int NrOfMembers(void) { return nr_of_members; };
   void AddMember(char *s);
   void AddMembers(target_code *tc);
   char *Member(int i);

   void PrintTargetCode(FILE *target_file);
};

class constant
{
private:
   char *name;
   char *value;
public:
   constant(char *s, char *v) { name=s; value=v; };
   ~constant() { if (name!=NULL) delete [] name; 
		 if (value!=NULL) delete [] value; };
   char *Name(void) { return name; };
   char *Value(void) { return value; };
};

class constants:public List<constant>
{
public:
   constants():List<constant>() {};
   constants(constant *c):List<constant>(c) {};
   constant *Member(char *s);
   constant *Member(int i) { return List<constant>::Member(i); };
};

class range_class
{
private:
   int left,right;
   bool lsb_first;
   char *pointer;
public:
   range_class(int l,int r) { left=l; right=r; lsb_first=false; pointer=NULL; };
   range_class(int l,int r,bool b) { left=l; right=r; lsb_first=b; pointer=NULL; };
   range_class(char *s) { left=0; right=0; pointer=cpystr(s); };
   // This method must only be used by the Copy-method
   range_class(int l,int r, char *s, bool b) { left=l; right=r; pointer=cpystr(s); lsb_first=b; };

   range_class *Copy(void);
   int Left(void) { return left; };
   int Right(void) { return right; };
   int High(void) { if (right>left) { return right; } else return left; };
   int Low(void) { if (right<left) { return right; } else return left; };
   void Left(int i) { left=i; };
   void Right(int i) { right=i; };
   void LSBFirst(bool b) { lsb_first=b; };
   bool LSBFirst(void) { return lsb_first; };
   bool MSBFirst(void) { return !lsb_first; };
   int BitSize(void) { return abs(left-right)+1; };
   char *Pointer(void) { return pointer; };

   bool Compare(range_class *r);
};

class ranges:public List<range_class>
{
public:
   ranges():List<range_class>() {};
   ~ranges() {};
};

class software_driver
{
private:
   int array_length;
public:
   software_driver() { array_length=0; };
   software_driver(int al) { array_length=al; };
   int ArrayLength(void) { return array_length; };
};

class hardware_driver
{
private:
   int relative_address;
   int array_length;
public:
   hardware_driver(int ra) { relative_address=ra; array_length=0; };
   hardware_driver(int ra, int al) { relative_address=ra; array_length=al; };
   int RelativeAddress(void) { return relative_address; };
   int ArrayLength(void) { return array_length; };
};

class device_driver
{
private:
   enum {
      SOFTWARE=0,
      HARDWARE=1
   } type;
   union {
      software_driver *swd;
      hardware_driver *hwd;
   } driver;
public:
   device_driver(software_driver *sd) { type=SOFTWARE; driver.swd=sd; };
   device_driver(hardware_driver *hd) { type=HARDWARE; driver.hwd=hd; };
   bool IsSW(void) { return (type==SOFTWARE); }
   bool IsHW(void) { return (type==HARDWARE); }
   int RelativeAddress(void);
   int ArrayLength(void);
};

class conversion_function
{
   int left,right,bit_size;
   bool *is_used_by;
public:
   conversion_function(char *s,range_class *r,int b);
   int Left(void) { return left; };
   int Right(void) { return right; };
   int BitSize(void) { return bit_size; };
   void InitFlags(int nr);
   void IsUsedBy(int i,bool val) { is_used_by[i]=val; };
   bool IsUsedBy(int i) { return is_used_by[i]; };
   void write_function(FILE *file);
};

class conversion_functions:public List<conversion_function>
{
public:
   conversion_functions(conversion_function *f):List<conversion_function>(f) {};
   conversion_functions():List<conversion_function>() {};
   conversion_function *AddMember(conversion_function *f);
   void write_functions(FILE *file,int fsm);
};

class input
{
private:
  char *name;
  array_type *array_size;
  range_class *input_range;
  int frequency;
  int rate;
  device_driver *driver;
  bool *is_read_by;
  bool *is_clock_in;
  int bool_vector_size;
public:
   input(char *s, array_type *a, int f, int r) { name=s; array_size=a; 
					 frequency=f; rate=r;
					 input_range=NULL; driver=NULL; };
   input(char *s, array_type *a) { name=s; array_size=a;
			   frequency=0; rate=0; input_range=NULL; driver=NULL;};
   input(char *s, array_type *a, device_driver *d) { name=s; array_size=a;
			   frequency=0; rate=0; input_range=NULL; driver=d;};
   input(char *s, array_type *a, range_class *r)  { name=s; array_size=a;
			   frequency=0; rate=0; input_range=r; driver=NULL; };
   ~input() { if (name!=NULL) delete name; };
   char *Name(void) { return name; }
   int BitSize(void) { return array_size->BitSize(); };
   void BitSize(int i) { array_size->BitSize(i); };
   int ArraySize(void) { return array_size->ArraySize(); };
   range_class *Range(void) { return input_range; };
   int Frequency(void) { return frequency; };
   int Rate(void) { return rate; };
   bool HasDriver(void) { return (driver!=NULL); };
   device_driver *Driver(void) { return driver; };
   void InitFlags(int nr);
   void IsReadBy(int i,bool val) { is_read_by[i]=val; };
   bool IsReadBy(int i) { return is_read_by[i]; };
   void IsClockIn(int i,bool val) { is_clock_in[i]=val; };
   bool IsClockIn(int i) { return is_clock_in[i]; };
   bool IsClock(void);
   bool write_clocks(FILE *file,bool first);
   void write_driver(FILE *file);
   void write_vhdl(FILE *file,int fsm);
   void write_portmap(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
};

class inputs:public List<input>
{
public:
   inputs(input *i):List<input>(i) {};
   inputs():List<input>() {};
   input *Member(char *s);
   input *Member(int i) { return List<input>::Member(i); };
   void write_clocks(FILE *file);
   void write_driver(FILE *file);
   void write_vhdl(FILE *file,int fsm);
   void write_portmaps(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
   void GUI_ListPorts(FILE *file);
   int EstimatePadArea(FILE *file, technology *tech);
};

class internal
{
private:
  char *name;
  array_type *array_size;
  range_class *internal_range;
  bool *is_read_by;
  bool *is_clock_in;
  bool *is_written_by;
  int bool_vector_size;
public:
   internal(char *s, array_type *a) { name=s; array_size=a; internal_range=NULL; };
   internal(char *s, array_type *a,range_class *r) { name=s; array_size=a; internal_range=r; };
   ~internal() { if (name!=NULL) delete [] name; };
   char *Name(void) { return name; }
   int BitSize(void) { return array_size->BitSize(); };
   int ArraySize(void) { return array_size->ArraySize(); };
   void BitSize(int i) { array_size->BitSize(i); };
   range_class *Range(void) { return internal_range; };
   void InitFlags(int nr);
   void IsReadBy(int i,bool val) { is_read_by[i]=val; };
   bool IsReadBy(int i) { return is_read_by[i]; };
   void IsClockIn(int i,bool val) { is_clock_in[i]=val; };
   bool IsClockIn(int i) { return is_clock_in[i]; };
   void IsWrittenBy(int i,bool val) { is_written_by[i]=val; };
   bool IsWrittenBy(int i) { return is_written_by[i]; };
   bool IsWrittenByOthers(int i);
   void write_driver(FILE *file);
   void write_vhdl(FILE *file,int fsm);
   void write_signal(FILE *file);
   void write_signal(FILE *file,int fsm);
   void write_default(FILE *file,int fsm);
   void write_portmap(FILE *file,int fsm);
   void write_to_port(FILE *file,int fsm);
   void write_register(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
};

class internals:public List<internal>
{
  int bool_vector_size;
public:
   internals(internal *i):List<internal>(i) {};
   internals():List<internal>() {};
   internal *Member(char *s);
   internal *Member(int i) { return List<internal>::Member(i); };

   void write_driver(FILE *file);
   void write_vhdl(FILE *file,int fsm);
   void write_signals(FILE *file);
   void write_signals(FILE *file,int fsm);
   void write_defaults(FILE *file,int fsm);
   void write_portmaps(FILE *file,int fsm);
   void write_to_ports(FILE *file,int fsm);
   void write_registers(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
   void GUI_ListPorts(FILE *file);
   int Estimate(FILE *file, technology *tech,int fsm);
};

class output
{
private:
   char *name;
   array_type *array_size;
   range_class *output_range;
   bool *is_read_by;
   bool *is_written_by;
   device_driver *driver;
   int nr_of_fsms;
public:
   output(char *n, array_type *a) { name=n; array_size=a;
			    output_range=NULL; driver=NULL;};
   output(char *n, array_type *a, device_driver *d) { name=n; array_size=a;
					     output_range=NULL; driver=d;};
   output(char *n, array_type *a, range_class *r) { name=n; array_size=a;
				     output_range=r; driver=NULL;};
   ~output() { if (name!=NULL) delete [] name; };
   char *Name(void) { return name; }
   int BitSize(void) { return array_size->BitSize(); };
   int ArraySize(void) { return array_size->ArraySize(); };
   void BitSize(int i) { array_size->BitSize(i); };
   range_class *Range(void) { return output_range; };
   bool HasDriver(void) { return (driver!=NULL); };
   device_driver *Driver(void) { return driver; };
   void InitFlags(int nr);
   void IsReadBy(int i,bool val) { is_read_by[i]=val; };
   bool IsReadBy(int i) { return is_read_by[i]; };
   bool IsRead(void);
   void IsWrittenBy(int i,bool val) { is_written_by[i]=val; };
   bool IsWrittenBy(int i) { return is_written_by[i]; };
   void write_driver(FILE *file);
   void write_vhdl(FILE *file,int fsm);
   void write_portmap(FILE *file,int fsm);
   void write_signal(FILE *file);
   void write_signal(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
   void write_default(FILE *file,int fsm);
   void write_to_port(FILE *file);
   void write_to_port(FILE *file,int fsm);
   void write_register(FILE *file,int fsm);
};

class outputs:public List<output>
{
public:
   outputs(output *o):List<output>(o) {};
   outputs():List<output>() {};
   output *Member(char *s);
   output *Member(int i) { return List<output>::Member(i); };
   void write_driver(FILE *file);
   void write_vhdl(FILE *file,int fsm);
   void write_portmaps(FILE *file,int fsm);
   void write_signals(FILE *file);
   void write_signals(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
   void write_defaults(FILE *file,int fsm);
   void write_to_ports(FILE *file);
   void write_to_ports(FILE *file,int fsm);
   void write_registers(FILE *file,int fsm);
   void GUI_ListPorts(FILE *file);
   int Estimate(FILE *file,technology *tech,int fsm);
   int EstimatePadArea(FILE *file, technology *tech);
};

class aliased_signal_name
{
private:
   char *name;
   int bit_size;
   range_class *signal_range;
public:
   aliased_signal_name(char *n,range_class *r) { name=cpystr(n); signal_range=r; };
   aliased_signal_name(char *n) { name=cpystr(n); signal_range=NULL; };
};

class aliased_signal_names:public List<aliased_signal_name>
{
public:
   aliased_signal_names(aliased_signal_name *a):List<aliased_signal_name>(a) {};
};

class alias
{
private:
   char *name;
   int bit_size;
   aliased_signal_names *asn_names;

   bool *is_read_by;
   bool *is_written_by;
   int nr_of_fsms;
public:
   alias(char *n, aliased_signal_names *asn) { name=n; asn_names=asn; };
   ~alias() { if (name!=NULL) delete [] name; };
   char *Name(void) { return name; }
   int BitSize(void) { return bit_size; };

   void InitFlags(int nr);
   void IsReadBy(int i,bool val);
   bool IsReadBy(int i) { return is_read_by[i]; };
   void IsWrittenBy(int i,bool val);
   bool IsWrittenBy(int i) { return is_written_by[i]; };
   void write_vhdl(FILE *file,int fsm);
   void write_portmap(FILE *file,int fsm);
   void write_signal(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
   void write_default(FILE *file,int fsm);
   void write_to_port(FILE *file,int fsm);
   void write_register(FILE *file,int fsm);
};

class aliases:public List<alias>
{
public:
   aliases(alias *a):List<alias>(a) {};
   aliases():List<alias>() {};
   alias *Member(char *s);
   alias *Member(int i) { return List<alias>::Member(i); };

/*   void write_vhdl(FILE *file,int fsm);
   void write_portmaps(FILE *file,int fsm);
   void write_signals(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
   void write_defaults(FILE *file,int fsm);
   void write_to_ports(FILE *file,int fsm);
   void write_registers(FILE *file,int fsm);
*/
};

class fifo
{
private:
   char *name;
   char *clk_name;
   input_stream *stream;
   int depth;
   bool *is_read_by;
public:
   fifo(input_stream *s, char *c, int d);
   ~fifo();
   input_stream *Stream(void) { return stream; };
   char *Name(void) { return name; };
   char *ClockName(void) { return clk_name; };
   int Depth(void) { return depth; };
   void Depth(int d) { depth=d; };
   void InitFlags(int nr);
   void IsReadBy(int i,bool val) { is_read_by[i]=val; };
   bool IsReadBy(int i) { return is_read_by[i]; };
   int Estimate(technology *tech, int fsm);

   void write_vhdl(int nr,FILE *file);
   void write_signals(FILE *file);
   void write_process_list(FILE *file);
};

class fifos:public List<fifo>
{
public:
   fifos():List<fifo>() {};
   fifos(fifo *f):List<fifo>(f) {};
   fifo *Member(char *s);
   fifo *Member(int i) { return List<fifo>::Member(i); };
   fifo *AddMember(fifo *f);
   int Estimate(technology *tech, int fsm);

   void write_vhdl(FILE *file,int fsm);
   void write_signals(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
};

class memory
{
private:
   char *name;
   int address_size;
   int nr_of_ports;
   char *layout;
   int bit_size;
   bool *is_read_by;
   bool *is_clock_in;
   bool *is_written_by;
   int bool_vector_size;
public:
   memory(char *n, int a, int p, char *l);
   memory(char *n, int a, int p, int b) { name=cpystr(n), address_size=a; layout=NULL; nr_of_ports=p; bit_size=b; };
   ~memory() { if (name!=NULL) delete [] name;
	       if (layout!=NULL) delete [] layout; };
   char *Name(void) { return name; }
   int MemorySize(void) { return (1<<address_size); }
   int AddressSize(void) { return address_size; }
   int NrOfPorts(void) { return nr_of_ports; };
   int DataSize(void) { return bit_size; };
   char *Layout(void) { return layout; }
   int BitSize(void) { return bit_size; };
   void BitSize(int i) { bit_size=i; };

   void InitFlags(int nr);
   void IsReadBy(int i,bool val) { is_read_by[i]=val; };
   bool IsReadBy(int i) { return is_read_by[i]; };
   void IsWrittenBy(int i,bool val) { is_written_by[i]=val; };
   bool IsWrittenBy(int i) { return is_written_by[i]; };
   bool IsWrittenByOthers(int i);
   void Initialize(void);

   void write_vhdl(int i,FILE *file);
   void write_vhdl(FILE *file,int fsm);
   void write_signals(FILE *file);
   void write_default(FILE *file,int fsm);
   void write_portmap(FILE *file,int fsm);
   void write_process_list(FILE *file,int fsm);
};

class memories:public List<memory>
{
public:
   memories(memory *m):List<memory>(m) {};
   memories():List<memory>() {};
   memory *Member(char *s);
   memory *Member(int i) { return List<memory>::Member(i); };
   void Initialize(void);
   int MultiPortMemories(void);

   void write_vhdl(FILE *file);
   void write_vhdl(FILE *file,int fsm);
   void write_defaults(FILE *file,int fsm);
   void write_portmaps(FILE *file,int fsm);
   void write_signals(FILE *file);
   void write_process_list(FILE *file,int fsm);
};

class start
{
private:
   char *name;
   input_stream *stream;
   char *clk_name;
   int bit_size;
   int clk_period;
   lexem *entry_lexem,*exit_lexem;
   int end_state;
public:
   start(char *n, input_stream *s,char *cn, int c)
     { name=n; stream=s; clk_name=cn; clk_period=c; };
   ~start() { if (name!=NULL) delete [] name; };
   char *Name(void) { return name; }
   input_stream *Stream(void) { return stream; }
   char *ClockName(void) { return clk_name; };
   int BitSize(void) { return bit_size; };
   int ClkPeriod(void) { return clk_period; };
   lexem *EntryLexem(void) { return entry_lexem; }; // Used by simulator 
   lexem *ExitLexem(void)  { return exit_lexem; }; // Used by simulator 
   void build_fsm(int fsm);
   void write_driver(FILE *file,int fsm);
   void write_vhdl(FILE *file,int fsm);
   void write_entity(FILE *file,int fsm);
   void write_component(FILE *file,int fsm);
   void write_architecture(FILE *file,int fsm);
   void write_portmap(FILE *file,int fsm);
   void write_fsm(FILE *file,int fsm);
   void write_signals(FILE *file,int fsm);
   void write_registers(FILE *file,int fsm);
   void write_transition(FILE *file,int fsm,char *value);
   int Estimate(FILE *file,technology *tech,int fsm);
   void DumpActions(FILE *file) {};
};

class starts:public List<start>
{
public:
   starts():List<start>() {};
   starts(start *s):List<start>(s) {};
   void write_vhdl(FILE *file);
   void write_script(FILE *file, char *vhdl_file_name);
   void write_xfc(FILE *file);
   void write_components(FILE *file);
   void write_portmaps(FILE *file);
   int Estimate(FILE *file,technology *tech);
};

class production_lexem
{
private:
   char *name;
   int multiplicity;
public:
   production_lexem(char *n) { name=n; multiplicity=1; };
   production_lexem(char *n, int i) { name=n; multiplicity=i; };
   ~production_lexem() { if (name!=NULL) delete [] name; };
   char *Name(void) { return name; };
   int Multiplicity(void) { return multiplicity; };
};

extern int STREAM_INP;
extern int STREAM_INTERN;
extern int STREAM_OUTP;
class stream_item
{
private:
   char *name;
   char *address;
   int type;
public:
   stream_item(char *n) { name=n; address=NULL; };
   stream_item(char *n,char *a) { name=n; address=a; };
   int Type(void) { return type; };
   void Type(int i) { type=i; };
   char *Name(void) { return name; };
   ~stream_item() { if (name!=NULL) delete [] name;
		    if (address!=NULL) delete [] address; };
};

class input_stream:public List<stream_item>
{
private:
   int bit_size;
   int *bit_sizes;
   int last_word;
   bool has_fifo;
   bool reset;
public:
   input_stream(stream_item *i):List<stream_item>(i) { reset=false; bit_size=0; };
   int BitSize(void);
   int BitSize(int i) { return bit_sizes[i]; };
   void ResetPos(void) { last_word=-1; };
   int LastWord(void) { return last_word; };
   //void LastWord(int p);
   bool HasFifo(void) { return last_word>-1; };
   void CheckConsistency(int fsm);
   void write_driver(FILE *file,bool write_first_and,char *value,bool not_flag);
   void write_transition(FILE *file,int fsm,bool write_first_and,production_terminal *terminal);
   void write_signals(FILE *file);
   void WriteFifo(FILE *file);
   char *Name(void);
   char *FifoName(void);
   bool Reset(void) { return reset; };
   void Reset(bool val) { reset=val; };
   bool Compare(input_stream *stream);
   input_stream *Copy();
};

class production_redirection
{
private:
  //   char *lexeme;
   input_stream *stream;
public:
   //   production_redirection(char *n,input_stream *s) { lexeme=n; stream=s; };
    production_redirection(input_stream *s) { stream=s; };
    ~production_redirection() { // if (lexeme!=NULL) delete [] lexeme;
			       if (stream!=NULL) delete stream; };
   //   char *Lexem(void) { return lexeme; };
   input_stream *Stream(void) { return stream; };
};

class production_interrupt
{
private:
   char *signal;
   bool low;
   input_stream *stream;
public:
   production_interrupt(char *s) { signal=cpystr(s); low=false; 
				   stream=new input_stream(new stream_item(cpystr(signal))); };
   int IsLow(void) { return low; };
   char *Signal(void) { return signal; };
   input_stream *Stream(void) { return stream; };
   void CheckConsistency(int fsm);
};

class production_reset:public production_interrupt
{
public:
   production_reset(char *s):production_interrupt(s) {};
};

class production_signal
{
private:
   union {
      action_signal *sig;
      action_variable *var;
   } source;
   enum {
     PROD_SIGNAL=0,
     PROD_VARIABLE=1
   } type;
   int bit_size;
public:
   production_signal(action_signal *sig) { source.sig=sig; type=PROD_SIGNAL; };
   production_signal(action_variable *var) { source.var=var; type=PROD_VARIABLE; };
   ~production_signal();

   action_signal *Signal(void) { return source.sig; };
   action_variable *Variable(void) { return source.var; };
   int Type(void) { return type; };
   void BitSize(int bs) { bit_size=bs; };
   int BitSize(void) { return bit_size; };

   bool IsSignal(void) { return type==PROD_SIGNAL; };
   bool IsVariable(void) { return type==PROD_VARIABLE; };

   bool Compare(production_signal *signal);
   production_signal *Copy(void);
   void BitPos(productions *p,int bp);
   void CheckConsistency(int fsm,input_stream *stream,int bp);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bp);
   void PrintSignal(FILE *file,int fsm,input_stream *stream,int bp);
};

extern int COND_EQU;
extern int COND_NEQ;
extern int COND_GTE;
extern int COND_GT;
extern int COND_LT;
extern int COND_LTE;
class production_cond
{
private:
   production_signal *signal;
   union {
     char *value;
     production_signal *sig;
   } comparand;
   enum { COND_CONSTANT=0,
	  COND_SIGNAL=1,
   } type; 
   int condition;
   int bit_size;
   bool left_assoc;
public:
   production_cond(production_signal *s,int c,char *v) { signal=s; condition=c; comparand.value=cpystr(v); bit_size=0; type=COND_CONSTANT; };
   production_cond(production_signal *s,int c,production_signal *as) { signal=s; condition=c; comparand.sig=as; bit_size=0; type=COND_SIGNAL; };
   ~production_cond();

   production_signal *Signal1(void) { return signal; };
   char *Value(void) { return comparand.value; };
   production_signal *Signal2(void) { return comparand.sig; };
   int Condition(void) { return condition; };

   bool IsSignal(void) { return type==COND_SIGNAL; };
   bool IsConstant(void) { return type==COND_CONSTANT; }

   int Type(void) { return type; };
   int BitSize(void) { return bit_size; };
   void BitSize(int i) { bit_size=i; };

   void LeftAssoc(bool b) { left_assoc=b; };
   bool LeftAssoc(void) { return left_assoc; };

   production_cond *Copy(void);
   bool Compare(production_cond *cond);
   void BitPos(productions *p,int bp);
   void CheckConsistency(int fsm,input_stream *stream,int bp);
   void PrintCondition(FILE *file,int fsm,input_stream *stream,int bp);
};

class production_conds:public List<production_cond>
{
public:
   production_conds(production_cond *s):List<production_cond>(s) {};
   production_conds():List<production_cond>() {};

   void BitPos(productions *p,int bp);
   bool Compare(production_conds *conds);
   void CheckConsistency(int fsm,input_stream *stream,int bp);
   char *DumpDaVinci(void);
   void PrintTransitions(FILE *file,int fsm,input_stream *stream,int bp);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bp);
};

class production_terminal
{
private:
   enum {
      PGM_CONSTANT=0,
      PGM_SIGNAL=1,
      PGM_OTHERS=2,
      PGM_BITS=3
   } type;
   char *value;
   bool is_negated;
   action_signal *signal;
   action_signals *list_of_signals;
public:
   production_terminal(char *v,bool b);
   production_terminal(char c,int i,bool b);
   production_terminal(action_signal *as) { signal=as; type=PGM_SIGNAL; };
   ~production_terminal() { if (value!=NULL) delete [] value; };
   bool IsConstant(void) { return (type==PGM_CONSTANT); }
   bool IsSignal(void)   { return (type==PGM_SIGNAL); }
   bool IsOthers(void)   { return (type==PGM_OTHERS); }
   bool IsBits(void)     { return (type==PGM_BITS); }
   bool IsNegated(void)  { return is_negated; };
   void Negated(bool b)  { is_negated=b; };
   int Type(void) { return type; };
   char *Value(void) { return value; };
   void Value(char *v) { value=v; };
   action_signal *Signal(void) { return signal; };
   action_signal *Signal(int i) { return list_of_signals->Member(i); };
   action_signals *ListOfSignals(void) { return list_of_signals; };
   void ListOfSignals(action_signals *las) { list_of_signals=las; };
   char Bit(int i) { return value[i]; };
   void Bit(int i,char c) { value[i]=c; };
   void FlipBit(int i) { if (value[i]=='1') { value[i]='0'; }
		         else { value[i]='1'; };
		       };
   int NrOfBits(void);
   production_terminal *Copy(void);
};

class production_error
{
public:
   production_error(void) {};
   ~production_error() {};
};

class action_address
{
private:
   union {
      action_signal *sig;
      action_variable *var;
      action_constant *con;
   } address;
   range_class *source_range;
   enum {
     ADDRESS_VOID=0,
     ADDRESS_SIGNAL=1,
     ADDRESS_VARIABLE=2,
     ADDRESS_CONSTANT=3
   } address_type;
public:   
   action_address() { address_type=ADDRESS_VOID; address.sig=NULL; 
                      source_range=NULL; };
   action_address(action_signal *s)
                           { address_type=ADDRESS_SIGNAL; 
                             address.sig=s; source_range=NULL; };
   action_address(action_variable *v)
                           { address_type=ADDRESS_VARIABLE;
			     address.var=v; source_range=NULL; };
   action_address(action_constant *c)
                           { address_type=ADDRESS_CONSTANT;
			     address.con=c; source_range=NULL; };
   action_address(range_class *r) 
                           { address_type=ADDRESS_VOID; address.sig=NULL; 
			     source_range=r; };
   ~action_address();
   action_signal *Signal(void) { return address.sig; };
   action_variable *Variable(void) { return address.var; }
   action_constant *Constant(void) { return address.con; }
   range_class *Range(void) { return source_range; };
   void Range(range_class *r) { source_range=r; };
   int Type(void) { return address_type; }

   bool IsVoid(void)     { return address_type==ADDRESS_VOID; };
   bool IsSignal(void)   { return address_type==ADDRESS_SIGNAL; };
   bool IsVariable(void) { return address_type==ADDRESS_VARIABLE; };
   bool IsConstant(void) { return address_type==ADDRESS_CONSTANT; };
   bool HasRange(void)   { return source_range!=NULL; }

   action_address *Copy(void);
   bool Compare(action_address *a);

   void BitPos(productions *p,int bp);
   void CheckConsistency(int fsm,input_stream *stream,int bp);
   void WordAlignAddress(range_class *r); // Signal address
};

class action_macro
{
private:
   char *name;
public:
   action_macro(char *n) { name=cpystr(n); };
   ~action_macro() { if (name!=NULL) delete [] name; };

   action_macro *Copy(void) { return new action_macro(Name()); }; 
   char *Name(void) { return name; };
   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   action_line *ExpandActionMacros(void);
};

class action_signal
{
private:
   char *name;
   action_address *address;
   int array_size;
   int bit_size;
   int port_number;
   int address_size;
   //   range_class *bit_range;
   bool negate;
   bool is_memory;
   bool is_input;
   bool is_output;
   bool is_internal;
public:
   action_signal(char *n);
   action_signal(char *n,int p,action_address *a);
   action_signal(char *n,bool neg);
   action_signal(char *n, range_class *r);
   // This constructor must only be used by the Copy-method
   action_signal(char *n,int b,int p,int a,bool neg) 
      { name=cpystr(n); bit_size=b; port_number=p; address_size=a; negate=neg; };

   ~action_signal() { if (name!=NULL) delete [] name; };

   action_signal *Copy(void);
   char *Name(void) { return name; };
   action_address *Address(void) { return address; };
   void Address(action_address *a) { address=a; };
   int BitSize(void) { return bit_size; };
   int ArraySize(void) { return array_size; };
   void ArraySize(int i) { array_size=i; };
   int PortNumber(void) { return port_number; };
   int AddressSize(void) { return address_size; };
   range_class *Range(void) { return Address()->Range(); };
   //void *Range(range_class *r) { bit_range=r; };
   bool IsMemory(void) { return is_memory; };
   void IsMemory(bool b) { is_memory=b; };
   bool IsOutput(void) { return is_output; };
   void IsOutput(bool b) { is_output=b; };
   bool IsInput(void) { return is_input; };
   void IsInput(bool b) { is_input=b; };
   bool IsInternal(void) { return is_internal; };
   void IsInternal(bool b) { is_internal=b; };
   bool Negate(void) { return negate; };

   void BitPos(productions *p,int bp);
   void CheckConsistency(int fsm,input_stream *stream,int bp);
   bool Compare(action_signal *s2);
   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   void write_driver(FILE *file);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bp);
   void PrintSignal(FILE *file,int fsm,input_stream *stream,int bp);
   void PrintMemoryAccess(FILE *file,int ind);
};

class action_variable
{
private:
   char *name;
   int ref_pos;
   char *port_name;
   char *fifo_name;
   range_class *bit_range;
   int input_stream_width;
   int bit_pos,prod_pos,first_bit,last_bit,prod_size;
   bool last_partition;
public:
   action_variable(char *n) { name=cpystr(n); first_bit=0; last_partition=false; ref_pos=-1; bit_range=NULL; };
   action_variable(char *n, int i) { name=cpystr(n); first_bit=0; last_partition=false; ref_pos=i; bit_range=NULL; };
   action_variable(char *n, int i, range_class *r) {
	   name = cpystr(n); first_bit = 0; last_partition = false; ref_pos = i; bit_range = r; 
	   sprintf_s(log_str, 1024,"RANGE %d to %d\n",r->Left(),r->Right());
	   log(log_str);
	};
   ~action_variable();

   action_variable *Copy(void);
   char *Name(void) { return name; };
   int RefPos(void) { return ref_pos; }
   char *PortName(void) { return port_name; };
   char *FifoName(void) { return fifo_name; };
   range_class *Range(void) { return bit_range; };
   void Range(range_class *r) { bit_range=r; };
   void FifoName(char *n) { fifo_name=cpystr(n); };
   void write_driver(FILE *file,int fsm, input_stream *stream,int bp);
   void PrintVariable(FILE *file,int fsm, input_stream *stream,int bp);
   void PrintExpression(FILE *file,int fsm, input_stream *stream,int bp);
   void PrintVariable(FILE *file,int fsm, input_stream *stream,int bp,int ind);

   void BitPos(productions *p,int bp); // BitPos() set bit_pos, prod_pos, last and first_bit

   void InputStreamWidth(int i) { input_stream_width=i; };
   void SetBitPos(int i) { bit_pos=i; };
   void ProdPos(int i)   { prod_pos=i; };
   void ProdSize(int i)  { prod_size=i; };
   void RefPos(int i)    { ref_pos=i; };
   void FirstBit(int i)  { first_bit=i; }; // offset within width
   void LastBit(int i)   { last_bit=i; };
   void LastPartition(bool b) { last_partition=b; };

   int InputStreamWidth(void) { return input_stream_width; };
   int BitPos(void)   { return bit_pos; };
   int ProdPos(void)  { return prod_pos; };
   int ProdSize(void) { return prod_size; };
   int FirstBit(void) { return first_bit; };
   int LastBit(void)  { return last_bit; };
   int BitSize(void)  { return first_bit-last_bit+1; };
   bool LastPartition(void) { return last_partition; };

   void CheckConsistency(int fsm,input_stream *stream,int bp);
   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   void WordAlignAddress(void);
   bool Compare(action_variable *av);
};

class action_constant
{
private:
   char *value;
public:
   action_constant(char *v) { value=cpystr(v); };
   ~action_constant() { if (value!=NULL) delete [] value; };

   action_constant *Copy(void) { return new action_constant(Value()); };
   void write_driver(FILE *file);
   void PrintConstant(FILE *file);
   char *Value(void) { return value; };
   void Value(char *s) { value=cpystr(s); };
   int Integer(void);
   void AddToValue(char *s) { value=catstr(value,s); };
   int BitSize(void) { return strlen(value); };
   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   bool Compare(action_constant *ac);
};

class cdfg_constant
{
private:
   int number;
   char *c_number;
   bool is_numeric;
public:
   cdfg_constant(int n) { number=n; c_number=NULL; is_numeric=true; };
   cdfg_constant(char *c) { number=0; c_number=cpystr(c); is_numeric=false; };
   ~cdfg_constant() {};

   cdfg_constant *Copy(void);
   int Number(void) { return number; };
   char *C_Number(void) { return c_number; };

   bool IsNumeric(void) { return is_numeric; };

   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   bool Compare(cdfg_constant *cc);
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos)
     { return; };
   void write_driver(FILE *file);
   void PrintCDFG(FILE *file);
};

class cdfg_variable
{
private:
   char *name;
   int number;
   range_class *bit_range;
   int input_stream_width;
   int bit_pos,prod_pos,first_bit,last_bit,prod_size;
   bool last_partition;
public:
   cdfg_variable(char *n)		 { name=cpystr(n); number=1; bit_range=NULL; };
   cdfg_variable(char *n, int i) { name=cpystr(n); number=i; bit_range=NULL; };
   cdfg_variable(char *n, int i, range_class *r) { name=cpystr(n); number=i; bit_range=r; };
   ~cdfg_variable() 
   { 
	   if (name!=NULL) delete [] name; 
	   if (bit_range!=NULL) delete bit_range;
   };

   cdfg_variable *Copy(void) { return new cdfg_variable(Name(),Number()); };
   char *Name(void) { return name; };
   int Number(void) { return number; }

   void BitPos(productions *p,int bp);
   void InputStreamWidth(int i) { input_stream_width=i; };
   void SetBitPos(int i) { bit_pos=i; };
   void ProdPos(int i)   { prod_pos=i; };
   void ProdSize(int i)  { prod_size=i; };
//   void RefPos(int i)    { ref_pos=i; };
   void FirstBit(int i)  { first_bit=i; }; // offset within width
   void LastBit(int i)   { last_bit=i; };
   void LastPartition(bool b) { last_partition=b; };

   int InputStreamWidth(void) { return input_stream_width; };
   int BitPos(void)   { return bit_pos; };
   int ProdPos(void)  { return prod_pos; };
   int ProdSize(void) { return prod_size; };
   int FirstBit(void) { return first_bit; };
   int LastBit(void)  { return last_bit; };
   int BitSize(void)  { return first_bit-last_bit+1; };
   bool LastPartition(void) { return last_partition; };

   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   bool Compare(cdfg_variable *cv);
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos)
     { return; };
   void write_driver(FILE *file);
   void write_driver(FILE *file,int fsm, input_stream *stream,int bp);
   void PrintVariable(FILE *file,int fsm, input_stream *stream,int bp);
//   void PrintExpression(FILE *file,int fsm, input_stream *stream,int bp);
//   void PrintVariable(FILE *file,int fsm, input_stream *stream,int bp,int ind);
   void PrintCDFG(FILE *file);
};

class cdfg_signal
{
private:
   char *name;
   action_address *address;
   int bit_size;
   range_class *bit_range;
   bool is_memory;
   bool is_input;
   bool is_output;
   bool is_internal;
public:
   cdfg_signal(char *n) { name=cpystr(n); address=new action_address(); bit_size=-1; bit_range=NULL; is_memory=false; is_output=false; is_input=false; is_internal=false; };
   cdfg_signal(char *n, action_address *a) { name=cpystr(n); address=a; bit_size=-1; bit_range=NULL; is_memory=false; is_output=false; is_input=false; is_internal=false; };
   cdfg_signal(char *n,range_class *r) { name=cpystr(n); address=new action_address(); bit_size=-1; bit_range=r; is_memory=false; is_output=false; is_input=false; is_internal=false; };
   ~cdfg_signal() { if (name!=NULL) delete [] name; 
                    if (bit_range!=NULL) delete bit_range; };

   cdfg_signal *Copy(void);
   char *Name(void) { return name; };
   action_address *Address(void) { return address; };
   void Address(action_address *a) { address=a; };
   int BitSize(void) { return bit_size; };
   void BitSize(int i) { bit_size=i; };
   range_class *Range(void) { return bit_range; };
   void Range(range_class *r) { bit_range=r; };
   bool IsMemory(void) { return is_memory; };
   void IsMemory(bool b) { is_memory=b; };
   bool IsOutput(void) { return is_output; };
   void IsOutput(bool b) { is_output=b; };
   bool IsInput(void) { return is_input; };
   void IsInput(bool b) { is_input=b; };
   bool IsInternal(void) { return is_internal; };
   void IsInternal(bool b) { is_internal=b; };

   void BitPos(productions *p,int bp);
   action_schedule *WordAlignAction(int bit_pos,action_target *target);

   bool Compare(cdfg_signal *cs);
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos); 
   void write_driver(FILE *file);
//   void write_driver(FILE *file,int fsm,input_stream *stream,int bp);
   void PrintCDFG(FILE *file);
   void PrintSignal(FILE *file,int fsm,input_stream *stream,int bp);
   void PrintMemoryAccess(FILE *file,int ind);
};

class action_arguments;
class action_cdfg
{
private:
   union {
      char *fun;
      cdfg_constant *con;
      cdfg_variable *var;
      cdfg_signal *sig;
   } rel;
   enum { 
      ILF_FUNCTION=0,
      PGM_CONSTANT=1,
      PGM_VARIABLE=2,
      PGM_SIGNAL=3
   } type;
   action_arguments *args;
   range_class *bit_range;
public:
   action_cdfg(char *f,action_arguments *a) { bit_range=NULL; rel.fun=cpystr(f); args=a; type=ILF_FUNCTION; };
   action_cdfg(cdfg_constant *c) { bit_range=NULL; rel.con=c; type=PGM_CONSTANT; args=NULL; };
   action_cdfg(cdfg_variable *v) { bit_range=NULL; rel.var=v; type=PGM_VARIABLE; args=NULL; };
   action_cdfg(cdfg_signal *s)   { bit_range=NULL; rel.sig=s; type=PGM_SIGNAL;   args=NULL; };
   ~action_cdfg();

   action_cdfg *Copy(void);
   int Type(void) { return type; };
   int BitSize(void) { return bit_range->BitSize(); }; // autocalculated
   int WordSize(void);

   bool IsFunction(void) { return type==ILF_FUNCTION; };
   bool IsConstant(void) { return type==PGM_CONSTANT; };
   bool IsVariable(void) { return type==PGM_VARIABLE; };
   bool IsSignal(void) { return type==PGM_SIGNAL; };

   char *Function(void) { return rel.fun; };
   cdfg_constant *Constant(void) { return rel.con; };
   cdfg_variable *Variable(void) { return rel.var; };
   cdfg_signal *Signal(void) { return rel.sig; };
   action_arguments *Arguments(void) { return args; };
   range_class *BitRange(void) { return bit_range; };

   void BitRange(range_class *br) { bit_range=br; };

   bool Compare(action_cdfg *ac);
   void BitPos(productions *p,int bp); // used to determine variable references
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos);
   void PrintCDFG(FILE *file,int fsm,input_stream *stream,int bit_pos);
   void PrintMemoryAccess(FILE *file,int ind);
};

class cdfg_word_alignment;
class action_arguments:public List<action_cdfg>
{
public:
   action_arguments():List<action_cdfg>() {};

   action_arguments *Copy(void);
   int WordSize(void);
   bool Compare(action_arguments *aa);
   void BitPos(productions *p,int bp); // used to determine variable references
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   cdfg_word_alignment *WordAlignAction(int bit_pos,action_target *target);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos);
   void PrintCDFG(FILE *file,int fsm,input_stream *stream,int bit_pos);
};

class cdfg_word_alignment
{
private:
   action_arguments *arg;
   action_schedule *sched;
public:
   cdfg_word_alignment(action_arguments *a,action_schedule *s) { arg=a; sched=s; };
};

class mux_condition
{
private:
   action_signal *signal;
   bool condition;
   union {
      char *str;
      action_signal *sig;
   } value;
   enum {
      CONDITION_STRING=0,
      CONDITION_SIGNAL=1
   } type;
public:
   mux_condition(action_signal *s,bool c,char *v)
     { signal=s; condition=c; value.str=cpystr(v); type=CONDITION_STRING; };
   mux_condition(action_signal *s1,bool c,action_signal *s2)
     { signal=s1; condition=c; value.sig=s2; type=CONDITION_SIGNAL; };
   ~mux_condition() { delete signal; };

   mux_condition *Copy(void);
   action_signal *Signal(void) { return signal; };
   bool Condition(void) { return condition; };
   bool IsSignal(void) { return type==CONDITION_SIGNAL; };
   char *Value(void) { return value.str; };
   action_signal *Signal2(void) { return value.sig; };

   bool Compare(mux_condition *cond2);
   void BitPos(productions *p,int bit_pos);
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos);
   void PrintCondition(FILE *file,int fsm,input_stream *stream,int bit_pos);
   void PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos);
};

class mux_and
{
private:
   mux_expression *left,*right;
public:
   mux_and(mux_expression *l,mux_expression *r) { left=l; right=r; };

   mux_expression *Left(void) { return left; };
   mux_expression *Right(void) { return right; };

   mux_and *Copy(void);

   bool Compare(mux_and *and2);
   void BitPos(productions *p,int bp); // used to determine variable references
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void write_driver(FILE *file, int fsm,input_stream *stream,int bp, int ind);
   void PrintAction(FILE *file, int fsm,input_stream *stream,int bp,int ind);
};

class mux_expression
{
private:
   enum {
      MUX_AND=0,
      MUX_CONDITION=1
   } type;
   union {
      mux_and *mand;
//      production_cond *cond;
      mux_condition *cond;
   } rel;
public:
   mux_expression(mux_and *m) { rel.mand=m; type=MUX_AND; };
//   mux_expression(production_cond *c) { rel.cond=c; type=MUX_CONDITION; };
   mux_expression(mux_condition *c) { rel.cond=c; type=MUX_CONDITION; };

   mux_expression *Copy(void);
   int Type(void) { return type; };
   bool IsAnd(void) { return type==MUX_AND; };
//   production_cond *Condition(void) { return rel.cond; };
   mux_condition *Condition(void) { return rel.cond; };
   mux_and *And(void) { return rel.mand; };

   bool Compare(mux_expression *expr2);
   void BitPos(productions *p,int bp); // used to determine variable references
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void write_driver(FILE *file, int fsm,input_stream *stream,int bp, int ind);
   void PrintAction(FILE *file, int fsm,input_stream *stream,int bp,int ind);
};

class action_mux
{
private:
   mux_expression *expr;
   action_line *tbr,*fbr;
public:
   action_mux(mux_expression *e,action_line *t, action_line *f) 
     { expr=e; tbr=t; fbr=f; };
   ~action_mux() {};
   action_mux *Copy(void);
   mux_expression *Expression(void) { return expr; };
   action_line *TrueBranch(void) { return tbr; };
   action_line *FalseBranch(void) { return fbr; };
   void BitPos(productions *p,int bp); // used to determine variable references
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   bool Compare(action_mux *mux2);
};

class action_item
{
private:
   union {
      action_macro *macro;
      action_variable *variable;
      action_constant *constant;
      action_cdfg *cdfg;
      action_mux *mux;
      action_signal *signal;
   } item;
   enum {
      PGM_MACRO=0,
      PGM_VARIABLE=1,
      PGM_CONSTANT=2,
      PGM_CDFG=3,
      PGM_MUX=4,
      PGM_SIGNAL=5
   } type;
public:
   action_item(action_macro *m)    { item.macro=m; type=PGM_MACRO; };
   action_item(action_variable *v) { item.variable=v; type=PGM_VARIABLE; };
   action_item(action_constant *c) { item.constant=c; type=PGM_CONSTANT; };
   action_item(action_cdfg *c)     { item.cdfg=c; type=PGM_CDFG; };
   action_item(action_mux *m)      { item.mux=m; type=PGM_MUX; };
   action_item(action_signal *s)   { item.signal=s; type=PGM_SIGNAL; };
   ~action_item();
   int Type(void) { return type; };
   char *Value(void) { return item.constant->Value(); };
   int BitSize(void); // { return item.constant->BitSize(); };
//   char *VarName(void)  { return item.variable->Name(); };
   action_constant *Constant(void) { return item.constant; };
   action_macro *Macro(void) { return item.macro; };
   action_signal *Signal(void) { return item.signal; };
   action_variable *Variable(void) { return item.variable; };
   action_mux *Mux(void) { return item.mux; };
   action_cdfg *CDFG(void) { return item.cdfg; };

   bool IsMacro(void) { return type==PGM_MACRO; };
   bool IsVariable(void) { return type==PGM_VARIABLE; };
   bool IsConstant(void) { return type==PGM_CONSTANT; };
   bool IsMux(void) { return type==PGM_MUX; };
   bool IsSignal(void) { return type==PGM_SIGNAL; };
   bool IsCDFG(void) { return type==PGM_CDFG; };

   action_item *Copy(void);
   void BitPos(productions *p,int bp); // used to determine variable references
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos,int target_size);
   void PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int target_size);
   void PrintMemoryAccess(FILE *file,int ind);
   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   action_line *ExpandActionMacros(void);
   bool Compare(action_item *item2);
};

class action_line:public List<action_item>
{
private:
   int nr_of_bits;
public:
   action_line(action_item *a):List<action_item>(a) {};
   action_line():List<action_item>() {};
   ~action_line();
   void AddMember(action_item *i);
   void AddMembers(action_line *l);
   action_line *Copy(void);

   int BitSize(void) { return nr_of_bits; };
   void BitSize(int i) { nr_of_bits=i; };

   void BitPos(productions *p,int bp); // used to determine variable references
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos,int target_size);
   void PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int target_size);
   void PrintMemoryAccess(FILE *file,int ind);
   action_schedule *WordAlignAction(int bit_pos,action_target *target);
   action_line *ExpandActionMacros(void);
   bool Compare(action_line *a2);
};

class action_muxed_line
{
private:
   mux_expression *expr;
   action *tbr,*fbr;
public:
   action_muxed_line(mux_expression *e,action *t, action *f) 
     { expr=e; tbr=t; fbr=f; };
   ~action_muxed_line() {};
   mux_expression *Expression(void) { return expr; };
   action *TrueBranch(void) { return tbr; };
   action *FalseBranch(void) { return fbr; };

   action_muxed_line *Copy(void);
   void BitPos(productions *p,int bp); // used to determine variable references
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   bool Compare(action_muxed_line *mux2);
};

class action_target
{
private:
   char *dest;
   action_address *address;
   //   range_class *target_range;
   int port_number;
   int address_size;
   int array_size;
   int bit_size;
   bool is_memory;
   bool is_input;
   bool is_output;
   bool is_internal;
public:
   action_target(char *d);                         // Pure Signal, no address
   action_target(char *d,action_address *a);       // Signal has an address
   action_target(char *d,int n,action_address *a); // Multi-port Memory
   //   action_target(char *d,range_class *r);                // Part of signal's range
   ~action_target();
   char *Dest(void) { return dest; };
   action_address *Address(void) { return address; };
   range_class *Range(void) { return Address()->Range(); };
   int PortNumber(void) { return port_number; };
   void PortNumber(int i) { port_number=i; };
   int AddressSize(void) { return address_size; };
   void AddressSize(int i) { address_size=i; };
   int ArraySize(void) { return array_size; };
   void ArraySize(int i) { array_size=i; };
   int BitSize(void) { return bit_size; }

   bool IsMemory(void) { return is_memory; };
   void IsMemory(bool b) { is_memory=b; };
   bool IsOutput(void) { return is_output; };
   void IsOutput(bool b) { is_output=b; };
   bool IsInput(void) { return is_input; };
   void IsInput(bool b) { is_input=b; };
   bool IsInternal(void) { return is_internal; };
   void IsInternal(bool b) { is_internal=b; };

   action_target *Copy(void);
   int Width(void) { return Range()->BitSize(); };
   void Elaborate(void);
   bool Compare(action_target *a2);
   void write_driver(FILE *file,input_stream *stream,int bit_pos,int ind);
   void PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos,int ind,action_line *line,int bit_size);

   void BitPos(productions *p,int bp);
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
};

class action
{
private:
   union { 
      action_target *signal;
      vhdl_code *code;
   } target;
   enum {
      PGM_SIGNAL=0,
      PGM_VHDL_CODE=1
   } type;
   int bit_size;
   bool expanded;
   union {
      action_line *line;
      action_muxed_line *mux;
   } act;
   enum {
      PGM_NOT_MUXED=0,
      PGM_MUXED=1
   } mux_type;
public:
   action(action_target *t,action_line *l) { target.signal=t; type=PGM_SIGNAL;
				    act.line=l; mux_type=PGM_NOT_MUXED;
				    expanded=false;
				  };
   action(action_target *t,action_muxed_line *m) { target.signal=t;
                                           type=PGM_SIGNAL;
					   act.mux=m; mux_type=PGM_MUXED;
					   expanded=false;
					 };
   action(vhdl_code *c) { target.code=c; type=PGM_VHDL_CODE; act.line=NULL; 
                          mux_type=PGM_NOT_MUXED; expanded=false; };
   ~action();
   action_target *Target(void) { return target.signal; };
   vhdl_code *VHDLCode(void) { return target.code; };
   int BitSize(void) { return bit_size; };
   void BitSize(int i) { bit_size=i; };
   action_line *Line(void)        { return act.line; };
   void Line(action_line *l)      { act.line=l; mux_type=PGM_NOT_MUXED; };
   action_muxed_line *Mux(void)   { return act.mux; };
   void Mux(action_muxed_line *m) { act.mux=m; mux_type=PGM_MUXED; };
   int Type(void)                 { return type; };
   int MuxType(void)              { return mux_type; };
   bool Expanded(void) { return expanded; };
   void Expanded(bool b) { expanded=b; };
   bool IsMuxed(void) { return mux_type==PGM_MUXED; };
   bool IsVHDL(void) { return type==PGM_VHDL_CODE; };
   bool IsSignal(void) { return type == PGM_SIGNAL; };
   action *Copy(void);

   void BitPos(productions *p,int bp);
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void write_driver(FILE *file,int fsm,input_stream *stream, int bit_pos,int ind);
   void PrintAction(FILE *file,int fsm,input_stream *stream, int bit_pos,int ind);
   action_schedule *WordAlignAction(void);
   action_line *ExpandActionMacros(void);
   bool Compare(action *a2);
   void DumpMember(FILE *file)
  {
	   /*
	   if (IsSignal())
	   {
		   fprintf(file, "   %s(?)\n", Target()->Dest());
		   sprintf(log_str, "%s(?)\n", Target()->Dest());
		   log(log_str);
	   };
	   */
	   fprintf(error_log, "DumpMember:: %08x\n",this);
  };
};

class actions:public List<action>
{
private:
   int bit_pos;
   bool has_been_moved;
public:
   actions():List<action>() {};
   actions(action *a):List<action>(a) {};
   action *Member(char *s);
   action *Member(int i) { return List<action>::Member(i); };
   void AddMembers(actions *a);
   void AddMember(action *a);
   actions *Copy(void);
   int BitPos(void) { return bit_pos; };
   void BitPos(productions *p,int bp);

   bool Compare(actions *a2);
   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void write_driver(FILE *file, int fsm,input_stream *stream,int bit_pos);
   void PrintAction(FILE *file,int fsm,input_stream *stream,int bp);
   void ExpandActionMacros(void);
   void DumpMembers(FILE *file);
};

class action_schedule:public List<actions>
{
public:
   action_schedule():List<actions>() {};
   action_schedule(actions *a):List<actions>(a) {};
   actions *Member(action_target *target);
   actions *Member(int i) { return List<actions>::Member(i); };
   //   void Member(int i,actions *a) { List<actions>::Member(i,a); }
   void AddMember(actions *a);
   void AddMembers(action_schedule *as);

   void CheckConsistency(int fsm,input_stream *stream,int bit_pos);
   void write_driver(FILE *file,int fsm,input_stream *stream,int bit_pos);
   void PrintAction(FILE *file,int fsm,input_stream *stream,int bit_pos);
};

class production_item
{
private:
   union {
      production_lexem *lexeme;
      production_redirection *redirection;
      production_terminal *terminal;
      production_cond *cond;
      production_interrupt *interrupt;
      production_reset *reset;
      production_error *error;
      actions *acts;
   } item;
   enum {
      PGM_LEXEM=0,
      PGM_REDIRECTION=1,
      PGM_TERMINAL=2,
      PGM_COND=3,
      PGM_INTERRUPT=4,
      PGM_RESET=5,
      PGM_ERROR=6,
      PGM_ACTION=7
   } type;
   int bit_pos;
   int nr_of_bits;
public:
   production_item(production_lexem *l)       { item.lexeme=l; type=PGM_LEXEM; 
						nr_of_bits=0; bit_pos=-1; };
   production_item(production_redirection *r) { item.redirection=r;
						type=PGM_REDIRECTION;
					        nr_of_bits=0; bit_pos=-1; };
   production_item(production_terminal *t)    { item.terminal=t;
						type=PGM_TERMINAL;
					        nr_of_bits=t->NrOfBits();
						bit_pos=-1; };
   production_item(production_cond *s)        { item.cond=s;
						type=PGM_COND;
					        nr_of_bits=1; bit_pos=-1; };
   production_item(production_interrupt *i)   { item.interrupt=i;
						type=PGM_INTERRUPT;
					        nr_of_bits=1; bit_pos=-1; };
   production_item(production_reset *r)       { item.reset=r;
						type=PGM_RESET;
					        nr_of_bits=1; bit_pos=-1; };
   production_item(production_error *e)       { item.error=e; type=PGM_ERROR;
					        nr_of_bits=0; bit_pos=-1; };
   production_item(actions *a)                { item.acts=a; type=PGM_ACTION;
					        nr_of_bits=0; bit_pos=-1; };
   ~production_item();
   bool IsLexem(void) { return (type==PGM_LEXEM); };
   bool IsRedirection(void) { return (type==PGM_REDIRECTION); };
   bool IsTerminal(void) { return (type==PGM_TERMINAL); };
   bool IsConstant(void) { return item.terminal->IsConstant(); };
   bool IsOthers(void) { return item.terminal->IsOthers(); };
   bool IsBits(void) { return item.terminal->IsBits(); };
   bool IsCond(void) { return type==PGM_COND; };
   bool IsInterrupt(void) { return type==PGM_INTERRUPT; };
   bool IsReset(void) { return type==PGM_RESET; };
   bool IsError(void) { return (type==PGM_ERROR); };
   bool IsAction(void) { return (type==PGM_ACTION); };
   char *Name(void) { return item.lexeme->Name(); };
   int Type(void) { return type; }; // For debugging purposes
   production_lexem *Lexem(void) { return item.lexeme; };
   production_redirection *Redirection(void) { return item.redirection; };
   production_terminal *Terminal(void) { return item.terminal; };
   production_cond *Cond(void) { return item.cond; };
   production_interrupt *Interrupt(void) { return item.interrupt; };
   production_reset *Reset(void) { return item.reset; };
   production_error    *Error(void) { return item.error; };
   actions             *Actions(void) { return item.acts; };
   int BitSize(void) { return nr_of_bits; };
   void BitSize(int i) { nr_of_bits=i; };
   int BitPos(void) { return bit_pos; };
   void BitPos(int i) { bit_pos=i; };
};

class production_line:public List<production_item>
{
private:
   int nr_of_bits;
public:
   production_line(production_item *i):List<production_item>(i) {};
   void BitSize(int i) { nr_of_bits=i; };
   int BitSize(void) { return nr_of_bits; }
};

typedef List<production_line> production_lines;

class production
{
private:
   char *name;
   production_lines *lines;
   int nr_of_bits;
   int bit_pos;
   input_stream *stream;
   bool is_referenceable;
public:
   production(char *n, production_lines *l)
      { name=cpystr(n); lines=l; stream=NULL; nr_of_bits=0; bit_pos=-1; };
   production(char *n, input_stream *s) // This one should only used within build_grammar_DAG
      { name=cpystr(n); lines=NULL; stream=s->Copy(); nr_of_bits=0; bit_pos=-1; };
   ~production() {};
   char *Name(void) { return name; };
   int NrOfLines(void) { return lines->NrOfMembers(); };
   production_line *Line(int i) { return lines->Member(i); };
   int BitSize(void) { return nr_of_bits; };
   void BitSize(int i) { nr_of_bits=i; };
   int BitPos(void) { return bit_pos; };
   void BitPos(int p) { bit_pos=p; };
   input_stream *Stream(void) { return stream; };
   void Stream(input_stream *s) { stream=s; };
   bool IsReferenceable(void) { return is_referenceable; };
   void IsReferenceable(bool b) { is_referenceable=b; };
};

class productions:public List<production>
{
public:
   productions(production *p):List<production>(p) {};
   productions():List<production>() {};
   production *Member(char *s);
   production *Member(int i) { return List<production>::Member(i); };
   void AddMember(production *p); /* Node-limited version only !!! */
   bool IsMember(char *s);
};

class layout
{
private:
   char *name;
   production_line *line;
public:
   layout(char *n, production_line *l) { name=n; line=l; };
   char *Name(void) { return name; };
   int NrOfMembers() { return line->NrOfMembers(); };
   production_item *Member(int i) { return line->Member(i); };
};

class layouts:public List<layout>
{
public:
   layouts():List<layout>() {};
   layouts(layout *l):List<layout>(l) {};
   layout *Member(char *s);
   layout *Member(int i) { return List<layout>::Member(i); };
};

class lexems:public List<lexem>
{
public:
   lexems(lexem *l):List<lexem>(l) {};
   lexems():List<lexem>() {};
   void ReduceExits(void);
   void LinkOthers(void);
   void InsertError(lexem *l);
   void SetAllVisited(bool flag);
};

//class state_groups:public List<lexems>
//{
//public:
//   state_groups():List<lexems>() {};
//   AddMember(lexem *l);
//   void ReduceRedundantStates(void);
//};

class hyper_state
{
   int state;
public:
   hyper_state() { state=-1; };
   void State(int i) { state=i; };
   int State(void) { return state; };
   bool IsMarked(void) { return (state!=-1); };
};

extern lexems *AllLexems;
class lexem
{
private:
   enum {
      PGM_TERMINAL=0,
      PGM_INTERRUPT=1,
      PGM_RESET=2,
      PGM_ERROR=3,
      PGM_EXIT=4
   } type;
   union {
      production_terminal *terminal;
      production_interrupt *interrupt;
      production_reset *reset;
      production_error *error;
   } lexeme;
   // Error Control
   bool visited;
   // Grammar Information
   input_stream *stream;
   char *rule;
   // int state;
   hyper_state *next_state;
   production_conds *conds;
   lexems *interrupts;
   lexems *preds;
   lexems *succs;
   bool loop;
   bool loop_entry;
   actions *acts;
   action_schedule *act_scheds;
   int bit_pos;
public:
   lexem(input_stream *s,production_terminal *t)
                                 { lexeme.terminal=t;
				   visited=false;
				   AllLexems->AddMember(this);
				   type=PGM_TERMINAL;
				   rule=NULL;
				   stream=s;
				   conds=new production_conds();
				   interrupts=new lexems();
				   preds=new lexems();
				   succs=new lexems();
				   loop=false;
				   loop_entry=false;
				   acts=new actions();
				   act_scheds=new action_schedule();
				   next_state=NULL;
				   bit_pos=0;
				 };
   lexem(production_interrupt *i){ lexeme.interrupt=i;
				   visited=false;
				   AllLexems->AddMember(this);
				   type=PGM_INTERRUPT;
				   rule=NULL;
				   stream=i->Stream();
				   conds=new production_conds();
				   interrupts=new lexems();
				   preds=new lexems();
				   succs=new lexems();
				   loop=false;
				   loop_entry=false;
				   acts=new actions();
				   act_scheds=new action_schedule();
				   next_state=NULL;
				   bit_pos=0;
				 };
   lexem(production_reset *r)    { lexeme.reset=r;
				   visited=false;
				   AllLexems->AddMember(this);
				   type=PGM_RESET;
				   rule=NULL;
				   stream=r->Stream();
				   conds=new production_conds();
				   interrupts=new lexems();
				   preds=new lexems();
				   succs=new lexems();
				   loop=false;
				   loop_entry=false;
				   acts=new actions();
				   act_scheds=new action_schedule();
				   next_state=NULL;
				   bit_pos=0;
				 };
   lexem(production_error *e)    { lexeme.error=e;
				   visited=false;
				   AllLexems->AddMember(this);
				   type=PGM_ERROR;
				   rule=NULL;
				   stream=NULL;
				   conds=new production_conds();
				   interrupts=new lexems();
				   preds=new lexems();
				   succs=new lexems();
				   loop=false;
				   loop_entry=false;
				   acts=new actions();
				   act_scheds=new action_schedule();
				   next_state=NULL;
				   bit_pos=0;
				 };
   lexem()                       { lexeme.error=NULL;
				   visited=false;
				   AllLexems->AddMember(this);
				   type=PGM_EXIT;
				   rule=NULL;
				   stream=NULL;
				   conds=new production_conds();
				   interrupts=new lexems();
				   preds=new lexems();
				   succs=new lexems();
				   loop=false;
				   loop_entry=false;
				   acts=new actions();
				   act_scheds=new action_schedule();
				   next_state=NULL;
				   bit_pos=0;
				 };
   ~lexem();
   lexem *Copy(void);
   int Type(void) { return type; }
   bool IsTerminal(void) { return (type==PGM_TERMINAL); };
   bool IsConstant(void) { if (IsTerminal()) return lexeme.terminal->IsConstant(); else return false; };
   bool IsOthers(void)   { if (IsTerminal()) return lexeme.terminal->IsOthers(); else return false; };
   bool IsBits(void)     { if (IsTerminal()) return lexeme.terminal->IsBits(); else return false; };
   bool IsInterrupt(void){ return (type==PGM_INTERRUPT); };
   bool IsReset(void)    { return (type==PGM_RESET); };
   bool IsError(void)    { return (type==PGM_ERROR); };
   bool IsExit(void)     { return (type==PGM_EXIT); };
   char *Value(void)	 { 
							if (IsTerminal())
							{ 
								return lexeme.terminal->Value(); 
							}
							else
							{
								return "NOT A TERMINAL";
							};
					};
   void Value(char *v) { if (IsTerminal())
						 { 
						    lexeme.terminal->Value(v);
						 }
					   };
   action_signals *ListOfSignals(void) { return lexeme.terminal->ListOfSignals(); };
   action_signal *Signal(int i) { return lexeme.terminal->Signal(i); };
   bool IsNegated(void) { return lexeme.terminal->IsNegated(); };
   production_terminal *Terminal(void)   { return lexeme.terminal; };
   production_interrupt *Interrupt(void) { return lexeme.interrupt; };
   production_reset *Reset(void)         { return lexeme.reset; };
   production_error *Error(void)         { return lexeme.error; };
   int BitSize(void);
   int BitPos(void) { return bit_pos; };
   void BitPos(int i) { bit_pos=i; };
   bool Visited(void) { return visited; };
   void Visited(bool flag) { visited=flag; };
   void Stream(input_stream *s) { stream=s; };
   input_stream *Stream(void) { return stream; };
   char *Rule(void) { return rule; };
   void Rule(char *r) { rule=cpystr(r); };
   int State(void) { return HyperState()->State(); };
   void State(int i) { HyperState()->State(i); };

   hyper_state *HyperState(void) { return next_state; };
   void HyperState(hyper_state *he) { next_state=he; };

   production_cond *Cond(int i) { return conds->Member(i); };
   production_conds *Conds(void) { return conds; };
   lexem *Succ(int i) { return succs->Member(i); };
   lexems *Succs(void) { return succs; };
   lexems *Interrupts(void) { return interrupts; };
   void Interrupts(lexems *l) { interrupts=l; };
   lexem *Pred(int i) { return preds->Member(i); };
   lexems *Preds(void) { return preds; };
   bool IsLoop(void) { return loop; };
   void IsLoop(bool b) { loop=b; };
   bool IsLoopEntry(void) { return loop_entry; };
   void IsLoopEntry(bool b) { loop_entry=b; };

   action *Action(int i) { return acts->Member(i); };
   actions *Actions(void) { return acts; };
   void ActScheds(action_schedule *s) { act_scheds=s; };
   action_schedule *ActScheds(void) { return act_scheds; };
   actions *ActSched(int i) { return act_scheds->Member(i); };
   int NrOfConds(void) { return conds->NrOfMembers(); };
   int NrOfInterrupts(void) { return interrupts->NrOfMembers(); };
   int NrOfSuccs(void) { return succs->NrOfMembers(); };
   int NrOfPreds(void) { return preds->NrOfMembers(); };
   int NrOfActions(void) { return acts->NrOfMembers(); };
   int NrOfActScheds(void) { return act_scheds->NrOfMembers(); };
   void AddInterrupts(lexems *l);
   void AddCond(production_cond *s);
   void AddSucc(lexem *l);
   void AddPred(lexem *l);
   void AddAction(action *a);
   void AddActions(actions *a);
   void AddActSched(actions *a);
   void AddActScheds(action_schedule *a);
   void DelCond(int i) { conds->DelMember(i); };
   void DelSucc(int i) { succs->DelMember(i); };
   void DelPred(int i) { preds->DelMember(i); };
   void DelAction(int i) { acts->DelMember(i); };
   void DelActSched(int i) { act_scheds->DelMember(i); };
   bool ReduceExits(void);
   void ReduceGrammar(void);
   lexem *AtomizeTerminals(void);
   void WordAlignTerminals(int bit_pos);
   void WordAlignActions(void);
   bool CompareSuccs(int i,int j);
   bool ComparePreds(int p1,int p2);
   void MergeSuccs(int i, int j);
   void MergePreds(int p1,int p2);

   void MoveCond(int i,lexem *l);
   void MoveAllConds(lexem *l);
   void MoveLeftConds(lexem *l);
   void MoveRightConds(lexem *l);
   void MoveSucc(int i,lexem *l);
   void MovePred(int i,lexem *l);
   void MoveSuccs(lexem *l);
   void MoveAction(int i,lexem *l);
   void MoveActions(lexem *l);
   void MoveInterrupts(lexem *l);

   void CopyCond(int i,lexem *l);
   void CopyAllConds(lexem *l);
   void CopyAction(int i,lexem *l);
   void CopyActions(lexem *l);
   void CopySucc(int i,lexem *l);
   void CopySuccs(lexem *l);
   int  MarkAllStates(int next_state);
   void ReduceTailStates(void);
   void write_driver(FILE *file, int fsm,int bit_pos);
   void SetAllBitPos(int bp);
   void PrintAllTransitions(FILE *file,int fsm);
   void PrintTransition(FILE *file,char *stream,int output_stream_width);
   void ScheduleUpwards(void);
   void MoveUpSchedActs(void);
   void MoveUpSchedActs(int start,int nr);
   void ScheduleDownwards(void);
   void MoveDownSchedActs(void);
//   void CleanActScheds(void);
   int  CompareActions(actions *a1,actions *a2);
   bool OutputIsWrittenToByAllSuccs(action_target *target);
   bool CompareActionWithAllSuccs(action_target *Target,actions *sched,int nr);
   void DelMovedActionsFromAllSuccs(action_target *target,int nr);
   void CheckConsistency(int fsm);
   void LinkOthers(void);
   void ConnectInterruptEnds(lexem *exit_lexem);
   void LinkInterrupts(void);
   void MoveErrors(void);
   void LinkErrors(void);
   void InsertError(lexem *l);
   void UnlinkInterruptHolders(void);

   void SplitDAGintoTree(void);
   void CreateHyperStates(void);
   void MergeHyperStates(void);

   void DebugDataBase(FILE *file);
   void DumpNode(FILE *file);
   void DumpGraph(FILE *file);
   void DumpDaVinci(FILE *file);

   void BuildEstimate(fsm_estimates *fes,output_estimates *oes);
};

class elaboration
{
private:
   char *port;
   int width;
public:
   elaboration(char *p,int w) { port=cpystr(p); width=w; };
   char *Port(void) { return port; };
   int Width(void) { return width; };
   void Elaborate(void);
};

class elaborations:public List<elaboration>
{
public:
   elaborations():List<elaboration>() {};
   elaborations(elaboration *e):List<elaboration>(e) {};
   void Elaborate(void);

   elaboration *Member(char *m);
   elaboration *Member(int i) { return List<elaboration>::Member(i); };

};

//class binary_transition
//{
//private:
//   binary_transition *zero,*one,*dash;
//   lexem *next_state;
//public:
//   binary_transition(lexem *s) { zero=NULL; one=NULL;
//				 dash=NULL; next_state=s; };
//   binary_transition(char *b,lexem *s);
//   bool HasZero(void) { return zero!=NULL; };
//}

#define DONT_CARE_BIT '-'
#define OTHER_BIT 'X'

#endif
