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

/* Comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Identifier = [:jletter:] [:jletterdigit:]*

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

    /* operators */
    "+"         {return symbol(PLUS);}
    "-"         {return symbol(MINUS);}
    "*"         {return symbol(MULT);}
    "/"         {return symbol(DIV);}
    "="         {return symbol(EQ);}
    ">"         {return symbol(GT);}
    "<"         {return symbol(LT);}
    "<="        {return symbol(LTEQ);}
    ">="        {return symbol(GTEQ);}
    "=="        {return symbol(EQEQ);}
    "!="        {return symbol(NOTEQ);}
    "&&"        {return symbol(ANDAND);}
    "||"        {return symbol(OROR);}
    "!"         {return symbol(NOT);}
    "++"        {return symbol(PLUSPLUS);}
    "--"        {return symbol(MINUSMINUS);}

    /* separators */
    "("         {return symbol(LPAREN);}
    ")"         {return symbol(RPAREN);}
    "{"         {return symbol(LBRACE);}
    "}"         {return symbol(RBRACE);}
    "["         {return symbol(LBRACK);}
    "]"         {return symbol(RBRACK);}
    ";"         {return symbol(SEMICOLON);}
    ","         {return symbol(COMMA);}


}

[^]             {throw new RuntimeException("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn);}
<<EOF>>         {return symbol(EOF);}