/**
 * Assignatura 21780 Compiladors
 * Estudis de Grau en Informàtica
 * Professor: Pere Palmer
 * Autors: Teletubbies sospechosos
 */
package compiler.codigo_intermedio;

public class Instruccion {

    private String opCode;
    private String operador1;
    private String operador2;
    private String resultado;
    private String tipo; // Tipo de dato para PRINT, READ, etc.

    public Instruccion(String opCode, String op1, String op2, String res) {
        this.opCode = opCode;
        operador1 = op1;
        operador2 = op2;
        resultado = res;
        this.tipo = null;
    }

    // Constructor con tipo
    public Instruccion(String opCode, String op1, String op2, String res, String tipo) {
        this.opCode = opCode;
        operador1 = op1;
        operador2 = op2;
        resultado = res;
        this.tipo = tipo;
    }

    @Override
    public String toString() {

        switch (opCode) {

            // Operaciones binarias
            case "+":
            case "-":
            case "*":
            case "/":
            case "%":
            case "&&":
            case "||":
            case "XOR":
            case "<":
            case ">":
            case "<=":
            case ">=":
            case "==":
            case "!=":
                return resultado + " = " + operador1 + " " + opCode + " " + operador2;

            // Operaciones unarias
            case "!":
            case "NEG":
                return resultado + " = " + opCode + " " + operador1;

            // Asignación
            case "=":
                return operador1 + " = " + operador2;

            // Saltos
            case "GOTO":
                return "goto " + operador1;
            case "IF":
                return "if " + operador1 + " goto " + resultado;
            case "IF_FALSE":
                return "if !(" + operador1 + ") goto " + resultado;

            // Etiqueta
            case "LABEL":
                return operador1 + ":";

            // Entrada / Salida (Según he visto en las diapositivas, para READ Y PRINT se debería poner "param_s" tx y luego call npread / npprint)
            case "READ":
                return "input " + operador1;
            case "PRINT":
                return "output " + operador1;

            // Return
            case "RETURN":
                return "return " + operador1;
            

            case "IND_VAL": 
                return resultado + " = " + operador1 + '[' + operador2 + ']';
            case "IND_ASS":
                return resultado + '[' + operador2 + "] = " + operador1;
            case "ALLOC":
                return "";
            case "PARAM_TYPE":
                return "; param " + operador1 + " : " + tipo;

            default:
                return opCode + " "
                        + (operador1 != null ? operador1 : "") + " "
                        + (operador2 != null ? operador2 : "") + " "
                        + (resultado != null ? resultado : "");
        }
    }

    public String getOpCode() {
        return opCode;
    }

    public String getOperador1() {
        return operador1;
    }

    public String getOperador2() {
        return operador2;
    }

    public String getResultado() {
        return resultado;
    }

    public String getTipo() {
        return tipo;
    }

    public void setOpCode(String opCode) {
        this.opCode = opCode;
    }

    public void setOperador1(String operador1) {
        this.operador1 = operador1;
    }

    public void setOperador2(String operador2) {
        this.operador2 = operador2;
    }

    public void setResultado(String resultado) {
        this.resultado = resultado;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }
}
