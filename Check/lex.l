%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int curve_bracket=0;
%}

reserved ["if","else if","while","for"]
digit [0-9]
integers {digit}+
char [a-zA-Z]
chars {char}+
special [-@#*+/:_\\]
id {special}{integers}|{special}{integers}{chars}|{special}{chars}{integers}|{special}{chars}|{chars}{integers}|{integers}{chars}|{chars}
punctuation [,"":;'']
operator [+*/_=-]

%%
"pp"{integers}[\t]+":"[\t]+ {;}
"pp"{integers} {;}

"integer_"{integers}    {printf("int");}
"character_"{integers}  {printf("char");}
"string"                {printf("string");}
"in case that"      { printf("if");}
"jump to"           { printf("goto");}
"while"             { printf("while");}
"otherwise"         { printf("else");}
"and"               { printf("&&");}
"or"                { printf("||");}
"lt"                { printf("<");}
"gt"                { printf(">");}
"lteq"              { printf("<=");}
"gteq"              { printf(">=");}

{reserved}[ ]"["     { curve_bracket++; printf("(");}
"["                 {printf("{");}
"]"                 { if(curve_bracket!=0){curve_bracket--;printf(")"); }else{printf("}");}}



({id})([ ]+"_"[ ]+)("2") {printf("sqrt(");
int i=0;
char c[50];
while(yytext[i]!=' '){
   c[i]=yytext[i];
   i++;
}
c[i]='\0';
printf(c);
printf(")");
};
{id}                { printf(yytext);}




":"                 {;}







%%


int main() {
    yylex();
    return 0;
}




"integer"_{integers}([ ]+){id}([ ]+)"="([ ]+)([^0-9\n]+)([ ]+){punctuation} {
    char c[100];
    int i=0;
   
    int j=0;

    while(yytext[i]!=' '){
        c[j]=yytext[i];
        i++;
        j++;
    }

    c[j]='\0';
    char id_int[100];
    while(yytext[i]==' '){
        i++;
    }

    int k=0;
    while(yytext[i]!=' '){
      id_int[k]=yytext[i];
      k++;
      i++;
    }
    id_int[k]='\0';

    
    fprintf(seq,"datatype: %s\n",c);
    fprintf(seq,"Error: wrong assigning to integer type  at pp%d\n",line_no);
    yyterminate();

}