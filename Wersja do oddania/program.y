/* Kod autorstwa Michala Przysiezneg 
                            2023r. */
%{
#include <stdio.h>
#include <string.h>

int yyerror(char *);
extern int yylval;
//zmienne liczace ilosc wystapien poszczegolnych elementow jezyka
extern int liczba_lini_kodu;
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
//zmienna sprawdzajaca czy skanowanie zostalo wykonane
int skanowanie_wykonane = 0;
%}

%token ROWNA_SIE FUNCTION CYFRY WARUNEK_TEKST NAWIAS_LEWY NAWIAS_PRAWY MNIEJSZE WIEKSZE CYFRY_FLOAT W_KLAMRA PASCAL_PROCEDURE KROPKA DWIEKROPKI AND OR IF ELSE THEN MNIEJSZE_ROWNE WIEKSZE_ROWNE NOT WHILE DO REPEAT UNTIL FOR TO DOWNTO HALT WRITE WRITELN READ READLN ARRAY OF CONST VAR INTEGER REAL BOOLEAN CHARACTER STRING PRZYPISAC PROGRAM NAZWA PASCAL_BEGIN END DWUKROPEK SREDNIK PRZECINEK TABLICA_LEWO TABLICA_PRAWO

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
            | PASCAL_BEGIN srodek_blok END 
            | if srodek_blok
            | while srodek_blok
            | for srodek_blok
            | WRITE NAWIAS_LEWY WARUNEK_TEKST NAWIAS_PRAWY SREDNIK srodek_blok {liczba_write++;}
            | WRITE NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK srodek_blok {liczba_write++;}
            | WRITELN NAWIAS_LEWY WARUNEK_TEKST NAWIAS_PRAWY SREDNIK srodek_blok {liczba_writeln++;}
            | WRITELN NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK srodek_blok {liczba_writeln++;}
            | READ NAWIAS_LEWY WARUNEK_TEKST NAWIAS_PRAWY SREDNIK srodek_blok {liczba_read++;}
            | READ NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK srodek_blok {liczba_read++;}
            | READLN NAWIAS_LEWY WARUNEK_TEKST NAWIAS_PRAWY SREDNIK srodek_blok {liczba_readln++;}
            | READLN NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK srodek_blok {liczba_readln++;}
            | przypisanie_wartosci srodek_blok
            | repeat srodek_blok
            | procedury_pascal srodek_blok
            | HALT srodek_blok
            | 
            ;

procedury_pascal: PASCAL_PROCEDURE NAZWA SREDNIK PASCAL_BEGIN srodek_blok END SREDNIK {liczba_procedur++;}
            ;            
repeat: REPEAT srodek_blok UNTIL warunek_repeat SREDNIK
            ;
warunek_repeat: NAZWA warunek_repeat
            | CYFRY warunek_repeat
            | CYFRY_FLOAT warunek_repeat
            | MNIEJSZE warunek_repeat
            | WIEKSZE warunek_repeat
            | MNIEJSZE_ROWNE warunek_repeat
            | WIEKSZE_ROWNE warunek_repeat
            | ROWNA_SIE warunek_repeat
            | ;

for: FOR NAZWA PRZYPISAC CYFRY TO CYFRY DO srodek_blok
            | FOR NAZWA PRZYPISAC CYFRY DOWNTO CYFRY DO srodek_blok
            | FOR NAZWA PRZYPISAC CYFRY TO NAZWA DO srodek_blok
            ;
przypisanie_wartosci: NAZWA PRZYPISAC operacje_matematyczne SREDNIK
                    | NAZWA PRZYPISAC WARUNEK_TEKST SREDNIK;
operacje_matematyczne: NAZWA operator_mat operacje_matematyczne
                    | CYFRY operator_mat operacje_matematyczne;
                    | CYFRY_FLOAT operator_mat operacje_matematyczne;
                    | ;
operator_mat: '+'
            | '-'
            | '*'
            | '/'
            | ROWNA_SIE
            | ;

while: WHILE warunek_while DO srodek_blok
            ;
warunek_while: NAZWA warunek_while
            | CYFRY warunek_while
            | CYFRY_FLOAT warunek_while
            | MNIEJSZE warunek_while
            | WIEKSZE warunek_while
            | MNIEJSZE_ROWNE warunek_while
            | WIEKSZE_ROWNE warunek_while
            | ROWNA_SIE warunek_while
            | ;

if         : IF warunek_if THEN srodek_blok ELSE srodek_blok SREDNIK {liczba_if++;}
            ;

warunek_if : NAZWA warunek_if
            | CYFRY warunek_if
            | CYFRY_FLOAT warunek_if
            | MNIEJSZE warunek_if
            | WIEKSZE warunek_if
            | MNIEJSZE_ROWNE warunek_if
            | WIEKSZE_ROWNE warunek_if
            | ROWNA_SIE warunek_if
            | AND warunek_if
            | OR warunek_if
            | NOT warunek_if
            | ;

funkcja: FUNCTION NAZWA NAWIAS_LEWY warunknki_srodek NAWIAS_PRAWY DWUKROPEK typ_zmiennej_funkcja SREDNIK  funkcje_srodek_poczatek END funkcja {liczba_funkcji++;}
        | FUNCTION NAZWA NAWIAS_LEWY warunknki_srodek NAWIAS_PRAWY DWUKROPEK typ_zmiennej_funkcja SREDNIK funkcje_srodek_poczatek END {liczba_funkcji++;}
        ;
warunknki_srodek: NAZWA warunknki_srodek
                    | CYFRY warunknki_srodek
                    | CYFRY_FLOAT warunknki_srodek
                    | DWUKROPEK warunknki_srodek
                    | PRZECINEK warunknki_srodek
                    | SREDNIK warunknki_srodek
                    | typ_zmiennej_funkcja warunknki_srodek
                    | ;       

funkcje_srodek_poczatek: zmienne funkcje_srodek_poczatek
                | stale funkcje_srodek_poczatek
                | PASCAL_BEGIN funkcje_srodek_dalej
                | if funkcje_srodek_dalej
                | W_KLAMRA funkcje_srodek_poczatek {liczba_komentarzy++;}
                ;
funkcje_srodek_dalej:
                | WRITE NAWIAS_LEWY WARUNEK_TEKST NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_write++;}
                | WRITE NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_write++;}
                | WRITELN NAWIAS_LEWY WARUNEK_TEKST NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_writeln++;}
                | WRITELN NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_writeln++;}
                | READ NAWIAS_LEWY WARUNEK_TEKST NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_read++;}
                | READ NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_read++;}
                | READLN NAWIAS_LEWY WARUNEK_TEKST NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_readln++;}
                | READLN NAWIAS_LEWY NAZWA NAWIAS_PRAWY SREDNIK funkcje_srodek_dalej {liczba_readln++;}
                | W_KLAMRA funkcje_srodek_dalej {liczba_komentarzy++;}
                | if funkcje_srodek_dalej
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
                    | W_KLAMRA deklaracje_zmiennych {liczba_komentarzy++;}
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
            
tablica:     ARRAY TABLICA_LEWO typ_wartosc_tablicy DWIEKROPKI typ_wartosc_tablicy TABLICA_PRAWO OF  typ_zmiennej_tablica
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

stala: NAZWA ROWNA_SIE wartosc_przypisana
    ;

wartosc_przypisana: CYFRY_FLOAT
                | CYFRY 
                | WARUNEK_TEKST
                ;

koniec: END KROPKA;
%%

int main() {
    printf("Początek skanowania ...\n");
    yyparse();
    fflush(stdout);
    system("clear");
    printf("Koniec skanowania.\n");
    if (skanowanie_wykonane == 1)
    {
        printf("Program poprawny składniowo.\n");
        if (liczba_lini_kodu > 0)
            printf("Liczba linii: %d\n", liczba_lini_kodu);
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
        printf("Program niepoprawny składniowo.\n");

    return 0;
}

int yyerror(char *s) {
    printf("----------------------\n");
    printf("Błąd: %s\n", s);
    return 0;
}




