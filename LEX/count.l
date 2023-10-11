/*lex program to count number of words*/
%{
#include<stdio.h>
#include<string.h>
int line = 0;
int word=0;
int chars=0;
%}
  
/* Rules Section*/
%%
\n {line++;}
([a-zA-Z])+    {word++;chars+=strlen(yytext);}
[^\t\n]         {chars++;}

%%
  

  
int main()
{   
    // The function that starts the analysis
    yylex();
    printf("lines:%d\n",line);
    printf("word:%d\n",word);
    printf("chars:%d\n",chars);
  
    return 0;
}