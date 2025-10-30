#ifndef LIST
#define LIST

#include <stdio.h>
#include <malloc.h>

FILE *error_log = stderr;

template <class temp> class List
{
private:
   int nr_of_members;
   temp **members;
public:
   List() { nr_of_members=0; members=NULL; };
   List(temp *member);
   ~List();
   int NrOfMembers(void) const { return nr_of_members; };
   void AddMember(temp *member);
   void AddFirst(temp *member);
   void DelMember(int i);
   void DelMembers(int from, int to);
   void DelAllMembers(void);
   void RemoveDuplicates(void);
   void RemoveNullPointers(void);
   temp *Member(int i) const { 
		fprintf(error_log,"%p\n",members);
		return members[i]; };
   bool IsMember(temp *member);
   int Find(temp *member);
   void Replace(int i,temp *member);
};

template <class temp> List<temp>::List(temp *member)
{
   nr_of_members=1;
   members=new temp *;
   members[0]=member;
};

template <class temp> List<temp>::~List()
{
   int i;
   for(i=0;i<nr_of_members;i++)
   {
      if (members[i]!=NULL) delete members[i];
   };
   if (members!=NULL) delete members;
};

template <class temp> void List<temp>::AddMember(temp *member)
{
   nr_of_members++;
   if (nr_of_members==1)
   {
      members=new temp *;
   }
   else
   {
      temp **tmp=members;
      members=new temp *[nr_of_members];
      for(int i=0;i<nr_of_members-1;i++)
      {
	 members[i]=tmp[i];
      };
      delete tmp;
   };
   members[nr_of_members-1]=member;
};

template <class temp> void List<temp>::AddFirst(temp *member)
{
   int i;
   nr_of_members++;
   if (nr_of_members==1)
   {
      members=new temp *;
   }
   else
   {
      temp **tmp=members;
      members=new temp *[nr_of_members];
      for(int i=nr_of_members-1;i>0;i--)
      {
	 members[i]=tmp[i-1];
      };
      delete tmp;
   };
   members[0]=member;
};

template <class temp> void List<temp>::DelMember(int i)
{
   int j;
   if (members[i]!=NULL) delete members[i];
   for(j=i+1;j<nr_of_members;j++)
   {
      members[j-1]=members[j];
   }
   nr_of_members--;
   temp **tmp=members;
   members=new temp *[nr_of_members];
   for(int i=0;i<nr_of_members-1;i++)
   {
      members[i]=tmp[i];
   };
   delete tmp;
};

template <class temp> void List<temp>::DelMembers(int from, int to)
{
   int i,j;
   if (to>nr_of_members-1)
   {
      fprintf(error_log,"DelMembers::Upper index out of bounds\n");
      exit(1);
   };
   if (from<0)
   {
      fprintf(error_log,"DelMembers::Lower index out of bounds\n");
      exit(1);
   };
   if (to+1==nr_of_members)
   {
      nr_of_members=from;
   }
   else
   {
      for(i=to+1,j=from;i<nr_of_members;i++,j++)
      {
	 members[j]=members[i];
      }
      nr_of_members=nr_of_members-(to-from+1);
   };
   if (nr_of_members==0)
   {
      members=NULL;
   }
   else
   {
      temp **tmp=members;
      members=new temp *[nr_of_members];
      for(int i=0;i<nr_of_members-1;i++)
      {
	 members[i]=tmp[i];
      };
      delete tmp;
   };
};

template <class temp> void List<temp>::DelAllMembers(void)
{
   int j;
   for(j=0;j<nr_of_members;j++)
   {
      if (members[j]!=NULL) delete members[j];
   };
   nr_of_members=0;
   delete members;
   members=NULL;
};

template <class temp> void List<temp>::RemoveDuplicates(void)
{
   int i,j;
   if (NrOfMembers()<=1) return;
   for(i=0;i<NrOfMembers()-1;i++)
   {
      for(j=i+1;j<NrOfMembers();j++)
      {
	 if (Member(i)==Member(j))
	 {
	    Replace(j,NULL);
	 };
      };
   };
   RemoveNullPointers();
};

template <class temp> void List<temp>::RemoveNullPointers(void)
{
   int i;
   for(i=NrOfMembers()-1;i>=0;i--)
   {
      if (Member(i)==NULL)
      {
	 DelMember(i);
      };
   };
};

template <class temp> bool List<temp>::IsMember(temp *member)
{
   int i;
   for(i=0;i<nr_of_members;i++)
   {
      if (Member(i)==member)
      {
	 return true;
      };
   };
   return false;
};

template <class temp> int List<temp>::Find(temp *member)
{
   int j;
   for(j=0;j<nr_of_members;j++)
   {
      if (Member(j)==member)
      {
	 return j;
      };
   };
   fprintf(error_log,"   Could not find Member %08x\n",member);
   exit(1);
};

template <class temp> void List<temp>::Replace(int i,temp *member)
{
   if ((i>=nr_of_members) || (i<0))
   {
      fprintf(error_log,"   Member address %d out of range\n",i);
      exit(1);
   }
   members[i]=member;
};

#endif
