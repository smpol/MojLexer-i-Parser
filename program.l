%option caseless

%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
    int liczba_lini_kodu=1;
%}

warunek_tekst '[^']*'

%%
"integer"       {return INTEGER;}
"real"          {return REAL;}
"boolean"       {return BOOLEAN;}
"character"     {return CHARACTER;}
"string"        {return STRING;}
":="            {return PRZYPISAC;}
"array"         {return ARRAY;}
"of"            {return OF;}
"and"           {return AND;}
"or"            {return OR;}
"<="            {return MNIEJSZE_ROWNE;}
">="            {return WIEKSZE_ROWNE;}
">"             {return WIEKSZE;}
"<"             {return MNIEJSZE;}
"not"           {return NOT;}
"while"         {return WHILE;}
"do"            {return DO;}
";"             {return SREDNIK;}
","             {return PRZECINEK;}
"repeat"        {return REPEAT;}
"until"         {return UNTIL;}
"for"           {return FOR;}
"to"            {return TO;}
"downto"        {return DOWNTO;}
"halt"          {return HALT;}
"write"         {return WRITE;}
"writeln"       {return WRITELN;}
"read"          {return READ;}
"readln"        {return READLN;}
"if"            {return IF;}
"else"          {return ELSE;}
"then"          {return THEN;}
"function"      {return FUNCTION;}
"procedure"     {return PASCAL_PROCEDURE;}
"["             {return TABLICA_LEWO;}
"]"             {return TABLICA_PRAWO;}
"="             {return ROWNA_SIE;}
"."             {return KROPKA;}
".."            {return DWIEKROPKI;}
"("             {return NAWIAS_LEWY;}
")"             {return NAWIAS_PRAWY;}
"const"         {return CONST;}
"var"           {return VAR;}
"program"       {return PROGRAM;}
"nazwa"         {return NAZWA;}
"begin"         {return PASCAL_BEGIN;}
"end"           {return END;}
":"             {return DWUKROPEK;}
[0-9]+          {return CYFRY;}
[0-9]+\.[0-9]+  {return CYFRY_FLOAT;}
[a-zA-Z_0-9]*   {return NAZWA;}
\{.*\}          {return W_KLAMRA;}
{warunek_tekst} {return WARUNEK_TEKST;}
[ \t\r]         ;  // Pomijaj białe znaki i znaki nowej linii
\n              {liczba_lini_kodu++;}
%%