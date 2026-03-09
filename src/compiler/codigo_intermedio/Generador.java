/**
 * Assignatura 21780 Compiladors
 * Estudis de Grau en Informàtica
 * Professor: Pere Palmer
 * Autors: Teletubbies sospechosos
 */
package compiler.codigo_intermedio;

import java.util.Stack;

public class Generador {

    private int tCount = 0;
    private int eCount = 0;

    // Pilas para manejar etiquetas de salida de bucles (break / continue)
    private Stack<String> breakStack = new Stack<>();
    private Stack<String> continueStack = new Stack<>();

    // Genera una nueva variable temporal
    public String nuevoTemporal() {
        return "t" + (tCount++);
    }

    // Genera una nueva etiqueta
    public String nuevaEtiqueta() {
        return "e" + (eCount++);
    }

    // Genera una nueva etiqueta personalizada
    public String nuevaEtiqueta(String nombre) {
        return "e_" + nombre;
    }

    // Genera una nueva etiqueta para el programa principal
    public String nuevaEtiqueta(boolean inicioMain) {
        if(inicioMain) return "main";
        else return "end";
    }

    // Push de etiqueta de salida de bucle (break)
    public void pushBreakLabel(String label) {
        breakStack.push(label);
    }

    // Pop de etiqueta de salida de bucle (break)
    public void popBreakLabel() {
        if (!breakStack.isEmpty()) {
            breakStack.pop();
        }
    }

    // Obtener la etiqueta de salida actual (break)
    public String getBreakLabel() {
        if (breakStack.isEmpty()) {
            return null;
        }
        return breakStack.peek();
    }

    // Push de etiqueta de continue de bucle
    public void pushContinueLabel(String label) {
        continueStack.push(label);
    }

    // Pop de etiqueta de continue de bucle
    public void popContinueLabel() {
        if (!continueStack.isEmpty()) {
            continueStack.pop();
        }
    }

    // Obtener la etiqueta de continue actual
    public String getContinueLabel() {
        if (continueStack.isEmpty()) {
            return null;
        }
        return continueStack.peek();
    }
}
