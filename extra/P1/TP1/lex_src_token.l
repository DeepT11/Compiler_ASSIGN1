%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int curve_bracket=0;
FILE* seq;
int line_no=0;
%}

digit [0-9]
integers {digit}+
char [a-zA-Z]
chars {char}+
special [-@#*+/:_\\]
id {special}{integers}|{special}{integers}{chars}|{special}{chars}{integers}|{special}{chars}|{chars}{integers}|{integers}{chars}|{chars}
punctuation [,"":;'']
operator [+*/_=-]
extra [$%!?`~\[\]\(\)\{\}]+


%%

"pp"{integers}   {fprintf(seq,"label: %s\n",yytext);
line_no=atoi(yytext + 2);
}

"integer_"{chars}|"integer_"{special}|"integer"_{punctuation}|"integer"_{operator}|"integer_"{id}|"integer_"{extra}|"integer_"[^[0-9]+]   {fprintf(seq,"Error: wrong format of datatype (%s) at pp%d\n",yytext,line_no); yyterminate();}
"character_"{punctuation}|"character_"{operator}|"character_"{chars}|"character_"{special}|"character_"{id}|"character_"{extra}|"character_"[^[0-9]+]  {fprintf(seq,"Error: wrong format of datatype (%s) at pp%d\n",yytext,line_no); yyterminate();}






")"|"("|"["|"]"   {fprintf(seq,"special symbol: %s\n",yytext);}
"in case that"|"otherwise"|"gteq"|"lteq"|"lt"|"do"|"and"|"or"|"for"|"return"|"while"|"jump to|neq|eq"    {fprintf(seq,"reserved keyword: %s\n",yytext);}
"integer_"{integers} {fprintf(seq,"datatype: %s\n",yytext);}

"character_"{integers} {fprintf(seq,"datatype: %s\n",yytext);}

"string"([ ]+){id}([ ]+)"="([ ]+)[^"](.)([^"]) {

    char c[100];
    int i=6;

    while(yytext[i]==' '){
        i++;
    }
    
    int j=0;

    while(yytext[i]!=' '){
        c[j]=yytext[i];
        i++;
        j++;
    }

    c[j]='\0';

    {fprintf(seq,"datatype: string\n");
     fprintf(seq,"ID: %s\n",c);
     fprintf(seq,"operator: =\n");
     fprintf(seq,"Error: wrong format of string literal at pp%d\n",line_no); yyterminate();}
}

"char"|"string"|"null"|"int"|"void"            {fprintf(seq,"datatype: %s\n",yytext);}
{id} {fprintf(seq,"ID: %s\n",yytext);}
{operator}         {fprintf(seq,"operator: %s\n",yytext);}
{integers}            {fprintf(seq,"constant: %s\n",yytext);}

{punctuation} {fprintf(seq,"punctuation: %s\n",yytext);}






(\")(.)*(\")  {
    char* c= yytext+1;
    c[yyleng-2]='\0';
    fprintf(seq,"punctuation: \"\n");
    fprintf(seq,"constant: %s\n", c);
    fprintf(seq,"punctuation: \"\n");
}
. {;}

%%


int main(int argc,char* argv[]) {
    if(argc!=2) {
        return 1;
    }

    FILE*inp=fopen(argv[1],"r");
    if(inp==NULL){
        printf("error opening input file");
        return 1;
    }
    seq=fopen("seq_tokens.txt","w");
    if(seq==NULL){
        printf("error opening output file");
        return 1;
    }
    stdout=seq;
    yyin=inp;
    
    yylex();
    return 0;
}