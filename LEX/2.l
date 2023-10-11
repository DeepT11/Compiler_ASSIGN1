%{
#include<stdio.h>

int intCount = 0;
int floatCount = 0;
%}

digit       [0-9]
integer     {digit}+
float       {digit}+"."{digit}+
whitespace  [ \t\n]+

%%

{integer}   { intCount++; }
{float}     { floatCount++; }
{whitespace} /* Ignore whitespace */
.           /* Ignore other characters */

%%

int main() {
    yylex();
    printf("Number of integers: %d\n", intCount);
    printf("Number of floating-point numbers: %d\n", floatCount);
    return 0;
}
