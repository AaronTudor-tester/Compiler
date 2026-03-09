package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoDeclaracion extends NodoAST {

    private String identificador;
    private TipoDato tipo;
    private boolean esArray;
    private int numDimensiones;

    public NodoDeclaracion(String id, TipoDato tipo, int linea, int columna) {
        super(linea, columna);
        this.identificador = id;
        this.tipo = tipo;
        this.esArray = false;
        this.numDimensiones = 0;
    }

    // Para arrays
    public NodoDeclaracion(String id, TipoDato tipo, int numDimensiones, int linea, int columna) {
        super(linea, columna);
        this.identificador = id;
        this.tipo = tipo;
        this.esArray = numDimensiones > 0;
        this.numDimensiones = numDimensiones;
    }

    public String getIdentificador() {
        return identificador;
    }

    public TipoDato getTipo() {
        return tipo;
    }

    public boolean esArray() {
        return esArray;
    }

    public int getNumDimensiones() {
        return numDimensiones;
    }

    public TipoParametro getTipoParametro() {
        return new TipoParametro(tipo, numDimensiones);
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoDeclaracion (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Identificador: " + identificador);
        System.out.print(indent + "  Tipo: " + tipo);
        if (esArray) {
            for (int i = 0; i < numDimensiones; i++) {
                System.out.print("[]");
            }
        }
        System.out.println();
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        // Para declaraciones sin inicialización no se genera ninguna instrucción
        return new ArrayList<>();
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"decl: ");
        buffer.append(identificador);
        buffer.append(" (");
        buffer.append(tipo);
        if (esArray) {
            for (int i = 0; i < numDimensiones; i++) {
                buffer.append("[]");
            }
        }
        buffer.append(")\"];");
        buffer.append("\n");
        out.print(buffer.toString());
    }
}
