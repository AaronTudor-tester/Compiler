/**
 * Assignatura 21780 Compiladors
 * Estudis de Grau en Informàtica
 * Professor: Pere Palmer
 * Autors: Teletubbies sospechosos (Jaume Juan Huguet, Katia Ostrovsky Borrás, Aarón-satyar Daghigh-nia Tudor, Antonio García Font)
 */
package lenguaje;

import java.io.FileReader;
import java.io.PrintWriter;
import java.util.*;

import compiler.lexic.Scanner;
import compiler.sintactic.Parser;
import compiler.sintactic.Symbols.NodoPrograma;
import compiler.sintactic.Symbols.Simbolo;
import compiler.sintactic.Symbols.BloqueActivacion;
import compiler.codigo_intermedio.Instruccion;
import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Optimizador;
import compiler.codigo_ensamblador.Generador68K;
import java.io.FileNotFoundException;

import java_cup.runtime.Symbol;
import java_cup.runtime.ComplexSymbolFactory.ComplexSymbol;

public class LenguajeNatural {

    public static void main(String[] args) {

        if (args.length < 1) {
            System.err.println("Uso: java Main <archivo_entrada>");
            System.exit(1);
        }

        String archivo = args[0]; // RUTA DEL ARCHIVO

        //String ruta = "programas/" + archivo + "/" + archivo + ".txt";
        String ruta = archivo.endsWith(".txt") ? archivo : archivo + ".txt";
        String directorioSalida = ruta.substring(0, ruta.lastIndexOf("\\") + 1);
        String nombreArchivo = archivo.substring(archivo.lastIndexOf("\\") + 1).replace(".txt", "");

        // Lista para capturar todos los errores
        List<String> listaErrores = new ArrayList<>();
        

        try {
            // ANALISIS LEXICO - GENERAR ARCHIVO DE TOKENS
            FileReader reader = new FileReader(ruta);
            String archivoTokens = directorioSalida + nombreArchivo + "_tokens.txt";
            PrintWriter writerTokens = new PrintWriter(archivoTokens);

            writerTokens.println("===== TOKENS GENERADOS =====\n");

            Scanner scanner1 = new Scanner(reader);
            Symbol tok;

            do {
                tok = scanner1.next_token();
                ComplexSymbol ctok = (ComplexSymbol) tok;

                String linea = String.format(
                        "Token %-12s  texto='%s'  (linea %d, col %d)",
                        ctok.getName(),
                        ctok.value == null ? "-" : ctok.value.toString(),
                        ctok.getLeft().getLine(),
                        ctok.getLeft().getColumn()
                );

                writerTokens.println(linea);

            } while (tok.sym != compiler.sintactic.ParserSym.EOF);

            writerTokens.close();
            System.out.println("Archivo de tokens generado: " + archivoTokens);

            // ANALISIS SINTACTICO Y SEMANTICO
            FileReader reader2 = new FileReader(ruta);
            Scanner scanner2 = new Scanner(reader2);
            Parser parser = new Parser(scanner2);

            Symbol resultado = parser.parse();

            String archivoErrores = directorioSalida + nombreArchivo + "_errores.txt";
            
            // Borrar archivo de errores viejo.
            java.io.File fErrores = new java.io.File(archivoErrores);
            if (fErrores.exists()) {
                fErrores.delete();
            }
            // Recopilar errores del parser
            // Generar archivo de errores solo si hay errores
            if (parser.getListaErrores() != null && !parser.getListaErrores().isEmpty()) {
                for (Parser.ErrorInfo error : parser.getListaErrores()) {
                    listaErrores.add(error.toString());
                }  
                PrintWriter writerErrores = new PrintWriter(archivoErrores);
                
                writerErrores.println("===== ERRORES DETECTADOS EN LA COMPILACIÓN =====\n");
                writerErrores.println("Archivo: " + ruta);
                writerErrores.println("Fecha: " + java.time.LocalDateTime.now());
                writerErrores.println("\n" + listaErrores.size() + " error(es) encontrado(s):\n");

                for (int i = 0; i < listaErrores.size(); i++) {
                    writerErrores.println((i + 1) + ". " + listaErrores.get(i));
                }

                writerErrores.close();
                System.err.println("\nArchivo de errores generado: " + archivoErrores);
                System.err.println("\nCompilación no completada debido a errores.");
                System.exit(1);
            } else {
                System.out.println("\nNo se detectaron errores. Compilación exitosa.");
            }

            // GENERAR ARCHIVO DE TABLA DE SÍMBOLOS
            BloqueActivacion global = parser.getBloqueGlobal();
            String archivoTablaSimbolos = directorioSalida + nombreArchivo + "_tabla_simbolos.txt";
            PrintWriter writerTabla = new PrintWriter(archivoTablaSimbolos);

            writerTabla.println("===== TABLA DE SÍMBOLOS =====\n");
            imprimirBloques(global, "", writerTabla);
            writerTabla.close();
            System.out.println("Tabla de símbolos generada: " + archivoTablaSimbolos);

            NodoPrograma prog = (NodoPrograma) resultado.value;

            // Generar un archivo en formato GraphViz .dot a partir del AST
            String archivoDot = directorioSalida + nombreArchivo + ".dot";
            toDot(prog, archivoDot);
            System.out.println("Archivo .dot generado: " + archivoDot);

            // GENERACIÓN DE CÓDIGO INTERMEDIO
            List<Instruccion> codigoIntermedio = prog.generarCodigo(new Generador());

            String archivoCodigoIntermedio = directorioSalida + nombreArchivo + "_codigo_intermedio.txt";
            PrintWriter writerIntermedio = new PrintWriter(archivoCodigoIntermedio);
            writerIntermedio.println("===== CÓDIGO INTERMEDIO =====\n");

            for (Instruccion instr : codigoIntermedio) {
                writerIntermedio.println(instr);
            }

            writerIntermedio.close();
            System.out.println("Código intermedio generado: " + archivoCodigoIntermedio);

            // GENERAR TABLAS DE VARIABLES Y PROCEDIMIENTOS
            String archivoTablas = directorioSalida + nombreArchivo + "_tablas_backend.txt";
            generarTablasBackend(codigoIntermedio, archivoTablas, global);
            System.out.println("Tablas de variables y procedimientos generadas: " + archivoTablas);

            // GENERACION DE CODIGO ENSAMBLADOR SIN OPTIMIZAR
            Generador68K gen68K = new Generador68K(codigoIntermedio);
            String archivoSalida = directorioSalida + nombreArchivo + ".x68";
            gen68K.generar(archivoSalida);
            System.out.println("Código ensamblador generado: " + archivoSalida);

            // OPTIMIZACIÓN
            Optimizador optimizador = new Optimizador();
            List<Instruccion> codigoOptimizado = optimizador.optimizar(codigoIntermedio);

            // GENERACIÓN DE CÓDIGO ENSAMBLADOR OPTIMIZADO
            gen68K = new Generador68K(codigoOptimizado);
            String archivoSalidaOptimizado = directorioSalida + nombreArchivo + "_optimizado.x68";
            gen68K.generar(archivoSalidaOptimizado);
            System.out.println("Código ensamblador optimizado generado: " + archivoSalidaOptimizado);

            // Calcular estadísticas para ver la mejora de la optimización antes de escribir el archivo
            int instruccionesOriginales = codigoIntermedio.size();
            int instruccionesOptimizadas = (int) codigoOptimizado.stream()
                    .filter(i -> !i.toString().isEmpty())
                    .count();
            int instruccionesEliminadas = instruccionesOriginales - instruccionesOptimizadas;
            double porcentajeReduccion = instruccionesOriginales > 0
                    ? (instruccionesEliminadas * 100.0 / instruccionesOriginales)
                    : 0;

            long bytesOriginal = new java.io.File(archivoSalida).length();
            long bytesOptimizado = new java.io.File(archivoSalidaOptimizado).length();
            long bytesReducidos = bytesOriginal - bytesOptimizado;
            double porcentajeReduccionAsm = bytesOriginal > 0
                    ? (bytesReducidos * 100.0 / bytesOriginal)
                    : 0;

            // Escribir el archivo de optimización con todas las estadísticas de las mejoras
            String archivoOptimizacion = directorioSalida + nombreArchivo + "_optimizacion.txt";
            PrintWriter writerOpt = new PrintWriter(archivoOptimizacion);
            writerOpt.println("===== OPTIMIZACIONES REALIZADAS =====\n");
            writerOpt.println("Archivo: " + ruta);
            writerOpt.println("Fecha: " + java.time.LocalDateTime.now());

            // Estadísticas de mejora respecto al código original
            writerOpt.println("\n--- ESTADÍSTICAS DE CÓDIGO INTERMEDIO ---\n");
            writerOpt.println("Instrucciones originales: " + instruccionesOriginales);
            writerOpt.println("Instrucciones optimizadas: " + instruccionesOptimizadas);
            writerOpt.println("Instrucciones eliminadas: " + instruccionesEliminadas);
            writerOpt.println(String.format("Reducción: %.2f%%", porcentajeReduccion));

            writerOpt.println("\n--- ESTADÍSTICAS DE ENSAMBLADOR ---\n");
            writerOpt.println("Archivo original (.x68): " + bytesOriginal + " bytes");
            writerOpt.println("Archivo optimizado (_optimizado.x68): " + bytesOptimizado + " bytes");
            writerOpt.println("Bytes reducidos: " + bytesReducidos + " bytes");
            writerOpt.println(String.format("Reducción en ensamblador: %.2f%%", porcentajeReduccionAsm));

            writerOpt.println("\n--- CÓDIGO OPTIMIZADO ---\n");
            for (Instruccion instr : codigoOptimizado) {
                if (!instr.toString().isEmpty()) {
                    writerOpt.println(instr);
                }
            }
            writerOpt.println("\n--- CAMBIOS REALIZADOS POR EL OPTIMIZADOR ---\n");
            int totalCambios = 0;
            for (Map.Entry<String, List<String>> optimizacion : optimizador.getCambios().entrySet()) {
                writerOpt.println(optimizacion.getKey() + ":");
                for (String cambio : optimizacion.getValue()) {
                    writerOpt.println("  - " + cambio);
                    totalCambios++;
                }
            }
            if (totalCambios == 0) {
                writerOpt.println("No se han realizado optimizaciones");
            }
            writerOpt.close();
            System.out.println("Optimizaciones generadas: " + archivoOptimizacion);

            System.out.println("\n===== COMPILACION COMPLETADA CON ÉXITO =====\n");
            System.out.println("Archivos generados en: " + directorioSalida + "\n");
            System.out.println("  1. " + nombreArchivo + "_tokens.txt                - Tokens léxicos");
            System.out.println("  2. " + nombreArchivo + "_tabla_simbolos.txt        - Tabla de símbolos");
            System.out.println("  3. " + nombreArchivo + "_codigo_intermedio.txt     - Código de intermedio");
            System.out.println("  4. " + nombreArchivo + "_tablas_backend.txt        - Variables y procedimientos");
            System.out.println("  5. " + nombreArchivo + ".x68                       - Ensamblador sin optimizar");
            System.out.println("  6. " + nombreArchivo + "_optimizado.x68            - Ensamblador optimizado");
            System.out.println("  7. " + nombreArchivo + "_optimizacion.txt          - Informe de optimizaciones");
            System.out.println("  8. " + nombreArchivo + ".dot                       - Visualización AST (Graphviz)");

        } catch (FileNotFoundException e) {
            System.err.println("Archivo no encontrado: " + archivo);
        } catch (Exception e) {
            System.err.println("Error durante el análisis: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void toDot(NodoPrograma prog, String outFile) {
        try (PrintWriter out = new PrintWriter(outFile)) {
            out.println("strict digraph {");
            prog.toDot(out);
            out.println("}");
        } catch (FileNotFoundException ex) {
            System.err.println("ERROR. No se puede escribir en \"" + outFile + "\"");
        }
    }

    // Metodo recursivo para imprimir toda la jerarquía de bloques
    private static void imprimirBloques(BloqueActivacion bloque, String indent, PrintWriter writer) {

        // Variables del bloque
        for (Simbolo s : bloque.getVariables()) {
            if (s.isConstante()) {
                writer.println(indent + "CONSTANTE: " + s);
            } else {
                writer.println(indent + "VARIABLE: " + s);
            }
        }

        // Funciones del bloque
        for (Simbolo f : bloque.getFunciones()) {
            writer.println(indent + "FUNCION: " + f);
        }

        // Bloques hijos
        for (BloqueActivacion hijo : bloque.getHijos()) {
            imprimirBloques(hijo, indent + "  ", writer);
        }
    }

    // Método para generar el archivo de las tablas de variables y procedimientos
    private static void generarTablasBackend(List<Instruccion> codigo, String archivo, BloqueActivacion global) {
        try (PrintWriter writer = new PrintWriter(archivo)) {
            writer.println("===== TABLAS DE VARIABLES Y PROCEDIMIENTOS =====\n");

            // Extraer variables del codigo intermedio
            Set<String> variablesUsadas = new HashSet<>();
            Set<String> temporales = new HashSet<>();
            Set<String> procedimientos = new HashSet<>();

            // Detectar funciones o procedimientos del código intermedio (buscamos sus etiquetas)
            for (Instruccion instr : codigo) {
                String instrStr = instr.toString().trim();
                if (instrStr.endsWith(":")) { // Las etiquetas termian con ":"
                    String labelName = instrStr.substring(0, instrStr.length() - 1).trim();
                    // No tenemos en cuenta etiquetas temporales, main, end, etc.
                    if (!labelName.equals("main") && !labelName.equals("end")
                            && !labelName.startsWith("L") && !labelName.matches("e\\d+")
                            && !labelName.startsWith("t\\d+_")) {
                        procedimientos.add(labelName);
                    }
                }

                // Recopilar operandos y resultados
                if (instr.getOperador1() != null) {
                    String op1 = instr.getOperador1();
                    if (op1.startsWith("t") && op1.matches("t\\d+")) {
                        temporales.add(op1);
                    } else if (!esLiteral(op1) && !esExpresion(op1) && !esEtiqueta(op1) && !procedimientos.contains(op1)) {
                        variablesUsadas.add(op1);
                    }
                }

                if (instr.getOperador2() != null) {
                    String op2 = instr.getOperador2();
                    if (op2.startsWith("t") && op2.matches("t\\d+")) {
                        temporales.add(op2);
                    } else if (!esLiteral(op2) && !esExpresion(op2) && !esEtiqueta(op2) && !procedimientos.contains(op2)) {
                        variablesUsadas.add(op2);
                    }
                }

                if (instr.getResultado() != null) {
                    String res = instr.getResultado();
                    if (res.startsWith("t") && res.matches("t\\d+")) {
                        temporales.add(res);
                    }
                }
            }

            // Eliminar nombres de funciones de las variables
            variablesUsadas.removeAll(procedimientos);
            variablesUsadas.remove("main");
            variablesUsadas.remove("end");

            // Filtrar temporales que contienen expresiones (ej: "t22 != t23")
            Set<String> temporalesFiltradas = new HashSet<>();
            for (String temp : temporales) {
                if (temp.matches("t\\d+") && !temp.contains(" ") && !temp.contains("!=")
                        && !temp.contains("==") && !temp.contains("<") && !temp.contains(">")) {
                    temporalesFiltradas.add(temp);
                }
            }

            writer.println("--- TABLA DE VARIABLES ---\n");
            writer.println("Variables del programa:");
            for (String var : variablesUsadas) {
                Simbolo sim = global.buscar(var);
                if (sim != null) {
                    writer.println("  " + var + " : " + sim.getTipo()
                            + (sim.isArray() ? " [" + sim.getLongitud() + "]" : ""));
                } else {
                    writer.println("  " + var);
                }
            }

            writer.println("\nVariables temporales generadas:");
            for (String temp : temporalesFiltradas) {
                writer.println("  " + temp);
            }

            writer.println("\n--- TABLA DE PROCEDIMIENTOS ---\n");
            if (procedimientos.isEmpty()) {
                writer.println("(ningun procedimiento definido)");
            } else {
                for (String proc : procedimientos) {
                    writer.println("  " + proc);
                    Simbolo sim = global.buscarFuncion(proc.replace("func_", ""));
                    if (sim != null) {
                        writer.println("    Tipo retorno: " + sim.getTipo());
                        if (sim.getParametros() != null) {
                            writer.println("    Parametros: " + sim.getParametros().size());
                        }
                    }
                }
            }

        } catch (FileNotFoundException ex) {
            System.err.println("ERROR: No se puede escribir en \"" + archivo + "\"");
        }
    }

    private static boolean esLiteral(String valor) {
        if (valor == null) {
            return false;
        }
        // Numero
        if (valor.matches("-?\\d+(\\.\\d+)?")) {
            return true;
        }
        // String literal
        if (valor.startsWith("\"") && valor.endsWith("\"")) {
            return true;
        }
        // Caracter
        if (valor.startsWith("'") && valor.endsWith("'")) {
            return true;
        }
        // true/false
        if (valor.equals("true") || valor.equals("false")) {
            return true;
        }
        return false;
    }

    private static boolean esExpresion(String valor) {
        if (valor == null) {
            return false;
        }
        // Expresiones que contienen operadores o palabras clave
        if (valor.contains(" ")) {
            return true; // "call multiplicar", "t22 != t23", etc.

        }
        if (valor.contains("!=") || valor.contains("==") || valor.contains("<=") || valor.contains(">=")) {
            return true;
        }
        if (valor.contains("<") || valor.contains(">")) {
            return true;
        }
        if (valor.contains("&&") || valor.contains("||")) {
            return true;
        }
        return false;
    }

    private static boolean esEtiqueta(String valor) {
        if (valor == null) {
            return false;
        }
        // Etiquetas temporales: e0, e1, e2, etc.
        if (valor.matches("e\\d+")) {
            return true;
        }
        // Etiquetas de control: L0, L1, etc.
        if (valor.matches("L\\d+")) {
            return true;
        }
        // Palabras reservadas del backend
        if (valor.equals("main") || valor.equals("end")) {
            return true;
        }
        return false;
    }
}
