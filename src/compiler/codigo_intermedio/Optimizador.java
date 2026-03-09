/**
 * Assignatura 21780 Compiladors
 * Estudis de Grau en Informàtica
 * Professor: Pere Palmer
 * Autors: Teletubbies sospechosos
 */
package compiler.codigo_intermedio;

import java.util.*;

public class Optimizador {

    Map<String, List<String>> cambios = new LinkedHashMap<>(); // Lista de cambios realizados con cada optimización

    public List<Instruccion> optimizar(List<Instruccion> codigo) {
        boolean cambio;
        do {
            cambio = false;
            cambio |= calcularConstantes(codigo);
            cambio |= fusionarLecturaAsignacion(codigo);
            cambio |= asignacionDiferida(codigo);
            cambio |= simplificacionAlgebraica(codigo);
            cambio |= ramificacionesAdyacentes(codigo);
            cambio |= eliminarEtiquetasMuertas(codigo);
            cambio |= eliminarCodigoMuerto(codigo);
        } while (cambio);

        return codigo;
    }

    private boolean esOperacionBinaria(String op) {
        return Set.of("+", "-", "*", "/", "%").contains(op);
    }

    private boolean esConstante(String s) {
        if (s == null) {
            return false;
        }

        // Entero
        if (s.matches("-?\\d+")) {
            return true;
        }
        // Decimal
        if (s.matches("-?\\d+\\.\\d+")) {
            return true;
        }

        return false;
    }

    private boolean esDecimal(String s) {
        return s != null && s.contains(".");
    }

    private String calcular(String op, String a, String b) {
        boolean decimal = esDecimal(a) || esDecimal(b);

        double x = Double.parseDouble(a);
        double y = Double.parseDouble(b);
        double res;

        switch (op) {
            case "+":
                res = x + y;
                break;
            case "-":
                res = x - y;
                break;
            case "*":
                res = x * y;
                break;
            case "/":
                res = x / y;
                break;
            case "%":
                res = x % y;
                break;
            default:
                res = 0;
        }

        if (!decimal && res == (int) res) {
            return Integer.toString((int) res);
        }
        return Double.toString(res);
    }

    private void convertirEnAsignacion(Instruccion i, String destino, String valor) {
        i.setOpCode("=");
        i.setOperador1(destino);
        i.setOperador2(valor);
        i.setResultado(null);
    }

    // Elimina saltos inútiles o saltos a etiquetas que solo contienen otro salto
    private boolean ramificacionesAdyacentes(List<Instruccion> codigo) {
        boolean cambio = false;

        Map<String, Integer> etiquetas = new HashMap<>();
        for (int i = 0; i < codigo.size(); i++) {
            Instruccion inst = codigo.get(i);
            if ("LABEL".equals(inst.getOpCode())) {
                etiquetas.put(inst.getOperador1(), i);
            }
        }

        for (int i = 0; i < codigo.size(); i++) {
            Instruccion inst = codigo.get(i);

            // Solo GOTO / IF / IF_FALSE
            if (!inst.getOpCode().equals("GOTO")
                    && !inst.getOpCode().equals("IF")
                    && !inst.getOpCode().equals("IF_FALSE")) {
                continue;
            }

            String destino = inst.getResultado();
            if (inst.getOpCode().equals("GOTO")) {
                destino = inst.getOperador1();
            }

            Integer idEtiqueta = etiquetas.get(destino);
            if (idEtiqueta == null || idEtiqueta >= codigo.size()) {
                continue;
            }

            int j = i + 1;
            // Avanzar a la siguiente instrucción después de la declaración del salto a la etiqueta (saltamos los LABEL)
            while (j < codigo.size() && "LABEL".equals(codigo.get(j).getOpCode())) {
                // Si la siguiente instrucción es la propia etiqueta del salto
                if (codigo.get(j).getOperador1().equals(destino)) {
                    // El salto es redundante
                    registrarCambio("Ramificaciones adyacentes", i, "Salto innecesario a " + destino + " eliminado");
                    codigo.remove(i);
                    i--; // Reajustar índice
                    cambio = true;
                    // Reconstruir mapa de etiquetas después de eliminar
                    etiquetas.clear();
                    for (int k = 0; k < codigo.size(); k++) {
                        if ("LABEL".equals(codigo.get(k).getOpCode())) {
                            etiquetas.put(codigo.get(k).getOperador1(), k);
                        }
                    }
                    break;
                }
                j++;
            }

            // Avanzar a la siguiente instrucción después de hacer el salto a la etiqueta (saltamos los LABEL)
            j = idEtiqueta;
            while (j < codigo.size() && "LABEL".equals(codigo.get(j).getOpCode())) {
                j++;
            }

            if (j == codigo.size()) {
                continue;
            }

            Instruccion siguiente = codigo.get(j);

            // Solo si es GOTO
            if (!"GOTO".equals(siguiente.getOpCode())) {
                continue;
            }

            String nuevoDestino = siguiente.getOperador1();

            // Evitar bucles
            if (nuevoDestino.equals(destino)) {
                continue;
            }

            // Reescribir salto
            if ("GOTO".equals(inst.getOpCode())) {
                inst.setOperador1(nuevoDestino);
            } else {
                inst.setResultado(nuevoDestino);
            }

            registrarCambio("Ramificaciones adyacentes", i, "Salto a " + destino + " reemplazado por salto directo a " + nuevoDestino);

            cambio = true;
        }

        return cambio;
    }

    // Calcula las operaciones con constantes
    private boolean calcularConstantes(List<Instruccion> codigo) {
        boolean cambio = false;

        for (int i = 0; i < codigo.size(); i++) {
            Instruccion instr = codigo.get(i);

            if (!esOperacionBinaria(instr.getOpCode())) {
                continue;
            }

            String op = instr.getOpCode();
            String a = instr.getOperador1();
            String b = instr.getOperador2();
            String r = instr.getResultado();

            if (esConstante(a) && esConstante(b)) {
                String valor = calcular(op, a, b);

                convertirEnAsignacion(instr, r, valor);
                registrarCambio("Cálculo de constantes", i, r + " = " + a + " " + op + " " + b + " -> " + r + " = " + valor);

                cambio = true;
            }
        }

        return cambio;
    }

    // Simplifica algunas operaciones con constantes
    private boolean simplificacionAlgebraica(List<Instruccion> codigo) {
        boolean cambio = false;

        for (int i = 0; i < codigo.size(); i++) {

            Instruccion instr = codigo.get(i);

            if (!esOperacionBinaria(instr.getOpCode())) {
                continue;
            }

            String op = instr.getOpCode();
            String a = instr.getOperador1();
            String b = instr.getOperador2();
            String r = instr.getResultado();

            // x = a + 0  ->  x = a
            if (op.equals("+") && ("0".equals(b) || "0.0".equals(b))) {
                convertirEnAsignacion(instr, r, a);
                registrarCambio("Simplificación algebraica", i, r + " = " + a);
                cambio = true;
            } // x = a * 1  ->  x = a
            else if (op.equals("*") && ("1".equals(b) || "1.0".equals(b))) {
                convertirEnAsignacion(instr, r, a);
                registrarCambio("Simplificación algebraica", i, r + " = " + a);
                cambio = true;
            } // x = a * 0  ->  x = 0 ó 0.0 según tipo
            else if (op.equals("*") && ("0".equals(b) || "0.0".equals(b))) {
                boolean decimal = esDecimal(a) || esDecimal(b);
                String cero = decimal ? "0.0" : "0";
                convertirEnAsignacion(instr, r, cero);
                registrarCambio("Simplificación algebraica", i, r + " = " + cero);
                cambio = true;
            }
        }

        return cambio;
    }

    // Fusiona IND_VAL seguido de una asignación: t = v[i]; x = t;  -->  x = v[i];
    private boolean fusionarLecturaAsignacion(List<Instruccion> codigo) {
        boolean cambio = false;

        for (int i = 0; i < codigo.size() - 1; i++) {
            Instruccion actual = codigo.get(i);
            Instruccion siguiente = codigo.get(i + 1);

            if ("IND_VAL".equals(actual.getOpCode()) && "=".equals(siguiente.getOpCode())) {

                String tempGenerado = actual.getResultado();
                String fuenteAsignacion = siguiente.getOperador2();
                String destinoFinal = siguiente.getOperador1();

                // Verificamos que no sean nulos y que conecten (que el temporal sea el mismo)
                if (tempGenerado != null && tempGenerado.equals(fuenteAsignacion)) {

                    
                    if (destinoFinal == null || !destinoFinal.startsWith("t")) {
                        continue;
                    }

                    actual.setResultado(destinoFinal);

                    // ELIMINACIÓN:
                    codigo.remove(i + 1);

                    registrarCambio("Fusión Lectura Array", i,
                            "Se eliminó temporal " + tempGenerado + " asignando directo a " + destinoFinal);

                    cambio = true;
                    // Retrocedemos un índice para no saltarnos nada al haber borrado una línea
                    i--;
                }
            }
        }
        return cambio;
    }

    // Elimina etiquetas 'e' que no tienen saltos hacia ellas
    private boolean eliminarEtiquetasMuertas(List<Instruccion> codigo) {
        boolean cambio = false;
        Set<String> etiquetasUsadas = new HashSet<>();

        // Guardar todas las etiquetas que se usan en saltos
        for (Instruccion i : codigo) {
            String op = i.getOpCode();
            if ("GOTO".equals(op)) {
                etiquetasUsadas.add(i.getOperador1());
            } else if ("IF".equals(op) || "IF_FALSE".equals(op)) {
                etiquetasUsadas.add(i.getResultado());
            }
        }

        // Eliminar etiquetas que no están usadas
        Iterator<Instruccion> it = codigo.iterator();
        int linea = 0;
        while (it.hasNext()) {
            Instruccion instr = it.next();
            if ("LABEL".equals(instr.getOpCode()) && !etiquetasUsadas.contains(instr.getOperador1()) && instr.getOperador1().startsWith("e")) {
                registrarCambio("Eliminación de etiquetas muertas", linea, "Se ha eliminado la etiqueta " + instr.getOperador1());
                it.remove();
                cambio = true;
            }
            linea++;
        }

        return cambio;
    }

    // Eliminar asignaciones y variables no utilizadas
    private boolean eliminarCodigoMuerto(List<Instruccion> codigo) {
        boolean cambio = false;
        Set<String> usados = new HashSet<>();

        // Ver qué variables se usan. También mirar el campo 'tipo' porque contiene referencias
        // a temporales/dimensiones (p.ej. "INT:t5:4") que deben contarse como usadas.
        for (Instruccion i : codigo) {
            String opCode = i.getOpCode();

            // Si tenemos IF o IF_FALSE, operador1 puede contener una expresión completa (ej: "t1 != t2")
            // Hay que extraer todas las variables de esa expresión
            if (opCode.equals("IF") || opCode.equals("IF_FALSE")) {
                if (i.getOperador1() != null) {
                    // Extraer todas las variables/temporales de la expresión
                    String expr = i.getOperador1();
                    String[] tokens = expr.split("[\\s+\\-*/%<>=!&|()\\[\\]]+");
                    for (String token : tokens) {
                        if (!token.isEmpty() && (token.matches("[a-zA-Z_][a-zA-Z0-9_]*") || token.matches("t\\d+"))) {
                            usados.add(token);
                        }
                    }
                }
            } else {
                // Para otras instrucciones, añadir operador1 si no es asignación
                if (i.getOperador1() != null && !opCode.equals("=")) {
                    usados.add(i.getOperador1());
                }
            }

            // Operador2 siempre se usa si existe
            if (i.getOperador2() != null) {
                usados.add(i.getOperador2());
            }

            // Además, si la instrucción tiene información en el campo 'tipo' (p. ej. "INT:t5:4"),
            // extraer tokens separados por ':' y otros separadores para detectar temporales usados allí.
            if (i.getTipo() != null) {
                String tipoStr = i.getTipo();
                String[] parts = tipoStr.split(":");
                for (String p : parts) {
                    String[] subtokens = p.split("[\\s,()\\[\\]]+");
                    for (String tk : subtokens) {
                        if (tk != null && !tk.isEmpty() && (tk.matches("[a-zA-Z_][a-zA-Z0-9_]*") || tk.matches("t\\d+"))) {
                            usados.add(tk);
                        }
                    }
                }
            }
        }

        // Eliminar asignaciones inútiles
        Iterator<Instruccion> it = codigo.iterator();
        int linea = 0;
        while (it.hasNext()) {
            Instruccion i = it.next();
            // Solo eliminar si es una asignación simple y el destino no se usa
            if (i.getOpCode().equals("=") && i.getOperador1() != null && !usados.contains(i.getOperador1())) {
                registrarCambio("Eliminación de código muerto", linea, "Se eliminó " + i.getOperador1());
                it.remove();
                cambio = true;
            }
            linea++;
        }
        return cambio;
    }

    // Si un temporal recibe un valor que solo se utiliza una vez, se puede hacer uso del valor directamente
// Si un temporal recibe un valor que solo se utiliza una vez, se puede hacer uso del valor directamente
    private boolean asignacionDiferida(List<Instruccion> codigo) {
        boolean cambio = false;

        // Cuenta las veces que se usa cada temporal
        Map<String, Integer> usosTemporal = new HashMap<>();

        for (Instruccion inst : codigo) {
            String op1 = inst.getOperador1();
            String op2 = inst.getOperador2();
            String opc = inst.getOpCode();

            // Si se usa un temporal, lo añadimos al HashMap o incrementamos la cantidad de usos si ya estaba
            if ("=".equals(opc)) {
                // En una asignación "a = b", solo b (operador2) se usa
                if (op2 != null && op2.startsWith("t")) {
                    usosTemporal.put(op2, usosTemporal.getOrDefault(op2, 0) + 1);
                }
            } else {
                if (op1 != null && op1.startsWith("t")) {
                    usosTemporal.put(op1, usosTemporal.getOrDefault(op1, 0) + 1);
                }
                if (op2 != null && op2.startsWith("t")) {
                    usosTemporal.put(op2, usosTemporal.getOrDefault(op2, 0) + 1);
                }
            }
        }

        // Busca asignaciones t = x para eliminarlas si solo se usan una vez
        for (int i = 0; i < codigo.size() - 1; i++) {
            Instruccion asignacionTemp = codigo.get(i); // Asignación del temporal

            String temp = asignacionTemp.getOperador1();

            if (temp == null) {
                continue;
            }
            if (!temp.startsWith("t")) {
                continue;   // Solo temporales
            }
            if (!asignacionTemp.getOpCode().equals("=")) {
                continue;   // Solo asignaciones
            }

            if (usosTemporal.get(temp) == null || usosTemporal.get(temp) != 1) {
                continue;   // No lo eliminamos si se usa más de una vez o si no se usa
            }

            String valor = asignacionTemp.getOperador2(); // Valor asignado al temporal

            // No eliminar si el valor es una llamada a función
            if (valor != null && valor.startsWith("call ")) {
                continue;
            }

            // Solo intentamos sustituir si 'valor' es constante o un identificador simple (ej. x, incr, t5)
            boolean valorConstante = esConstante(valor);
            boolean valorIdentificadorSimple = (valor != null && valor.matches("^[a-zA-Z_][a-zA-Z0-9_]*$"));

            if (!valorConstante && !valorIdentificadorSimple) {
                continue;
            }

            int j = -1; // Buscar la instrucción que usa el temporal como operador
            for (int k = i + 1; k < codigo.size(); k++) {
                Instruccion inst = codigo.get(k);

                if ("=".equals(inst.getOpCode())) { // Comprobar si tenemos x = t
                    if (temp.equals(inst.getOperador2())) {
                        j = k;
                        break;
                    }
                } else {  // Comprobar si tenemos operación binaria/unaria que usa t como operador
                    if (temp.equals(inst.getOperador1()) || temp.equals(inst.getOperador2()) || temp.equals(inst.getResultado())) {
                        j = k;
                        break;
                    }
                }
            }

            if (j == -1) {
                continue; // Uso no encontrado
            }

            // Si 'valor' es un identificador simple (no es constante), comprobar si entre i y j cambia su valor
            if (valorIdentificadorSimple) {
                String id = valor;
                boolean noModificar = false;
                for (int k = i + 1; k < j; k++) {
                    Instruccion instr = codigo.get(k);
                    String opcInstr = instr.getOpCode();

                    // llamadas a funciones pueden modificar el valor
                    if (opcInstr.startsWith("call ")) {
                        noModificar = true;
                        break;
                    }
                    // la instrucción asigna directamente a id
                    if ("=".equals(opcInstr) && id.equals(instr.getOperador1())) {
                        noModificar = true;
                        break;
                    }
                    // la instrucción tiene como resultado 'id' (ej. id = a + b)
                    if (instr.getResultado() != null && id.equals(instr.getResultado())) {
                        noModificar = true;
                        break;
                    }
                    // la instrucción contiene una llamada en sus operandos
                    if ((instr.getOperador1() != null && instr.getOperador1().startsWith("call "))
                            || (instr.getOperador2() != null && instr.getOperador2().startsWith("call "))) {
                        noModificar = true;
                        break;
                    }
                }
                if (noModificar) {
                    continue; // no es seguro reemplazar
                }
            }

            // Substituimos el temporal por su valor asignado
            Instruccion inst = codigo.get(j);
            if (inst.getOpCode().equals("=")) {
                // Reemplazamos t (x = t) por el valor del temporal
                inst.setOperador2(valor);
            } else {
                // Reemplazamos t en la instrucción binaria/unaria
                if (temp.equals(inst.getOperador1())) {
                    inst.setOperador1(valor);
                }
                if (temp.equals(inst.getOperador2())) {
                    inst.setOperador2(valor);
                }
                if (temp.equals(inst.getResultado())) {
                    inst.setResultado(valor);
                }
            }

            codigo.remove(i); // Eliminar t = x
            registrarCambio("Asignación diferida", i, temp + " eliminado y sustituido por " + valor);
            i--; // Reajustar índice
            cambio = true;
        }

        return cambio;
    }

    private void registrarCambio(String nombreOpt, int linea, String descripcion) {
        cambios.putIfAbsent(nombreOpt, new ArrayList<>());
        cambios.get(nombreOpt).add("Línea " + linea + ": " + descripcion);
    }

    public Map<String, List<String>> getCambios() {
        return cambios;
    }
}
