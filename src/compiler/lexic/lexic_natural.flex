/**
 * Assignatura 21780 Compiladors
 * Estudis de Grau en Informàtica
 * Professor: Pere Palmer
 * Autors: Teletubbies sospechosos
 */
package compiler.lexic;

import java.io.*;
import java.util.List;
import java.util.ArrayList;
import java_cup.runtime.*;
import java_cup.runtime.ComplexSymbolFactory.ComplexSymbol;
import java_cup.runtime.ComplexSymbolFactory.Location;

import compiler.sintactic.ParserSym;

%%

%cup
%public                                     // Clase pública
%class Scanner                              // Nombre de la clase generada
%int                                        // Tipo de los tókens generados
%line		                                // Para indicar la línea del error
%column		                                // Para indicar la posición del error


%eofval{
  return symbol(ParserSym.EOF);
%eofval}

// DEFINICIÓN DE PATRONES

// Palabras reservadas
int		    = "numero"
float		= "decimal"
bool		= "pregunta"
char		= "letra"
string		= "frase"
vacio		= "vacio"
const		= "constante"
true		= "cierto"
false		= "mentira"
if		    = "si"
else		= "sino"
for		    = "para"
while		= "mientras"
repeat		= "repite"
until		= "mientras que"
switch		= "segun"
case		= "si es"
break		= "salir"
array		= "lista de"
return		= "devuelve"
input		= "lee"
output		= "escribe"
outputn		= "escribeN"
long        = "de longitud"
main        = "principal"
acceso      = "posicion"

// Operadores
suma    	= "mas"
resta    	= "menos"
incr    	= "incrementa"
decr    	= "decrementa"
modif    	= "modifica"
prod    	= "multiplicado"
div		    = "dividido"
mod		    = "resto"
cond		= \?
asign		= "es"
igual		= "es igual que"
dist		= "es diferente de"
maigual		= "es mayor o igual que"
mayor		= "es mayor que"
meigual		= "es menor o igual que"
menor		= "es menor que"
and  		= "y ademas"
or   		= "o bien"
not  		= "no"
xor		    = "solo uno"

// Delimitadores
lparen  	= \(
rparen  	= \)
lcorch		= \[
rcorch		= \]
lbrack		= \{
rbrack		= \}
punto		= \.
coma		= \,
dpunto		= \:

// Expresiones
digito   	= [0-9]
digitos  	= {digito}+
decimal 	= {digitos}{punto}{digitos}
letra	  	= [A-Za-z]
id 		    = {letra}({letra}|{digito}|_)*
cadena      = \"([^\"\\\n]|\\.)*\"
elemento    = \'([^'\\\n])\'


// Comentarios y espacios en blanco
lcoment		= "//".*
mcoment 	= "/*" !([^]* "*/" [^]*) ("*/")?
blanco  	= [ \t\r\n]+

// Código copiado en la clase generada
%{
    // Gestión de símbolos basada en ComplexSymbol (sin atributo asociado).
    private ComplexSymbol symbol(int type) {
        // Sumar 1 para que la primera línia y columna no sea 0.
        Location izq = new Location(yyline+1, yycolumn+1);
        Location der = new Location(yyline+1, yycolumn+yytext().length()+1);

        return new ComplexSymbol(ParserSym.terminalNames[type], type, izq, der);
    }
    
    //Construcción de Symbol con un atributo asociado.
    private Symbol symbol(int type, Object value) {
        // Sumar 1 para que la primera línia y columna no sea 0.
        Location izq = new Location(yyline+1, yycolumn+1);
        Location der = new Location(yyline+1, yycolumn+yytext().length()+1);

        return new ComplexSymbol(ParserSym.terminalNames[type], type, izq, der, value);
    }
%}

%%

// REGLAS

// Ignorar espacios y comentarios
{blanco}   { /* ignorar */ }
{lcoment}  { /* ignorar */ }
{mcoment}  { /* ignorar */ }

// Palabras reservadas
{int}       { return symbol(ParserSym.INT); }
{float}     { return symbol(ParserSym.FLOAT); }
{bool}      { return symbol(ParserSym.BOOL); }
{char}      { return symbol(ParserSym.CHAR); }
{string}    { return symbol(ParserSym.STRING); }
{vacio}     { return symbol(ParserSym.VACIO); }
{const}     { return symbol(ParserSym.CONST); }
{true}      { return symbol(ParserSym.TRUE); }
{false}     { return symbol(ParserSym.FALSE); }
{if}        { return symbol(ParserSym.IF); }
{else}      { return symbol(ParserSym.ELSE); }
{for}       { return symbol(ParserSym.FOR); }
{while}     { return symbol(ParserSym.WHILE); }
{repeat}    { return symbol(ParserSym.REPEAT); }
{until}     { return symbol(ParserSym.UNTIL); }
{switch}    { return symbol(ParserSym.SWITCH); }
{case}      { return symbol(ParserSym.CASE); }
{break}     { return symbol(ParserSym.BREAK); }
{array}     { return symbol(ParserSym.ARRAY); }
{long}      { return symbol(ParserSym.LONG); }
{return}    { return symbol(ParserSym.RETURN); }
{input}     { return symbol(ParserSym.INPUT); }
{output}    { return symbol(ParserSym.OUTPUT); }
{outputn}   { return symbol(ParserSym.OUTPUTN); }
{main}      { return symbol(ParserSym.MAIN); }
{acceso}    { return symbol(ParserSym.ACCESO); }

// Operadores
{suma}      { return symbol(ParserSym.SUMA); }
{resta}     { return symbol(ParserSym.RESTA); }
{incr}      { return symbol(ParserSym.INCR); }
{decr}      { return symbol(ParserSym.DECR); }
{modif}     { return symbol(ParserSym.MODIF); }
{prod}      { return symbol(ParserSym.PROD); }
{div}       { return symbol(ParserSym.DIV); }
{mod}       { return symbol(ParserSym.MOD); }
{cond}      { return symbol(ParserSym.COND); }
{asign}     { return symbol(ParserSym.ASIGN); }
{igual}     { return symbol(ParserSym.IGUAL); }
{dist}      { return symbol(ParserSym.DIST); }
{maigual}   { return symbol(ParserSym.MAIGUAL); }
{mayor}     { return symbol(ParserSym.MAYOR); }
{meigual}   { return symbol(ParserSym.MEIGUAL); }
{menor}     { return symbol(ParserSym.MENOR); }
{not}       { return symbol(ParserSym.NOT); }
{and}       { return symbol(ParserSym.AND); }
{or}        { return symbol(ParserSym.OR); }
{xor}       { return symbol(ParserSym.XOR); }

// Delimitadores
{lparen}    { return symbol(ParserSym.LPAREN); }
{rparen}    { return symbol(ParserSym.RPAREN); }
{lcorch}    { return symbol(ParserSym.LCORCH); }
{rcorch}    { return symbol(ParserSym.RCORCH); }
{lbrack}    { return symbol(ParserSym.LBRACK); }
{rbrack}    { return symbol(ParserSym.RBRACK); }
{punto}     { return symbol(ParserSym.PUNTO); }
{coma}      { return symbol(ParserSym.COMA); }
{dpunto}    { return symbol(ParserSym.DPUNTO); }

// Identificadores y expresiones
{id}        { return symbol(ParserSym.ID, yytext()); }
{digitos}   { return symbol(ParserSym.NUMERO, Integer.parseInt(yytext())); }
{decimal}   { return symbol(ParserSym.DECIMAL, Double.valueOf(yytext())); }
{cadena}    { return symbol(ParserSym.CADENA, yytext()); }
{elemento}  { return symbol(ParserSym.ELEMENTO, yytext()); }

// Cualquier otro carácter (error)
[^]         { return symbol(ParserSym.error, yytext()); }