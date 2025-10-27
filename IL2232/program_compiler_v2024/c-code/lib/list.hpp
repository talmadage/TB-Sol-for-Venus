#ifndef LIST
#define LIST

#include <stdio.h>
#include <malloc.h>

template <class temp>
class List
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
   temp *Member(int i) const { return members[i]; };
   bool IsMember(temp *member);
   int Find(temp *member);
   void Replace(int i,temp *member);
   //   List<temp> *Copy(void);
};

template <class temp> List<temp>::List(temp *member)
{
   nr_of_members=1;
   members=(temp **)malloc(sizeof(temp *));
   members[0]=member;
};

template <class temp> List<temp>::~List()
{
   int i;
   for(i=0;i<nr_of_members;i++)
   {
      if (members[i]!=NULL) delete members[i];
   };
   if (members!=NULL) free(members);
};

template <class temp> void List<temp>::AddMember(temp *member)
{
   nr_of_members++;
   if (nr_of_members==1)
   {
      members=(temp **)malloc(sizeof(temp *));
   }
   else
   {
      members=(temp **)realloc(members,sizeof(temp *)*nr_of_members);
   };
   members[nr_of_members-1]=member;
};

template <class temp> void List<temp>::AddFirst(temp *member)
{
   int i;
   nr_of_members++;
   if (nr_of_members==1)
   {
      members=(temp **)malloc(sizeof(temp *));
   }
   else
   {
      members=(temp **)realloc(members,sizeof(temp *)*nr_of_members);
   };
   for(i=nr_of_members-1;i>0;i--)
   {
      members[i]=members[i-1];
   }
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
   members=(temp **)realloc(members,sizeof(temp *)*nr_of_members);
};

template <class temp> void List<temp>::DelMembers(int from, int to)
{
   int i,j;
   //fprintf(error_log, "%d Members - Deleting members %d to %d\n", nr_of_members, from, to);
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
	  //fprintf(error_log, "to=%d, from=%d\n", to, from);
      for(i=to+1,j=from;i<nr_of_members;i++,j++)
      {
		  //fprintf(error_log, "Creating new member %d - Deleting old member %d(%08x), moving member %d(%08x)\n", j, j, members[j], i, members[i]);
		 //if (members[j]!=NULL) delete members[j]; //Executing this line creates a core dump in Windows for some reason...
		 members[j]=members[i];
      }
      nr_of_members=nr_of_members-(to-from+1);
   };
   //fprintf(error_log, "Nr of remaining members - %d\n",nr_of_members);
   if (nr_of_members==0)
   {
      members=NULL;
   }
   else
   {
      members=(temp **)realloc(members,sizeof(temp *)*nr_of_members);
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
   free(members);
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

//template <class temp> List<temp> *List<temp>::Copy(void)
//{
//   List<temp> *ret=new List<temp>();
//   for(int i=0;i<nr_of_members;i++)
//   {
//      ret->AddMember(Member()->Copy());
//   };
//   return ret;
//};

#endif


