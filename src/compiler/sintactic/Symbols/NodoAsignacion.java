package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.*;
import java.util.*;

public class NodoAsignacion extends NodoExpresion {

    private String identificador; // Nombre de la variable asignada
    private NodoExpresion expresion; // Expresion que se asigna al identificador

    public NodoAsignacion(String id, NodoExpresion expr, int linea, int columna) {
        super(linea, columna);
        this.identificador = id;
        this.expresion = expr;
    }

    public String getIdentificador() {
        return identificador;
    }

    public NodoExpresion getExpresion() {
        return expresion;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoAsignacion (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Identificador: " + identificador);
        if (expresion != null) {
            System.out.println(indent + "  Expresion:");
            expresion.imprimirAST(indent + "    ");
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();
        codigo.addAll(expresion.generarCodigo(gen));
        codigo.add(new Instruccion("=", identificador, expresion.getTemporal(), null));
        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"=");
        buffer.append("(");
        buffer.append(identificador);
        buffer.append(")\"]");
        buffer.append("\n");
        
        if (expresion != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(expresion.getIndex());
            buffer.append("\n");
        }
        
        out.print(buffer.toString());
        
        if (expresion != null) {
            expresion.toDot(out);
        }
    }
}
 