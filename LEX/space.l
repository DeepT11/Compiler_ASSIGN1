%{
#include <stdio.h>
int prev_char_is_whitespace = 0; // Flag to track consecutive whitespace
%}

%%
[ \t\n]+ {
    if (!prev_char_is_whitespace) {
        printf(" "); // Replace sequence of whitespace with a single space
        prev_char_is_whitespace = 1;
    }
}

. {
    printf("%c", yytext[0]); // Copy other characters as is
    prev_char_is_whitespace = 0; // Reset flag
}
%%

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE* input = fopen(argv[1], "r");
    if (!input) {
        perror("Error opening input file");
        return 1;
    }

    yyin = input;
    yylex();

    fclose(input);
    return 0;
}
