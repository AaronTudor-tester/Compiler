package compiler.sintactic.Symbols;

import java.util.*;

public class BloqueActivacion {

    private BloqueActivacion padre;
    private List<BloqueActivacion> hijos = new ArrayList<>();

    // LinkedHashMap para mantener orden de declaración
    private LinkedHashMap<String, Simbolo> variables = new LinkedHashMap<>();
    private LinkedHashMap<String, Simbolo> funciones = new LinkedHashMap<>();

    private String nombre; // para identificar el bloque

    public BloqueActivacion(BloqueActivacion padre, String nombre) {
        this.padre = padre;
        this.nombre = nombre;
        if (padre != null) {
            padre.hijos.add(this);
        }
    }

    public void agregarVariable(Simbolo s) {
        variables.put(s.getNombre(), s);
    }

    public void agregarParametro(Simbolo s) {
        variables.put(s.getNombre(), s);
    }

    public void agregarFuncion(Simbolo s) {
        funciones.put(s.getNombre(), s);
    }

    public Simbolo buscar(String id) {
        if (variables.containsKey(id)) {
            return variables.get(id);
        }
        if (padre != null) {
            return padre.buscar(id);
        }
        return null;
    }

    public Simbolo buscarFuncion(String id) {
        if (funciones.containsKey(id)) {
            return funciones.get(id);
        }
        if (padre != null) {
            return padre.buscarFuncion(id);
        }
        return null;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Collection<Simbolo> getVariables() {
        return variables.values();
    }

    public Collection<Simbolo> getFunciones() {
        return funciones.values();
    }

    public BloqueActivacion getPadre() {
        return padre;
    }

    public List<BloqueActivacion> getHijos() {
        return hijos;
    }

    public void imprimirBloque(String indent) {

        System.out.println(indent + "BLOQUE " + nombre + ": ");

        for (Simbolo s : getVariables()) {
            if(s.isConstante()) {
            System.out.println(indent + "  CONSTANTE: " + s);
            } else {
            System.out.println(indent + "  VARIABLE: " + s);
            }
        }

        for (Simbolo f : getFunciones()) {
            System.out.println(indent + "  FUNCIÓN: " + f);
        }

        for (BloqueActivacion hijo : hijos) {
            hijo.imprimirBloque(indent + "  ");
        }
    }
}
