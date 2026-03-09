package compiler.sintactic.Symbols;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;

public class NodoAccesoArray extends NodoExpresion {

    private String id;
    private List<NodoExpresion> indices;
    private List<NodoExpresion> long_dimensiones;
    private int nbytes_tipo;
    private TipoDato tipoBase;

    public NodoAccesoArray(String id, List<NodoExpresion> long_dimensiones, List<NodoExpresion> indices, int nbytes_tipo, TipoDato tipo, int linea, int columna) {
        super(linea, columna);
        this.id = id;
        this.indices = indices;
        this.long_dimensiones = long_dimensiones;
        this.nbytes_tipo = nbytes_tipo;
        this.tipoBase = tipo;
        this.setTipo(tipo);

    }

    public String getId() {
        return id;
    }

    public List<NodoExpresion> getIndices() {
        return indices;
    }

    public String accesoPosicionBytes(List<Instruccion> codigo, Generador gen) {
        NodoExpresion indice_primero = indices.get(0);

        codigo.addAll(indice_primero.generarCodigo(gen));
        String t_acumulado = indice_primero.getTemporal();

        // Comprobación en compilación si el primer índice y la dimensión son literales
        if (long_dimensiones != null && long_dimensiones.size() > 0 && long_dimensiones.get(0) != null) {
            NodoExpresion dim0 = long_dimensiones.get(0);
            if (indice_primero.getClass() == NodoLiteral.class && dim0.getClass() == NodoLiteral.class) {
                int valIndice = Integer.parseInt(((NodoLiteral) indice_primero).getValor().toString());
                int valDim = Integer.parseInt(((NodoLiteral) dim0).getValor().toString());
                if (valIndice < 0 || valIndice >= valDim) {
                    throw new RuntimeException("Index out of bounds (compilation) at line " + indice_primero.linea + ", col " + indice_primero.columna + ": index=" + valIndice + " dim=" + valDim);
                }
            }
        }

        for (int i = 1; i < indices.size(); i++) {
            NodoExpresion indice_sig = indices.get(i);
            codigo.addAll(indice_sig.generarCodigo(gen));
            String t_siguiente = indice_sig.getTemporal();

            // Verificar si la dimensión es conocida
            if (long_dimensiones != null && i < long_dimensiones.size() && long_dimensiones.get(i) != null) {
                NodoExpresion dimension = long_dimensiones.get(i);
                codigo.addAll(dimension.generarCodigo(gen));
                String t_val_dimension = dimension.getTemporal();

                // Si tanto indice como dimensión son literales, comprobar en compilación y usar valores constantes
                if (indice_sig.getClass() == NodoLiteral.class && dimension.getClass() == NodoLiteral.class) {
                    int valIndice = Integer.parseInt(((NodoLiteral) indice_sig).getValor().toString());
                    int valDim = Integer.parseInt(((NodoLiteral) dimension).getValor().toString());
                    if (valIndice < 0 || valIndice >= valDim) {
                        throw new RuntimeException("Index out of bounds (compilation) at line " + indice_sig.linea + ", col " + indice_sig.columna + ": index=" + valIndice + " dim=" + valDim);
                    }
                    String t_mul = gen.nuevoTemporal();
                    codigo.add(new Instruccion("*", t_acumulado, String.valueOf(valDim), t_mul));
                    String t_sum = gen.nuevoTemporal();
                    codigo.add(new Instruccion("+", t_mul, String.valueOf(valIndice), t_sum));
                    t_acumulado = t_sum;
                } else {
                    // Cálculo normal del offset (sin comprobaciones runtime aquí)
                    String t_mul = gen.nuevoTemporal();
                    codigo.add(new Instruccion("*", t_acumulado, t_val_dimension, t_mul));
                    String t_sum = gen.nuevoTemporal();
                    codigo.add(new Instruccion("+", t_mul, t_siguiente, t_sum));
                    t_acumulado = t_sum;
                }
            } else {
                // Si no conocemos las dimensiones en tiempo de compilación, dejamos una marca (DIM_nombreArray_posicion) en el código intermedio.
                // El generador de código ensamblador usará la marca para obtener la dimensión del array y calcular el índice.
                String t_mul = gen.nuevoTemporal();
                String dim_marker = "DIM_" + id + "_" + i;
                codigo.add(new Instruccion("*", t_acumulado, dim_marker, t_mul));
                String t_sum = gen.nuevoTemporal();
                codigo.add(new Instruccion("+", t_mul, t_siguiente, t_sum));
                t_acumulado = t_sum;
            }
        }
        String t_nbytes = gen.nuevoTemporal();
        codigo.add(new Instruccion("=", t_nbytes, String.valueOf(nbytes_tipo), null));
        String t_offsetBytes = gen.nuevoTemporal();
        codigo.add(new Instruccion("*", t_acumulado, t_nbytes, t_offsetBytes));
        return t_offsetBytes;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "Acceso Array [" + id + "]");
        for (NodoExpresion expr : indices) {
            System.out.println(indent + "  Indice:");
            expr.imprimirAST(indent + "    ");
        }
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();

        String t_offsetBytes = accesoPosicionBytes(codigo, gen);

        // Calcular tamaño total del array (producto de todas las dimensiones)
        String t_tamanio_total = gen.nuevoTemporal();
        if (long_dimensiones != null && !long_dimensiones.isEmpty()) {
            // Verificar si todas las dimensiones son conocidas (no null)
            boolean dimensionesConocidas = true;
            for (NodoExpresion dim : long_dimensiones) {
                if (dim == null) {
                    dimensionesConocidas = false;
                    break;
                }
            }

            if (dimensionesConocidas) {
                // Calcular producto de dimensiones conocidas
                codigo.addAll(long_dimensiones.get(0).generarCodigo(gen));
                String t_prod = long_dimensiones.get(0).getTemporal();

                for (int i = 1; i < long_dimensiones.size(); i++) {
                    codigo.addAll(long_dimensiones.get(i).generarCodigo(gen));
                    String t_dim = long_dimensiones.get(i).getTemporal();
                    String t_nuevo = gen.nuevoTemporal();
                    codigo.add(new Instruccion("*", t_prod, t_dim, t_nuevo));
                    t_prod = t_nuevo;
                }
                codigo.add(new Instruccion("=", t_tamanio_total, t_prod, null));
            } else {
                // Para parámetros de array con dimensiones desconocidas, ponemos -1 para indicar que no se conoce el tamaño
                codigo.add(new Instruccion("=", t_tamanio_total, "-1", null));
            }
        } else {
            // Sin dimensiones / desconocido
            codigo.add(new Instruccion("=", t_tamanio_total, "-1", null));
        }

        String t_resultado = gen.nuevoTemporal();
        // Guardamos las dimensiones para comprobar out of bounds en ensamblador
        codigo.add(new Instruccion("IND_VAL", id, t_offsetBytes, t_resultado, tipoBase.toString() + ":" + t_tamanio_total + ":" + nbytes_tipo));

        this.setTemporal(t_resultado);
        return codigo;
    }

    @Override
    public void toDot(PrintWriter out) {
        StringBuilder buffer = new StringBuilder();

        buffer.append(this.getIndex());
        buffer.append("\t[label=\"Acceso Array\\n(");
        buffer.append(id);
        buffer.append(")\"]");
        buffer.append("\n");

        for (NodoExpresion indice : indices) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(indice.getIndex());
            buffer.append("\n");
        }

        out.print(buffer.toString());

        for (NodoExpresion indice : indices) {
            indice.toDot(out);
        }
    }

}
