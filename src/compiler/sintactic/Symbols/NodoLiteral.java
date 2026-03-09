package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoLiteral extends NodoExpresion {

    private Object valor;

    public NodoLiteral(Object valor, TipoDato tipo, int linea, int columna) {
        super(linea, columna);
        this.valor = valor;
        this.tipo = tipo;
    }

    public Object getValor() {
        return valor;
    }

    @Override
    public String toString() {
        return String.valueOf(valor);
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoLiteral (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Tipo: " + tipo + ", Valor: " + valor);
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();
        if (valor != null) {
            if(this.getTipo() == TipoDato.FLOAT && !String.valueOf(valor).contains(".")) {
                valor = valor + ".0";
            }
            // Para strings NO crear temporal, usar la etiqueta directamente
            if (tipo == TipoDato.STRING) {
                // El valor ya es la etiqueta (str0, str1, etc) del generador 68K
                setTemporal(valor.toString());  // Usar directamente la etiqueta
            } else if (tipo == TipoDato.CHAR) {

                setTemporal(gen.nuevoTemporal());
                int ascii = (int) ((Character) valor);
                codigo.add(new Instruccion("=", getTemporal(), String.valueOf(ascii), null));

            } else {
                // Para otros tipos, crear un temporal
                setTemporal(gen.nuevoTemporal());
                codigo.add(new Instruccion("=", getTemporal(), valor.toString(), null));
            }
        }
        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"");

        // Si el valor es una cadena con comillas, remover las comillas externas
        if (valor != null) {
            String valorStr = valor.toString();
            if (tipo == TipoDato.STRING && valorStr.startsWith("\"") && valorStr.endsWith("\"")) {
                valorStr = valorStr.substring(1, valorStr.length() - 1);
            }
            buffer.append(valorStr);
        } else {
            buffer.append("null");
        }

        buffer.append("\",shape=plaintext];");
        buffer.append("\n");
        out.print(buffer.toString());
    }
}
