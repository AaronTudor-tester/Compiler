package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.*;
import java.io.PrintWriter;
import java.util.List;

public abstract class NodoAST { // Nodo del AST (Abstract Syntax Tree)

    // Posición del nodo en el código fuente
    protected int linea;
    protected int columna;
    private final int index;
    private static int autoIncrement = 0;

    public NodoAST(int linea, int columna) {
        this.linea = linea;
        this.columna = columna;
        this.index = autoIncrement++;
    }

    public int getIndex() {
        return index;
    }

    public int getLinea() {
        return linea;
    }

    public int getColumna() {
        return columna;
    }

    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoAST (linea: " + linea + ", col: " + columna + ")");
    }

    // Método para generar código intermedio
    public abstract List<Instruccion> generarCodigo(Generador gen);

    // Método para generar archivo .dot (GraphViz)
    public abstract void toDot(PrintWriter out);
}
