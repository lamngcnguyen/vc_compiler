%%

%public
%class VCScanner
%standalone

%unicode
%line
%column

%{
    StringBuilder stringBuilder = new StringBuilder();
    private void symbol(String type, Object value) {
        System.out.printf("Line %d | Column: %d | Type: %s | Value: %s \n", yyline+1, yycolumn+1, type, value);
    }
%}

/* Defenitions */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Whitespace = {LineTerminator} | [ \t\f]

/* Comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Keywords = boolean|break|continue|else|for|float|if|int|return|void|while
Operators = \+|\-|\*|\/|\=|\>|\<|\<=|\>=|\==|\!=|\&&|(\|\|)|\!|(\+|\+)|(\-|\-)
Seperators = \(|\)|\{|\}|\[|\]|\;|\,

Identifier = [:jletter:] [:jletterdigit:]*

IntegerLiteral = 0 | [1-9][0-9]*

/* floating point literals */
FloatLiteral  = ({FLit1}|{FLit2}|{FLit3}) {Exponent}?
FLit1    = [0-9]+\.[0-9]*
FLit2    = \.[0-9]+
FLit3    = [0-9]+
Exponent = [eE][+-]?[0-9]+

/* string and character literals */
StringCharacter = [^\r\n\"\\]

BooleanLiteral = true|false

%state STRING

%%
<YYINITIAL> {
    {Comment}       {/* ignored */}
    {Whitespace}    {/* ignored */}

    {Keywords}          {symbol("Keywords", yytext());}
    {Operators}         {symbol("Operators", yytext());}
    {Seperators}        {symbol("Seperators", yytext());}

    {BooleanLiteral}    {symbol("Boolean Literal", yytext());}
    {Identifier}        {symbol("Identifiers", yytext());}
    {IntegerLiteral}    {symbol("Integer Literal", Integer.valueOf(yytext()));}
    {FloatLiteral}      {symbol("Floating-point Literal", new Float(yytext()));}

    \"                  {yybegin(STRING); stringBuilder.setLength(0);} //String literal
}

<STRING> {
    \"                      {yybegin(YYINITIAL); symbol("String Literal", stringBuilder.toString());}
    {StringCharacter}+      {stringBuilder.append(yytext());}
    "\\b"                   {stringBuilder.append('\b');}
    "\\t"                   {stringBuilder.append('\t');}
    "\\n"                   {stringBuilder.append('\n');}
    "\\f"                   {stringBuilder.append('\f');}
    "\\r"                   {stringBuilder.append('\r');}
    "\\\""                  {stringBuilder.append('\"');}
    "\\'"                   {stringBuilder.append('\'');}
    "\\\\"                  {stringBuilder.append('\\');}
}
