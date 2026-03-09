package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoCase extends NodoAST {

    private NodoExpresion valor; // Valor analizado para entrar en el case
    private NodoBloque cuerpo;

    public NodoCase(NodoExpresion valor, NodoBloque cuerpo, int linea, int columna) {
        super(linea, columna);
        this.valor = valor;
        this.cuerpo = cuerpo;
    }

    public NodoExpresion getValor() {
        return valor;
    }

    public NodoBloque getCuerpo() {
        return cuerpo;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoCase (linea: " + linea + ", col: " + columna + ")");

        if (valor != null) {
            System.out.println(indent + "  Valor:");
            valor.imprimirAST(indent + "    ");
        }

        System.out.println(indent + "  Cuerpo:");
        if (cuerpo != null) {
            cuerpo.imprimirAST(indent + "    ");
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        // NodoCase no se genera solo, siempre lo hace NodoSwitch
        return new ArrayList<>();
    }

    public List<Instruccion> generarCodigo(Generador gen, String expresionSwitch, String etiquetaSiguienteCase) {
        List<Instruccion> codigo = new ArrayList<>();

        // Si hay valor, comparamos con el valor de la expresión del switch
        if (valor != null) {
            codigo.addAll(valor.generarCodigo(gen));
            String condicion = expresionSwitch + " != " + valor.getTemporal();
            codigo.add(new Instruccion("IF", condicion, null, etiquetaSiguienteCase));
        }

        // Generamos el código del bloque de sentencias del case
        if (cuerpo != null) {
            codigo.addAll(cuerpo.generarCodigo(gen));
        }

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"case\"];");
        buffer.append("\n");
        
        if (valor != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(valor.getIndex());
            buffer.append("\n");
        }
        
        if (cuerpo != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(cuerpo.getIndex());
            buffer.append("\n");
        }
        
        out.print(buffer.toString());
        
        if (valor != null) {
            valor.toDot(out);
        }
        if (cuerpo != null) {
            cuerpo.toDot(out);
        }
    }
}
