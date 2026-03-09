package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoWhile extends NodoAST {

    private NodoExpresion condicion;
    private NodoBloque cuerpo;

    public NodoWhile(NodoExpresion cond, NodoBloque cuerpo, int linea, int columna) {
        super(linea, columna);
        this.condicion = cond;
        this.cuerpo = cuerpo;
    }

    public NodoExpresion getCondicion() {
        return condicion;
    }

    public NodoBloque getCuerpo() {
        return cuerpo;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoWhile (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Condición:");
        condicion.imprimirAST(indent + "    ");
        System.out.println(indent + "  Cuerpo:");
        cuerpo.imprimirAST(indent + "    ");
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        String etiquetaInicio = gen.nuevaEtiqueta();
        String etiquetaFin = gen.nuevaEtiqueta();

        codigo.add(new Instruccion("LABEL", etiquetaInicio, null, null));

        // Salimos del bucle si la condición es falsa
        codigo.addAll(condicion.generarCodigo(gen));
        codigo.add(new Instruccion("IF_FALSE", condicion.getTemporal(), null, etiquetaFin));

        codigo.addAll(cuerpo.generarCodigo(gen));

        codigo.add(new Instruccion("GOTO", etiquetaInicio, null, null));
        codigo.add(new Instruccion("LABEL", etiquetaFin, null, null));

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"while\"];");
        buffer.append("\n");
        
        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(condicion.getIndex());
        buffer.append("\n");
        
        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(cuerpo.getIndex());
        buffer.append("\n");
        
        out.print(buffer.toString());
        
        condicion.toDot(out);
        cuerpo.toDot(out);
    }
}
