%{
#include <stdio.h>
%}

%%
[A][A-Za-z][A-Za-z][ \t] { 
    printf("3 Letter words starting with A: %s\n", yytext);
}
.\n   ;  
%%

int main() {
    yylex();
    return 0;
}
