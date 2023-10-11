%{
#include <stdio.h>
%}

%%
\{[\t\n]+\}  {printf("space");}
.|\n         { printf("%s", yytext); } // Matches any other characters or newline
%%

int main() {
    yylex();
    return 0;
}
