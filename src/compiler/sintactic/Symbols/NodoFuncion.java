package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.*;
import java.util.*;

public class NodoFuncion extends NodoAST {

    private TipoDato tipoRetorno;
    private String nombre;
    private List<NodoDeclaracion> parametros;
    private NodoBloque sentencias;
    private int dimensionesRetorno;

    public NodoFuncion(TipoDato tipo, String nombre, List<NodoDeclaracion> params, NodoBloque sentencias, int linea, int columna) {
        super(linea, columna);
        this.tipoRetorno = tipo;
        this.nombre = nombre;
        this.parametros = params;
        this.sentencias = sentencias;
        this.dimensionesRetorno = 0;
    }

    public String getNombre() {
        return nombre;
    }

    public TipoDato getTipoRetorno() {
        return tipoRetorno;
    }

    public List<NodoDeclaracion> getParametros() {
        return parametros;
    }

    public NodoBloque getSentencias() {
        return sentencias;
    }

    public void setDimensionesRetorno(int dimensiones) {
        this.dimensionesRetorno = dimensiones;
    }

    public int getDimensionesRetorno() {
        return dimensionesRetorno;
    }

    public String validarReturns() {
        if (sentencias == null) {
            return null;
        }

        List<NodoReturn> returns = buscarReturns(sentencias);

        // Las funciones VOID no pueden tener return
        if (tipoRetorno == TipoDato.VOID && !returns.isEmpty()) {
            return "La función '" + nombre + "' es de tipo VOID y no puede contener sentencias 'devuelve'";
        }

        // Las funciones que no sean VOID deben tener al menos un return en todos los caminos
        if (tipoRetorno != TipoDato.VOID) {
            if (returns.isEmpty()) {
                return "La función '" + nombre + "' debe devolver un valor de tipo " + tipoRetorno;
            }

            // Comprobar que el bloque garantiza return en todos los caminos
            if (!garantizaReturn(this.sentencias)) {
                return "La función '" + nombre + "' no garantiza un 'devuelve' en todos los caminos de ejecución";
            }

            // Comprobar que el tipo del return coincida con el tipo de la función
            for (NodoReturn ret : returns) {
                if (ret.getExpresion() != null) {
                    NodoExpresion expr = ret.getExpresion();
                    TipoDato tipoReturn = expr.getTipo();
                    
                    if (this.dimensionesRetorno > 0 && !expr.isArray()) {
                        return "La función '" + nombre + "' declara devolver un ARRAY, pero el return es un valor simple.";
                    }

                    if (this.dimensionesRetorno == 0 && expr.isArray()) {
                        return "La función '" + nombre + "' declara devolver un valor simple, pero el return es un ARRAY.";
                    }
                    if (this.dimensionesRetorno != expr.getDimensionesEsp()) {
                        return "Las dimensiones del array esperadas [" + dimensionesRetorno +"], no coinciden con las dimensiones declaradas[" + expr.getDimensionesEsp()+']';
                    }
                    if (tipoReturn != tipoRetorno) {
                        if (!(tipoRetorno == TipoDato.FLOAT && tipoReturn == TipoDato.INT)) {
                            return "El return debe ser de tipo " + tipoRetorno + " pero es " + tipoReturn;
                        }
                    }
                } else {
                    // return sin expresión
                    return "El return en la función '" + nombre + "' debe devolver un valor de tipo " + tipoRetorno;
                }
            }
        }

        return null;
    }

    // Comprueba si un bloque garantiza return
    private boolean garantizaReturn(NodoBloque bloque) {
        if (bloque == null) {
            return false;
        }
        List<NodoAST> sents = bloque.getSentencias();
        if (sents == null || sents.isEmpty()) {
            return false;
        }

        // si encontramos una sentencia que garantiza return, el bloque garantiza return
        for (NodoAST s : sents) {
            if (garantizaReturn(s)) {
                return true;
            }
        }
        return false;
    }

    // Comprueba si una sentencia garantiza return en todos los caminos
    private boolean garantizaReturn(NodoAST nodo) {
        if (nodo == null) {
            return false;
        }

        // Return explícito
        if (nodo instanceof NodoReturn) {
            return true;
        }

        // comprobamos el contenido si es un bloque
        if (nodo instanceof NodoBloque) {
            return garantizaReturn((NodoBloque) nodo);
        }

        // Si tenemos IF, tanto 'if' como 'else' deben existir y garantizar return
        if (nodo instanceof NodoIf) {
            NodoIf nodoIf = (NodoIf) nodo;
            NodoAST entonces = nodoIf.getEntonces();
            NodoAST sino = nodoIf.getSino();

            if (sino == null) {
                return false;
            }

            return garantizaReturn(entonces) && garantizaReturn(sino);
        }

        return false;
    }

    // Busca recursivamente todos los nodos NodoReturn dentro del bloque
    private List<NodoReturn> buscarReturns(NodoBloque bloque) {
        List<NodoReturn> returns = new ArrayList<>();
        if (bloque == null) {
            return returns;
        }

        List<NodoAST> sentencias = bloque.getSentencias();
        if (sentencias == null) {
            return returns;
        }

        for (NodoAST sentencia : sentencias) {
            encontrarReturn(sentencia, returns);
        }
        return returns;
    }

    // Procesa sentencias y añade los NodoReturn encontrados
    private void encontrarReturn(NodoAST nodo, List<NodoReturn> returns) {
        if (nodo == null) {
            return;
        }

        if (nodo instanceof NodoReturn) {
            returns.add((NodoReturn) nodo);
            return;
        }

        if (nodo instanceof NodoBloque) {
            returns.addAll(buscarReturns((NodoBloque) nodo));
            return;
        }

        if (nodo instanceof NodoIf) {
            NodoIf nodoIf = (NodoIf) nodo;
            // rama if
            NodoAST entonces = nodoIf.getEntonces();
            encontrarReturn(entonces, returns);
            // rama else
            NodoAST sino = nodoIf.getSino();
            encontrarReturn(sino, returns);
            return;
        }

        // Ignorar returns dentro de bucles
        if (nodo instanceof NodoWhile || nodo instanceof NodoRepeat || nodo instanceof NodoFor) {
            return;
        }

        if (nodo instanceof NodoSwitch) {
            NodoSwitch nodoSwitch = (NodoSwitch) nodo;

            for (NodoCase caso : nodoSwitch.getCasos()) {
                returns.addAll(buscarReturns(caso.getCuerpo()));
            }
        }
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoFuncion: " + nombre + " (Devuelve: " + tipoRetorno + ")");

        System.out.println(indent + "  Parametros:");
        if (parametros.isEmpty()) {
            System.out.println(indent + "    (Vacio)");
        } else {
            for (NodoDeclaracion param : parametros) {
                param.imprimirAST(indent + "    ");
            }
        }

        System.out.println(indent + "  Sentencias:");
        if (sentencias != null) {
            sentencias.imprimirAST(indent + "    ");
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        // Generamos la etiqueta de la función
        gen.nuevaEtiqueta(nombre);
        codigo.add(new Instruccion("LABEL", nombre, null, null));

        // Generamos el código para los parámetros, marcando su tipo
        for (NodoDeclaracion param : parametros) {
            // Añadir instrucción PARAM_TYPE para indicar el tipo del parámetro
            String tipoStr;
            if (param.esArray()) {
                // Para arrays, indicar tipo base y dimensiones
                tipoStr = param.getTipo().name() + "_ARRAY_" + param.getNumDimensiones();
            } else {
                tipoStr = (param.getTipo() == TipoDato.FLOAT) ? "FLOAT"
                        : (param.getTipo() == TipoDato.CHAR) ? "CHAR"
                        : (param.getTipo() == TipoDato.BOOL) ? "BOOL" : "INT";
            }
            codigo.add(new Instruccion("PARAM_TYPE", param.getIdentificador(), null, null, tipoStr));
            codigo.addAll(param.generarCodigo(gen));
        }

        // Generamos el código para el cuerpo de la función
        if (sentencias != null) {
            codigo.addAll(sentencias.generarCodigo(gen));
        }

        // Si la función es VOID, agregar un return implícito al final
        if (tipoRetorno == TipoDato.VOID) {
            codigo.add(new Instruccion("RETURN", null, null, null));
        }

        return codigo;
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"func: ");
        buffer.append(nombre);
        buffer.append("\"];");
        buffer.append("\n");

        if (parametros != null && !parametros.isEmpty()) {
            for (NodoDeclaracion param : parametros) {
                buffer.append(this.getIndex());
                buffer.append("->");
                buffer.append(param.getIndex());
                buffer.append("\n");
            }
        }

        if (sentencias != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(sentencias.getIndex());
            buffer.append("\n");
        }

        out.print(buffer.toString());

        if (parametros != null) {
            for (NodoDeclaracion param : parametros) {
                param.toDot(out);
            }
        }

        if (sentencias != null) {
            sentencias.toDot(out);
        }
    }
}
