#!/bin/bash
rm lex.yy.c y.tab.c y.tab.h a.out
lex program.l
yacc -d program.y
gcc y.tab.c lex.yy.c -lfl
./a.out
