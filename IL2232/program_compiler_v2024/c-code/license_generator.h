#ifndef __LICENSE_GENERATOR_H__
#define __LICENSE_GENERATOR_H__

#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

extern char log_str[1024];
extern void log(char *s);

class key_date
{
private:
	char cdate[11];
	char ctime[9];
	char cwday[4];
	char cmon[4];
	char cmday[3];
	char cyear[5];
public:
	key_date()
	{
		struct tm *current;
		time_t now;
		time(&now);
		current = localtime(&now);
		char weekday[7][4]={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
		char month[12][4]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
		sprintf(cmon,"%s",month[current->tm_mon]);
		sprintf(cwday,"%s",weekday[current->tm_wday]);
		sprintf(cyear,"%d",1900+current->tm_year);
		if (current->tm_mday<10)
		{
			sprintf(cmday,"0%d",1+current->tm_mday);
		}
		else
		{
			sprintf(cmday,"%d",1+current->tm_mday);
		}
		if (current->tm_mon<9)
		{
			if (current->tm_mday<10)
			{
				sprintf(cdate,"%4d-0%d-0%d",1900+current->tm_year,1+current->tm_mon,current->tm_mday);
			}
			else
			{
				sprintf(cdate,"%4d-0%d-%2d",1900+current->tm_year,1+current->tm_mon,current->tm_mday);
			};
		}
		else
		{
			if (current->tm_mday<10)
			{
				sprintf(cdate,"%4d-%2d-0%d",1900+current->tm_year,1+current->tm_mon,current->tm_mday);
			}
			else
			{
				sprintf(cdate,"%4d-%2d-%2d",1900+current->tm_year,1+current->tm_mon,current->tm_mday);
			}
		};
		if (current->tm_hour<10)
		{
			if (current->tm_min<10)
			{
				if (current->tm_sec<10)
				{
					sprintf(ctime,"0%d:0%d:0%d",current->tm_hour,current->tm_min,current->tm_sec);
				}
				else
				{
					sprintf(ctime,"0%d:0%d:%2d",current->tm_hour,current->tm_min,current->tm_sec);
				}
			}
			else
			{
				if (current->tm_sec<10)
				{
					sprintf(ctime,"0%d:%2d:0%d",current->tm_hour,current->tm_min,current->tm_sec);
				}
				else
				{
					sprintf(ctime,"0%d:%2d:%2d",current->tm_hour,current->tm_min,current->tm_sec);
				}
			}
		}
		else
		{
			if (current->tm_min<10)
			{
				if (current->tm_sec<10)
				{
					sprintf(ctime,"%2d:0%d:0%d",current->tm_hour,current->tm_min,current->tm_sec);
				}
				else
				{
					sprintf(ctime,"%2d:0%d:%2d",current->tm_hour,current->tm_min,current->tm_sec);
				}
			}
			else
			{
				if (current->tm_sec<10)
				{
					sprintf(ctime,"%2d:%2d:0%d",current->tm_hour,current->tm_min,current->tm_sec);
				}
				else
				{
					sprintf(ctime,"%2d:%2d:%2d",current->tm_hour,current->tm_min,current->tm_sec);
				}
			}
		}
	}
	~key_date();
	char *Date(void) { return cdate; };
	char *Time(void) { return ctime; };
	char *Day(void) { return cmday; };
	char *WeekDay(void) { return cwday; };
	char *Month(void) { return cmon; };
	char *Year(void) { return cyear; };
};
#define SIZE_OF_KEY 70
typedef struct
{
	char key[2*SIZE_OF_KEY+1];
	char date[11];
	char feature[21];
} key_struct;
class key_generator
{
private:
	char key[2*SIZE_OF_KEY+2];
	char res[2*SIZE_OF_KEY];
	char *date;
	char *feature;
public:
	key_generator()
	{
		for(int i=0;i<2*SIZE_OF_KEY+1;i++) key[i]=0; 
	};
	key_generator(char *d,char *f,char *cname) {
		date=d; feature=f;
		char tmp[SIZE_OF_KEY+1];
		sprintf(tmp,"%-20s%10s%20s%20s",f,d,cname,f);
		Multiply(tmp,tmp);
		CreateKey();
	};
	~key_generator() {};
	char *Key(void) { return key; }; // For test purposes only, should be removed in sharp version...
	void Generate(FILE *file)
	{
		fprintf(file,"%s %s %s\n",feature,date,key);
	};
	bool CheckOut(char *d,char *f,char *k)
	{
		key_date *tmp_date=new key_date();
		if (strcmp(d,tmp_date->Date())<0)
		{
			sprintf(log_str,"\nError: License Feature %s has expired.\n",f);
			log(log_str);
			//fprintf(stderr,"\nError: License Feature %s has expired.\n",f);
			//exit(1);
			return false;
		}
		free(tmp_date);
		TCHAR name[MAX_COMPUTERNAME_LENGTH+2];
		DWORD name_size;
        name_size=sizeof name -  1;
        GetComputerName(name,&name_size);
		char cname[MAX_COMPUTERNAME_LENGTH+1];
		sprintf(cname,"%s",name);
		//sprintf(log_str,"%s %d %s\n",name,strlen(cname),cname);
		//log(log_str);
		char tmp[SIZE_OF_KEY+1];
		sprintf(tmp,"%-20s%10s%20s%20s",f,d,cname,f);
		log(tmp);
		log("\n");
		Multiply(tmp,tmp);
		CreateKey();
		//sprintf(log_str,"%s\n%s\n",k,key);
		//log(log_str);
		if(strcmp(k,key)==0) return true;
		return false;
	};
	void Multiply(char *op1,char *op2)
	{
		for(int i=0;i<2*SIZE_OF_KEY;i++) res[i]=0;
		for(int i=0;i<SIZE_OF_KEY;i++)
		{
			int carry=0;
			for(int j=0;j<SIZE_OF_KEY;j++)
			{
				int tal1=op1[i];
				if (tal1<0) tal1=256-tal1;
				int tal2=op2[j];
				if (tal2<0) tal2=256-tal2;
				int old_res=res[i+j];
				int result=old_res+tal1*tal2+carry;
				tal1 = result % 256;
				carry = result / 256;
				res[i+j]=tal1;
			};
		};
	};
	void CreateKey(void)
	{
		for(int i=0;i<SIZE_OF_KEY;i++)
		{
			int result=res[i];
			if (result<0) result=256-result;
			for(int j=0;j<2;j++)
			{
				int test=(result % 16);
				if (test>9)
				{
					key[2*i+j]=65 + (test-10);
				}
				else
				{
					key[2*i+j]=48 + test;
				}
				result=result/16;
			};
		};
		key[2*SIZE_OF_KEY]=0;
	};
};

#endif  __LICENSE_GENERATOR_H__