%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int curve_bracket=0;
FILE*out;
FILE*seq;
%}

reserved ["if","else if","while","for"]
digit [0-9]
integers {digit}+
char [a-zA-Z]
chars {char}+
special [-@#*+/:_\\]
id {special}{integers}|{special}{integers}{chars}|{special}{chars}{integers}|{special}{chars}|{chars}{integers}|{integers}{chars}|{chars}
punc [,"";'']
do []"do"]

operator [+*/_=-]


%%
{operator}         {fprintf(seq,"operator: %s\n",yytext); fprintf(out,yytext); }
"pp"{integers}     {fprintf(seq,"label: %s\n",yytext);}
"integer_"{integers} {fprintf(out,"int"); fprintf(seq,"datatype: %s\n",yytext);}
"character_"{integers} {fprintf(out,"char");fprintf(seq,"datatype: %s\n",yytext);}
"string"  {fprintf(out,"%s",yytext);fprintf(seq,"datatype: %s\n",yytext);}
"null"|"int"|"void"            {fprintf(out,yytext);fprintf(seq,"datatype: %s\n",yytext);}
"in case that"      { fprintf(out,"if");fprintf(seq,"reserved keyword: %s\n",yytext);}
"jump to"           { fprintf(out,"goto");fprintf(seq,"reserved keyword: %s\n",yytext);}
"while"             { fprintf(out,"while");fprintf(seq,"reserved keyword: %s\n",yytext);}
"otherwise"         { fprintf(out,"else");fprintf(seq,"reserved keyword: %s\n",yytext);}
"and"               { fprintf(out,"&&");fprintf(seq,"reserved keyword: %s\n",yytext);}
"or"                { fprintf(out,"||");fprintf(seq,"reserved keyword: %s\n",yytext);}
"lt"                { fprintf(out,"<");fprintf(seq,"reserved keyword: %s\n",yytext);}
"gt"                { fprintf(out,">");fprintf(seq,"reserved keyword: %s\n",yytext);}
"lteq"              { fprintf(out,"<=");fprintf(seq,"reserved keyword: %s\n",yytext);}
"gteq"              { fprintf(out,">=");fprintf(seq,"reserved keyword: %s\n",yytext);}
"for"               { fprintf(out,"%s",yytext);fprintf(seq,"reserved keyword: %s\n",yytext);}
"["/{do}            { fprintf(out,"{");fprintf(seq,"special symbol: [\n");}
"["/{reserved}      { curve_bracket++; fprintf(out,"("); fprintf(seq,"reserved keyword: [\n");}
"]"                 { if(curve_bracket!=0){curve_bracket--;fprintf(out,")"); fprintf(seq,"special symbol: %s\n",yytext); }else{
    fprintf(out,"}");
    fprintf(seq,"special symbol: %s\n",yytext);
}}
"["                 { fprintf(out,"{");fprintf(seq,"special symbol: %s\n",yytext);}

")"|"("             { fprintf(out,yytext); fprintf(seq,"special symbol: %s\n",yytext);}


({id})([\t ]+"_"[\t ]+)("2") {fprintf(out,"sqrt(");
int i=0;
char c[50];
while(yytext[i]!=' '){
   c[i]=yytext[i];
   i++;
}

c[i]='\0';
fprintf(out,"%s",c);
fprintf(out,")");
fprintf(seq,"operator: _\n");
fprintf(seq,"constant 2\n");
};

{id}                { fprintf(out,"%s",yytext);fprintf(seq,"ID: %s\n",yytext);}

(\")(.)*(\")  {
    char* c= yytext+1;
    c[yyleng-2]='\0';
    fprintf(seq,"punctuation: \"\n");
    fprintf(seq,"constant: %s\n", c);
    fprintf(seq,"punctuation: \"\n");
}

{punc} {fprintf(out,"%s",yytext);fprintf(seq,"punctuation: %s\n",yytext);}
":" {fprintf(seq,"punctuation: %s\n",yytext);}

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
    seq=fopen("seq_tokens.txt","w");

    if(out==NULL){
        printf("error opening output file");
        return 1;
    }
    stdout=out;
    yyin=inp;
    
    yylex();
    return 0;
}