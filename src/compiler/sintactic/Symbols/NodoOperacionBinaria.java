package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoOperacionBinaria extends NodoExpresion {

    private String operador;
    private NodoExpresion izquierda;
    private NodoExpresion derecha;
    private int dimensionesEsp = 0;

    public NodoOperacionBinaria(String op, NodoExpresion izq, NodoExpresion der,
            int linea, int columna) {
        super(linea, columna);
        this.operador = op;
        this.izquierda = izq;
        this.derecha = der;
    }

    // Establecer cuántas dimensiones se esperan (usado por el parser)
    public void setDimensionesEsp(int d) {
        this.dimensionesEsp = d;
    }

    public String getOperador() {
        return operador;
    }

    public NodoExpresion getIzquierda() {
        return izquierda;
    }

    public NodoExpresion getDerecha() {
        return derecha;
    }

    @Override
    public void setTipo(TipoDato tipo) {
        this.tipo = tipo;
        izquierda.tipo = tipo;
        derecha.tipo = tipo;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoOperacionBinaria (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Operador: " + operador);
        System.out.println(indent + "  Izquierda:");
        izquierda.imprimirAST(indent + "    ");
        System.out.println(indent + "  Derecha:");
        derecha.imprimirAST(indent + "    ");
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        codigo.addAll(izquierda.generarCodigo(gen));
        codigo.addAll(derecha.generarCodigo(gen));

        setTemporal(gen.nuevoTemporal());

        String opCode;

        switch (operador) {
            case "SUMA":
                opCode = "+";
                break;
            case "RESTA":
                opCode = "-";
                break;
            case "PROD":
                opCode = "*";
                break;
            case "DIV":
                opCode = "/";
                break;
            case "MOD":
                opCode = "%";
                break;
            case "IGUAL":
                opCode = "==";
                break;
            case "DIST":
                opCode = "!=";
                break;
            case "MENOR":
                opCode = "<";
                break;
            case "MAYOR":
                opCode = ">";
                break;
            case "MEIGUAL":
                opCode = "<=";
                break;
            case "MAIGUAL":
                opCode = ">=";
                break;
            case "AND":
                opCode = "&&";
                break;
            case "OR":
                opCode = "||";
                break;
            case "XOR":
                opCode = "XOR";
                break;
            default:
                opCode = null;
        }

        codigo.add(new Instruccion(opCode, izquierda.getTemporal(), derecha.getTemporal(), getTemporal()));

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"");
        buffer.append(operador);
        buffer.append("\"];\n");
        
        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(izquierda.getIndex());
        buffer.append("\n");
        
        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(derecha.getIndex());
        buffer.append("\n");
        
        out.print(buffer.toString());
        
        izquierda.toDot(out);
        derecha.toDot(out);
    }
}
