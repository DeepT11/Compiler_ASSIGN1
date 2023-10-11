%option noyywrap
%{
#include <stdlib.h>
#include <stdio.h>
%}

number [0-9]+

%%

{number} {
    int num = atoi(yytext);
    printf("Found : %d\n", num);
    if (num % 2 == 0) {
        printf("%d is even.\n", num);
    } else {
        printf("%d is odd.\n", num);
    }
}

%%

int main() {
    yylex();
    return 0;
}
