package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.*;
import java.util.ArrayList;
import java.util.List;

public class NodoBloque extends NodoAST {

    private List<NodoAST> sentencias;
    private BloqueActivacion bloqueActivacion;

    public NodoBloque(List<NodoAST> sentencias, BloqueActivacion bloque, int linea, int columna) {
        super(linea, columna);
        this.sentencias = sentencias;
        this.bloqueActivacion = bloque;
    }

    public BloqueActivacion getBloqueActivacion() {
        return bloqueActivacion;
    }

    public List<NodoAST> getSentencias() {
        return sentencias;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoBloque:");
        if (sentencias != null) {
            for (NodoAST s : sentencias) {
                s.imprimirAST(indent + "  ");
            }
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();
        if (sentencias != null) {
            for (NodoAST s : sentencias) {
                codigo.addAll(s.generarCodigo(gen));
            }
        }
        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"Bloque\"];");
        buffer.append("\n");
        
        if (sentencias != null) {
            for (NodoAST nodo : sentencias) {
                buffer.append(this.getIndex());
                buffer.append("->");
                buffer.append(nodo.getIndex());
                buffer.append("\n");
            }
        }
        
        out.print(buffer.toString());
        
        if (sentencias != null) {
            for (NodoAST nodo : sentencias) {
                nodo.toDot(out);
            }
        }
    }
}
