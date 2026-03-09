package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoTernario extends NodoExpresion {

    private NodoExpresion condicion;
    private NodoExpresion exprTrue;
    private NodoExpresion exprFalse;

    public NodoTernario(NodoExpresion c, NodoExpresion t, NodoExpresion f, int linea, int columna) {
        super(linea, columna);
        this.condicion = c;
        this.exprTrue = t;
        this.exprFalse = f;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoTernario (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Condición:");
        condicion.imprimirAST(indent + "    ");
        System.out.println(indent + "  Verdadero:");
        exprTrue.imprimirAST(indent + "    ");
        System.out.println(indent + "  Falso:");
        exprFalse.imprimirAST(indent + "    ");
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        String etiquetaFalso = gen.nuevaEtiqueta();
        String etiquetaFin = gen.nuevaEtiqueta();
        setTemporal(gen.nuevoTemporal());

        codigo.addAll(condicion.generarCodigo(gen));

        codigo.add(new Instruccion("IF_FALSE", condicion.getTemporal(), null, etiquetaFalso));

        // Si es verdadero
        codigo.addAll(exprTrue.generarCodigo(gen));
        codigo.add(new Instruccion("=", getTemporal(), exprTrue.getTemporal(), null));
        codigo.add(new Instruccion("GOTO", etiquetaFin, null, null));

        // Si es falso
        codigo.add(new Instruccion("LABEL", etiquetaFalso, null, null));
        codigo.addAll(exprFalse.generarCodigo(gen));
        codigo.add(new Instruccion("=", getTemporal(), exprFalse.getTemporal(), null));

        codigo.add(new Instruccion("LABEL", etiquetaFin, null, null));

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();

        buffer.append(this.getIndex());
        buffer.append("\t[label=\"?:\"]");
        buffer.append("\n");

        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(condicion.getIndex());
        buffer.append("\n");

        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(exprTrue.getIndex());
        buffer.append("\n");

        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(exprFalse.getIndex());
        buffer.append("\n");

        out.print(buffer.toString());

        condicion.toDot(out);
        exprTrue.toDot(out);
        exprFalse.toDot(out);
    }

}
