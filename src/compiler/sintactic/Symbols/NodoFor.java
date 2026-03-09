package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoFor extends NodoAST {

    private NodoAsignacion inicializacion; // Inicializacion de la variable del for
    private NodoExpresion condicion; // Condicion para continuar en el for
    private NodoExpresion incremento; // Incremento para cada iteracion
    private NodoBloque cuerpo;

    public NodoFor(NodoAsignacion init, NodoExpresion cond,
            NodoExpresion inc, NodoBloque cuerpo, int linea, int columna) {
        super(linea, columna);
        this.inicializacion = init;
        this.condicion = cond;
        this.incremento = inc;
        this.cuerpo = cuerpo;
    }

    public NodoAsignacion getInicializacion() {
        return inicializacion;
    }

    public NodoExpresion getCondicion() {
        return condicion;
    }

    public NodoExpresion getIncremento() {
        return incremento;
    }

    public NodoBloque getCuerpo() {
        return cuerpo;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoFor (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Inicialización:");
        if (inicializacion != null) {
            inicializacion.imprimirAST(indent + "    ");
        }
        System.out.println(indent + "  Condición:");
        if (condicion != null) {
            condicion.imprimirAST(indent + "    ");
        }
        System.out.println(indent + "  Incremento:");
        if (incremento != null) {
            incremento.imprimirAST(indent + "    ");
        }
        System.out.println(indent + "  Cuerpo:");
        if (cuerpo != null) {
            cuerpo.imprimirAST(indent + "    ");
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        if (inicializacion != null) {
            codigo.addAll(inicializacion.generarCodigo(gen));
        }

        String inicio = gen.nuevaEtiqueta();
        String fin = gen.nuevaEtiqueta();

        gen.pushBreakLabel(fin);
        gen.pushContinueLabel(inicio);

        codigo.add(new Instruccion("LABEL", inicio, null, null));

        if (condicion != null) {
            // Salimos del bucle si la condición es falsa
            codigo.addAll(condicion.generarCodigo(gen));
            codigo.add(new Instruccion("IF_FALSE", condicion.getTemporal(), null, fin));
        }

        if (cuerpo != null) {
            codigo.addAll(cuerpo.generarCodigo(gen));
        }

        if (incremento != null) {
            codigo.addAll(incremento.generarCodigo(gen));
        }

        codigo.add(new Instruccion("GOTO", inicio, null, null));
        codigo.add(new Instruccion("LABEL", fin, null, null));

        // Limpiar etiquetas
        gen.popBreakLabel();
        gen.popContinueLabel();

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"for\"];");
        buffer.append("\n");
        
        if (inicializacion != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(inicializacion.getIndex());
            buffer.append("\n");
        }
        
        if (condicion != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(condicion.getIndex());
            buffer.append("\n");
        }
        
        if (incremento != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(incremento.getIndex());
            buffer.append("\n");
        }
        
        if (cuerpo != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(cuerpo.getIndex());
            buffer.append("\n");
        }
        
        out.print(buffer.toString());
        
        if (inicializacion != null) {
            inicializacion.toDot(out);
        }
        if (condicion != null) {
            condicion.toDot(out);
        }
        if (incremento != null) {
            incremento.toDot(out);
        }
        if (cuerpo != null) {
            cuerpo.toDot(out);
        }
    }
}
