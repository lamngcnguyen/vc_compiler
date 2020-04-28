import java_cup.runtime.*;
%%

%public
%class Scanner
%implements sym

%unicode
%line
%column

%cup
%cupdebug

%{
    StringBuilder stringBuilder = new StringBuilder();
    private Symbol symbol(int type) {
        return new VcSymbol(type, yyline+1, yycolumn+1);
    }
    private Symbol symbol(int type, Object value) {
        return new VcSymbol(type, yyline+1, yycolumn+1, value);
    }
%}

/* Defenitions */
LineTerminator = \r|\n|\r\n
Whitespace = {LineTerminator} | [ \t\f]

Comment = {}

%%
<YYINITIAL> {
    /* kaywords */
    "boolean"   {return symbol(BOOLEAN);}
    "break"     {return symbol(BREAK);}
    "continue"  {return symbol(CONTINUE);}
    "else"      {return symbol(ELSE);}
    "for"       {return symbol(FOR);}
    "float"     {return symbol(FLOAT);}
    "if"        {return symbol(IF);}
    "int"       {return symbol(INT);}
    "return"    {return symbol(RETURN);}
    "void"      {return symbol(VOID);}
    "while"     {return symbol(WHILE);}


}

[^]                              { throw new RuntimeException("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>                          { return symbol(EOF); }