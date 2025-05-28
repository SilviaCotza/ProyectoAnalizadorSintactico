package com.mycompany.proyectoanalizadorsintactico;
import java_cup.runtime.Symbol;
/**
 *
 * @author Silvia Izabel
 */
public class CustomParser extends parser{
    public CustomParser(AnalizadorLexico lexer) {
        super(lexer);
    }

    /**
     * Método sobrescrito para reportar errores de sintaxis no fatales.
     * CUP llama a este método cuando encuentra un error recuperable.
     * El token actual en el que se detecta el error se pasa como 'cur_token'.
     */
    @Override
    public void syntax_error(Symbol cur_token) { // <-- ¡Corregido aquí: syntax_error!
        System.err.println("--- ERROR DE SINTAXIS ---");
        System.err.println("Mensaje: Token inesperado.");
        if (cur_token != null) {
            // Ajuste +1 para línea y columna porque JFlex y CUP son 0-indexados
            System.err.println("Token: '" + (cur_token.value != null ? cur_token.value : "EOF/Nulo") +
                               "' en línea: " + (cur_token.left + 1) +
                               ", columna: " + (cur_token.right + 1));
        } else {
            System.err.println("Información adicional del error: Token nulo (posible EOF inesperado).");
        }
        System.err.println("--------------------------");
    }

    /**
     * Método sobrescrito para reportar errores de sintaxis fatales.
     * CUP llama a este método cuando no puede recuperarse de un error.
     */
    @Override
    public void unrecovered_syntax_error(Symbol cur_token) throws java.lang.Exception {
        // Primero, reportamos el error usando nuestro método de reporte de error no fatal
        syntax_error(cur_token);
        System.err.println("¡ERROR FATAL! El análisis no puede continuar.");
        // Opcional: Si quieres que la aplicación se detenga completamente aquí, puedes lanzar una excepción
        // throw new RuntimeException("Análisis abortado debido a error fatal.");
    }
    
}
