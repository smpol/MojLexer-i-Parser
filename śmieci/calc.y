%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
}

%token T_PROGRAM
%token T_IDENTIFIER
%token T_SEMICOLON
%token T_VAR
%token T_TYPE
%token T_COMMA
%token T_COLON
%token T_BEGIN
%token T_IF
%token T_OPEN_P
%token T_BOOL
%token T_OPERATION
%token T_CLOSE_P
%token T_THEN
%token T_ELSE
%token T_WHILE
%token T_DO
%token T_ATRIB
%token T_END
%token T_DOT
%token T_NEWLINE
%token T_NUM
%token T_LOGIC
%token T_CMP

%start program

%%

program:
	T_PROGRAM T_IDENTIFIER T_SEMICOLON code { printf("Program dziala poprawnie\n"); exit(0);}
;
code:
	vars commands T_DOT
;

commands:
 	T_BEGIN command T_END T_SEMICOLON
;

command:
	T_IDENTIFIER T_ATRIB expression T_SEMICOLON command |
	T_IF T_OPEN_P condition T_CLOSE_P T_THEN commands command|
	T_IF T_OPEN_P condition T_CLOSE_P T_THEN commands T_ELSE commands command|
	T_WHILE T_OPEN_P condition T_CLOSE_P T_DO commands command |
	{/*NADA*/}
;

vars:
	T_VAR var_def |
	{/*NADA*/}
;

value:
	T_IDENTIFIER | T_NUM
;

expression:
	value |
	math |
	condition
;

math:
	value |
	math T_OPERATION math
;

condition:
	T_BOOL |
	expression T_CMP expression |
	condition T_LOGIC condition
;
var_def:
	T_IDENTIFIER T_COMMA var_def |
	T_IDENTIFIER T_COLON T_TYPE T_SEMICOLON var_def |
	T_IDENTIFIER T_COLON T_TYPE T_SEMICOLON
;

%%

int main() {
	yyin = stdin;

	while(!feof(yyin))
		yyparse();

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Nieprawidlowo: %s\n", s);
	exit(1);
}
