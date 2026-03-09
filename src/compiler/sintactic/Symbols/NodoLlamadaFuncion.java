package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.*;
import java.util.ArrayList;
import java.util.List;

public class NodoLlamadaFuncion extends NodoExpresion {

    private String nombre;
    private List<NodoExpresion> args;

    public NodoLlamadaFuncion(String nombre, List<NodoExpresion> args, int l, int c) {
        super(l, c);
        this.nombre = nombre;
        this.args = args;
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        // Calculamos los argumentos (si hay)
        List<String> temporalesArgs = new ArrayList<>();
        List<NodoAccesoArray> arrayArgs = new ArrayList<>(); // Para guardar información de arrays 
        
        if (args != null) {
            for (NodoExpresion arg : args) {
                if (arg.getClass() == NodoVariable.class) {
                    // Solo guardamos el nombre si es una variable normal
                    NodoVariable varArg = (NodoVariable) arg;
                    temporalesArgs.add(varArg.getNombre());
                    arrayArgs.add(null);
                } else if (arg.getClass() == NodoAccesoArray.class) {
                    codigo.addAll(arg.generarCodigo(gen));
                    temporalesArgs.add(arg.getTemporal());
                    arrayArgs.add((NodoAccesoArray) arg); // Es un array
                } else {
                    // Si es una expresión, generamos su código
                    codigo.addAll(arg.generarCodigo(gen));
                    temporalesArgs.add(arg.getTemporal());
                    arrayArgs.add(null);
                }
            }
        }

        // Generamos el código de los parámetros
        for (int i = 0; i < temporalesArgs.size(); i++) {
            String t = temporalesArgs.get(i);
            codigo.add(new Instruccion("param_s", t, null, null));
            
            // Generamos param_dim para accesos a arrays 
            if (arrayArgs.get(i) != null) {
                NodoAccesoArray arrayArg = arrayArgs.get(i);
                codigo.add(new Instruccion("param_dim", arrayArg.getId(), null, null));
            }
        }

        // Generamos la llamada a la función
        if (this.getTipo() != TipoDato.VOID) {
            this.setTemporal(gen.nuevoTemporal()); // Asignamos el resultado a un temporal
            codigo.add(new Instruccion("=", this.getTemporal(), "call " + nombre, null));
        } else {
            codigo.add(new Instruccion("call", nombre, null, null));
        }

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"call: ");
        buffer.append(nombre);
        buffer.append("\"];");
        buffer.append("\n");
        
        if (args != null) {
            for (NodoExpresion arg : args) {
                buffer.append(this.getIndex());
                buffer.append("->");
                buffer.append(arg.getIndex());
                buffer.append("\n");
            }
        }
        
        out.print(buffer.toString());
        
        if (args != null) {
            for (NodoExpresion arg : args) {
                arg.toDot(out);
            }
        }
    }
}
