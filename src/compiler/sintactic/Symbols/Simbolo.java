package compiler.sintactic.Symbols;

import java.beans.Expression;
import java.util.List;

public class Simbolo {

    public enum Categoria {
        VARIABLE,
        FUNCION,
        CONSTANTE,
    }

    private String nombre;
    private TipoDato tipo;
    private Object valor;
    private int linea;
    private int columna;
    private boolean inicializada;
    private boolean esConstante;
    private boolean esArray;
    private int longitud; // Cantidad total de valores del array
    private List <NodoExpresion> long_dimensiones; // Longitud de las dimensiones del array
    private int dimensiones_esperadas; //Cantidad de dimensiones especificadas por el usuario.
    private Categoria categoria;
    private List<TipoParametro> parametros; // Para funciones, lista de tipos de parámetros
    private boolean esGlobal; // Indica si la variable es global

    // Variable / parámetro
    public Simbolo(String nombre, TipoDato tipo, Categoria categoria, int linea, int columna) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.categoria = categoria;
        this.linea = linea;
        this.columna = columna;

        this.inicializada = false;
        this.esConstante = false;
        this.esArray = false;
        this.longitud = 0;
        this.long_dimensiones = null;
        this.dimensiones_esperadas = 0;
        this.esGlobal = false;
    }

    // Variable con valor inicial
    public Simbolo(String nombre, TipoDato tipo, Object valor, int linea, int columna) {
        this(nombre, tipo, Categoria.VARIABLE, linea, columna);
        this.valor = valor;
        this.inicializada = true;
    }

    // Para funciones
    public Simbolo(String nombre, TipoDato tipoRetorno, List<TipoParametro> parametros, int linea, int columna) {
        this.nombre = nombre;
        this.tipo = tipoRetorno;
        this.parametros = parametros;
        this.linea = linea;
        this.columna = columna;
        this.categoria = Categoria.FUNCION;
    }

    // Getters
    public String getNombre() {
        return nombre;
    }

    public TipoDato getTipo() {
        return tipo;
    }

    public Object getValor() {
        return valor;
    }

    public int getLinea() {
        return linea;
    }

    public int getColumna() {
        return columna;
    }

    public boolean isInicializada() {
        return inicializada;
    }

    public boolean isConstante() {
        return esConstante;
    }

    public boolean isArray() {
        return esArray;
    }

    public int getLongitud() {
        return longitud;
    }

    public List<NodoExpresion> getLong_Dimensiones() {
        return this.long_dimensiones;
    }
    
    public int getNumDimensiones () {
        return this.dimensiones_esperadas;
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public List<TipoParametro> getParametros() {
        return parametros;
    }

    public boolean esGlobal() {
        return esGlobal;
    }

    // Setters
    public void setValor(Object valor) {
        this.valor = valor;
        this.inicializada = true;
    }

    public void setInicializada(boolean i) {
        inicializada = i;
    }

    public void setArray(Object valor, int longitud, List <NodoExpresion> long_dimensiones, int dimensiones_esperadas) {
        this.valor = valor;
        this.longitud = longitud;
        this.long_dimensiones = long_dimensiones;
        this.dimensiones_esperadas = dimensiones_esperadas;
        this.esArray = true;
        this.inicializada = true;
    }

    public void setTipo(TipoDato tipo) {
        this.tipo = tipo;
    }

    public void setConstante() {
        esConstante = true;
        categoria = Categoria.CONSTANTE;
    }

    public void setParametros(List<TipoParametro> parametros) {
        this.parametros = parametros;
    }

    public void setGlobal(boolean esGlobal) {
        this.esGlobal = esGlobal;
    }

    public int getTipoSize() {
        switch (tipo) {
            case INT:
                return 4;
            case FLOAT:
                return 4;
            case CHAR:
                return 2; // Mantenemos 2 bytes para compatibilidad con ensamblador 68K
            case BOOL:
                return 2; // Mantenemos 2 bytes para compatibilidad con ensamblador 68K
            case STRING:
                return 4; // dirección en memoria
            default:
                return 4;
        }
    } 

    @Override
    public String toString() {
        if (categoria == Categoria.FUNCION) {
            return String.format("Simbolo{nombre='%s', tipoRetorno=%s, parametros=%s, linea=%d}",
                    nombre, tipo, parametros, linea);
        } else {
            return String.format("Simbolo{nombre='%s', tipo=%s, valor=%s, linea=%d, inicializada=%s}",
                    nombre, tipo, valor, linea, inicializada);
        }
    }
}
