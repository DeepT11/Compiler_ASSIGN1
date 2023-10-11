%{
#include <stdio.h>
int yylex();
%}

%%
float   { printf("double "); }
.       { putchar(yytext[0]); }
%%

int main() {
    yylex();
    return 0;
}
