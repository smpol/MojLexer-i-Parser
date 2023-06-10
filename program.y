%{
#include <stdio.h>
#include <string.h>

int yyerror(char *);
extern int yylval;
extern int line_count;

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

int liczba_zmiennych = 0;
int liczba_stalych = 0;

int liczba_int = 0;
int liczba_real = 0;
int liczba_boolean = 0;
int liczba_character = 0;
int liczba_string = 0;
int liczba_tablic = 0;

int skanowanie_wykonane = 0;


%}

%token PROGRAM NAZWA TBEGIN END

%token DWUKROPEK SREDNIK PRZECINEK TABLICA_LEFT TABLICA_RIGHT
%token ROWNE KROPKA DWIEKROPKI APOSTROF

%token CONST VAR INTEGER REAL BOOLEAN CHARACTER STRING ASSIGN

%token ARRAY OF

%token AND OR MNIEJSZEROWNE WIEKSZEROWNE NOT

%token WHILE DO REPEAT UNTIL FOR TO DOWNTO

%token EXIT BREAK HALT

%token WRITE WRITELN READ READLN

%token IF ELSE THEN

%token FUNCTION TPROCEDURE

%token CYFRY NAPIS NAWIAS_LEWY NAWIAS_PRAWY MNIEJSZE WIEKSZE CYFRY_FLOAT W_NAWIAS KLAMRA_LEWA KLAMRA_PRAWA W_KLAMRA

%%
poczatek    : PROGRAM NAZWA SREDNIK pocz_blok srodek_blok koniec  {
            printf("-------------------------\n");
            printf("\nKoniec skanowania\n"); 
            skanowanie_wykonane=1;
            return 0;}
            ;

pocz_blok   : W_KLAMRA pocz_blok {printf(" Wykryto komentarz\n");}
            | stale 
            | zmienne 
            | stale zmienne 
            | zmienne stale 
            | 
            ;

srodek_blok: srodek_blok funkcja
            | W_KLAMRA srodek_blok {printf(" Wykryto komentarz\n");}
            | funkcja srodek_blok
            | TBEGIN srodek_blok END 
            | if srodek_blok
            | while srodek_blok
            | for srodek_blok
            | WRITE W_NAWIAS SREDNIK srodek_blok {printf("Wywolanie funkcji WRITE\n");}
            | WRITELN W_NAWIAS SREDNIK srodek_blok {printf("Wywolanie funkcji WRITELN\n");}
            | READ W_NAWIAS SREDNIK srodek_blok {printf("Wywolanie funkcji READ\n");}
            | READLN W_NAWIAS SREDNIK srodek_blok {printf("Wywolanie funkcji READLN\n");}
            | W_KLAMRA srodek_blok {printf(" Wykryto komentarz\n");}
            | przypisanie_wartosci srodek_blok
            | 
            ;

for: FOR NAZWA ASSIGN CYFRY TO CYFRY DO srodek_blok
            | FOR NAZWA ASSIGN CYFRY DOWNTO CYFRY DO srodek_blok
            | FOR NAZWA ASSIGN CYFRY TO NAZWA DO srodek_blok
            ;
przypisanie_wartosci: NAZWA ASSIGN operacje_matematyczne SREDNIK
                    | NAZWA ASSIGN NAZWA SREDNIK
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

if         : IF warunek_if warunek_symbol warunek_if THEN srodek_blok ELSE srodek_blok SREDNIK
            ;

/* warunek_if : NAZWA warunek_if
            | CYFRY warunek_if
            | CYFRY_FLOAT warunek_if
            | MNIEJSZE warunek_if
            | WIEKSZE warunek_if
            | MNIEJSZEROWNE warunek_if
            | WIEKSZEROWNE warunek_if
            | ROWNE warunek_if
            | ; */
warunek_if : NAZWA |CYFRY | CYFRY_FLOAT;
warunek_symbol: MNIEJSZE 
                | WIEKSZE
                | MNIEJSZEROWNE
                | WIEKSZEROWNE
                | ROWNE
                | '!' ROWNE ;



funkcja: FUNCTION NAZWA W_NAWIAS DWUKROPEK typ_zmiennej_funkcja SREDNIK  funkcje_srodek_poczatek END funkcja
        | FUNCTION NAZWA W_NAWIAS DWUKROPEK typ_zmiennej_funkcja SREDNIK funkcje_srodek_poczatek END
        ;

/* funkcja_srodek: zmienne 
                | stale 
                | zmienne stale 
                | stale zmienne 
                | WRITE W_NAWIAS SREDNIK 
                | WRITELN W_NAWIAS SREDNIK 
                | READ W_NAWIAS SREDNIK 
                | READLN W_NAWIAS SREDNIK
                |
                ; */

funkcje_srodek_poczatek: zmienne funkcje_srodek_poczatek
                | stale funkcje_srodek_poczatek
                | zmienne stale funkcje_srodek_poczatek
                | stale zmienne funkcje_srodek_poczatek
                | TBEGIN funkcje_srodek_dalej
                | if funkcje_srodek_dalej
                | W_KLAMRA funkcje_srodek_poczatek {printf(" Wykryto komentarz\n");}
                ;
funkcje_srodek_dalej:
                | WRITE W_NAWIAS SREDNIK funkcje_srodek_dalej {printf("Wywolanie funkcji WRITE\n");}
                | WRITELN W_NAWIAS SREDNIK funkcje_srodek_dalej {printf("Wywolanie funkcji WRITELN\n");}
                | READ W_NAWIAS SREDNIK funkcje_srodek_dalej {printf("Wywolanie funkcji READ\n");}
                | READLN W_NAWIAS SREDNIK funkcje_srodek_dalej {printf("Wywolanie funkcji READLN\n");}
                | W_KLAMRA funkcje_srodek_dalej {printf(" Wykryto komentarz\n");}
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
                    | W_KLAMRA deklaracje_zmiennych {printf(" Wykryto komentarz\n");}
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
                | W_KLAMRA deklaracje_stalych {printf(" Wykryto komentarz\n");}
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
    /* printf("Koniec skanowania.\n"); */
    /* printf("Liczba linii: %d\n", lines); */
    if (skanowanie_wykonane == 1)
    {
        printf("Liczba linii: %d\n", line_count);
        printf("Liczba zmiennych: %d\n", liczba_zmiennych);
        printf("Liczba stałych: %d\n", liczba_stalych);
        printf("Liczba zmiennych typu int: %d\n", liczba_int);
        printf("Liczba zmiennych typu real: %d\n", liczba_real);
        printf("Liczba zmiennych typu boolean: %d\n", liczba_boolean);
        printf("Liczba zmiennych typu character: %d\n", liczba_character);
        printf("Liczba zmiennych typu string: %d\n", liczba_string);
        printf("Liczba tablic: %d\n", liczba_tablic);
    }


    return 0;
}

int yyerror(char *s) {
    printf("----------------------\n");
    printf("Błąd: %s\n", s);
    return 0;
}




