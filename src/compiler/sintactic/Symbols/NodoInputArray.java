package compiler.sintactic.Symbols;

import compiler.codigo_intermedio.*;
import java.util.ArrayList;
import java.util.List;

public class NodoInputArray extends NodoAST {
    private NodoAccesoArray acceso;
    
    public NodoInputArray(NodoAccesoArray acceso, int linea, int columna) {
        super(linea, columna);
        this.acceso = acceso;
    }
    
    @Override
    public void imprimirAST(String indent) {
        System.out.println(indent + "InputArray:");
        System.out.println(indent + "  Acceso:");
        acceso.imprimirAST(indent + "    ");
    }
    
    @Override
    public List<Instruccion> generarCodigo(Generador gen) {
        List<Instruccion> codigo = new ArrayList<>();
        
        // Calcular el offset del array
        String offsetBytes = acceso.accesoPosicionBytes(codigo, gen);
        
        // Leer el valor introducido por el usuario
        String tempLectura = gen.nuevoTemporal();
        codigo.add(new Instruccion("READ", tempLectura, null, null, acceso.getTipo().name()));
        
        // Asignar el valor leído al array en la posición calculada
        codigo.add(new Instruccion("IND_ASS", tempLectura, offsetBytes, acceso.getId(), acceso.getTipo().name()));
        
        return codigo;
    }
    
    @Override
    public void toDot(java.io.PrintWriter out) {
        StringBuilder buffer = new StringBuilder();
        buffer.append(this.getIndex());
        buffer.append("\t[label=\"INPUT_ARRAY\"];\n");
        buffer.append(this.getIndex());
        buffer.append("->");
        buffer.append(acceso.getIndex());
        buffer.append("\n");
        out.print(buffer.toString());
        acceso.toDot(out);
    }
}
