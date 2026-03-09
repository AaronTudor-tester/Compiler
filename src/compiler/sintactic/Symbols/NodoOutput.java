package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoOutput extends NodoAST {

    private NodoExpresion expresion; // Expresion para mostrar como output
    private boolean conSaltoLinea; // Si debe añadir salto de línea al final

    public NodoOutput(NodoExpresion expr, boolean conSaltoLinea, int linea, int columna) {
        super(linea, columna);
        this.expresion = expr;
        this.conSaltoLinea = conSaltoLinea;
    }

    public NodoExpresion getExpresion() {
        return expresion;
    }

    public boolean getConSaltoLinea() {
        return conSaltoLinea;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoOutput (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Expresion:");
        expresion.imprimirAST(indent + "    ");
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
  
        List<Instruccion> codigo = new ArrayList<>();
        codigo.addAll(expresion.generarCodigo(gen));
        Instruccion printInstr = new Instruccion("PRINT", expresion.getTemporal(), null, null, expresion.getTipo().toString());
        codigo.add(printInstr);
        
        if (conSaltoLinea) {
            Instruccion newlineInstr = new Instruccion("PRINT", "\"\\n\"", null, null, "STRING");
            codigo.add(newlineInstr);
        }

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"print\"];");
        buffer.append("\n");
        
        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(expresion.getIndex());
        buffer.append("\n");
        
        out.print(buffer.toString());
        
        expresion.toDot(out);
    }
}
