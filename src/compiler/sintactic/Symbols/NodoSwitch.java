package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoSwitch extends NodoAST {

    private NodoExpresion expresion;
    private List<NodoCase> casos;

    public NodoSwitch(NodoExpresion expresion, List<NodoCase> casos, int linea, int columna) {
        super(linea, columna);
        this.expresion = expresion;
        this.casos = casos;
    }

    public NodoExpresion getExpresion() {
        return expresion;
    }

    public List<NodoCase> getCasos() {
        return casos;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoSwitch (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Expresion:");
        expresion.imprimirAST(indent + "    ");

        if (casos != null) {
            for (NodoCase c : casos) {
                if (c.getValor() == null) {
                    System.out.println(indent + "  Default:");
                } else {
                    System.out.println(indent + "  Case:");
                }
                c.imprimirAST(indent + "    ");
            }
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        codigo.addAll(expresion.generarCodigo(gen));
        String expresionSwitch = expresion.getTemporal(); // temporal que contiene el resultado de la expresión del switch

        String etiquetaFinSwitch = gen.nuevaEtiqueta();
        gen.pushBreakLabel(etiquetaFinSwitch); // Guardamos la etiqueta de fin de switch para los breaks

        // Generamos etiquetas para cada case (menos el primero)
        List<String> etiquetasCase = new ArrayList<>();
        etiquetasCase.add(null); // El primer case no necesita etiqueta
        for (int i = 1; i < casos.size(); i++) {
            etiquetasCase.add(gen.nuevaEtiqueta());
        }

        // Generamos el código de cada case
        for (int i = 0; i < casos.size(); i++) {
            NodoCase c = casos.get(i);

            if (i > 0) codigo.add(new Instruccion("LABEL", etiquetasCase.get(i), null, null));

            String etiquetaSiguiente = (i + 1 < casos.size()) ? etiquetasCase.get(i + 1) : etiquetaFinSwitch;

            codigo.addAll(c.generarCodigo(gen, expresionSwitch, etiquetaSiguiente));
        }

        gen.popBreakLabel(); // Sacamos la etiqueta de fin de switch
        codigo.add(new Instruccion("LABEL", etiquetaFinSwitch, null, null));

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"switch\"];");
        buffer.append("\n");
        
        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(expresion.getIndex());
        buffer.append("\n");
        
        if (casos != null) {
            for (NodoCase caso : casos) {
                buffer.append(this.getIndex());
                buffer.append("->");
                buffer.append(caso.getIndex());
                buffer.append("\n");
            }
        }
        
        out.print(buffer.toString());
        
        expresion.toDot(out);
        if (casos != null) {
            for (NodoCase caso : casos) {
                caso.toDot(out);
            }
        }
    }
}
