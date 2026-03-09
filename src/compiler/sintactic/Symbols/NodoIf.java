package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoIf extends NodoAST {

    private NodoExpresion condicion;
    private NodoBloque entonces;
    private NodoBloque sino;

    public NodoIf(NodoExpresion cond, NodoBloque ent, NodoBloque sin, int linea, int columna) {
        super(linea, columna);
        this.condicion = cond;
        this.entonces = ent;
        this.sino = sin;
    }

    public NodoExpresion getCondicion() {
        return condicion;
    }

    public NodoBloque getEntonces() {
        return entonces;
    }

    public NodoBloque getSino() {
        return sino;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoIf (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Condición:");
        if (condicion != null) {
            condicion.imprimirAST(indent + "    ");
        }
        System.out.println(indent + "  Entonces:");
        if (entonces != null) {
            entonces.imprimirAST(indent + "    ");
        }
        if (sino != null) {
            System.out.println(indent + "  Sino:");
            sino.imprimirAST(indent + "    ");
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        codigo.addAll(condicion.generarCodigo(gen));

        String etiquetaElse = gen.nuevaEtiqueta();
        String etiquetaFin = gen.nuevaEtiqueta();

        // Salto a else si la condición es falsa
        codigo.add(new Instruccion("IF_FALSE", condicion.getTemporal(), null, etiquetaElse));

        // Genera el código del interior del if
        if (entonces != null) {
            codigo.addAll(entonces.generarCodigo(gen));
        }

        codigo.add(new Instruccion("GOTO", etiquetaFin, null, null));
        codigo.add(new Instruccion("LABEL", etiquetaElse, null, null));

        // Genera el código del interior del else (si existe)
        if (sino != null) {
            codigo.addAll(sino.generarCodigo(gen));
        }

        codigo.add(new Instruccion("LABEL", etiquetaFin, null, null));

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"if\"];");
        buffer.append("\n");
        
        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(condicion.getIndex());
        buffer.append("\n");
        
        if (entonces != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(entonces.getIndex());
            buffer.append("\n");
        }
        
        if (sino != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(sino.getIndex());
            buffer.append("\n");
        }
        
        out.print(buffer.toString());
        
        condicion.toDot(out);
        if (entonces != null) {
            entonces.toDot(out);
        }
        if (sino != null) {
            sino.toDot(out);
        }
    }
}
