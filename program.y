%{
#include <stdio.h>
#include <string.h>

int yyerror(char *);
extern int yylval;
extern int line_count;


int liczba_zmiennych = 0;
int liczba_stalych = 0;
int liczba_komentarzy = 0;
int liczba_write = 0;
int liczba_read = 0;
int liczba_writeln = 0;
int liczba_readln = 0;
int liczba_procedur = 0;
int liczba_if = 0;

int liczba_int = 0;
int liczba_real = 0;
int liczba_boolean = 0;
int liczba_character = 0;
int liczba_string = 0;
int liczba_tablic = 0;
int liczba_funkcji = 0;

int skanowanie_wykonane = 0;


%}

%token PROGRAM NAZWA TBEGIN END

%token DWUKROPEK SREDNIK PRZECINEK TABLICA_LEFT TABLICA_RIGHT
%token ROWNE KROPKA DWIEKROPKI 

%token CONST VAR INTEGER REAL BOOLEAN CHARACTER STRING ASSIGN

%token ARRAY OF

%token AND OR MNIEJSZEROWNE WIEKSZEROWNE NOT

%token WHILE DO REPEAT UNTIL FOR TO DOWNTO

%token EXIT BREAK HALT

%token WRITE WRITELN READ READLN APOSTROF

%token IF ELSE THEN

%token FUNCTION TPROCEDURE

%token CYFRY NAPIS NAWIAS_LEWY NAWIAS_PRAWY MNIEJSZE WIEKSZE CYFRY_FLOAT KLAMRA_LEWA KLAMRA_PRAWA W_KLAMRA

%%
poczatek    : PROGRAM NAZWA SREDNIK pocz_blok srodek_blok koniec  {
            skanowanie_wykonane=1;
            return 0;}
            ;

pocz_blok   : W_KLAMRA pocz_blok {liczba_komentarzy++;}
            | stale 
            | zmienne 
            | stale zmienne 
            | zmienne stale 
            | 
            ;

srodek_blok: srodek_blok funkcja
            | W_KLAMRA srodek_blok {liczba_komentarzy++;}
            | funkcja srodek_blok
            | TBEGIN srodek_blok END 
            | if srodek_blok
            | while srodek_blok
            | for srodek_blok
            | WRITE NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK srodek_blok {liczba_write++;}
            | WRITE NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK srodek_blok {liczba_write++;}
            | WRITELN NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK srodek_blok {liczba_writeln++;}
            | WRITELN NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK srodek_blok {liczba_writeln++;}
            | READ NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK srodek_blok {liczba_read++;}
            | READ NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK srodek_blok {liczba_read++;}
            | READLN NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK srodek_blok {liczba_readln++;}
            | READLN NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK srodek_blok {liczba_readln++;}
            | W_KLAMRA srodek_blok {liczba_komentarzy++;}
            | przypisanie_wartosci srodek_blok
            | repeat srodek_blok
            | procedury_pascal srodek_blok
            | HALT srodek_blok
            | 
            ;

procedury_pascal: TPROCEDURE NAZWA SREDNIK TBEGIN srodek_blok END SREDNIK {liczba_procedur++;}
            ;            
repeat: REPEAT srodek_blok UNTIL warunek_repeat SREDNIK
            ;
warunek_repeat: NAZWA warunek_repeat
            | CYFRY warunek_repeat
            | CYFRY_FLOAT warunek_repeat
            | MNIEJSZE warunek_repeat
            | WIEKSZE warunek_repeat
            | MNIEJSZEROWNE warunek_repeat
            | WIEKSZEROWNE warunek_repeat
            | ROWNE warunek_repeat
            | ;

for: FOR NAZWA ASSIGN CYFRY TO CYFRY DO srodek_blok
            | FOR NAZWA ASSIGN CYFRY DOWNTO CYFRY DO srodek_blok
            | FOR NAZWA ASSIGN CYFRY TO NAZWA DO srodek_blok
            ;
przypisanie_wartosci: NAZWA ASSIGN operacje_matematyczne SREDNIK
                    | NAZWA ASSIGN NAPIS SREDNIK

                    | ;
operacje_matematyczne: NAZWA operator_mat operacje_matematyczne
                    | CYFRY operator_mat operacje_matematyczne;
                    | CYFRY_FLOAT operator_mat operacje_matematyczne;
                    | ;
operator_mat: '+'
            | '-'
            | '*'
            | '/'
            | ROWNE
            | ;

while: WHILE warunek_while DO srodek_blok
            ;
warunek_while: NAZWA warunek_while
            | CYFRY warunek_while
            | CYFRY_FLOAT warunek_while
            | MNIEJSZE warunek_while
            | WIEKSZE warunek_while
            | MNIEJSZEROWNE warunek_while
            | WIEKSZEROWNE warunek_while
            | ROWNE warunek_while
            | ;

if         : IF warunek_if THEN srodek_blok ELSE srodek_blok SREDNIK {liczba_if++;}
            ;

warunek_if : NAZWA warunek_if
            | CYFRY warunek_if
            | CYFRY_FLOAT warunek_if
            | MNIEJSZE warunek_if
            | WIEKSZE warunek_if
            | MNIEJSZEROWNE warunek_if
            | WIEKSZEROWNE warunek_if
            | ROWNE warunek_if
            | AND warunek_if
            | OR warunek_if
            | NOT warunek_if
            | ;
/* if         : IF warunek_if warunek_symbol warunek_if THEN srodek_blok ELSE srodek_blok SREDNIK
            ; */
/* warunek_if : NAZWA |CYFRY | CYFRY_FLOAT;
warunek_symbol: MNIEJSZE 
                | WIEKSZE
                | MNIEJSZEROWNE
                | WIEKSZEROWNE
                | ROWNE
                | '!' ROWNE ; */



funkcja: FUNCTION NAZWA NAWIAS_LEWY warunknki_srodek NAWIAS_PRAWY DWUKROPEK typ_zmiennej_funkcja SREDNIK  funkcje_srodek_poczatek END funkcja {liczba_funkcji++;}
        | FUNCTION NAZWA NAWIAS_LEWY warunknki_srodek NAWIAS_PRAWY DWUKROPEK typ_zmiennej_funkcja SREDNIK funkcje_srodek_poczatek END {liczba_funkcji++;}
        ;
warunknki_srodek: NAZWA warunknki_srodek
                    | CYFRY warunknki_srodek
                    | CYFRY_FLOAT warunknki_srodek
                    | DWUKROPEK warunknki_srodek
                    | PRZECINEK warunknki_srodek
                    | SREDNIK warunknki_srodek
                    | PRZECINEK warunknki_srodek
                    | typ_zmiennej_funkcja warunknki_srodek
                    | ;       

/* funkcja_srodek: zmienne 
                | stale 
                | zmienne stale 
                | stale zmienne 
                | WRITE NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK 
                | WRITELN NAPIS SREDNIK 
                | READ NAPIS SREDNIK 
                | READLN NAPIS SREDNIK
                |
                ; */

funkcje_srodek_poczatek: zmienne funkcje_srodek_poczatek
                | stale funkcje_srodek_poczatek
                | zmienne stale funkcje_srodek_poczatek
                | stale zmienne funkcje_srodek_poczatek
                | TBEGIN funkcje_srodek_dalej
                | if funkcje_srodek_dalej
                | W_KLAMRA funkcje_srodek_poczatek {liczba_komentarzy++;}
                ;
funkcje_srodek_dalej:
                | WRITE NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_write++;}
                | WRITE NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_write++;}
                | WRITELN NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_writeln++;}
                | WRITELN NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_writeln++;}
                | READ NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_read++;}
                | READ NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_read++;}
                | READLN NAWIAS_LEWY NAPIS NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_readln++;}
                | READLN NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_readln++;}
                | W_KLAMRA funkcje_srodek_dalej {liczba_komentarzy++;}
                | if funkcje_srodek_dalej
                |
                ;

typ_zmiennej_funkcja: INTEGER 
            | REAL
            | BOOLEAN
            | CHARACTER
            | STRING
            | tablica
            ;


zmienne: VAR deklaracje_zmiennych
        ;

deklaracje_zmiennych: deklaracje_zmiennych zmienna SREDNIK
                    | zmienna SREDNIK
                    | W_KLAMRA deklaracje_zmiennych {system("clear");
                        ;liczba_komentarzy++;}
                    ;
zmienna:  NAZWA DWUKROPEK typ_zmiennej 
        | NAZWA PRZECINEK zmienna
        ;

typ_zmiennej: INTEGER {liczba_zmiennych++; liczba_int++;} 
            | REAL {liczba_zmiennych++; liczba_real++;} 
            | BOOLEAN {liczba_zmiennych++; liczba_boolean++;} 
            | CHARACTER {liczba_zmiennych++; liczba_character++;} 
            | STRING {liczba_zmiennych++; liczba_string++;} 
            | tablica
            ;
            
tablica:     ARRAY TABLICA_LEFT typ_wartosc_tablicy DWIEKROPKI typ_wartosc_tablicy TABLICA_RIGHT OF  typ_zmiennej_tablica
            ;

typ_wartosc_tablicy: NAZWA
                    | CYFRY
                    ;

typ_zmiennej_tablica: INTEGER {liczba_tablic++;} 
                    | REAL {liczba_tablic++;} 
                    | BOOLEAN {liczba_tablic++;} 
                    | CHARACTER {liczba_tablic++;} 
                    | STRING {liczba_tablic++;} 
                    ;

stale : CONST deklaracje_stalych
        ;

deklaracje_stalych: 
                deklaracje_stalych stala SREDNIK {liczba_stalych++;}
                | stala SREDNIK {liczba_stalych++;}
                | W_KLAMRA deklaracje_stalych {liczba_komentarzy++;}
                ;

stala: NAZWA ROWNE wartosc_przypisana
    ;

wartosc_przypisana: CYFRY_FLOAT
                | CYFRY 
                | NAPIS
                ;

koniec: END KROPKA;
%%

int main() {
    printf("Początek skanowania ...\n");
    yyparse();
    fflush(stdout);
    system("clear");
    printf("Koniec skanowania.\n");
    /* printf("Liczba linii: %d\n", lines); */
    if (skanowanie_wykonane == 1)
    {
        printf("Program poprawny składniowo.\n");
        if (line_count > 0)
            printf("Liczba linii: %d\n", line_count);
        if (liczba_zmiennych > 0)
            printf("Liczba zmiennych: %d\n", liczba_zmiennych);
        if (liczba_stalych > 0)
            printf("Liczba stałych: %d\n", liczba_stalych);
        if (liczba_int > 0)
            printf("Liczba zmiennych typu int: %d\n", liczba_int);
        if (liczba_real > 0)
            printf("Liczba zmiennych typu real: %d\n", liczba_real);
        if (liczba_boolean > 0)
            printf("Liczba zmiennych typu boolean: %d\n", liczba_boolean);
        if (liczba_character > 0)
            printf("Liczba zmiennych typu character: %d\n", liczba_character);
        if (liczba_string > 0)
            printf("Liczba zmiennych typu string: %d\n", liczba_string);
        if (liczba_tablic > 0)
            printf("Liczba tablic: %d\n", liczba_tablic);
        if (liczba_komentarzy > 0)
            printf("Liczba komentarzy: %d\n", liczba_komentarzy);
        if (liczba_write > 0)
            printf("Liczba instrukcji write: %d\n", liczba_write);
        if (liczba_writeln > 0)
            printf("Liczba instrukcji writeln: %d\n", liczba_writeln);
        if (liczba_read > 0)
            printf("Liczba instrukcji read: %d\n", liczba_read);
        if (liczba_readln > 0)
            printf("Liczba instrukcji readln: %d\n", liczba_readln);
        if (liczba_if > 0)
            printf("Liczba instrukcji if: %d\n", liczba_if);
        if (liczba_procedur > 0)
            printf("Liczba procedur: %d\n", liczba_procedur);
        if (liczba_funkcji > 0)
            printf("Liczba funkcji: %d\n", liczba_funkcji);
    }
    else
    {
        printf("Program niepoprawny składniowo.\n");
    }


    return 0;
}

int yyerror(char *s) {
    printf("----------------------\n");
    printf("Błąd: %s\n", s);
    return 0;
}




