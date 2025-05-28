package com.mycompany.proyectoanalizadorsintactico;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.StringReader;
import java.io.Reader;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

@Controller
public class AnalizadorWebController {

    @GetMapping("/")
    public String showAnalizadorForm(Model model) {
        model.addAttribute("resultadoAnalisis", "");
        model.addAttribute("codigoFuente", "");
        model.addAttribute("lexemasDetallados", ""); // Nuevo atributo para los detalles de lexemas
        return "analizador";
    }

    @PostMapping("/analizar")
    public String analizarCodigo(@RequestParam("codigo") String codigoFuente, Model model) {
        String resultadoGeneral = "";
        String lexemasDetallados = ""; // Variable para almacenar los lexemas y su info

        // --------- INICIO: Captura de System.out y System.err ---------
        ByteArrayOutputStream capturedOutput = new ByteArrayOutputStream();
        PrintStream originalOut = System.out;
        PrintStream originalErr = System.err;
        System.setOut(new PrintStream(capturedOutput)); // Redirige System.out
        System.setErr(new PrintStream(capturedOutput)); // Redirige System.err
        // -------------------------------------------------------------

        try {
            Reader reader = new StringReader(codigoFuente);
            AnalizadorLexico lexer = new AnalizadorLexico(reader);
            CustomParser parser = new CustomParser(lexer);

            try {
                parser.parse(); // Ejecuta el análisis (esto debería imprimir los lexemas y errores)

                // Asegúrate de que todos los buffers estén vacíos antes de restaurar
                System.out.flush();
                System.err.flush();

                String fullCapturedOutput = capturedOutput.toString();

                // Aquí puedes procesar 'fullCapturedOutput' para separar el resultado general
                // de los lexemas detallados.
                // Por simplicidad inicial, enviaremos todo el contenido capturado al frontend,
                // y luego podemos refinar si es necesario.

                if (fullCapturedOutput.contains("ERROR")) {
                    resultadoGeneral = "Análisis completado con ERRORES. Consulta los detalles para más información.";
                    // Considera extraer solo las líneas de error para 'resultadoGeneral' si quieres un resumen.
                } else if (fullCapturedOutput.isEmpty() || !fullCapturedOutput.contains("Lexema:")) {
                    // Si no hay errores y no hay lexemas, puede ser un código vacío o sin salida detallada
                    resultadoGeneral = "Análisis sintáctico exitoso. No se generaron detalles de lexemas visibles.";
                } else {
                    resultadoGeneral = "Análisis sintáctico exitoso.";
                }

                // Aquí asignamos la salida completa capturada a lexemasDetallados
                lexemasDetallados = fullCapturedOutput;


            } catch (Exception e) {
                resultadoGeneral = "Error durante el análisis: " + e.getMessage();
                lexemasDetallados = capturedOutput.toString() + "\nStack Trace: " + e.getMessage();
            }

        } finally {
            // --------- FINAL: Restaurar System.out y System.err ---------
            System.setOut(originalOut);
            System.setErr(originalErr);
            // -------------------------------------------------------------
        }

        model.addAttribute("resultadoAnalisis", resultadoGeneral);
        model.addAttribute("codigoFuente", codigoFuente);
        model.addAttribute("lexemasDetallados", lexemasDetallados); // Enviamos los detalles capturados

        return "analizador";
    }

    
}
