#ifndef RLI_STRING
#define RLI_STRING

extern int minimum(int a,int b);
extern int find(char *s,char c,int start);
extern char *midstr(char *s,int start,int bits);
extern char *cpystr(char *s);
extern char *c2s(char c);
extern char *catstr(char *s1,char *s2);
extern char *itoa(int i);
//extern char *ltoa(long l);
//extern char *lltoa(long long ll);
extern char *repeat(char c,int nr);
extern char *mirror(char *s);

#endif /* RLI_STRING */

