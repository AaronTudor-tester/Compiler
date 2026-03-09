package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoInput extends NodoAST {

    private String identificador; // Variable donde se guarda el valor leido
    private TipoDato tipo; // Tipo de la variable

    public NodoInput(String id, TipoDato tipo, int linea, int columna) {
        super(linea, columna);
        this.identificador = id;
        this.tipo = tipo;
    }

    public String getVariable() {
        return identificador;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoInput (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Variable: " + identificador);
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();
        codigo.add(new Instruccion("READ", identificador, null, null, tipo.name()));
        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"input(");
        buffer.append(identificador);
        buffer.append(")\"];");
        buffer.append("\n");
        out.print(buffer.toString());
    }
}
