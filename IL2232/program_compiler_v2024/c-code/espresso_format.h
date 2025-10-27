#ifndef __ESPRESSO_FORMAT_H_
#define __ESPRESSO_FORMAT_H_

#include <stdio.h>
#include "lib/list.hpp"
#include "lib/rli_string.h"
#include "estimations.h"

extern FILE *error_log;

class parsed_cube
{
private:
   char *input;
   char *output;
public:
   parsed_cube(char *i,char *o) { input=cpystr(i); output=cpystr(o); };
   char *Input(void) { return input; };
   char Output(int i) { return output[i]; };
   char *Output(void) { return output; };
   int NrOfInputs(void) { return strlen(input); };
   int NrOfOutputs(void) { return strlen(output); };
   void Write(FILE *file);
};

class parsed_cubes:public List<parsed_cube>
{
public:
   parsed_cubes():List<parsed_cube>() {};
   parsed_cubes(parsed_cube *c):List<parsed_cube>(c) {};
   int Estimate(technology *tech);
   void Write(FILE *file);
};

class parsed_labels:public List<char>
{
public:
   parsed_labels():List<char>() {};
   parsed_labels(char *s):List<char>(s) {};
   void Write(FILE *file);
};

extern parsed_cubes *Function;
extern parsed_labels *InputLabels;
extern parsed_labels *OutputLabels;

extern int espresso_parse(void);
extern int espresso_lines;
extern FILE *espresso_in;


#endif // __ESPRESSO_FORMAT_H_







