package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.*;
import java.util.ArrayList;
import java.util.List;

public class NodoPrograma extends NodoAST {

    private final List <NodoAST> definiciones;
    private final List<NodoAST> sentencias;

    public NodoPrograma(List<NodoAST> definiciones, List<NodoAST> sentencias, int linea, int columna) {
        super(linea, columna);
        this.definiciones = definiciones;
        this.sentencias = sentencias;    
    }

    public List<NodoAST> getDefiniciones() {
        return definiciones;
    }
    public List<NodoAST> getSentencias() {
        return sentencias;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoPrograma (linea: " + linea + ", col: " + columna + ")");
        // Imprime las definiciones (funciones / variables)
        if (definiciones != null) {
            for (NodoAST hijo : definiciones) {
                hijo.imprimirAST(indent + "--");
            }
        }
        // Imprime todos los hijos / sentencias
        if (sentencias != null) {
            for (NodoAST hijo : sentencias) {
                hijo.imprimirAST(indent + "--");
            }
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        // Recorremos todas las definiciones y generamos su código
        if (definiciones != null) {
            for (NodoAST s : definiciones) {
                codigo.addAll(s.generarCodigo(gen));
            }
        }

        // Etiqueta de inicio del programa principal
        gen.nuevaEtiqueta(true);
        codigo.add(new Instruccion("LABEL", "main", null, null));

        // Recorremos todas las sentencias y generamos su código
        for (NodoAST s : sentencias) {
            codigo.addAll(s.generarCodigo(gen));
        }

        // Etiqueta de final del programa principal
        gen.nuevaEtiqueta(false);
        codigo.add(new Instruccion("LABEL", "end", null, null));

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"Programa\"];");
        buffer.append("\n");
        
        if (definiciones != null) {
            for (NodoAST nodo : definiciones) {
                buffer.append(this.getIndex());
                buffer.append("->");
                buffer.append(nodo.getIndex());
                buffer.append("\n");
            }
        }
        
        if (sentencias != null) {
            for (NodoAST nodo : sentencias) {
                buffer.append(this.getIndex());
                buffer.append("->");
                buffer.append(nodo.getIndex());
                buffer.append("\n");
            }
        }
        
        out.print(buffer.toString());
        
        if (definiciones != null) {
            for (NodoAST nodo : definiciones) {
                nodo.toDot(out);
            }
        }
        
        if (sentencias != null) {
            for (NodoAST nodo : sentencias) {
                nodo.toDot(out);
            }
        }
    }
}
