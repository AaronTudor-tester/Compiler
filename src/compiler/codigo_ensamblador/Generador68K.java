/**
 * Assignatura 21780 Compiladors
 * Estudis de Grau en Informàtica
 * Professor: Pere Palmer
 * Autors: Teletubbies sospechosos
 */
package compiler.codigo_ensamblador;

import compiler.codigo_intermedio.Instruccion;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Generador68K {

    private List<Instruccion> codigo;
    private StringBuilder asm;
    private Set<String> variables;
    private Set<String> floatVariables;
    private Set<String> charVariables;  // Variables de tipo CHAR
    private Set<String> longVariables;  // Variables que necesitan 32 bits
    private Set<String> stringVariables; // Variables de tipo STRING 
    private Set<String> stringArrays;    // Arrays que contienen strings
    private Set<String> arrayVariables;  // Variables de tipo ARRAY 
    private Map<String, String> literalToLabel;
    private Map<String, String> labelToLiteral;
    private Map<String, List<Integer>> dimensionesArray; // Dimensiones de arrays pasados como parámetros
    private int strCount = 0;

    // Conjunto para saber que rutinas auxiliares se van a necesitar
    private Set<String> rutinasNecesarias;

    public Generador68K(List<Instruccion> codigo) {
        this.codigo = codigo;
        this.asm = new StringBuilder();
        this.variables = new HashSet<>();
        this.floatVariables = new HashSet<>();
        this.charVariables = new HashSet<>();
        this.longVariables = new HashSet<>();
        this.stringVariables = new HashSet<>();
        this.stringArrays = new HashSet<>();
        this.arrayVariables = new HashSet<>();
        this.literalToLabel = new HashMap<>();
        this.labelToLiteral = new HashMap<>();
        this.dimensionesArray = new HashMap<>();
        this.rutinasNecesarias = new HashSet<>();
    }

    public void generar(String archivo) throws IOException {
        recolectarVariables();
        detectarVariablesFloat();
        detectarVariablesChar();
        detectarVariablesLong();
        detectarVariablesString();
        detectarVariablesArray();
        detectarRutinasNecesarias();
        StringBuilder globalInit = new StringBuilder();
        StringBuilder functionsCode = new StringBuilder();
        StringBuilder mainCode = new StringBuilder();
        StringBuilder currentSection = globalInit;
        boolean foundMain = false;

        // Primero separamos el código en secciones
        for (Instruccion i : codigo) {
            String op = i.getOpCode();
            if (op != null && op.equalsIgnoreCase("LABEL")) {
                String lbl = i.getResultado() != null ? i.getResultado() : i.getOperador1();
                if (lbl != null && lbl.equals("main")) {
                    currentSection = mainCode;
                    foundMain = true;
                    mainCode.append(lbl).append(":\n");
                } else if (lbl != null) {
                    // Esto es para manejar funciones antes de main
                    if (!foundMain) {
                        currentSection = functionsCode;
                    }
                    currentSection.append(lbl).append(":\n");
                }
            } else {
                // Traducir en un StringBuilder temporal
                StringBuilder temp = new StringBuilder();
                StringBuilder oldAsm = asm;
                asm = temp;
                traducir(i);
                currentSection.append(asm.toString());
                asm = oldAsm;
            }
        }

        cabecera();
        // Añadir inicialización global
        asm.append(globalInit);
        // Saltar a main
        asm.append("\tJMP main\n");
        // Agregar rutinas auxiliares
        agregarRutinasAuxiliares();
        //Añadir código de funciones
        asm.append(functionsCode);
        //Añadir código principal
        asm.append(mainCode);
        // Añadir instrucción de parada al final del main
        asm.append("\tBRA HALT\n");
        // Añadir sección de datos
        datos();
        escribirArchivo(archivo);
    }

    // Detecta qué rutinas auxiliares son necesarias según el código intermedio
    private void detectarRutinasNecesarias() {
        rutinasNecesarias.clear();

        for (Instruccion i : codigo) {
            String op = i.getOpCode();
            String tipo = i.getTipo();

            if (op != null && (op.equals("print") || op.equals("PRINT"))) {
                // Determinar qué rutina de impresión se necesita
                if (tipo != null && tipo.equals("BOOL")) {
                    rutinasNecesarias.add("PRINT_BOOL");
                } else if (tipo != null && tipo.equals("FLOAT")) {
                    rutinasNecesarias.add("PRINT_DECIMAL_2");
                } else if (tipo != null && tipo.equals("CHAR")) {
                    // Los CHAR usan TRAP #15 directamente, no necesitan rutina 
                } else {
                    // Para números enteros, determinar si necesita LONG o SIGNED
                    String op1 = i.getOperador1();
                    if (isLong(op1)) {
                        rutinasNecesarias.add("PRINT_SIGNED_LONG");
                    } else {
                        rutinasNecesarias.add("PRINT_SIGNED");
                    }
                }
            } else if (op != null && (op.equals("read") || op.equals("READ"))) {
                // Determinar qué rutina de lectura se necesita
                if (tipo != null && tipo.equals("CHAR")) {
                    rutinasNecesarias.add("READ_CHAR");
                } else if (tipo != null && tipo.equals("BOOL")) {
                    rutinasNecesarias.add("READ_BOOL");
                } else if (tipo != null && tipo.equals("FLOAT")) {
                    rutinasNecesarias.add("READ_FLOAT");
                } else if (tipo != null && tipo.equals("STRING")) {
                    rutinasNecesarias.add("READ_STRING");
                } else {
                    rutinasNecesarias.add("READ_NUM_VALID");
                }
            } else if (op != null && (op.equals("/") || op.equals("%"))) {
                // Detectar operaciones de división y módulo que necesitan manejo de división por cero
                rutinasNecesarias.add("DIV_ZERO_HANDLER");
            } else if (op != null && (op.equals("IND_VAL") || op.equals("IND_ASS"))) {
                // Necesitamos la rutina para manejar indices fuera de rango
                rutinasNecesarias.add("ARRAY_BOUNDS_CHECK");
                // También necesitaremos comprobar accesos a posiciones no inicializadas en lecturas
                if (op.equals("IND_VAL")) {
                    rutinasNecesarias.add("UNINIT_CHECK");
                }
            } else if (op != null && op.equals("ALLOC")) {
                // Necesitamos comprobar en tiempo de ejecución que el tamaño a reservar sea > 0
                rutinasNecesarias.add("ALLOC_SIZE_CHECK");
            }
        }

        // Agregar dependencias necesarias
        Set<String> conDependencias = new HashSet<>(rutinasNecesarias);
        if (rutinasNecesarias.contains("PRINT_SIGNED")) {
            conDependencias.add("PRINT_UNSIGNED");
        }
        if (rutinasNecesarias.contains("PRINT_SIGNED_LONG")) {
            conDependencias.add("PRINT_UNSIGNED_LONG");
        }
        rutinasNecesarias = conDependencias;

        // Debug: mostrar rutinas detectadas
        System.out.println("Rutinas auxiliares detectadas: " + rutinasNecesarias);
    }

    // Rutinas auxiliares para operaciones comunes
    private void agregarRutinasAuxiliares() {
        if (rutinasNecesarias.isEmpty()) {
            return; // No agregar rutinas si no se necesita ninguna
        }

        asm.append("\n; ===== RUTINAS AUXILIARES =====\n");

        // Solo generar las rutinas necesarias
        if (rutinasNecesarias.contains("PRINT_SIGNED")) {
            generarPrintSigned();
        }
        if (rutinasNecesarias.contains("PRINT_SIGNED_LONG")) {
            generarPrintSignedLong();
        }
        if (rutinasNecesarias.contains("PRINT_DECIMAL_2")) {
            generarPrintDecimal2();
        }
        if (rutinasNecesarias.contains("PRINT_BOOL")) {
            generarPrintBool();
        }
        if (rutinasNecesarias.contains("READ_NUM_VALID")) {
            generarReadNumValid();
        }
        if (rutinasNecesarias.contains("READ_CHAR")) {
            generarReadChar();
        }
        if (rutinasNecesarias.contains("READ_STRING")) {
            generarReadString();
        }
        if (rutinasNecesarias.contains("READ_BOOL")) {
            generarReadBool();
            // READ_BOOL necesita STRING_COMPARE
            generarStringCompare();
        }
        if (rutinasNecesarias.contains("READ_FLOAT")) {
            generarReadFloat();
        }
        if (rutinasNecesarias.contains("ARRAY_BOUNDS_CHECK")) {
            asm.append("\nARRAY_INDEX_OUT_OF_BOUNDS:\n");
            asm.append("\t; Indice fuera de rango - mostrar mensaje y detener la simulacion\n");
            asm.append("\tLEA ERROR_INDEX_MSG, A1\n");
            asm.append("\tMOVE.B #14, D0\n");
            asm.append("\tTRAP #15\n");
            asm.append("\tSIMHALT\n");
        }
        if (rutinasNecesarias.contains("UNINIT_CHECK")) {
            asm.append("\nUNINITIALIZED_ACCESS:\n");
            asm.append("\t; Acceso a posicion no inicializada - mostrar mensaje y detener la simulacion\n");
            asm.append("\tLEA ERROR_UNINIT_MSG, A1\n");
            asm.append("\tMOVE.B #14, D0\n");
            asm.append("\tTRAP #15\n");
            asm.append("\tSIMHALT\n");
        }
        if (rutinasNecesarias.contains("ALLOC_SIZE_CHECK")) {
            asm.append("\nALLOC_SIZE_INVALID:\n");
            asm.append("\t; Tamaño de array inválido en tiempo de ejecución - mostrar mensaje y detener\n");
            asm.append("\tLEA ERROR_ALLOC_MSG, A1\n");
            asm.append("\tMOVE.B #14, D0\n");
            asm.append("\tTRAP #15\n");
            asm.append("\tSIMHALT\n");
        }

    }

    private void cabecera() {
        // Inicializar stack pointer en Easy68K
        asm.append("\tORG $1000\n");
        asm.append("START:\n");
        asm.append("\tLEA STACKPTR, A7\n");
    }

    private void traducir(Instruccion i) {
        String op = i.getOpCode();
        String op1 = i.getOperador1();
        String op2 = i.getOperador2();
        String res = i.getResultado();

        // Agregar comentario con la instruccion intermedia
        asm.append("\t; ").append(i.toString()).append("\n");

        // Ignorar instrucciones con operaciones lógicas inválidas en operandos (excepto IF/IF_FALSE, que las gestionan)
        // Pero NO filtrar cadenas de texto que contienen estos caracteres
        if (!op.equals("IF") && !op.equals("IF_FALSE")
                && !op.equals("print") && !op.equals("PRINT")
                && ((op1 != null && !op1.startsWith("\"") && (op1.contains("!=") || op1.contains("==") || op1.contains("<") || op1.contains(">") || op1.contains("&&") || op1.contains("||")))
                || (op2 != null && !op2.startsWith("\"") && (op2.contains("!=") || op2.contains("==") || op2.contains("<") || op2.contains(">") || op2.contains("&&") || op2.contains("||"))))) {
            return;
        }
        String tipos = i.getTipo();
        String tiposOrig = tipos;
        switch (op) {
            case "ALLOC":
                // Obtener puntero libre
                asm.append("\tMOVE.L HEAP_PTR, D0\n");
                // Guardar la dirección asignada en la variable destino
                asm.append("\tMOVE.L D0, ").append(op1).append("\n");

                // Calcular el tamaño a reservar en D1 (32 bits)
                String sizeOp = valor(op2);
                if (sizeOp.startsWith("#")) {
                    asm.append("\tMOVE.L ").append(sizeOp).append(", D1\n");
                } else {
                    asm.append("\tCLR.L D1\n");
                    asm.append("\tMOVE.W ").append(sizeOp).append(", D1\n");
                }

                // Comprobación runtime: tamaño debe ser >= 1
                asm.append("\tCMP.L #1, D1\n");
                asm.append("\tBLT ALLOC_SIZE_INVALID\n");

                // Sumar el tamaño al puntero del heap y actualizar
                if (sizeOp.startsWith("#")) {
                    asm.append("\tADD.L ").append(sizeOp).append(", D0\n");
                } else {
                    asm.append("\tCLR.L D1\n");
                    asm.append("\tMOVE.W ").append(sizeOp).append(", D1\n");
                    asm.append("\tADD.L D1, D0\n");
                }
                asm.append("\tMOVE.L D0, HEAP_PTR\n");
                // Inicializar la memoria recién asignada con un valor centinela para detectar lecturas desde posiciones no inicializadas
                // Determinar tamaño de elemento según el tipo (por defecto 4)
                int nbytesAlloc = 4;
                if (tipos != null) {
                    if (tipos.equals("CHAR") || tipos.equals("BOOL")) {
                        nbytesAlloc = 2;
                    } else if (tipos.equals("INT") || tipos.equals("FLOAT") || tipos.equals("STRING")) {
                        nbytesAlloc = 4;
                    }
                }

                // Usaremos D1 como número total de bytes a inicializar (ya contiene sizeOp)
                // Si no hay bytes, saltar inicialización
                String initLabel = "INIT_" + op1 + "_LOOP";
                String initEnd = initLabel + "_END";
                asm.append("\tTST.L D1\n");
                asm.append("\tBEQ ").append(initEnd).append("\n");

                // Cargar base en A0
                asm.append("\tMOVE.L ").append(op1).append(", A0\n");

                // Usar -1 como centinela (-1 es inmediato válido)
                if (nbytesAlloc == 2) {
                    asm.append(initLabel).append(":\n");
                    asm.append("\tMOVE.W #-1, D4\n");
                    asm.append("\tMOVE.W D4, (A0)+\n");
                    asm.append("\tSUBQ.L #2, D1\n");
                    asm.append("\tBGT ").append(initLabel).append("\n");
                    asm.append(initEnd).append(":\n");
                } else {
                    asm.append(initLabel).append(":\n");
                    asm.append("\tMOVE.L #-1, D4\n");
                    asm.append("\tMOVE.L D4, (A0)+\n");
                    asm.append("\tSUBQ.L #4, D1\n");
                    asm.append("\tBGT ").append(initLabel).append("\n");
                    asm.append(initEnd).append(":\n");
                }
                break;

            case "IND_ASS": // vector[offset] = valor
                asm.append("\tMOVEA.L ").append(res).append(", A0\n"); // Base
                // Cargar offset correctamente (puede ser DS.W)
                String offsetOp = valor(op2);
                if (offsetOp.startsWith("#")) {
                    asm.append("\tMOVE.L ").append(offsetOp).append(", D0\n");
                } else {
                    asm.append("\tCLR.L D0\n");
                    asm.append("\tMOVE.W ").append(offsetOp).append(", D0\n");
                }

                // Comprobación de límites: índice negativo o >= tamaño
                asm.append("\tTST.L D0\n");
                asm.append("\tBMI ARRAY_INDEX_OUT_OF_BOUNDS\n");

                if (tipos != null && tipos.contains(":")) {
                    String[] parts = tipos.split(":");
                    String tipoBase = parts[0];
                    String t_tamanio = parts[1];
                    String nbytes = parts[2];

                    // Si conocemos el tamaño (no -1), generamos la comparación en bytes
                    if (!"-1".equals(t_tamanio)) {
                        if (t_tamanio.matches("-?\\d+")) {
                            try {
                                int tval = Integer.parseInt(t_tamanio);
                                int nval = Integer.parseInt(nbytes);
                                int limitBytes = tval * nval;
                                asm.append("\tCMP.L #").append(limitBytes).append(", D0\n");
                                asm.append("\tBGE ARRAY_INDEX_OUT_OF_BOUNDS\n");
                            } catch (NumberFormatException e) {
                                // fallback: runtime calc
                                asm.append("\tMOVE.W ").append(t_tamanio).append(", D2\n");
                                asm.append("\tEXT.L D2\n");
                                asm.append("\tMOVE.W #").append(nbytes).append(", D3\n");
                                asm.append("\tMULS D3, D2\n");
                                asm.append("\tCMP.L D2, D0\n");
                                asm.append("\tBGE ARRAY_INDEX_OUT_OF_BOUNDS\n");
                            }
                        } else {
                            // runtime cálculo del límite en bytes
                            asm.append("\tMOVE.W ").append(t_tamanio).append(", D2\n");
                            asm.append("\tEXT.L D2\n");
                            asm.append("\tMOVE.W #").append(nbytes).append(", D3\n");
                            asm.append("\tMULS D3, D2\n");
                            asm.append("\tCMP.L D2, D0\n");
                            asm.append("\tBGE ARRAY_INDEX_OUT_OF_BOUNDS\n");
                        }
                    }

                    tipos = tipoBase;
                }

                String valorOp = valor(op1);

                if (tipos != null && (tipos.equals("CHAR") || tipos.equals("BOOL"))) {
                    asm.append("\tMOVE.W ").append(valorOp).append(", D1\n"); // Valor
                    asm.append("\tMOVE.W D1, 0(A0, D0.L)\n");      // Escribir
                } else if ((tipos != null && tipos.equals("STR")) || valorOp.startsWith("str")) {
                    // Para strings, cargar la dirección con LEA
                    asm.append("\tLEA ").append(valorOp).append(", A1\n");
                    asm.append("\tMOVE.L A1, 0(A0, D0.L)\n");      // Escribir dirección
                } else {
                    // Usar MOVE.W para cargar desde variables temporales y extender a LONG
                    if (valorOp.startsWith("#")) {
                        // Es un literal inmediato
                        asm.append("\tMOVE.L ").append(valorOp).append(", D1\n");
                    } else {
                        // Es una variable (probablemente temporal DS.W)
                        asm.append("\tCLR.L D1\n");
                        asm.append("\tMOVE.W ").append(valorOp).append(", D1\n");
                    }
                    asm.append("\tMOVE.L D1, 0(A0, D0.L)\n");      // Escribir
                }
                break;

            case "IND_VAL": // valor = vector[offset]
                asm.append("\tMOVEA.L ").append(op1).append(", A0\n"); // Base

                // Cargar offset correctamente (puede ser DS.W)
                String offsetOp2 = valor(op2);
                if (offsetOp2.startsWith("#")) {
                    asm.append("\tMOVE.L ").append(offsetOp2).append(", D0\n");
                } else {
                    asm.append("\tCLR.L D0\n");
                    asm.append("\tMOVE.W ").append(offsetOp2).append(", D0\n");
                }

                // Comprobación de límites: índice negativo o >= tamaño
                asm.append("\tTST.L D0\n");
                asm.append("\tBMI ARRAY_INDEX_OUT_OF_BOUNDS\n");

                // Bounds checking (extraemos el tamaño y nbytes de tipos si hay)
                if (tiposOrig != null && tiposOrig.contains(":")) {
                    String[] parts = tiposOrig.split(":");
                    String tipoBase = parts[0];
                    String t_tamanio = parts[1];
                    String nbytes = parts[2];

                    // Si conocemos el tamaño (no -1), generamos la comparación en bytes
                    if (!"-1".equals(t_tamanio)) {
                        if (t_tamanio.matches("-?\\d+")) {
                            try {
                                int tval = Integer.parseInt(t_tamanio);
                                int nval = Integer.parseInt(nbytes);
                                int limitBytes = tval * nval;
                                asm.append("\tCMP.L #").append(limitBytes).append(", D0\n");
                                asm.append("\tBGE ARRAY_INDEX_OUT_OF_BOUNDS\n");
                            } catch (NumberFormatException e) {
                                asm.append("\tMOVE.W ").append(t_tamanio).append(", D2\n");
                                asm.append("\tEXT.L D2\n");
                                asm.append("\tMOVE.W #").append(nbytes).append(", D3\n");
                                asm.append("\tMULS D3, D2\n");
                                asm.append("\tCMP.L D2, D0\n");
                                asm.append("\tBGE ARRAY_INDEX_OUT_OF_BOUNDS\n");
                            }
                        } else {
                            // runtime cálculo del límite en bytes
                            asm.append("\tMOVE.W ").append(t_tamanio).append(", D2\n");
                            asm.append("\tEXT.L D2\n");
                            asm.append("\tMOVE.W #").append(nbytes).append(", D3\n");
                            asm.append("\tMULS D3, D2\n");
                            asm.append("\tCMP.L D2, D0\n");
                            asm.append("\tBGE ARRAY_INDEX_OUT_OF_BOUNDS\n");
                        }
                    }

                    tipos = tipoBase;
                }

                if (tipos != null && (tipos.equals("CHAR") || tipos.equals("BOOL"))) {
                    asm.append("\tMOVE.W 0(A0, D0.L), D1\n");      // Leer
                    asm.append("\tEXT.L D1\n");
                    // Comprobación de acceso a posición no inicializada (centinela = -1)
                    if (tiposOrig != null && tiposOrig.contains(":")) {
                        asm.append("\tCMP.W #-1, D1\n");
                        asm.append("\tBEQ UNINITIALIZED_ACCESS\n");
                    }
                } else {
                    asm.append("\tMOVE.L 0(A0, D0.L), D1\n");      // Leer    
                    // Comprobación de acceso a posición no inicializada (centinela = -1)
                    if (tiposOrig != null && tiposOrig.contains(":")) {
                        asm.append("\tCMP.L #-1, D1\n");
                        asm.append("\tBEQ UNINITIALIZED_ACCESS\n");
                    }
                }
                // Guardar: usar MOVE.L para strings y arrays, MOVE.W para enteros normales, y MOVE.B si el tipo base es CHAR/BOOL (lectura de arrays de bytes)
                boolean isStringArray = stringArrays.contains(op1);
                if (tipos != null && (tipos.equals("CHAR") || tipos.equals("BOOL"))) {
                    asm.append("\tMOVE.B D1, ").append(res).append("\n");
                } else if (isLong(res) || isArrayVar(res) || isStringVar(res) || isStringArray) {
                    asm.append("\tMOVE.L D1, ").append(res).append("\n");
                } else {
                    asm.append("\tMOVE.W D1, ").append(res).append("\n");
                }
                break;

            case "param_s":
                // añadir parámetros (value) a la lista pendiente para ser usado por la siguiente llamada
                parametrosPendientesAdd(i.getOperador1());
                break;

            case "param_dim":
                // Guardar las dimensiones del array que se está pasando como parámetro para que la función llamada pueda calcular offsets correctamente
                String nombreArray = i.getOperador1();
                // Buscamos las dimensiones del array
                List<Integer> dims = extraerDimensionesArray(nombreArray);
                if (dims != null && !dims.isEmpty()) {
                    dimensionesArray.put(nombreArray, dims);
                }

                break;

            case "=":
                String dest = res != null ? res : op1;
                String src = res != null ? op1 : op2;
                if (src == null || dest == null) {
                } else {
                    if (src.startsWith("call ")) {
                        String func = src.split(" ", 2)[1];

                        // Para mapear parámetros de funciones
                        if (!parametrosPendientes.isEmpty()) {
                            List<String> nombreParametros = getNombreParametros(func, parametrosPendientes.size());
                            for (int pi = 0; pi < parametrosPendientes.size(); pi++) {
                                String val = parametrosPendientes.get(pi);

                                String nombreParametro = (pi < nombreParametros.size()) ? nombreParametros.get(pi) : null;

                                // Normalizar y obtener nombre seguro para el parámetro
                                String pname = asegurarYNormalizarParametro(nombreParametro, func, pi);

                                String instr = moveSize(pname);
                                asm.append("\t").append(instr).append(" ").append(valor(val)).append(", ").append(pname).append("\n");

                                if (dimensionesArray.containsKey(val)) {
                                    dimensionesArray.put(pname, dimensionesArray.get(val));
                                }
                            }
                            parametrosPendientes.clear();
                        }

                        // Llamada a la función
                        asm.append("\tJSR ").append(func).append("\n");

                        asm.append("\t").append(moveSize(dest)).append(" D0, ").append(dest).append("\n");
                    } else if (src.startsWith("\"") && src.endsWith("\"")) {
                        String lbl = literalToLabel.get(src);
                        if (lbl == null) {
                            lbl = src;
                        }
                        // Para strings, usar LEA para cargar la dirección
                        if (isStringVar(dest)) {
                            asm.append("\tLEA ").append(lbl).append(", A0\n");
                            asm.append("\tMOVE.L A0, ").append(dest).append("\n");
                        } else {
                            asm.append("\t").append(moveSize(dest)).append(" ").append(lbl).append(", ").append(dest).append("\n");
                        }
                    } else {
                        // Si estamos copiando una variable string a otra
                        if (isStringVar(dest) && isStringVar(src)) {
                            asm.append("\tMOVE.L ").append(src).append(", ").append(dest).append("\n");
                        } else {
                            asm.append("\t").append(moveSize(dest))
                                    .append(" ")
                                    .append(valor(src))
                                    .append(", ")
                                    .append(dest)
                                    .append("\n");
                        }
                    }
                }
                break;
            // Operaciones binarias
            case "+":
                if (isFloat(op1) || isFloat(op2)) {
                    // Los operandos se tratan como valores ya escalados x100 (variables o literales)
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tADD.W ").append(valor(op2)).append(", D0\n");
                    asm.append("\tMOVE.W D0, ").append(res).append("\n");
                } else {
                    asm.append("\tMOVE.W ")
                            .append(valor(op1))
                            .append(", D0\n");
                    asm.append("\tADD.W ")
                            .append(valor(op2))
                            .append(", D0\n");
                    asm.append("\tMOVE.W D0, ")
                            .append(res)
                            .append("\n");
                }
                break;

            case "-":
                if (isFloat(op1) || isFloat(op2)) {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tSUB.W ").append(valor(op2)).append(", D0\n");
                    asm.append("\tMOVE.W D0, ").append(res).append("\n");
                } else {
                    asm.append("\tMOVE.W ")
                            .append(valor(op1))
                            .append(", D0\n");
                    asm.append("\tSUB.W ")
                            .append(valor(op2))
                            .append(", D0\n");
                    asm.append("\tMOVE.W D0, ")
                            .append(res)
                            .append("\n");
                }
                break;

            case "*":
                if (isFloat(op1) || isFloat(op2)) {
                    // Multiplicación float (tratamos operandos escalados x100).
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");

                    if (!isFloat(op1)) {
                        asm.append("\tMOVE.W #100, D2\n");
                        asm.append("\tMULS D2, D0\n");
                    }
                    asm.append("\tMOVE.W ").append(valor(op2)).append(", D1\n");

                    if (!isFloat(op2)) {
                        asm.append("\tMOVE.W #100, D2\n");
                        asm.append("\tMULS D2, D1\n");
                    }

                    asm.append("\tMULS D1, D0\n");

                    asm.append("\tMOVE.W #100, D2\n");
                    asm.append("\tDIVS D2, D0\n");

                    asm.append("\tMOVE.W D0, ").append(res).append("\n");
                } else {
                    // Multiplicación entera normal
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tMULS ").append(valor(op2)).append(", D0\n");
                    asm.append("\tMOVE.W D0, ").append(res).append("\n");
                }
                break;

            case "/":
                if (isFloat(op1) || isFloat(op2)) {
                    // División float (tratamos operandos escalados x100).
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    if (!isFloat(op1)) {
                        asm.append("\tMOVE.W #100, D2\n");
                        asm.append("\tMULS D2, D0\n");
                    }

                    asm.append("\tMOVE.W ").append(valor(op2)).append(", D1\n");
                    if (!isFloat(op2)) {
                        asm.append("\tMOVE.W #100, D2\n");
                        asm.append("\tMULS D2, D1\n");
                    }

                    asm.append("\tTST.W D1\n");
                    asm.append("\tBEQ DIV_ZERO_ERROR\n");

                    asm.append("\tMOVE.W #100, D2\n");
                    asm.append("\tMULS D2, D0\n");

                    asm.append("\tDIVS D1, D0\n");

                    asm.append("\tMOVE.W D0, ").append(res).append("\n");
                } else {
                    // División entera normal
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tTST.W ").append(valor(op2)).append("\n");
                    asm.append("\tBEQ DIV_ZERO_ERROR\n");
                    asm.append("\tDIVS ").append(valor(op2)).append(", D0\n");
                    asm.append("\tMOVE.W D0, ").append(res).append("\n");
                }
                break;
            case "%":
                if (isFloat(op1) || isFloat(op2)) {
                    // Módulo float (tratamos operandos escalados x100).
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    if (!isFloat(op1)) {
                        asm.append("\tMOVE.W #100, D4\n");
                        asm.append("\tMULS D4, D0\n");
                    }

                    asm.append("\tMOVE.W ").append(valor(op2)).append(", D1\n");
                    if (!isFloat(op2)) {
                        asm.append("\tMOVE.W #100, D4\n");
                        asm.append("\tMULS D4, D1\n");
                    }

                    asm.append("\tTST.W D1\n");
                    asm.append("\tBEQ DIV_ZERO_ERROR\n");

                    asm.append("\tEXT.L D0\n");              // Extender signo antes de copiar
                    asm.append("\tMOVE.L D0, D2\n");

                    asm.append("\tDIVS D1, D0\n");

                    asm.append("\tCLR.L D3\n");
                    asm.append("\tMOVE.W D0, D3\n");
                    asm.append("\tMULS D1, D3\n");

                    asm.append("\tSUB.L D3, D2\n");

                    asm.append("\tMOVE.W D2, ").append(res).append("\n");
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tMOVE.W ").append(valor(op2)).append(", D1\n");
                    asm.append("\tTST.W D1\n");
                    asm.append("\tBEQ DIV_ZERO_ERROR\n");
                    asm.append("\tEXT.L D0\n");
                    asm.append("\tMOVE.L D0, D2\n");
                    asm.append("\tDIVS D1, D0\n");
                    asm.append("\tCLR.L D3\n");
                    asm.append("\tMOVE.W D0, D3\n");
                    asm.append("\tMULS D1, D3\n");
                    asm.append("\tSUB.L D3, D2\n");
                    asm.append("\tMOVE.W D2, ").append(res).append("\n");
                }
                break;

            // Operaciones unarias
            case "NEG":
                asm.append("\tMOVE.W ")
                        .append(valor(op1))
                        .append(", D0\n");
                asm.append("\tNEG.W D0\n");
                asm.append("\tMOVE.W D0, ")
                        .append(res)
                        .append("\n");
                break;

            case "!":
            case "NOT":
                asm.append("\tMOVE.W ")
                        .append(valor(op1))
                        .append(", D0\n");
                asm.append("\tCMP.W #0, D0\n");
                asm.append("\tBEQ ").append(res).append("_not_true\n");
                // Si op1 != 0 (true), NOT debería dar 0 (false)
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                asm.append("\tJMP ").append(res).append("_not_end\n");
                // Si op1 == 0 (false), NOT debería dar 1 (true)
                asm.append(res).append("_not_true:\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_not_end:\n");
                break;

            case "INCR":
            case "INCR++":
                asm.append("\tMOVE.W ")
                        .append(valor(op1))
                        .append(", D0\n");
                asm.append("\tADD.W #1, D0\n");
                asm.append("\tMOVE.W D0, ")
                        .append(op1)
                        .append("\n");
                break;

            case "DECR":
            case "DECR--":
                asm.append("\tMOVE.W ")
                        .append(valor(op1))
                        .append(", D0\n");
                asm.append("\tSUB.W #1, D0\n");
                asm.append("\tMOVE.W D0, ")
                        .append(op1)
                        .append("\n");
                break;

            // Operadores comparativos generan 1 (true) o 0 (false)
            case "<":
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                if (isLong(op1) || isLong(op2)) {
                    asm.append("\tMOVE.L ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.L ").append(valor(op2)).append(", D0\n");
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.W ").append(valor(op2)).append(", D0\n");
                }
                asm.append("\tBLT ").append(res).append("_true\n");
                asm.append("\tJMP ").append(res).append("_false\n");
                asm.append(res).append("_true:\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_false:\n");
                break;

            case ">":
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                if (isLong(op1) || isLong(op2)) {
                    asm.append("\tMOVE.L ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.L ").append(valor(op2)).append(", D0\n");
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.W ").append(valor(op2)).append(", D0\n");
                }
                asm.append("\tBGT ").append(res).append("_true\n");
                asm.append("\tJMP ").append(res).append("_false\n");
                asm.append(res).append("_true:\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_false:\n");
                break;

            case "==":
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                // Usar operaciones de 32 bits si es string o long
                if (isStringVar(op1) || isStringVar(op2) || isLong(op1) || isLong(op2)) {
                    asm.append("\tMOVE.L ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.L ").append(valor(op2)).append(", D0\n");
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.W ").append(valor(op2)).append(", D0\n");
                }
                asm.append("\tBEQ ").append(res).append("_true\n");
                asm.append("\tJMP ").append(res).append("_false\n");
                asm.append(res).append("_true:\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_false:\n");
                break;

            case "!=":
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                // Usar operaciones de 32 bits si es string o long
                if (isStringVar(op1) || isStringVar(op2) || isLong(op1) || isLong(op2)) {
                    asm.append("\tMOVE.L ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.L ").append(valor(op2)).append(", D0\n");
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.W ").append(valor(op2)).append(", D0\n");
                }
                asm.append("\tBNE ").append(res).append("_true\n");
                asm.append("\tJMP ").append(res).append("_false\n");
                asm.append(res).append("_true:\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_false:\n");
                break;

            case "<=":
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                if (isLong(op1) || isLong(op2)) {
                    asm.append("\tMOVE.L ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.L ").append(valor(op2)).append(", D0\n");
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.W ").append(valor(op2)).append(", D0\n");
                }
                asm.append("\tBLE ").append(res).append("_true\n");
                asm.append("\tJMP ").append(res).append("_false\n");
                asm.append(res).append("_true:\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_false:\n");
                break;

            case ">=":
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                if (isLong(op1) || isLong(op2)) {
                    asm.append("\tMOVE.L ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.L ").append(valor(op2)).append(", D0\n");
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.W ").append(valor(op2)).append(", D0\n");
                }
                asm.append("\tBGE ").append(res).append("_true\n");
                asm.append("\tJMP ").append(res).append("_false\n");
                asm.append(res).append("_true:\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_false:\n");
                break;

            // Operadores lógicos AND y OR
            case "&&":
                // AND lógico: res = op1 && op2
                // Si op1 es 0, el resultado es 0 (false)
                // Si op1 != 0, el resultado es op2 != 0 ? 1 : 0
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                asm.append("\tCMP.W #0, D0\n");
                asm.append("\tBEQ ").append(res).append("_false\n");
                asm.append("\tMOVE.W ").append(valor(op2)).append(", D0\n");
                asm.append("\tCMP.W #0, D0\n");
                asm.append("\tBEQ ").append(res).append("_false\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_false:\n");
                break;

            case "||":
                // OR lógico: res = op1 || op2
                // Si op1 != 0, el resultado es 1 (true)
                // Si op1 es 0, el resultado es op2 != 0 ? 1 : 0
                asm.append("\tMOVE.W #0, ").append(res).append("\n");
                asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                asm.append("\tCMP.W #0, D0\n");
                asm.append("\tBNE ").append(res).append("_true\n");
                asm.append("\tMOVE.W ").append(valor(op2)).append(", D0\n");
                asm.append("\tCMP.W #0, D0\n");
                asm.append("\tBNE ").append(res).append("_true\n");
                asm.append("\tJMP ").append(res).append("_false\n");
                asm.append(res).append("_true:\n");
                asm.append("\tMOVE.W #1, ").append(res).append("\n");
                asm.append(res).append("_false:\n");
                break;

            case "if<":
            case "if>":
            case "if==":
                asm.append("\tCMP.W ")
                        .append(valor(op2))
                        .append(", ")
                        .append(valor(op1))
                        .append("\n");
                if (op.equals("if<")) {
                    asm.append("\tBLT ").append(res).append("\n");
                } else if (op.equals("if>")) {
                    asm.append("\tBGT ").append(res).append("\n");
                } else {
                    asm.append("\tBEQ ").append(res).append("\n");
                }
                break;

            case "IF":
                // IF: if operand1 != 0 goto res
                // Comprobar si el operando contiene operaciones lógicas (ej: "t1 != t2")
                if (op1 != null && (op1.contains("!=") || op1.contains("==") || op1.contains("<") || op1.contains(">"))) {
                    // Extraer operandos de la expresión lógica
                    procesarComparacionEnIF(op1, res != null ? res : op2, false);
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.W #0, D0\n");
                    asm.append("\tBNE ").append(res != null ? res : op2).append("\n");
                }
                break;

            case "IF_FALSE":
                // IF_FALSE: if operand1 == 0 goto res
                // Comprobar si el operando contiene operaciones lógicas
                if (op1 != null && (op1.contains("!=") || op1.contains("==") || op1.contains("<") || op1.contains(">"))) {
                    // Extraer operandos de la expresión lógica
                    procesarComparacionEnIF(op1, res != null ? res : op2, true);
                } else {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                    asm.append("\tCMP.W #0, D0\n");
                    asm.append("\tBEQ ").append(res != null ? res : op2).append("\n");
                }
                break;

            case "call":
                // Llamada a función void (sin asignación de retorno)
                String func = op1;
                // Si hay parámetros pendientes, mapearlos a los nombres de parámetros
                if (!parametrosPendientes.isEmpty()) {
                    List<String> nombreParametros = getNombreParametros(func, parametrosPendientes.size());
                    for (int pi = 0; pi < parametrosPendientes.size(); pi++) {
                        String val = parametrosPendientes.get(pi);
                        String pname = (pi < nombreParametros.size()) ? nombreParametros.get(pi) : null;
                        if (pname != null) {
                            // Usar MOVE.L si es un array, MOVE.W para valores simples
                            String moveInstr = (isArrayVar(val) || isArrayVar(pname)) ? "MOVE.L" : "MOVE.W";
                            asm.append("\t").append(moveInstr).append(" ").append(valor(val)).append(", ").append(pname).append("\n");
                        }
                    }
                    parametrosPendientes.clear();
                }
                asm.append("\tJSR ").append(func).append("\n");
                break;

            case "goto":
            case "GOTO":
                String tgt = res != null ? res : op1;
                asm.append("\tJMP ").append(tgt).append("\n");
                break;

            case "label":
            case "LABEL":
                String lbl = res != null ? res : op1;
                asm.append(lbl).append(":" + "\n");
                break;

            case "PARAM_TYPE":
                // Instrucción informativa, no genera código
                break;

            case "print":
            case "PRINT":
                // Distinguir entre números y strings
                String tipo = i.getTipo(); // "INT", "STRING", etc.
                if (tipo != null && tipo.equals("STRING")) {
                    // Si es String, cargamos la dirección en A1 usando LEA
                    String stringLabel = op1;
                    // Si op1 es un literal entre comillas, convertir a etiqueta
                    if (op1.startsWith("\"") && op1.endsWith("\"")) {
                        // Detectar si es "\n" para convertirlo en salto de línea
                        String contenido = op1.substring(1, op1.length() - 1);
                        // Comparar con backslash-n (dos caracteres: \ y n)
                        if (contenido.length() == 2 && contenido.charAt(0) == '\\' && contenido.charAt(1) == 'n') {
                            // Imprimir salto de línea
                            asm.append("\tLEA NEWLINE, A1\n");
                            asm.append("\tMOVE.B #14, D0\n");
                            asm.append("\tTRAP #15\n");
                            break;
                        }
                        stringLabel = literalToLabel.get(op1);
                        if (stringLabel == null) {
                            stringLabel = op1; // Fallback si no se encuentra
                        }
                        asm.append("\tLEA ")
                                .append(stringLabel)
                                .append(", A1\n");
                    } else if (isStringVar(op1)) {
                        // Si es una variable string, cargar la dirección desde la variable
                        /*asm.append("\tMOVEA.L ")
                                .append(op1)
                                .append(", A1\n"); */
                        asm.append("\tLEA ").append(op1).append(", A1\n");
                    } else {
                        asm.append("\tLEA ")
                                .append(stringLabel)
                                .append(", A1\n");
                    }
                    asm.append("\tMOVE.B #14, D0\n");
                    asm.append("\tTRAP #15\n");
                } else if (tipo != null && tipo.equals("BOOL")) {
                    // Para BOOL, imprimimos "cierto" o "mentira"
                    asm.append("\tMOVE.W ")
                            .append(valor(op1))
                            .append(", D1\n");
                    asm.append("\tJSR PRINT_BOOL\n");
                } else if ((tipo != null && tipo.equals("CHAR")) || isChar(op1)) {
                    // Para CHAR, usamos Task 6
                    asm.append("\tMOVE.B ")
                            .append(valor(op1))
                            .append(", D1\n");
                    asm.append("\tMOVE.B #6, D0\n");
                    asm.append("\tTRAP #15\n");
                } else {
                    // Para números, si es FLOAT, usamos PRINT_DECIMAL_2 (están escalados x100),
                    // si es INT de 32 bits, usamos PRINT_SIGNED_LONG, y si es INT de 16 bits, usamos PRINT_SIGNED
                    if ((tipo != null && tipo.equals("FLOAT")) || isFloat(op1)) {
                        // Mover el valor escalado (32-bit) a D1
                        asm.append("\tCLR.L D1\n");
                        // Si es inmediato (#nnn) move.l #nnn, D1. Si es variable, move.w var, D1 + sign/zero-extend
                        if (valor(op1).startsWith("#")) {
                            asm.append("\tMOVE.L ").append(valor(op1)).append(", D1\n");
                        } else {
                            // cargar palabra y extender a long
                            asm.append("\tMOVE.W ").append(valor(op1)).append(", D1\n");
                            asm.append("\tEXT.L D1\n");
                        }
                        asm.append("\tJSR PRINT_DECIMAL_2\n");
                    } else if (isLong(op1)) {
                        // Número de 32 bits
                        if (valor(op1).startsWith("#")) {
                            asm.append("\tMOVE.L ").append(valor(op1)).append(", D1\n");
                        } else {
                            asm.append("\tMOVE.L ").append(valor(op1)).append(", D1\n");
                        }
                        asm.append("\tJSR PRINT_SIGNED_LONG\n");
                    } else {
                        // Número de 16 bits
                        asm.append("\tMOVE.W ")
                                .append(valor(op1))
                                .append(", D1\n");
                        asm.append("\tJSR PRINT_SIGNED\n");
                    }
                }
                break;
            case "READ":
            case "read":
                // Verificar el tipo de dato a leer
                if (i.getTipo() != null && i.getTipo().equals("CHAR")) {
                    // Leer carácter
                    asm.append("\tJSR READ_CHAR\n");
                    asm.append("\tMOVE.B D1, ").append(op1).append("\n");
                } else if (i.getTipo() != null && i.getTipo().equals("BOOL")) {
                    // Leer booleano
                    asm.append("\tJSR READ_BOOL\n");
                    asm.append("\tMOVE.W D1, ").append(op1).append("\n");
                } else if (i.getTipo() != null && i.getTipo().equals("FLOAT")) {
                    // Leer decimal
                    asm.append("\tJSR READ_FLOAT\n");
                    asm.append("\tMOVE.W D1, ").append(op1).append("\n");
                } else if (i.getTipo() != null && i.getTipo().equals("STRING")) {
                    // Leer String
                    asm.append("\tLEA ").append(op1).append(", A1\n");
                    asm.append("\tMOVE.W #80, D1\n");
                    asm.append("\tJSR READ_STRING\n");
                } else {
                    // Leer número con validación de entrada (por defecto)
                    asm.append("\tJSR READ_NUM_VALID\n");
                    asm.append("\tMOVE.W D1, ").append(op1).append("\n");
                }
                break;
            case "RETURN":
            case "return":
                // Poner el valor de retorno en D0 y regresar de la subrutina
                if (op1 != null) {
                    asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
                }
                asm.append("\tRTS\n");
                break;

        }
    }

    private String valor(String op) {
        if (op == null) {
            return "null";
        }

        // Gestionar las marcas DIM_nombreArray_posicion para arrays multidimensionales como parámetros
        if (op.startsWith("DIM_")) {
            String[] parts = op.split("_");
            if (parts.length >= 3) {
                String nombreArray = parts[1];
                // Validar si la tercera parte es un número válido
                if (esNumeroEntero(parts[2])) {
                    int dimIndex = Integer.parseInt(parts[2]);
                    List<Integer> dims = dimensionesArray.get(nombreArray);
                    if (dims != null && dimIndex > 0 && dimIndex <= dims.size()) {
                        return "#" + dims.get(dimIndex - 1); // Devolver la dimensión como literal
                    }

                    // Si no encontramos dimensiones para este array específico, intentar inferirlas de los accesos en el código
                    dims = inferirDimensionesDesdeAccesos(nombreArray);
                    if (dims != null && dims.size() >= dimIndex) {
                        dimensionesArray.put(nombreArray, dims); // Cachear para futuros accesos
                        return "#" + dims.get(dimIndex - 1);
                    }
                }
            }
            return "#3"; // Si no se ha encontrado la dimensión, devolvemos un valor por defecto
        }

        if (op.equals("true")) {
            return "#1";
        }
        if (op.equals("false")) {
            return "#0";
        }
        if (op.matches("-?\\d+")) {
            return "#" + op;
        }

        // FLOAT (redondeo a 2 decimales y escalado x100)
        if (op.matches("-?\\d+\\.\\d+")) {
            double d = Double.parseDouble(op);
            int escalado = (int) Math.round(d * 100.0);
            return "#" + escalado;
        }

        if (op.startsWith("\"") && literalToLabel.containsKey(op)) {
            return literalToLabel.get(op);
        }
        return op;
    }

    // Detecta literales float de la forma 123.45
    private boolean isFloatLiteral(String s) {
        if (s == null) {
            return false;
        }
        return s.matches("-?\\d+\\.\\d+");
    }

    private boolean isFloat(String s) {
        if (s == null) {
            return false;
        }
        if (isFloatLiteral(s)) {
            return true;
        }
        return floatVariables.contains(s);
    }

    private boolean isChar(String s) {
        if (s == null) {
            return false;
        }
        return charVariables.contains(s);
    }

    // Recolecta variables y literales de cadena del código intermedio 
    private void recolectarVariables() {
        Set<String> labels = new HashSet<>();
        for (Instruccion i : codigo) {
            String opc = i.getOpCode();
            if (opc == null) {
                continue;
            }
            if (opc.equalsIgnoreCase("LABEL")) {
                String lbl = i.getResultado() != null ? i.getResultado() : i.getOperador1();
                if (lbl != null) {
                    labels.add(lbl);
                }
            }
        }

        for (Instruccion i : codigo) {
            agregarCondicional(i.getOperador1(), labels);
            agregarCondicional(i.getOperador2(), labels);
            agregarCondicional(i.getResultado(), labels);
        }
    }

    // Determina qué variables son de tipo float (decimal) analizando instrucciones.
    private void detectarVariablesChar() {
        // Primero marcamos las variables usadas en instrucciones PRINT con tipo CHAR
        for (Instruccion ins : codigo) {
            String tipo = ins.getTipo();
            if ("CHAR".equalsIgnoreCase(tipo) && "PRINT".equalsIgnoreCase(ins.getOpCode())) {
                String var = ins.getOperador1();
                // No marcamos literales numéricos ni strings
                if (var != null && !var.startsWith("#") && !var.startsWith("\"") && !var.matches("\\d+")) {
                    charVariables.add(var);
                }
            }
            // También detectar chars leídos con READ
            if ("CHAR".equalsIgnoreCase(tipo) && ("READ".equalsIgnoreCase(ins.getOpCode()) || "read".equalsIgnoreCase(ins.getOpCode()))) {
                String var = ins.getOperador1();
                if (var != null && !var.startsWith("#") && !var.startsWith("\"") && !var.matches("\\d+")) {
                    charVariables.add(var);
                }
            }
        }

        // Después hay que propagar hacia atrás en las asignaciones
        // Si t2 = x y t2 es CHAR, entonces x también es CHAR
        boolean changed = true;
        while (changed) {
            changed = false;
            for (Instruccion ins : codigo) {
                if ("=".equals(ins.getOpCode())) {
                    String dest = ins.getOperador1();  // variable destino
                    String src = ins.getOperador2();   // variable fuente

                    // Si el destino es CHAR, la fuente también lo es
                    // No marcar literales numéricos
                    if (dest != null && src != null && !src.startsWith("#") && !src.startsWith("\"") && !src.matches("\\d+")) {
                        if (charVariables.contains(dest) && !charVariables.contains(src)) {
                            charVariables.add(src);
                            changed = true;
                        }
                        // Si la fuente es CHAR, el destino también lo es
                        if (charVariables.contains(src) && !charVariables.contains(dest) && !dest.matches("\\d+")) {
                            charVariables.add(dest);
                            changed = true;
                        }
                    }
                }
            }
        }
    }

    private void detectarVariablesFloat() {
        boolean changed = true;
        // Marcamos las variables asignadas directamente desde literales float
        for (Instruccion ins : codigo) {
            if ("=".equals(ins.getOpCode())) {
                String dest = ins.getOperador1();
                String src = ins.getOperador2();
                if (dest != null && src != null) {
                    if (isFloatLiteral(src) || "FLOAT".equalsIgnoreCase(ins.getTipo())) {
                        floatVariables.add(dest);
                    }
                }
            }
            // Detectamos parámetros de tipo FLOAT mediante PARAM_TYPE
            if ("PARAM_TYPE".equals(ins.getOpCode()) && "FLOAT".equalsIgnoreCase(ins.getTipo())) {
                String paramName = ins.getOperador1();
                if (paramName != null) {
                    floatVariables.add(paramName);
                }
            }
        }

        // Detectamos parámetros de función que se reciben desde llamadas con literales float
        for (int idx = 0; idx < codigo.size(); idx++) {
            Instruccion ins = codigo.get(idx);
            if (ins == null) {
                continue;
            }
            if ("=".equals(ins.getOpCode())) {
                String src = ins.getOperador2();
                if (src != null && src.startsWith("call ")) {
                    String func = src.split(" ", 2)[1];
                    // recopilamos los param_s inmediatamente anteriores
                    List<String> callParams = new ArrayList<>();
                    for (int j = idx - 1; j >= 0; j--) {
                        Instruccion prev = codigo.get(j);
                        if (prev == null || prev.getOpCode() == null) {
                            break;
                        }
                        if ("param_s".equals(prev.getOpCode())) {
                            callParams.add(0, prev.getOperador1());
                        } else {
                            break;
                        }
                    }
                    if (!callParams.isEmpty()) {
                        List<String> nombreParametros = getNombreParametros(func, callParams.size());
                        for (int k = 0; k < callParams.size() && k < nombreParametros.size(); k++) {
                            String val = callParams.get(k);
                            String pname = nombreParametros.get(k);
                            if (pname == null) {
                                continue;
                            }
                            if (isFloatLiteral(val) || floatVariables.contains(val)) {
                                floatVariables.add(pname);
                            }
                        }
                    }
                }
            }
        }

        // Propagamos (si una variable se asigna desde una operación que contiene floats, la marcamos)
        while (changed) {
            changed = false;
            for (Instruccion ins : codigo) {
                String op = ins.getOpCode();
                if (op == null) {
                    continue;
                }
                if ("+".equals(op) || "-".equals(op) || "*".equals(op) || "/".equals(op)) {
                    String a = ins.getOperador1();
                    String b = ins.getOperador2();
                    String dest = ins.getResultado();
                    if (dest == null) {
                        continue;
                    }
                    boolean fa = (a != null) && (isFloatLiteral(a) || floatVariables.contains(a));
                    boolean fb = (b != null) && (isFloatLiteral(b) || floatVariables.contains(b));
                    if ((fa || fb) && !floatVariables.contains(dest)) {
                        floatVariables.add(dest);
                        changed = true;
                    }
                }
                // Asignación directa desde variable float
                if ("=".equals(op)) {
                    String dest = ins.getOperador1();
                    String src = ins.getOperador2();
                    if (dest != null && src != null && floatVariables.contains(src) && !floatVariables.contains(dest)) {
                        floatVariables.add(dest);
                        changed = true;
                    }
                }
            }
        }
    }

    // Detectar variables que necesitan 32 bits (números fuera del rango de 16 bits)
    private void detectarVariablesLong() {
        // Marcar variables asignadas desde literales grandes
        for (Instruccion ins : codigo) {
            if ("=".equals(ins.getOpCode())) {
                String dest = ins.getOperador1();
                String src = ins.getOperador2();
                if (dest != null && src != null) {
                    // No marcar como long si ya es float
                    if (isLongLiteral(src) && !floatVariables.contains(dest)) {
                        longVariables.add(dest);
                    }
                }
            }
        }

        // Propagar: si una variable long se asigna a otra, la segunda también es long
        boolean changed = true;
        while (changed) {
            changed = false;
            for (Instruccion ins : codigo) {
                if ("=".equals(ins.getOpCode())) {
                    String dest = ins.getOperador1();
                    String src = ins.getOperador2();
                    // No propagar long a variables float
                    if (dest != null && src != null && longVariables.contains(src)
                            && !floatVariables.contains(dest)) {
                        if (!longVariables.contains(dest)) {
                            longVariables.add(dest);
                            changed = true;
                        }
                    }
                }
            }
        }
    }

    // Determinar si un literal es un número que necesita 32 bits
    private boolean isLongLiteral(String s) {
        if (s == null) {
            return false;
        }
        // Validar si es un número entero válido antes de parsearlo
        if (!esNumeroEntero(s)) {
            return false;
        }
        int val = Integer.parseInt(s);
        return val < -32768 || val > 32767;
    }

    // Determinar si una variable necesita 32 bits
    private boolean isLong(String var) {
        if (var == null) {
            return false;
        }
        if (isLongLiteral(var)) {
            return true;
        }
        return longVariables.contains(var);
    }

    // Detectar variables de tipo STRING (frases)
    private void detectarVariablesString() {
        for (Instruccion ins : codigo) {
            if ("=".equals(ins.getOpCode())) {
                String dest = ins.getOperador1();
                String src = ins.getOperador2();
                String tipo = ins.getTipo();
                // Si el tipo es STRING o la fuente es un literal string
                if ((tipo != null && tipo.equals("STRING"))
                        || (src != null && src.startsWith("\"") && src.endsWith("\""))) {
                    if (dest != null) {
                        stringVariables.add(dest);
                    }
                }
            } else if (("read".equalsIgnoreCase(ins.getOpCode()) || "READ".equalsIgnoreCase(ins.getOpCode()))) {
                // Solo si el tipo de la instrucción READ es STRING
                if ("STRING".equals(ins.getTipo())) {
                    String var = ins.getOperador1();
                    if (var != null) {
                        stringVariables.add(var);
                    }
                }
            } else if ("IND_ASS".equals(ins.getOpCode())) {
                // Si es asignación a array con un literal string
                String value = ins.getOperador1();
                if (value != null && value.startsWith("\"") && value.endsWith("\"")) {
                    // El array contiene strings
                    String arrayVar = ins.getResultado();
                    if (arrayVar != null) {
                        stringArrays.add(arrayVar);
                    }
                }
            } else if ("IND_VAL".equals(ins.getOpCode())) {
                // Si es lectura de un array de strings
                String arrayVar = ins.getOperador1();
                String dest = ins.getResultado();
                if (dest != null && arrayVar != null && stringArrays.contains(arrayVar)) {
                    stringVariables.add(dest);
                }
            }
        }

        // Propagar (si una variable string se asigna a otra)
        boolean changed = true;
        while (changed) {
            changed = false;
            for (Instruccion ins : codigo) {
                if ("=".equals(ins.getOpCode())) {
                    String dest = ins.getOperador1();
                    String src = ins.getOperador2();
                    if (dest != null && src != null && stringVariables.contains(src)) {
                        if (!stringVariables.contains(dest)) {
                            stringVariables.add(dest);
                            changed = true;
                        }
                    }
                }
            }
        }
    }

    private boolean isStringVar(String var) {
        return var != null && stringVariables.contains(var);
    }

    // Detectar variables de tipo ARRAY (punteros que necesitan 32 bits)
    private void detectarVariablesArray() {
        for (Instruccion ins : codigo) {
            if ("ALLOC".equals(ins.getOpCode())) {
                String dest = ins.getOperador1();
                if (dest != null) {
                    arrayVariables.add(dest);
                }
            }
            // Detectar parámetros de tipo ARRAY mediante PARAM_TYPE
            if ("PARAM_TYPE".equals(ins.getOpCode())) {
                String tipo = ins.getTipo();
                if (tipo != null && tipo.contains("_ARRAY_")) {
                    String paramName = ins.getOperador1();
                    if (paramName != null) {
                        arrayVariables.add(paramName);
                    }
                }
            }
        }
    }

    private boolean isArrayVar(String var) {
        return var != null && arrayVariables.contains(var);
    }

    // Generar MOVE del tamaño correcto dependiendo si es 16 o 32 bits
    private String moveSize(String var) {
        // CHAR usa MOVE.B (8 bits)
        if (isChar(var)) {
            return "MOVE.B";
        }
        // Long usa MOVE.L (32 bits)
        if (isLong(var)) {
            return "MOVE.L";
        }
        // Por defecto MOVE.W (16 bits)
        return "MOVE.W";
    }

    // Lista de parámetros pendientes para la siguiente llamada a función
    private List<String> parametrosPendientes = new ArrayList<>();

    private void parametrosPendientesAdd(String s) {
        if (s == null) {
            return;
        }
        parametrosPendientes.add(s);
    }

    // Obtener nombres de parámetros para una función dada
    private List<String> getNombreParametros(String func, int n) {
        List<String> names = new ArrayList<>();
        for (int idx = 0; idx < codigo.size(); idx++) {
            Instruccion ins = codigo.get(idx);
            String opc = ins.getOpCode();
            String op1 = ins.getOperador1();
            String res = ins.getResultado();
            if (opc != null && opc.equalsIgnoreCase("LABEL")) {
                String lbl = res != null ? res : op1;
                if (lbl != null && lbl.equals(func)) {
                    // Al encontrar la función, buscar variables usadas pero no asignadas (parámetros)
                    Set<String> usedVars = new LinkedHashSet<>();
                    Set<String> assignedVars = new HashSet<>();

                    // Recorrer las instrucciones de la función hasta encontrar otra etiqueta o return
                    for (int j = idx + 1; j < codigo.size(); j++) {
                        Instruccion k = codigo.get(j);
                        String kop = k.getOpCode();

                        // Si encontramos otra etiqueta, terminamos
                        if (kop != null && kop.equalsIgnoreCase("LABEL")) {
                            break;
                        }

                        // Registrar variables usadas
                        String op1k = k.getOperador1();
                        String op2k = k.getOperador2();

                        if (op1k != null && !op1k.matches("-?\\d+") && !op1k.matches("t\\d+") && !op1k.startsWith("\"")) {
                            usedVars.add(op1k);
                        }
                        if (op2k != null && !op2k.matches("-?\\d+") && !op2k.matches("t\\d+") && !op2k.startsWith("\"")) {
                            usedVars.add(op2k);
                        }

                        // Registrar variables asignadas
                        if (kop != null && kop.equals("=")) {
                            String destino = k.getOperador1();
                            if (destino != null && !destino.matches("t\\d+")) {
                                assignedVars.add(destino);
                            }
                        }
                    }

                    // Los parámetros son variables usadas pero no asignadas
                    for (String var : usedVars) {
                        if (!assignedVars.contains(var) && names.size() < n) {
                            names.add(var);
                        }
                    }
                    break;
                }
            }
        }
        return names;
    }

    // Agrega variable o literal si no es etiqueta, número o instrucción
    private void agregarCondicional(String s, Set<String> labels) {
        if (s == null) {
            return;
        }
        if (labels.contains(s)) {
            return;
        }
        if (s.startsWith("\"") && s.endsWith("\"")) {
            // No agregar "\n" como literal, se gestionará directamente como NEWLINE
            String contenido = s.substring(1, s.length() - 1);
            if (contenido.length() == 2 && contenido.charAt(0) == '\\' && contenido.charAt(1) == 'n') {
                return;
            }
            if (!literalToLabel.containsKey(s)) {
                String lbl = "str" + (strCount++);
                literalToLabel.put(s, lbl);
                labelToLiteral.put(lbl, s);
                variables.add(lbl);
            }
            return;
        }
        if (s.contains(" ")) {
            return; // salta tokens como 'call suma' u otros

        }
        if (s.contains("[")) {
            return; // salta variables con índices como numeros[0]

        }
        if (s.matches("-?\\d+")) {
            return; // numericos
        }

        // decimales (float)
        if (s.matches("-?\\d+\\.\\d+")) {
            return;
        }

        //if (s.startsWith("L") || s.startsWith("e")) return; // etiquetas
        if (s.startsWith("L")) {
            return;
        }

        variables.add(s);
    }

    // Agrega variable si no es número o etiqueta
    private void agregar(String s) {
        if (s == null) {
            return;
        }
        if (s.matches("-?\\d+")) {
            return;
        }
        // Ignorar etiquetas de nombre
        if (s.startsWith("L") || s.startsWith("e")) {
            return;
        }
        variables.add(s);
    }

    // Genera la sección de datos
    private void datos() {
        asm.append("\n\t; DATA SECTION\n");
        asm.append("NEWLINE:\tDC.B 13,10,0\n");  // CR+LF para salto de línea

        // Solo agregar estas constantes si hay rutinas que las necesitan
        if (rutinasNecesarias.contains("PRINT_SIGNED") || rutinasNecesarias.contains("PRINT_SIGNED_LONG") || rutinasNecesarias.contains("PRINT_DECIMAL_2")) {
            asm.append("MINUS_SIGN:\tDC.B '-',0\n");
        }

        if (rutinasNecesarias.contains("PRINT_DECIMAL_2")) {
            asm.append("DECIMAL_POINT:\tDC.B '.',0\n");
            asm.append("ZERO_CHAR:\tDC.B '0',0\n");
        }

        // Solo agregar mensaje de división por cero si se necesita
        if (rutinasNecesarias.contains("DIV_ZERO_HANDLER")) {
            asm.append("DIV_ZERO_MSG:\tDC.B 'ERROR: Division entre cero',13,10,0\n");
        }

        // Solo agregar mensaje de error de entrada si hay rutinas de lectura
        if (rutinasNecesarias.contains("READ_NUM_VALID")) {
            asm.append("ERROR_INPUT_MSG:\tDC.B 'ERROR: Entrada invalida. Ingrese un numero valido: ',0\n");
        }

        // Solo agregar mensaje de error para READ_FLOAT si se necesita
        if (rutinasNecesarias.contains("READ_FLOAT")) {
            asm.append("ERROR_FLOAT_MSG:\tDC.B 'ERROR: Entrada invalida. Ingrese un decimal valido (ej: 12.34): ',0\n");
        }

        // Solo agregar strings para booleanos si se necesitan
        if (rutinasNecesarias.contains("PRINT_BOOL") || rutinasNecesarias.contains("READ_BOOL")) {
            asm.append("STR_CIERTO:\tDC.B 'cierto',0\n");
            asm.append("STR_MENTIRA:\tDC.B 'mentira',0\n");
        }

        // Mensaje para indices fuera de rango en tiempo de ejecucion
        if (rutinasNecesarias.contains("ARRAY_BOUNDS_CHECK")) {
            asm.append("ERROR_INDEX_MSG:\tDC.B 'ERROR: Indice fuera de rango',13,10,0\n");
        }

        // Mensaje para acceso a posición no inicializada
        if (rutinasNecesarias.contains("UNINIT_CHECK")) {
            asm.append("ERROR_UNINIT_MSG:\tDC.B 'ERROR: Acceso a posicion no inicializada',13,10,0\n");
        }

        // Mensaje para tamaño de alloc inválido en tiempo de ejecución
        if (rutinasNecesarias.contains("ALLOC_SIZE_CHECK")) {
            asm.append("ERROR_ALLOC_MSG:\tDC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0\n");
        }

        // Agregar strings adicionales para READ_BOOL si se necesita
        if (rutinasNecesarias.contains("READ_BOOL")) {
            asm.append("ERROR_BOOL_MSG:\tDC.B 'ERROR: Entrada invalida. Ingrese cierto o mentira: ',0\n");
        }

        // Solo agregar buffer de entrada si hay rutinas de lectura
        if (rutinasNecesarias.contains("READ_NUM_VALID") || rutinasNecesarias.contains("READ_CHAR") || rutinasNecesarias.contains("READ_BOOL") || rutinasNecesarias.contains("READ_FLOAT")) {
            asm.append("INPUT_BUFFER:\tDS.B 80\n");
        }

        // Inicializar HEAP_PTR (puntero al heap dinámico para arrays)
        asm.append("HEAP_PTR:\tDC.L $8000\n");

        for (String v : variables) {
            if (labelToLiteral.containsKey(v)) {
                // literal de cadena
                String lit = labelToLiteral.get(v);
                String inner = lit.substring(1, lit.length() - 1);
                // salta comillas simples
                inner = inner.replace("'", "''");
                asm.append(v).append(":\tDC.B '").append(inner).append("',0\n");
            } else {
                // Usar DS.B para chars (8 bits), DS.L para 32 bits (long, string o array), DS.W para 16 bits
                if (isChar(v)) {
                    asm.append(v).append(":\tDS.B 1\n");
                } else if (isStringVar(v)) {
                    asm.append(v).append(":\tDS.B 80\n");
                } else if (isLong(v) || isArrayVar(v)) {
                    asm.append(v).append(":\tDS.L 1\n");
                } else {
                    asm.append(v).append(":\tDS.W 1\n");
                }
            }
        }
    }

    // Escribe el archivo ensamblador final en Easy68K formateado (pasar del asm al .x68)
    private void escribirArchivo(String nombre) throws IOException {
        if (nombre.endsWith(".asm")) {
            nombre = nombre.substring(0, nombre.length() - 4) + ".x68";
        }

        // Solo agregar manejador de error de división entre cero si se necesita
        if (rutinasNecesarias.contains("DIV_ZERO_HANDLER")) {
            asm.append("\n; ===== MANEJADOR DE ERROR DE DIVISION ENTRE CERO =====\n");
            asm.append("DIV_ZERO_ERROR:\n");
            asm.append("\tLEA DIV_ZERO_MSG, A1\n");
            asm.append("\tMOVE.B #14, D0\n");
            asm.append("\tTRAP #15\n");
            asm.append("\tBRA HALT\n");
        }

        // poner directiva final 
        asm.append("\nHALT:\n\tSIMHALT\n");

        // Sección de pila
        asm.append("\n\tORG $5000\n");
        asm.append("STACKPTR:\n");

        asm.append("\tEND START\n");

        FileWriter fw = new FileWriter(nombre);
        fw.write(asm.toString());
        fw.close();
    }

    // Procesa comparaciones lógicas dentro de IF (ej: "t1 != t2")
    private void procesarComparacionEnIF(String expresion, String label, boolean negado) {
        // La expresión puede ser: "t1 != t2", "t1 == t2", "t1 < t2", etc.
        String[] partes = null;
        String operador = null;

        if (expresion.contains("!=")) {
            partes = expresion.split("!=");
            operador = "!=";
        } else if (expresion.contains("==")) {
            partes = expresion.split("==");
            operador = "==";
        } else if (expresion.contains("<=")) {
            partes = expresion.split("<=");
            operador = "<=";
        } else if (expresion.contains(">=")) {
            partes = expresion.split(">=");
            operador = ">=";
        } else if (expresion.contains("<")) {
            partes = expresion.split("<");
            operador = "<";
        } else if (expresion.contains(">")) {
            partes = expresion.split(">");
            operador = ">";
        }

        if (partes != null && partes.length == 2) {
            String op1 = partes[0].trim();
            String op2 = partes[1].trim();

            asm.append("\tMOVE.W ").append(valor(op1)).append(", D0\n");
            asm.append("\tCMP.W ").append(valor(op2)).append(", D0\n");

            if (negado) {
                // IF_FALSE - invertir la condición
                if ("!=".equals(operador)) {
                    asm.append("\tBEQ ").append(label).append("\n");
                } else if ("==".equals(operador)) {
                    asm.append("\tBNE ").append(label).append("\n");
                } else if ("<".equals(operador)) {
                    asm.append("\tBGE ").append(label).append("\n");
                } else if (">".equals(operador)) {
                    asm.append("\tBLE ").append(label).append("\n");
                } else if ("<=".equals(operador)) {
                    asm.append("\tBGT ").append(label).append("\n");
                } else if (">=".equals(operador)) {
                    asm.append("\tBLT ").append(label).append("\n");
                }
            } else {
                // IF - condición normal
                if ("!=".equals(operador)) {
                    asm.append("\tBNE ").append(label).append("\n");
                } else if ("==".equals(operador)) {
                    asm.append("\tBEQ ").append(label).append("\n");
                } else if ("<".equals(operador)) {
                    asm.append("\tBLT ").append(label).append("\n");
                } else if (">".equals(operador)) {
                    asm.append("\tBGT ").append(label).append("\n");
                } else if ("<=".equals(operador)) {
                    asm.append("\tBLE ").append(label).append("\n");
                } else if (">=".equals(operador)) {
                    asm.append("\tBGE ").append(label).append("\n");
                }
            }
        }
    }

    /**
     * Extrae las dimensiones de un array a partir del código intermedio. Busca
     * instrucciones de multiplicación que indican el tamaño del array.
     */
    private List<Integer> extraerDimensionesArray(String nombreArray) {
        List<Integer> dimensiones = new ArrayList<>();
        // Buscar en el código intermedio instrucciones que definan el array
        for (Instruccion instr : codigo) {
            String tipo = instr.getTipo();
            if (tipo != null && tipo.contains("ARRAY") && tipo.contains(nombreArray)) {
                // Intentar extraer dimensiones (Formato esperado: "INT_ARRAY_2:[2,3]")
                if (tipo.contains("[") && tipo.contains("]")) {
                    String dimStr = tipo.substring(tipo.indexOf("[") + 1, tipo.indexOf("]"));
                    String[] dims = dimStr.split(",");
                    for (String dim : dims) {
                        String dimTrimmed = dim.trim();
                        // Validar si es un número entero válido antes de parsearlo
                        if (esNumeroEntero(dimTrimmed)) {
                            dimensiones.add(Integer.parseInt(dimTrimmed));
                        }
                        // Si no es válido, simplemente ignoramos esta dimensión
                    }
                }
            }
        }
        // Si no encontramos dimensiones, intentamos inferirlas a partir de los accesos
        if (dimensiones.isEmpty()) {
            dimensiones = inferirDimensionesDesdeAccesos(nombreArray);
        }
        return dimensiones.isEmpty() ? null : dimensiones;
    }

    // Infiere las dimensiones de un array observando cómo se accede en el código
    private List<Integer> inferirDimensionesDesdeAccesos(String nombreArray) {
        List<Integer> dimensiones = new ArrayList<>();
        // Buscar el tamaño total del array (número de elementos)
        int totalElementos = -1;
        for (Instruccion instr : codigo) {
            // Buscar patrón: t_N = size (número de elementos)
            // Luego: t_M = 4 (bytes por elemento)
            // Luego: t_result = t_N * t_M
            // Después hay asignaciones al array
            if ("*".equals(instr.getOpCode())) {
                String op1 = instr.getOperador1();
                String op2 = instr.getOperador2();
                if (op2 != null && "4".equals(op2) && op1 != null && op1.startsWith("t")) {
                    // Buscar el valor de op1 buscando hacia atrás
                    for (int i = codigo.indexOf(instr) - 1; i >= 0; i--) {
                        Instruccion prev = codigo.get(i);
                        if ("=".equals(prev.getOpCode()) && op1.equals(prev.getResultado())) {
                            String valueStr = prev.getOperador1();
                            if (valueStr != null && valueStr.matches("\\d+")) {
                                totalElementos = Integer.parseInt(valueStr);
                                break;
                            }
                        }
                    }
                }
            }
        }
        // Buscar patrones de multiplicación en accesos para inferir la segunda dimensión
        // Patrón típico para array 2D: t = i * NUM_COLS; t2 = t + j
        int colsInferidas = 0;
        for (Instruccion instr : codigo) {
            if ("*".equals(instr.getOpCode())) {
                String op2 = instr.getOperador2();
                // Buscar si el resultado de esta multiplicación se usa en una suma (patrón 2D)
                if (op2 != null && op2.matches("\\d+")) {
                    String multResult = instr.getResultado();
                    // Buscar si este resultado se usa en una suma
                    for (Instruccion nextInstr : codigo) {
                        if ("+".equals(nextInstr.getOpCode())) {
                            if (multResult != null
                                    && (multResult.equals(nextInstr.getOperador1())
                                    || multResult.equals(nextInstr.getOperador2()))) {
                                // Este es un patrón de acceso 2D: i * cols + j
                                int cols = Integer.parseInt(op2);
                                if (cols > colsInferidas) {
                                    colsInferidas = cols;
                                }
                            }
                        }
                    }
                }
            }
        }
        // Si encontramos ambos valores, calcular las dimensiones
        if (totalElementos > 0 && colsInferidas > 1) {
            int filas = totalElementos / colsInferidas;
            dimensiones.add(filas);
            dimensiones.add(colsInferidas);
        }
        return dimensiones;
    }

    // ============ MÉTODOS PARA RUTINAS AUXILIARES ============
    private void generarPrintSigned() {
        asm.append("PRINT_SIGNED:\n");
        asm.append("\tTST.W D1\n");
        asm.append("\tBPL PRINT_UNSIGNED\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tLEA MINUS_SIGN, A1\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tNEG.W D1\n");
        asm.append("PRINT_UNSIGNED:\n");
        asm.append("\tMOVE.B #3, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tRTS\n");
        asm.append("\n");
    }

    private void generarPrintUnsigned() {
        // Esta rutina es llamada por PRINT_SIGNED
    }

    private void generarPrintSignedLong() {
        asm.append("PRINT_SIGNED_LONG:\n");
        asm.append("\tTST.L D1\n");
        asm.append("\tBPL PRINT_UNSIGNED_LONG\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tLEA MINUS_SIGN, A1\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tNEG.L D1\n");
        asm.append("PRINT_UNSIGNED_LONG:\n");
        asm.append("\tMOVE.B #3, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tRTS\n");
        asm.append("\n");
    }

    private void generarPrintUnsignedLong() {
        // Esta rutina es llamada por PRINT_SIGNED_LONG
    }

    private void generarPrintDecimal2() {
        asm.append("PRINT_DECIMAL_2:\n");
        asm.append("\tMOVE.L D1, D3\n");

        asm.append("\tTST.L D3\n");
        asm.append("\tBPL .PD2_POSITIVE\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tLEA MINUS_SIGN, A1\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tNEG.L D3\n");
        asm.append(".PD2_POSITIVE:\n");

        asm.append("\tMOVE.L D3, D2\n");
        asm.append("\tMOVE.W #100, D4\n");
        asm.append("\tDIVS D4, D2\n");

        asm.append("\tMOVE.L D2, D5\n");
        asm.append("\tMOVE.W #100, D4\n");
        asm.append("\tMOVE.L D5, D6\n");
        asm.append("\tCLR.L D0\n");
        asm.append("\tMOVE.W D4, D0\n");
        asm.append("\tMULS D0, D6\n");
        asm.append("\tSUB.L D6, D3\n");

        asm.append("\tCLR.L D1\n");
        asm.append("\tMOVE.W D2, D1\n");
        asm.append("\tMOVE.B #3, D0\n");
        asm.append("\tTRAP #15\n");

        asm.append("\tLEA DECIMAL_POINT, A1\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tTRAP #15\n");

        asm.append("\tCLR.L D0\n");
        asm.append("\tMOVE.W D3, D0\n");
        asm.append("\tCMP.W #10, D0\n");
        asm.append("\tBGE .PD2_SKIP_ZERO\n");
        asm.append("\tLEA ZERO_CHAR, A1\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append(".PD2_SKIP_ZERO:\n");
        asm.append("\tCLR.L D1\n");
        asm.append("\tMOVE.W D3, D1\n");
        asm.append("\tMOVE.B #3, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tRTS\n\n");
    }

    private void generarPrintBool() {
        asm.append("PRINT_BOOL:\n");
        asm.append("\tTST.W D1\n");
        asm.append("\tBEQ .PRINT_MENTIRA\n");
        asm.append("\tLEA STR_CIERTO, A1\n");
        asm.append("\tBRA .PRINT_BOOL_STR\n");
        asm.append(".PRINT_MENTIRA:\n");
        asm.append("\tLEA STR_MENTIRA, A1\n");
        asm.append(".PRINT_BOOL_STR:\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tRTS\n\n");
    }

    private void generarReadNumValid() {
        asm.append("READ_NUM_VALID:\n");
        asm.append(".RNV_RETRY:\n");
        asm.append("\tLEA INPUT_BUFFER, A1\n");
        asm.append("\tMOVE.B #2, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tLEA INPUT_BUFFER, A1\n");
        asm.append("\tCLR.W D2\n");
        asm.append("\tCLR.L D3\n");
        asm.append("\tCLR.L D4\n");
        asm.append("\tMOVE.B (A1), D5\n");
        asm.append("\tCMP.B #0, D5\n");
        asm.append("\tBEQ .RNV_ERR\n");
        asm.append("\tCMP.B #'-', D5\n");
        asm.append("\tBNE .RNV_CHK\n");
        asm.append("\tMOVE.W #1, D2\n");
        asm.append("\tADDA.L #1, A1\n");
        asm.append(".RNV_CHK:\n");
        asm.append(".RNV_LOOP:\n");
        asm.append("\tMOVE.B (A1)+, D5\n");
        asm.append("\tCMP.B #0, D5\n");
        asm.append("\tBEQ .RNV_VALID\n");
        asm.append("\tCMP.B #10, D5\n");
        asm.append("\tBEQ .RNV_VALID\n");
        asm.append("\tCMP.B #13, D5\n");
        asm.append("\tBEQ .RNV_VALID\n");
        asm.append("\tCMP.B #'0', D5\n");
        asm.append("\tBLT .RNV_ERR\n");
        asm.append("\tCMP.B #'9', D5\n");
        asm.append("\tBGT .RNV_ERR\n");
        asm.append("\tADD.L #1, D4\n");
        asm.append("\tSUB.B #'0', D5\n");
        asm.append("\tMOVE.L D3, D6\n");
        asm.append("\tMULS #10, D3\n");
        asm.append("\tEXT.W D5\n");
        asm.append("\tEXT.L D5\n");
        asm.append("\tADD.L D5, D3\n");
        asm.append("\tBRA .RNV_LOOP\n");
        asm.append(".RNV_VALID:\n");
        asm.append("\tTST.L D4\n");
        asm.append("\tBEQ .RNV_ERR\n");
        asm.append("\tMOVE.W D3, D1\n");
        asm.append("\tTST.W D2\n");
        asm.append("\tBEQ .RNV_END\n");
        asm.append("\tNEG.W D1\n");
        asm.append(".RNV_END:\n");
        asm.append("\tRTS\n");
        asm.append(".RNV_ERR:\n");
        asm.append("\tLEA ERROR_INPUT_MSG, A1\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tBRA .RNV_RETRY\n\n");
    }

    private void generarReadChar() {
        asm.append("READ_CHAR:\n");
        asm.append("\tMOVE.B #5, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tRTS\n\n");
    }

    private void generarReadString() {
        asm.append("READ_STRING:\n");
        asm.append("\tMOVE.L D0, -(A7)\n");
        asm.append("\tMOVE.B #2, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tMOVE.L (A7)+, D0\n");
        asm.append("\tRTS\n\n");
    }

    private void generarReadBool() {
        asm.append("READ_BOOL:\n");
        asm.append(".RB_RETRY:\n");
        asm.append("\tLEA INPUT_BUFFER, A1\n");
        asm.append("\tMOVE.B #2, D0\n");
        asm.append("\tTRAP #15\n");

        asm.append("\tLEA INPUT_BUFFER, A1\n");
        asm.append("\tLEA STR_CIERTO, A2\n");
        asm.append("\tJSR STRING_COMPARE\n");
        asm.append("\tTST.W D0\n");
        asm.append("\tBEQ .RB_TRUE\n");

        asm.append("\tLEA INPUT_BUFFER, A1\n");
        asm.append("\tLEA STR_MENTIRA, A2\n");
        asm.append("\tJSR STRING_COMPARE\n");
        asm.append("\tTST.W D0\n");
        asm.append("\tBEQ .RB_FALSE\n");

        asm.append("\tLEA ERROR_BOOL_MSG, A1\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tBRA .RB_RETRY\n");

        asm.append(".RB_TRUE:\n");
        asm.append("\tMOVE.W #1, D1\n");
        asm.append("\tRTS\n");

        asm.append(".RB_FALSE:\n");
        asm.append("\tMOVE.W #0, D1\n");
        asm.append("\tRTS\n\n");
    }

    private void generarReadFloat() {
        asm.append("READ_FLOAT:\n");
        asm.append(".RF_RETRY:\n");
        asm.append("\tLEA INPUT_BUFFER, A1\n");
        asm.append("\tMOVE.B #2, D0\n");
        asm.append("\tTRAP #15\n");

        asm.append("\tLEA INPUT_BUFFER, A1\n");
        asm.append("\tCLR.W D2\n");
        asm.append("\tCLR.W D3\n");
        asm.append("\tCLR.W D4\n");
        asm.append("\tCLR.W D5\n");

        asm.append("\tMOVE.B (A1), D6\n");
        asm.append("\tCMP.B #0, D6\n");
        asm.append("\tBEQ .RF_ERROR\n");

        asm.append("\tCMP.B #'-', D6\n");
        asm.append("\tBNE .RF_PARSE_INT\n");
        asm.append("\tMOVE.W #1, D2\n");
        asm.append("\tADDA.L #1, A1\n");

        asm.append(".RF_PARSE_INT:\n");
        asm.append("\tMOVE.B (A1)+, D6\n");
        asm.append("\tCMP.B #0, D6\n");
        asm.append("\tBEQ .RF_FINISH\n");
        asm.append("\tCMP.B #10, D6\n");
        asm.append("\tBEQ .RF_FINISH\n");
        asm.append("\tCMP.B #13, D6\n");
        asm.append("\tBEQ .RF_FINISH\n");
        asm.append("\tCMP.B #'.', D6\n");
        asm.append("\tBEQ .RF_PARSE_DEC\n");

        asm.append("\tCMP.B #'0', D6\n");
        asm.append("\tBLT .RF_ERROR\n");
        asm.append("\tCMP.B #'9', D6\n");
        asm.append("\tBGT .RF_ERROR\n");

        asm.append("\tSUB.B #'0', D6\n");
        asm.append("\tMOVE.W #10, D7\n");
        asm.append("\tMULS D7, D3\n");
        asm.append("\tADD.W D6, D3\n");
        asm.append("\tBRA .RF_PARSE_INT\n");

        asm.append(".RF_PARSE_DEC:\n");
        asm.append("\tCLR.W D5\n");                    // Contador de dígitos decimales
        asm.append(".RF_DEC_LOOP:\n");
        asm.append("\tMOVE.B (A1)+, D6\n");
        asm.append("\tCMP.B #0, D6\n");
        asm.append("\tBEQ .RF_FINISH\n");
        asm.append("\tCMP.B #10, D6\n");
        asm.append("\tBEQ .RF_FINISH\n");
        asm.append("\tCMP.B #13, D6\n");
        asm.append("\tBEQ .RF_FINISH\n");

        asm.append("\tCMP.B #'0', D6\n");
        asm.append("\tBLT .RF_ERROR\n");
        asm.append("\tCMP.B #'9', D6\n");
        asm.append("\tBGT .RF_ERROR\n");

        asm.append("\tCMP.W #2, D5\n");               // Solo leer 2 dígitos decimales
        asm.append("\tBGE .RF_DEC_LOOP\n");            // Si ya leímos 2, ignorar el resto

        asm.append("\tSUB.B #'0', D6\n");              // Convertir a número
        asm.append("\tMOVE.W #10, D7\n");
        asm.append("\tMULS D7, D4\n");                 // D4 = D4 * 10
        asm.append("\tADD.W D6, D4\n");                // D4 = D4 + dígito
        asm.append("\tADD.W #1, D5\n");                // Incrementar contador
        asm.append("\tBRA .RF_DEC_LOOP\n");

        asm.append(".RF_FINISH:\n");
        asm.append("\tMOVE.W #100, D7\n");
        asm.append("\tMULS D7, D3\n");                 // Parte entera * 100

        // Ajustar parte decimal según dígitos leídos
        asm.append("\tCMP.W #1, D5\n");                // ¿Solo 1 dígito decimal?
        asm.append("\tBNE .RF_TWO_DIGITS\n");
        asm.append("\tMOVE.W #10, D7\n");              // Si solo 1 dígito, multiplicar por 10
        asm.append("\tMULS D7, D4\n");                 // Ej: .5 -> 50
        asm.append(".RF_TWO_DIGITS:\n");

        asm.append("\tADD.W D4, D3\n");                // Sumar parte decimal

        asm.append("\tTST.W D2\n");
        asm.append("\tBEQ .RF_POSITIVE\n");
        asm.append("\tNEG.W D3\n");
        asm.append(".RF_POSITIVE:\n");
        asm.append("\tMOVE.W D3, D1\n");
        asm.append("\tRTS\n");

        asm.append(".RF_ERROR:\n");
        asm.append("\tLEA ERROR_FLOAT_MSG, A1\n");
        asm.append("\tMOVE.B #14, D0\n");
        asm.append("\tTRAP #15\n");
        asm.append("\tBRA .RF_RETRY\n\n");
    }

    private void generarStringCompare() {
        asm.append("STRING_COMPARE:\n");
        asm.append(".SC_LOOP:\n");
        asm.append("\tMOVE.B (A1)+, D2\n");
        asm.append("\tMOVE.B (A2)+, D3\n");

        asm.append("\tCMP.B #'A', D2\n");
        asm.append("\tBLT .SC_SKIP1\n");
        asm.append("\tCMP.B #'Z', D2\n");
        asm.append("\tBGT .SC_SKIP1\n");
        asm.append("\tADD.B #32, D2\n");
        asm.append(".SC_SKIP1:\n");

        asm.append("\tCMP.B #'A', D3\n");
        asm.append("\tBLT .SC_SKIP2\n");
        asm.append("\tCMP.B #'Z', D3\n");
        asm.append("\tBGT .SC_SKIP2\n");
        asm.append("\tADD.B #32, D3\n");
        asm.append(".SC_SKIP2:\n");

        asm.append("\tCMP.B #10, D2\n");
        asm.append("\tBEQ .SC_END_D2\n");
        asm.append("\tCMP.B #13, D2\n");
        asm.append("\tBEQ .SC_END_D2\n");
        asm.append("\tBRA .SC_CONT\n");
        asm.append(".SC_END_D2:\n");
        asm.append("\tCLR.B D2\n");
        asm.append(".SC_CONT:\n");

        asm.append("\tCMP.B D2, D3\n");
        asm.append("\tBNE .SC_DIFFERENT\n");

        asm.append("\tTST.B D2\n");
        asm.append("\tBEQ .SC_EQUAL\n");

        asm.append("\tBRA .SC_LOOP\n");

        asm.append(".SC_EQUAL:\n");
        asm.append("\tMOVE.W #0, D0\n");
        asm.append("\tRTS\n");

        asm.append(".SC_DIFFERENT:\n");
        asm.append("\tMOVE.W #1, D0\n");
        asm.append("\tRTS\n\n");
    }

    /**
     * Valida si una cadena representa un número entero válido
     *
     */
    private boolean esNumeroEntero(String s) {
        if (s == null || s.isEmpty()) {
            return false;
        }

        // Eliminar espacios en blanco
        s = s.trim();
        if (s.isEmpty()) {
            return false;
        }

        // Verificar signo negativo al inicio
        int startIndex = 0;
        if (s.charAt(0) == '-' || s.charAt(0) == '+') {
            if (s.length() == 1) {
                return false; // Solo signo, no número
            }
            startIndex = 1;
        }

        // Verificar que todos los caracteres restantes sean dígitos
        for (int i = startIndex; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c < '0' || c > '9') {
                return false;
            }
        }

        return true;
    }

    // Asegura que exista almacenamiento para un parámetro y devuelve el nombre normalizado
    private String asegurarYNormalizarParametro(String pnameCandidate, String func, int index) {
        // Si el nombre es válido, lo usamos
        if (pnameCandidate != null && !pnameCandidate.contains(" ") && !pnameCandidate.startsWith("call") && !pnameCandidate.matches("-?\\d+")) {
            if (!variables.contains(pnameCandidate)) {
                variables.add(pnameCandidate);
            }
            return pnameCandidate;
        }

        // Si pnameCandidate no es válido (null, contiene espacios, empieza por "call", etc.)
        // generamos un nombre seguro basado en la función y el índice del parámetro
        String pname = func + "_p" + index;
        int suffix = 0;
        String base = pname;
        while (variables.contains(pname)) {
            suffix++;
            pname = base + "_" + suffix;
        }
        variables.add(pname);
        return pname;
    }

}
