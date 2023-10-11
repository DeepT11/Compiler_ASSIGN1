%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int curve_bracket=0;
FILE*out;
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
"pp"{integers}[\t]+":"[\t]+ {;}
"pp"{integers} {;}

"eq" {fprintf(out,"==");}
"neq" {fprintf(out,"!=");}


"in case that"([ ]*)"\["   { 
curve_bracket++; 
fprintf(out,"if");
fprintf(out,"(");
}


"otherwise" fprintf(out,"else");

"while"([ ]*)"\["   { curve_bracket++; 
int i=0;
char c[100];
while(yytext[i]!='['){
c[i]=yytext[i];
i++;
}
c[i]='\0';

fprintf(out,"while");
fprintf(out,"(");
}

"for"([ ]*)"\["   { curve_bracket++; 
int i=0;
char c[100];
while(yytext[i]!='['){
c[i]=yytext[i];
i++;
}
c[i]='\0';

fprintf(out,"for");
fprintf(out,"(");
}


"]"                 { if(curve_bracket>0){curve_bracket--;fprintf(out,")"); }else{
    fprintf(out,"}");
}}

"["                 { fprintf(out,"{",yytext); }


"integer_"{integers}  {fprintf(out,"int");}
"character_"{integers} {fprintf(out,"char");}
"string"            {fprintf(out,"%s",yytext);}

"jump to"           { fprintf(out,"goto");}

"and"               { fprintf(out,"&&");}
"or"                { fprintf(out,"||");}
"lt"                { fprintf(out,"<");}
"gt"                { fprintf(out,">");}
"lteq"              { fprintf(out,"<=");}
"gteq"              { fprintf(out,">=");}
"do"                 {;}



"null"  {
    int i=0;
    char c[100];

    while(yytext[i]!=' '){
        c[i]=yytext[i];
        i++;
    }
    c[i]='\0';

    fprintf(out,"void");
}



({id})([\t]+"_"[\t ]+)("2") {fprintf(out,"sqrt(");
int i=0;
char c[50];
while(yytext[i]!=' '){
   c[i]=yytext[i];
   i++;
}
c[i]='\0';
fprintf(out,"%s",c);
fprintf(out,")");
};

{id}                { fprintf(out,"%s",yytext);}
":"                 {;}
. {fprintf(out,"%s",yytext);}
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
    out=fopen("C.txt","w");
    if(out==NULL){
        printf("error opening output file");
        return 1;
    }
    stdout=out;
    yyin=inp;
    
    yylex();
    return 0;
}