package compiler.sintactic.Symbols;


import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import compiler.codigo_intermedio.Generador;
import compiler.codigo_intermedio.Instruccion;


public class NodoAsignacionAcceso extends NodoAST {


   private NodoAccesoArray acceso;
   private NodoExpresion valor;   


   public NodoAsignacionAcceso(NodoAccesoArray acceso, NodoExpresion valor, int linea, int columna) {
       super(linea, columna);
       this.acceso = acceso;
       this.valor = valor;
   }


   @Override
   public void imprimirAST(String indent) {
       System.out.println(indent + "Asignacion Array [STORE]");
       acceso.imprimirAST(indent + "  ");
       valor.imprimirAST(indent + "  ");
   }


   @Override
   public List<Instruccion> generarCodigo(Generador gen) {
       List<Instruccion> codigo = new ArrayList<>();


       String t_offsetBytes = acceso.accesoPosicionBytes(codigo, gen);


       codigo.addAll(valor.generarCodigo(gen));
       String t_valor = valor.getTemporal();


       codigo.add(new Instruccion("IND_ASS", t_valor, t_offsetBytes, acceso.getId(), acceso.getTipo().toString()));


       return codigo;
   }


   @Override
   public void toDot(PrintWriter out) {
    StringBuilder buffer = new StringBuilder();

        buffer.append(this.getIndex());
        buffer.append("\t[label=\"[] =\\n(Asign. Array)\"]"); 
        buffer.append("\n");

        if (acceso != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(acceso.getIndex());
            buffer.append("\n");
        }

        if (valor != null) {
            buffer.append(this.getIndex());
            buffer.append("->");
            buffer.append(valor.getIndex());
            buffer.append("\n");
        }
        out.print(buffer.toString());
        if (acceso != null) acceso.toDot(out);
        if (valor != null) valor.toDot(out);
   }
}

