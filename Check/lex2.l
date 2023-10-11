%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int curve_bracket=0;
%}

digit [0-9]
integers {digit}+
char [a-zA-Z]
chars {char}+
special [-@#*+/:_\\]
id {special}{integers}|{special}{integers}{chars}|{special}{chars}{integers}|{special}{chars}|{chars}{integers}|{integers}{chars}|{chars}
punctuation [,"":;'']
operator [+*/_=-]

%%
"pp"{integers}   {printf("label: %s\n",yytext);}
")"|"("|"["|"]"   {printf("special symbol: %s\n",yytext);}
"in case that"|"otherwise"|"gteq"|"lteq"|"lt"|"do"|"and"|"or"|"for"|"return"|"while"|"jump to"    {printf("reserved keyword: %s\n",yytext);}
"integer_"{integers} {printf("datatype: %s\n",yytext);}
"character_"{integers} {printf("datatype: %s\n",yytext);}
"char"|"string"|"null"|"int"|"void"            {printf("datatype: %s\n",yytext);}
{id} {printf("ID: %s\n",yytext);}
{operator}         {printf("operator: %s\n",yytext);}
{integers}            {printf("constant: %s\n",yytext);}

{punctuation} {printf("punctuation: %s\n",yytext);}

(\")(.)*(\")  {
    char* c= yytext+1;
    c[yyleng-2]='\0';
    printf("punctuation: \"\n");
    printf("constant: %s\n", c);
    printf("punctuation: \"\n");
}



. {;}

%%

int main() {
    yylex();
    return 0;
}
