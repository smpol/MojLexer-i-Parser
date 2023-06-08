%option caseless

%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"

%}

%%
"program"       {return PASCAL_PROGRAM;}
"end."           {return PASCAL_END_PROGRAM;}
%%