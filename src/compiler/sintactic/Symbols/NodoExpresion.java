package compiler.sintactic.Symbols;

public abstract class NodoExpresion extends NodoAST {

    protected TipoDato tipo;
    private String temporal; // Variable auxiliar donde se guarda el valor de la expresión
    private int dimensionesEsp;

    public NodoExpresion(int linea, int columna) {
        super(linea, columna);
        this.tipo = TipoDato.ERROR;
        this.dimensionesEsp = 0;
    }

    public TipoDato getTipo() {
        return tipo;
    }

    public void setTipo(TipoDato tipo) {
        this.tipo = tipo;
    }

    public boolean isArray () {
        return dimensionesEsp > 0;
    }

    public void setDimensionesEsp(int dimension) {
        this.dimensionesEsp = dimension;
    }

    public int getDimensionesEsp () {
        return this.dimensionesEsp;
    }

    public String getTemporal() {
        return temporal;
    }

    public void setTemporal (String temporal) {
        this.temporal = temporal;
    }
    
    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoExpresion (linea: " + linea + ", col: " + columna + ", tipo: " + tipo + ")");
    }
}
