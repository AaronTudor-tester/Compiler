package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoOperacionUnaria extends NodoExpresion {

    private String operador;
    private NodoExpresion operando;
    private boolean postIncremento;
    private int dimensionesEsp = 0;

    public NodoOperacionUnaria(String op, NodoExpresion opnd, int linea, int columna) {
        super(linea, columna);
        this.operador = op;
        this.operando = opnd;
        postIncremento = false;
    }

    // Establecer cuántas dimensiones se esperan (usado por el parser)
    public void setDimensionesEsp(int d) {
        this.dimensionesEsp = d;
    }

    public String getOperador() {
        return operador;
    }

    public NodoExpresion getOperando() {
        return operando;
    }

    public void esPostIncremento() {
        postIncremento = true;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoOperacionUnaria (linea: " + linea + ", col: " + columna + ")");
        System.out.println(indent + "  Operador: " + operador);
        System.out.println(indent + "  Operando:");
        operando.imprimirAST(indent + "    ");
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        String var;
        // Si es una variable, usamos su nombre directamente
        if (operando instanceof NodoVariable) {
            var = ((NodoVariable) operando).getNombre();
        } else {
            // Si es una expresión, generamos su código y usamos temporal
            codigo.addAll(operando.generarCodigo(gen));
            var = operando.getTemporal();
        }

        switch (operador) {
            case "INCR":
            case "DECR":
                String op = operador.equals("INCR") ? "+" : "-";

                if (postIncremento) {
                    String t = gen.nuevoTemporal();
                    codigo.add(new Instruccion("=", t, var, null));

                    if (operando.getTipo() == TipoDato.FLOAT) {
                        codigo.add(new Instruccion(op, var, "1.0", var));
                    } else {
                        codigo.add(new Instruccion(op, var, "1", var));
                    }
                    // El resultado es el valor antiguo (post)
                    setTemporal(t);
                } else {
                    if (operando.getTipo() == TipoDato.FLOAT) {
                        codigo.add(new Instruccion(op, var, "1.0", var));
                    } else {
                        codigo.add(new Instruccion(op, var, "1", var));
                    }
                    // El resultado es el nuevo valor (pre)
                    setTemporal(var);
                }
                break;

            case "RESTA":
            case "NOT":
                setTemporal(gen.nuevoTemporal());
                String opCode = operador.equals("RESTA") ? "NEG" : "!";
                codigo.add(new Instruccion(opCode, var, null, getTemporal()));
                break;
        }

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"");
        buffer.append(operador);
        buffer.append("\"];");
        buffer.append("\n");

        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(operando.getIndex());
        buffer.append("\n");

        out.print(buffer.toString());

        operando.toDot(out);
    }

}
