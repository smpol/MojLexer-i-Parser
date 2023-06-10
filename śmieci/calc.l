%option noyywrap

%{
    #include <stdio.h>

    #define YY_DECL int yylex()

    #include "calc.tab.h"

%}

%%
[ \t]	; // ignore all whitespace
"program" {return T_PROGRAM;}
";" {return T_SEMICOLON;}
"var" {return T_VAR;}
"int" {return T_TYPE;}
"bool" {return T_TYPE;}
"real" {return T_TYPE;}
"," {return T_COMMA;}
"." {return T_DOT;}
":" {return T_COLON;}
"begin" {return T_BEGIN;}
"if" {return T_IF;}
"(" {return T_OPEN_P;}
"True" {return T_BOOL;}
"False" {return T_BOOL;}
"not" {return T_LOGIC;}
"and" {return T_LOGIC;}
"or" {return T_LOGIC;}
"=" {return T_CMP;}
"+" {return T_OPERATION;}
"-" {return T_OPERATION;}
"mod" {return T_OPERATION;}
"div" {return T_OPERATION;}
"*" {return T_OPERATION;}
"<>" {return T_CMP;}
"<" {return T_CMP;}
">" {return T_CMP;}
"<=" {return T_CMP;}
">=" {return T_CMP;}
")" {return T_CLOSE_P;}
"then" {return T_THEN;}
"else" {return T_ELSE;}
"while" {return T_WHILE;}
"do" {return T_DO;}
":=" {return T_ATRIB;}
"end" {return T_END;}
\n ; // Ignore lines
[0-9]+ {return T_NUM;}
[0-9]+\.[0-9]+ 	{return T_NUM;}
[a-zA-Z][a-zA-Z_0-9]* {return T_IDENTIFIER;}
%%
