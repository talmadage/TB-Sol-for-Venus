#ifndef __ESTIMATIONS_
#define __ESTIMATIONS_

#include <stdio.h>
#include "program.h"

class technology
{
private:
   char *name;
   int nand,tand,nor,tor,inv,txor,fa,ha,mux,fd,ld,pad;
public:
   technology(char *n) { name=cpystr(n); nand=0; tand=0; nor=0; tor=0; inv=0;
		         txor=0; fa=0; ha=0; mux=0; fd=0; ld=0; pad=0; };
   void Nand(int i) { nand=i; };
   void And(int i)  { tand=i; };
   void Nor(int i)  { nor=i; };
   void Or(int i)   { tor=i; };
   void Inv(int i)  { inv=i; };
   void Xor(int i)  { txor=i; };
   void Fa(int i)   { fa=i; };
   void Ha(int i)   { ha=i; };
   void Mux(int i)  { mux=i; };
   void Fd(int i)   { fd=i; };
   void Ld(int i)   { ld=i; };
   void Pad(int i)  { pad=i; };
   int Nand(void) { return nand; };
   int And(void)  { return tand; };
   int Nor(void)  { return nor; };
   int Or(void)   { return tor; };
   int Inv(void)  { return inv; };
   int Xor(void)  { return txor; };
   int Fa(void)   { return fa; };
   int Ha(void)   { return ha; };
   int Mux(void)  { return mux; };
   int Fd(void)   { return fd; };
   int Ld(void)   { return ld; };
   int Pad(void)  { return pad; };

   int FSMCore(int nr_of_bits);
   int Mux(int nr_of_inputs,int nr_of_bits) { return (nr_of_inputs-1)*nr_of_bits; };
   int PLA(int nr_of_inputs,int nr_of_outputs,int nr_of_products);
   int PLA(char **pla_inputs,char **pla_outputs,int nr_of_products);
   int EQU(char *s);
};

class lexem;
class fsm_estimate
{
private:
   int state;
   lexem *transition;
   char *from_state;
   char *to_state;
public:
   fsm_estimate(int state,lexem *t);
   lexem *Transition(void) { return transition; };
   int State(void) { return state; };
   char *FromState(void) { return from_state; };
   char *ToState(void) { return to_state; };
//   char *Cover(char *b);
   void Initiate(int state_vector_size);
   void Estimate(FILE *file, technology *tech);
   void DumpKISS(FILE *file);
};

class fsm_estimates:public List<fsm_estimate>
{
   int state_vector_size;
public:
   fsm_estimates():List<fsm_estimate>() {};
   fsm_estimates(fsm_estimate *fe):List<fsm_estimate>(fe) {};
//   void AddMember(transition *t);
//   char *Cover(void);
   void Sort(void);
   void StateVectorSize(int i) { state_vector_size=i; };
   int StateVectorSize(void) { return state_vector_size; }
   fsm_estimates *Partition(bool incr);
   void Initiate(int state_vector_size);
   int Estimate(FILE *file, technology *tech);
   int EstimateJumpArea(technology *tech);
   int EstimateIncrArea(technology *tech);
   void DumpKISS(FILE *file);
};

class output_bits:public List<action_item>
{
public:
  output_bits():List<action_item>() {};
  output_bits(action_item *ai);
  void AddMember(action_item *ai);
  int Find(action_item *ai);
};

class output_estimate
{
private:
   char *name;
   int width;
   int state;
   char *state_bits;
   lexem *transition;
   actions *assignment;
   action_schedule *split;
public:
   output_estimate(int s, lexem *t, actions *a);
   void Name(char *s) { name=cpystr(s); };
   char *Name(void) { return name; };
   void Width(int w) { width=w; };
   int Width(void) { return width; };
   int State(void) { return state; };
   char *StateBits(void) { return state_bits; };
   lexem *Transition(void) { return transition; };
   actions *Actions(void) { return assignment; };
   action_schedule *Split(void) { return split; };
   bool IsSignal(void);
   bool IsVariable(void);
   bool IsConstant(void);
//   int Estimate(FILE *file,technology *tech);
   void Initiate(int state_vector_size);
   void SplitAssignment(void);
   void DumpKISS(FILE *file,int fsm,int state_vector_size);
};

class output;
class internal;
class output_partitions;
class output_estimates:public List<output_estimate>
{
   int state_vector_size;
public:
   output_estimates():List<output_estimate>() {};
   output_estimates(output_estimate *e):List<output_estimate>(e) {};

   output_estimates *Partition(output *oput);
   output_estimates *Partition(internal *intp);
   output_partitions *Partition(void);
   void StateVectorSize(int i) { state_vector_size=i; };
   int StateVectorSize(void) { return state_vector_size; }
   void Initiate(int state_vector_size);

   int Partition(FILE *file,technology *tech);
   int Estimate(technology *tech);
   void SplitAssignment(void);
   void DumpKISS(FILE *file,int fsm,int state_vector_size);
};

class output_partitions:public List<output_estimates>
{
public:
   output_partitions():List<output_estimates>() {};
   output_partitions(output_estimates *oe):List<output_estimates>(oe) {};
   int Estimate(FILE *file,technology *tech);
};

#endif





