import java.io.File;
import java.nio.file.*;
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
        try {
            File f = new File("result.txt");
            f.createNewFile();
            String result = "Line " + (yyline+1) + " | Column: " + (yycolumn+1) + " | Type: " + type + " | Value: " + value + " \n";
            Files.write(Paths.get("result.txt"), result.getBytes(), StandardOpenOption.APPEND);
            System.out.printf("Line %d | Column: %d | Type: %s | Value: %s \n", yyline+1, yycolumn+1, type, value);
        } catch (Exception e) {
            e.printStackTrace();
        }
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
    {Comment}           {/* ignored */}
    {Whitespace}        {/* ignored */}

    {Keywords}          {symbol("Keywords", yytext());}
    {Operators}         {symbol("Operators", yytext());}
    {Seperators}        {symbol("Seperators", yytext());}

    {BooleanLiteral}    {symbol("Boolean Literal", yytext());}
    {IntegerLiteral}    {symbol("Integer Literal", Integer.valueOf(yytext()));}
    {FloatLiteral}      {symbol("Floating-point Literal", new Float(yytext()));}
    {Identifier}        {symbol("Identifiers", yytext());}

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
