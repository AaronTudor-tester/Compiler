package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoVariable extends NodoExpresion {

    private String nombre;
    private Object valor; // Valor conocido de la variable
    private int dimensionesEsp = 0;

    public NodoVariable(String nombre, int linea, int columna) {
        super(linea, columna);
        this.nombre = nombre;
    }

    // Establecer cuántas dimensiones se esperan (usado por el parser)
    public void setDimensionesEsp(int d) {
        this.dimensionesEsp = d;
    }

    public String getNombre() {
        return nombre;
    }

    public void setValor(Object valor) {
        this.valor = valor;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoVariable (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Nombre: " + nombre);
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();
        setTemporal(gen.nuevoTemporal());
        codigo.add(new Instruccion("=", getTemporal(), nombre, null));

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"");
        buffer.append(nombre);
        buffer.append("\",shape=plaintext];");
        buffer.append("\n");
        out.print(buffer.toString());
    }

}
