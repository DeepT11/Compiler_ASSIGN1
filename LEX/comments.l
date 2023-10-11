%{
#include <stdio.h>
%}

%x IN_COMMENT_SINGLE
%x IN_COMMENT_MULTI

%%
"/*"            { BEGIN(IN_COMMENT_MULTI); printf("%s\n", yytext); }
<IN_COMMENT_MULTI>"*/" { BEGIN(INITIAL); printf("%s\n", yytext); }


"//"            { BEGIN(IN_COMMENT_SINGLE); printf("%s", yytext); }
<IN_COMMENT_SINGLE>\n { BEGIN(INITIAL); printf("\n"); }


.               { }
%%

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    
    FILE* file = fopen(argv[1], "r");
    if (file == NULL) {
        printf("Error opening file.\n");
        return 1;
    }
    
    yyin = file;
    yylex();
    
    fclose(file);
    return 0;
}
