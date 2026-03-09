package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoReturn extends NodoAST {

    private NodoExpresion expresion; // Valor devuelto

    public NodoReturn(NodoExpresion expr, int linea, int columna) {
        super(linea, columna);
        this.expresion = expr;
    }

    public NodoExpresion getExpresion() {
        return expresion;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoReturn (linea: " + linea + ", col: " + columna + ")");
        if (expresion != null) {
            System.out.println(indent + "  Expresion:");
            expresion.imprimirAST(indent + "    ");
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        if (expresion != null) {
            codigo.addAll(expresion.generarCodigo(gen));
            codigo.add(new Instruccion("RETURN", expresion.getTemporal(), null, null));
        } else {
            // Devuelve void
            codigo.add(new Instruccion("RETURN", null, null, null));
        }

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"return\"];");
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
