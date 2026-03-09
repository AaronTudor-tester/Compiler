package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;
import java.util.ArrayList;
import java.util.List;

public class NodoAsignacionArray extends NodoAST {

    private String id; // Nombre del array
    private TipoDato tipoBase;
    private List<NodoExpresion> valores; // Valores de los elementos del array
    private List<NodoExpresion> long_dimensiones;

    public NodoAsignacionArray(String id, TipoDato tipoBase, List<NodoExpresion> valores, List<NodoExpresion> long_dimensiones, int linea, int columna){
        super(linea, columna);
        this.id = id;
        this.tipoBase = tipoBase;
        this.valores = valores;
        this.long_dimensiones = long_dimensiones;
    }
    

    public String getId() {
        return id;
    }

    public TipoDato getTipoBase() {
        return tipoBase;
    }

    public List<NodoExpresion> getValores() {
        return valores;
    }
    private int getTipoSize() {
        switch (tipoBase) {
            case INT:
                return 4;
            case FLOAT:
                return 4;
            case CHAR:
                return 2; 
            case BOOL:
                return 2; 
            case STRING:
                return 4; // dirección en memoria
            default:
                return 4;
        }
    } 

    public int getTamano() {
        return (valores != null) ? valores.size() : 0;
    }

    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "NodoAsignacionArray{"
                + "id='" + id + '\''
                + ", tipoBase=" + tipoBase
                + ", tamaño=" + getTamano()
                + ", linea=" + getLinea()
                + ", columna=" + getColumna()
                + '}');
    }

    @Override
    public List<Instruccion> generarCodigo(Generador gen) {

        List<Instruccion> codigo = new ArrayList<>();
        String t_total = gen.nuevoTemporal();
        if (long_dimensiones != null && !long_dimensiones.isEmpty()){
            
            codigo.add(new Instruccion("=", t_total, "1", null));

            for (NodoExpresion dim : long_dimensiones) {
                
                codigo.addAll(dim.generarCodigo(gen));
                
                String t_res = gen.nuevoTemporal();
                codigo.add(new Instruccion("*", t_total, dim.getTemporal(), t_res));
                t_total = t_res;
            }
            
        } else if (valores != null && !valores.isEmpty()) {
            codigo.add (new Instruccion("=", t_total, String.valueOf(valores.size()), null));         
        } else {
            return codigo;
        }
        String t_bytes_tipo = gen.nuevoTemporal();
        codigo.add(new Instruccion("=", t_bytes_tipo, String.valueOf(this.getTipoSize()), null));
        String t_bytes = gen.nuevoTemporal();
        codigo.add(new Instruccion("*", t_total, t_bytes_tipo, t_bytes));
        codigo.add(new Instruccion("ALLOC", id, t_bytes, null, tipoBase.toString()));

        if (valores != null && !valores.isEmpty()) {
        
            
            for (int i = 0; i < valores.size(); i++) {
                NodoExpresion valor = valores.get(i);
                
                codigo.addAll(valor.generarCodigo(gen));
                
                String t_indice = gen.nuevoTemporal();
                codigo.add(new Instruccion("=", t_indice, String.valueOf(i), null));
                
                String t_bytes_tipo_valores = gen.nuevoTemporal();
                codigo.add(new Instruccion("=", t_bytes_tipo_valores, String.valueOf(this.getTipoSize()), null));

                String t_offset = gen.nuevoTemporal();
                codigo.add(new Instruccion("*", t_indice, t_bytes_tipo_valores, t_offset));
                
                codigo.add(new Instruccion("IND_ASS", valor.getTemporal(), t_offset, id, tipoBase.toString()));
            }
        }

        return codigo;
       
    }

    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"array: ");
        buffer.append(id);
        buffer.append("[");
        buffer.append(getTamano());
        buffer.append("](");
        buffer.append(tipoBase);
        buffer.append(")\"];");
        buffer.append("\n");
        
        if (valores != null) {
            for (NodoExpresion valor : valores) {
                buffer.append(this.getIndex());
                buffer.append("->");
                buffer.append(valor.getIndex());
                buffer.append("\n");
            }
        }
        
        out.print(buffer.toString());
        
        if (valores != null) {
            for (NodoExpresion valor : valores) {
                valor.toDot(out);
            }
        }
    }
}
