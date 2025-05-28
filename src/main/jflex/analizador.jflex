package com.mycompany.proyectoanalizadorsintactico;

import java_cup.runtime.*;

%%

// opciones y declaraciones

%class AnalizadorLexico
%public
%cup
%char
%line
%column



%{
    public void imprimirLexema(String lexema, long columna, 
                               int linea) {
        System.out.println("Lexema:" + lexema +
                          " Columna: " + columna +
                          " Línea: " + linea);
    }

    public Symbol getToken(int tipo, Object valor) {
        return new Symbol(tipo, yyline, yycolumn, valor);
    }
%}

digito = [0-9]
numero = {digito}+
espacios_blanco = [ \t\n\r]

%%

// reglas léxicas
"DEFINE"        { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.DEFINE, yytext()); }
"PRINT"         { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.PRINT, yytext()); }
"IF"            { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.IF, yytext()); }
"THEN"          { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.THEN, yytext()); }
"ELSE"          { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.ELSE, yytext()); }
"ELSEIF"        { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.ELSEIF, yytext()); }
"WHILE"         { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.WHILE, yytext()); }
"LOOP"          { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.LOOP, yytext()); }
"FUNCTION"      { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.FUNCTION, yytext()); }
"RETURN"        { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.RETURN, yytext()); }
"END"           { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.END, yytext()); }
"TRUE"          { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.TRUE, Boolean.TRUE); }
"FALSE"         { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.FALSE, Boolean.FALSE); }

/* Tipos de datos */
"int"           { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.INT, yytext()); }
"double"        { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.DOUBLE, yytext()); }
"string"        { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.STRING, yytext()); }
"boolean"       { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.BOOLEAN, yytext()); }

/* Operadores Aritméticos */
"+"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.PLUS, yytext()); }
"-"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.MINUS, yytext()); }
"*"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.MULT, yytext()); }
"/"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.DIV, yytext()); }

/* Operadores de Comparación */
"<="            { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.LE, yytext()); }
">="            { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.GE, yytext()); }
"=="            { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.EQ, yytext()); }
"!="            { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.NEQ, yytext()); }
"<"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.LT, yytext()); }
">"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.GT, yytext()); }

/* Operadores Lógicos */
"&&"            { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.AND, yytext()); }
"||"            { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.OR, yytext()); }
"!"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.NOT, yytext()); }

/* Paréntesis */
"("             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.LPAREN, yytext()); }
")"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.RPAREN, yytext()); }

/* Puntuación */
";"             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.SEMICOLON, yytext()); }
","             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.COMMA, yytext()); }
"="             { imprimirLexema(yytext(), yycolumn, yyline); return getToken(sym.ASSIGN, yytext()); }

{espacios_blanco}   { imprimirLexema(yytext(), yycolumn, yyline ); }

/* Identificadores */
[a-zA-Z_][a-zA-Z0-9_]* {
    imprimirLexema(yytext(), yycolumn, yyline);
    return getToken(sym.IDENTIFIER, yytext());
}

/* Números */
{numero}"."{numero} {
    imprimirLexema(yytext(), yycolumn, yyline);
    return getToken(sym.DOUBLE_LITERAL, Double.parseDouble(yytext()));
}

{numero} {
    imprimirLexema(yytext(), yycolumn, yyline);
    return getToken(sym.INTEGER_LITERAL, Integer.parseInt(yytext()));
}

/* Cadenas (sin comillas externas) */
\"([^\"\\\n]|\\.)*\" {
    String valor = yytext().substring(1, yytext().length() - 1); // quitar comillas
    imprimirLexema(valor, yycolumn, yyline);
    return getToken(sym.STRING_LITERAL, valor);
}

/* Error */
. {
    System.err.println("Error léxico: carácter no reconocido '" + yytext() + "' en línea " + (yyline + 1) + ", columna " + (yycolumn + 1));
    return getToken(sym.ERROR, yytext());
}
