%{
#include <stdio.h>
#include <string.h>

int yyerror(char *);
extern int yylval;

int lines = 0;
int variables = 0;
int consts = 0;
int numIf = 0;
int numWhile = 0;
int numRepeat = 0;
int numFor = 0;
int numAssign = 0;
int numBreak = 0;
int numExit = 0;
int numHalt = 0;
int numWrite = 0;
int numRead = 0;

int poprawny = 0;

%}

%token PASCAL_PROGRAM PASCAL_END_PROGRAM

%%
input: PASCAL_PROGRAM statement PASCAL_END_PROGRAM     { printf("Tekst poprawny.\n"); }
    | PASCAL_PROGRAM error PASCAL_END_PROGRAM          { printf("Tekst niepoprawny.\n"); }
    
     ;

statement: /* Pusta reguła dla dowolnej treści między BEGIN a END. */
          ;

%%

int main() {
    printf("Początek skanowania ...\n");
    yyparse();

    return 0;
}

int yyerror(char *s) {
    printf("Błąd: %s\n", s);
    return 0;
}




