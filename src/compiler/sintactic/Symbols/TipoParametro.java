package compiler.sintactic.Symbols;

/**
 * Clase que representa el tipo de un parámetro de función,
 * incluyendo información sobre si es un array y su número de dimensiones.
 */
public class TipoParametro {
    private TipoDato tipoBase;
    private boolean esArray;
    private int numDimensiones;

    public TipoParametro(TipoDato tipoBase) {
        this.tipoBase = tipoBase;
        this.esArray = false;
        this.numDimensiones = 0;
    }

    public TipoParametro(TipoDato tipoBase, int numDimensiones) {
        this.tipoBase = tipoBase;
        this.esArray = numDimensiones > 0;
        this.numDimensiones = numDimensiones;
    }

    public TipoDato getTipoBase() {
        return tipoBase;
    }

    public boolean esArray() {
        return esArray;
    }

    public int getNumDimensiones() {
        return numDimensiones;
    }

    public boolean esCompatibleCon(TipoParametro otro) {
        if (this.tipoBase != otro.tipoBase) {
            return false;
        }
        if (this.esArray != otro.esArray) {
            return false;
        }
        if (this.numDimensiones != otro.numDimensiones) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        if (esArray) {
            StringBuilder sb = new StringBuilder();
            sb.append(tipoBase);
            for (int i = 0; i < numDimensiones; i++) {
                sb.append("[]");
            }
            return sb.toString();
        }
        return tipoBase.toString();
    }
}
