package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoBreak extends NodoAST {

    public NodoBreak(int linea, int columna) {
        super(linea, columna);
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoBreak (linea: " + linea + ", col: " + columna + ")");
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        // Generador mantiene la etiqueta del fin del bucle actual
        String etiquetaSalida = gen.getBreakLabel();
        if (etiquetaSalida == null) {
            // Si el break está fuera de un bucle, entonces actua como exit (termina la ejecucción del programa)
            codigo.add(new Instruccion("GOTO", "end", null, null));
            return codigo;
        }

        codigo.add(new Instruccion("GOTO", etiquetaSalida, null, null));

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"break\",shape=plaintext];");
        buffer.append("\n");
        out.print(buffer.toString());
    }
}
