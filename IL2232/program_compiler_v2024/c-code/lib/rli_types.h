#ifndef RLI_TYPES
#define RLI_TYPES

#include <stdio.h>
#include "rli_string.h"
#include "list.hpp"

extern FILE *error_log;

// **********************************************************************
// * Declare all classes for dynamic database
// **********************************************************************

class Dyn_Object;
class Dyn_Tuple;

class Dyn_Var
{
private:
   enum {SINGLE=0,OBJECT=1,TUPLE=2};
   char *name;
   int type;
   union
   {
      char *value;
      Dyn_Object *object;
      Dyn_Tuple *tuple;
   } item;
public:
   Dyn_Var(void) { name=NULL; type=SINGLE; item.value=NULL; };
   Dyn_Var(char *new_name, char *new_value)
     { name=new_name; type=SINGLE; item.value=new_value; };
   Dyn_Var(char *new_value)
     { name=NULL; type=SINGLE; item.value=new_value; };
   Dyn_Var(char *new_name, Dyn_Object *new_object)
     { name=new_name; type=OBJECT; item.object=new_object; }; 
   Dyn_Var(Dyn_Object *new_object)
     { name=NULL; type=OBJECT; item.object=new_object; }; 
   Dyn_Var(char *new_name, Dyn_Tuple *new_tuple)
     { name=new_name; type=TUPLE; item.tuple=new_tuple; }; 
   Dyn_Var(Dyn_Tuple *new_tuple)
     { name=NULL; type=TUPLE; item.tuple=new_tuple; }; 
   ~Dyn_Var();
   // Data Set Functions
   void Name(char *n) { name=n; }
   void Value(char *v) { item.value=v; }
   // Data retrieval functions
   int Type() { return type; };
   char *Name(void) { return name; };
   char *Value(void) { return item.value; };
   Dyn_Var *Member(char *member);
   Dyn_Var *Member(int member);
   int NrOfMembers();
   // File functions
   void Write(FILE *file);
};

class Dyn_Object:public List<Dyn_Var>
{
public:
   Dyn_Object():List<Dyn_Var>() {};
   Dyn_Object(Dyn_Var *d):List<Dyn_Var>(d) {};
   ~Dyn_Object() {};
   void AddMember(Dyn_Var *v) { List<Dyn_Var>::AddMember(v); };
//   void AddFirst(Dyn_Var *new_memb); // Add a member first in the Set
   void DelMember(char *s);
   void DelMember(int i) { List<Dyn_Var>::DelMember(i); };
   bool ExistMember(char *s);
//   int NrOfMembers(void) { return nr_of_members; };
//   void NrOfMembers(int new_nr) { nr_of_members=new_nr; };
   Dyn_Var *Member(char *member);
   Dyn_Var *Member(int i) { return List<Dyn_Var>::Member(i); };
   // File functions
   void Write(FILE *file);
};

class Dyn_Tuple:public List<Dyn_Var>
{
public:
   Dyn_Tuple():List<Dyn_Var>() {};
   Dyn_Tuple(Dyn_Var *data):List<Dyn_Var>(data) {};
   ~Dyn_Tuple() {};
   void AddMember(Dyn_Var *v) { List<Dyn_Var>::AddMember(v); };
//   void AddFirst(Dyn_Var *new_memb); // Add a member first in the Set
//   int DelMember(int member);
//   int NrOfMembers(void) { return nr_of_members; };
//   void NrOfMembers(int new_nr) { nr_of_members=new_nr; };
//   Dyn_Var *Member(int i) { return List<Dyn_Var>::Member(i); };
   // File functions
   void Write(FILE *file);
};

#endif /* RLI_TYPES */




