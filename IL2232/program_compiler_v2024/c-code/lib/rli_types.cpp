#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include "rli_string.h"
#include "rli_types.h"

// **********************************************************************
// * Declare all member functions
// **********************************************************************
//******************* Methods for Dyn_Var ******************

Dyn_Var::~Dyn_Var()
{
   if (name!=NULL) delete [] name; // Delete the name string
   if (type==OBJECT)
   {
      if (item.object!=NULL) delete item.object; //->~Dyn_Object();
   }
   else if (type==TUPLE)
   {
      if (item.tuple!=NULL) delete item.tuple; //->~Dyn_Tuple();
   }
   else
   {
      if (item.value!=NULL) delete [] item.value; // Delete the Value string
   };
};

Dyn_Var *Dyn_Var::Member(char *member)
{
   if (type==OBJECT)
   {
      return item.object->Member(member);
   }
   else
   {
      fprintf(error_log,"Error: Dynamic Variable is an item or a tuple, NOT an object!\n");
      exit(1);
   };
};

Dyn_Var *Dyn_Var::Member(int member)
{
   if (type==OBJECT)
   {
      return item.object->Member(member);
   }
   else if (type==TUPLE)
   {
      return item.tuple->Member(member);
   }
   else
   {
      fprintf(error_log,"Error: Dynamic Variable is an item, NOT an object or a tuple!\n");
      exit(1);
   };
};

int Dyn_Var::NrOfMembers()
{
   if (type==OBJECT)
   {
      return item.object->NrOfMembers();
   }
   else if (type==TUPLE)
   {
      return item.tuple->NrOfMembers();
   }
   else
   {
      fprintf(error_log,"Error: Dynamic Variable is an item, NOT an object or a tuple!\n");
      exit(1);
   };
}

void Dyn_Var::Write(FILE *file)
{
   if (type==SINGLE)
   {
      if (name==NULL)
      {
	 fprintf(file,"       %s",item.value);
      }
      else
      {
	 fprintf(file,"       %s %s",name,item.value);
      };
   }
   else
   {
      if (name==NULL)
      {
	 fprintf(file,"      (\n");
      }
      else
      {
	 fprintf(file,"   %s (\n",name);
      };
      if (type==OBJECT)
      {
	 if (item.object!=NULL) item.object->Write(file);
      }
      else // type==TUPLE
      {
	 item.tuple->Write(file);
      };
      fprintf(file,"      )");
   };
};

//******************* Methods for Dyn_Object ******************

//   Dyn_Object(Dyn_Var *data);
//   ~Dyn_Object();
//   void AddMember(Dyn_Var *new_memb); // Add a member last in the Set
//   void AddFirst(Dyn_Var *new_memb); // Add a member first in the Set
//   int DelMember(char *old_memb);
//   int ExistMember(char *old_memb);
//   Dyn_Var *Member(char *memb);

// Returns the pointer to Data item search_name
Dyn_Var *Dyn_Object::Member(char *member)
{
   int i;
   for (i=0;i<NrOfMembers();i++)
   {
      if (strcmp(member,Member(i)->Name())==0)
      {
	 return Member(i);
      };
   };
   return NULL;
};

void Dyn_Object::DelMember(char *s)
{
   int i,found=-1;
   for (i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
	 found=i;
	 break;
      };
   };
   if (found!=-1)
   {
      DelMember(i);
   }
};

bool Dyn_Object::ExistMember(char *s)
{
   int i;
   bool found=false;
   for (i=0;i<NrOfMembers();i++)
   {
      if (strcmp(s,Member(i)->Name())==0)
      {
	 found=true;
	 break;
      };
   };
   return found;
};

void Dyn_Object::Write(FILE *file)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->Write(file);
      if (i==NrOfMembers()-1)
      {
	 fprintf(file,"\n");
      }
      else
      {
	 fprintf(file,";\n");
      };
   };
};

//******************* Methods for Dyn_Tuple ******************

//   Dyn_Tuple(Dyn_Var *data);
//   ~Dyn_Tuple();
//   void AddMember(Dyn_Var *new_memb); // Add a member last in the Set
//   void AddFirst(Dyn_Var *new_memb); // Add a member first in the Set

void Dyn_Tuple::Write(FILE *file)
{
   int i;
   for(i=0;i<NrOfMembers();i++)
   {
      Member(i)->Write(file);
      if (i==NrOfMembers()-1)
      {
	 fprintf(file,"\n");
      }
      else
      {
	 fprintf(file,",\n");
      };
   };
};
