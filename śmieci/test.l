%{
    #include <stdio.h>
    #include "pascal.tab.h"

    extern int yylval;
    extern int yylineno;
%}

%option noyywrap

alpha [a-zA-Z_]
alphanum [a-zA-Z0-9_]

%%

"if"            { return IF; }
"while"         { return WHILE; }
"repeat"        { return REPEAT; }
"var"           { return VAR; }
"begin"         { return BEGIN; }
"end"           { return END; }
"procedure"     { return PROCEDURE; }
[ \t]+          { /* Ignore whitespace */ }
\n              { ++yylineno; return NEWLINE; }
{alpha}{alphanum}* { return WORD; }
.               { return *yytext; }

%%