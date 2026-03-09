# DOCUMENTACION DEL COMPILADOR LENGUAJE NATURAL

**Autores:** Jaume Juan Huguet, Antonio García Font, Aarón-satyar Daghigh-nia Tudor, Katia Ostrovsky Borrás
**Asignatura:** Compiladores (21780) - Grado en Informática  
**Profesor:** Pere Palmer

---

# 0. INTRODUCCIÓN
Esta práctica consiste en el diseño e implementación de un compilador para un lenguaje imperativo de estilo natural, desarrollado en el contexto de la asignatura Compiladores (Curso 2025-2026). El objetivo principal es cubrir todas las fases clásicas de un compilador, desde el análisis léxico hasta la generación de código, aplicando las técnicas vistas en la asignatura.

El lenguaje diseñado pretende ser legible y cercano al lenguaje humano, utilizando palabras clave en castellano para definir variables, expresiones, estructuras de control y operaciones de entrada/salida.

### 0.1. Objetivo del Proyecto
- **Crear un compilador de un lenguaje natural** que traduzca código escrito en español natural a:
  - Código Intermedio (Representación intermedia)
  - Código Ensamblador 68K (Easy68K)
- **Características especiales:**
  - Palabras reservadas en español natural
  - Sintaxis cercana al lenguaje natural
  - Soporta variables, funciones, arrays, bucles, condicionales
  - Análisis semántico y comprobación de tipos
  - Generación de AST y Graphviz (.dot)
  - Optimización de código

### 0.2. Tecnologías Utilizadas
- **JFlex:** Generador de analizadores léxicos
- **Java CUP:** Generador de analizadores sintácticos (LALR)
- **Java:** Lenguaje de implementación
- **Graphviz:** Visualización de AST
- **Easy68K:** Ensamblador destino (Motorola 68000)

### 0.3. Flujo General del Compilador
```
┌─────────────┐
│ Código .txt │ (en lenguaje natural)
└──────┬──────┘
       │
       ▼
┌──────────────────┐
│ Scanner (Léxico) │ ─→ Tokens
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ Parser (Sintác.) │ ─→ AST + Tabla de Símbolos
└──────┬───────────┘
       │
       ▼
┌─────────────────────┐
│ Análisis Semántico  │ ─→ Validación de tipos
└──────┬──────────────┘
       │
       ▼
┌──────────────────────────┐
│ Generador Código Interm. │ ─→ 3-Address Code
└──────┬─────────────────┬─┘
       │                 │
       ▼                 ▼
   ┌────────────┐  ┌──────────┐
   │Optimizador │  │Graphviz  │ ─→ .dot visual
   └──────┬─────┘  └──────────┘
       │
       ▼
┌──────────────────────┐
│ Generador 68K (ASM)  │ ─→ .x68
└──────────────────────┘
```

---

# 1. INTRODUCCIÓN A LA PROGRAMACIÓN EN LENGUAJE NATURAL

### Características del Lenguaje
- **Sintaxis amigable** basada en español natural
- **Tipado dinámico con verificación en tiempo de compilación**
- **Tipos de datos soportados:**
  - `numero` → Integer
  - `decimal` → Float
  - `pregunta` → Boolean
  - `letra` → Char
  - `frase` → String
  - `vacio` → Void (para funciones)
  - `lista de <tipo>` → Arrays
  - `constante` → Variables inmutables

### 1.1. Estructura General de un Programa
```
numero suma(numero a, numero b) {
    devuelve a mas b.
}

principal {
    // Código principal
}
```
- **Funciones:** Se definen antes de `principal`
- **Función principal:** Bloque `principal` es obligatorio
- **Puntos y comas:** Cada instrucción termina con `.`

### 1.2. Variables y Asignación
```
numero x es 10.
decimal precio es 9.99.
pregunta esVerdad es cierto.
letra inicial es 'A'.
frase mensaje es "Hola Mundo".
constante decimal PI es 3.14159.
```
- **Declaración:** `tipo identificador es valor.`
- **Constantes:** No pueden ser reasignadas
- **Inicialización:** Puede ser con literal o expresión

### 1.3. Operadores Aritméticos
```
numero a es 10.
numero b es 3.

numero suma es a mas b.           // 13
numero resta es a menos b.        // 7
numero mult es a multiplicado b.  // 30
numero div es a dividido b.       // 3
numero modulo es a resto b.       // 1

numero negativo es menos a.       // -10
```
- **Operadores:** `mas`, `menos`, `multiplicado`, `dividido`, `resto`
- **Unarios:** `menos x`, `no pregunta`

### 1.4. Operadores Lógicos y de Comparación
```
si x es mayor que y {
    escribe "x > y".
}

si a es menor o igual que 5 {
    escribe "a <= 5".
}

si x es igual que y y ademas z es diferente de 0 {
    escribe "Condición compuesta".
}

si no esVerdad o bien esOtro {
    escribe "Lógica booleana".
}
```
- **Comparación:** `es igual que`, `es diferente de`, `es mayor que`, `es menor que`, `es mayor o igual que`, `es menor o igual que`
- **Lógicos:** `y ademas`, `o bien`, `no`, `solo uno` (XOR)

### 1.5. Instrucciones de I/O
```
numero x.
escribe "Ingrese un número: ".
lee x.

escribe "El valor es: ".
escribe valor.

escribe "Múltiples escrituras".
escribe x, y, z.
```
- **Salida:** `escribe <expresión>.`
- **Entrada:** `lee <tipo>` (devuelve un valor)
- **Concatenación:** Múltiples valores con comas

### 1.6. Operaciones Especiales
```
// Incremento/Decremento
incrementa contador.
decrementa contador.

// Modificación de variable
modifica x es x mas 5.
```

---

# 2. ESTRUCTURAS DE CONTROL Y FUNCIONES

### 2.1. Condicional IF-ELSE
```
si condicion {
    // Código si es verdadero
} sino {
    // Código si es falso
}

// Sin else
si x es mayor que 10 {
    escribe "Mayor que 10".
}
```
- **Sintaxis:** `si <condición> { ... } sino { ... }`
- **Else opcional**
- **Condición:** Expresión booleana

### 2.2. Bucle MIENTRAS (WHILE)
```
numero i es 0.
mientras i es menor que 10 {
    escribe i.
    incrementa i.
}
```
- **Sintaxis:** `mientras <condición> { ... }`
- **Se evalúa la condición antes de cada iteración**
- **Soporta `salir` (break)**

### 2.3. Bucle PARA (FOR)
```
para numero i es 0 hasta que i es menor que 10 incremena i {
    escribe i.
}

para numero x en lista_numeros {
    escribe x.
}
```
- **Sintaxis de rango:** `para <tipo> var es <init> hasta que <cond> <incr> { ... }`
- **Sintaxis foreach:** `para <tipo> var en <colección> { ... }`

### 2.4. Sentencia SWITCH-CASE
```
segun opcion {
    si es 1 {
        escribe "Opción 1".
    }
    si es 2 {
        escribe "Opción 2".
    }
    si es 3 {
        escribe "Opción 3".
    }
}
```
- **Sintaxis:** `segun <expresión> { si es <valor> { ... } ... }`
- **Sin fallthrough implícito** (cada case es independiente)

### 2.5. Definición de Funciones
```
// Función con retorno
numero sumar(numero a, numero b) {
    devuelve a mas b.
}

// Función sin retorno (void)
vacio imprimirMensaje(frase msg) {
    escribe msg.
}

// Múltiples parámetros
decimal calcular(numero x, decimal y, frase unidad) {
    numero resultado es x multiplicado y.
    escribe unidad.
    devuelve resultado.
}
```
- **Declaración:** `<tipo_retorno> nombre(<parámetros>) { ... }`
- **Parámetros:** `tipo nombre, tipo nombre`
- **Retorno:** `devuelve <expresión>.`
- **Sin retorno:** Tipo `vacio`

### 2.6. Variables Locales y Alcance (Scope)
```
numero global es 100.

numero multiplicar(numero a) {
    numero resultado es a multiplicado 2.  // Local
    devuelve resultado.
}

principal {
    numero local es 50.
    resultado es multiplicar(local).      // Usar función
    escribe global.                        // Acceder a global
    escribe resultado.                     // Acceder a local
}
```
- **Variables globales:** Declaradas fuera de funciones
- **Variables locales:** Declaradas dentro de funciones o bloques
- **Parámetros:** Como variables locales
- **Tabla de símbolos** gestiona el alcance

### 2.7. Arrays
```
// Declaración de array
lista de numero numeros es [1, 2, 3, 4, 5].
lista de frase palabras es ["hola", "mundo"].

// Acceso a elementos
numero primero es numeros posicion (0).
escribe primero.

// Modificar elemento
numeros posicion (2) es 100.

// Arrays Multidimensionales
lista de numero cubo es [ 
    [ [10, 20, 30], [40, 50, 60] ], 
    [ [70, 80, 90], [100, 110, 120] ] 
].

numero x es cubo (1,1,0). // x = 100

// Declaramos una matriz de 3x3
lista de numero matriz de longitud 3, 3.

// Asignacion manual en diferentes coordenadas
// Fila 0
matriz posicion (0, 0) es 1.
matriz posicion (0, 1) es 2.

// Iteración
para numero i es 0, repite si i es menor que 5, incrementa i {
        // Asignamos i * 10 a cada posicion: 0, 10, 20...
        numeros posicion (i) es i multiplicado 10.
}
```
- **Inicialización:** `lista de <tipo> nombre es [elem1, elem2, ...]`
- **Acceso:** `nombre posicion (índice)`
- **Modificación:** `nombre posicion (índice) es valor`

#### 2.7.1. Reserva de Memoria para Arrays

En nuestro compilador, **los arrays se almacenan dinámicamente en el HEAP** (memoria dinámica). El compilador utiliza un puntero global `HEAP_PTR` que mantiene la dirección de la siguiente posición libre en memoria.

**¿Cómo se reserva espacio?**

Cuando declares un array, el compilador realiza una operación `ALLOC` (allocate) que:

1. **Calcula el tamaño total necesario** en bytes:
   - Para un array de `n` elementos de tipo `T`, el espacio reservado es: `n × tamaño_tipo`
   - Ejemplo: `lista de numero matriz de longitud 3, 3` reserva 3×3×4 = 36 bytes (números = 4 bytes)

2. **Reserva el bloque en el HEAP**:
   ```
   Código Intermedio:
   t_size = 36                    ; Tamaño en bytes
   ALLOC t_size → matriz          ; Guarda dirección base en 'matriz'
   HEAP_PTR += t_size             ; Avanza el puntero libre
   ```

3. **Código 68K equivalente**:
   ```asm
   MOVE.L HEAP_PTR, D0        ; D0 = dirección actual del heap
   MOVE.L D0, matriz          ; Guardar dirección base en variable
   ADD.L #36, D0              ; Calcular siguiente dirección libre
   MOVE.L D0, HEAP_PTR        ; Actualizar puntero global
   ```

**Ejemplo visual de memoria:**
```
Antes:  HEAP_PTR → [Espacio libre]
        
Después de: lista de numero matriz de longitud 3, 3
            
HEAP_PTR → [0x1000] matriz[0,0] matriz[0,1] ... matriz[2,2] [Espacio libre]
           ↑
           La variable 'matriz' apunta a 0x1000
```

#### 2.7.2. Cálculo de Dirección (Indexación de Arrays)

El acceso a un elemento de un array se realiza mediante el **cálculo de desplazamiento (offset)** desde la dirección base.

**Para arrays multidimensionales**, el compilador convierte índices múltiples a un offset lineal usando la fórmula:

$$\text{offset} = (i_1 \times d_2 \times d_3 \times \ldots) + (i_2 \times d_3 \times \ldots) + \ldots + i_n$$

Donde $d_j$ es la dimensión en la posición $j$.

**Ejemplo: Matriz 3×3**
```
matriz posicion (1, 2) accede a:
offset = (1 × 3) + 2 = 5
```

**Código Intermedio generado:**
```
; Acceso: x = matriz[1, 2]
i0 = 1                          ; Primer índice
i1 = 2                          ; Segundo índice
dim1 = 3                        ; Segunda dimensión
t_mul = i0 * dim1              ; 1 × 3 = 3
t_offset = t_mul + i1          ; 3 + 2 = 5
t_nbytes = 4                    ; Tamaño de numero (INT = 4 bytes)
t_offsetBytes = t_offset * 4    ; 5 × 4 = 20 bytes (offset en memoria)
IND_VAL matriz, t_offsetBytes → x
```

**Código 68K equivalente:**
```asm
MOVE.W #1, t0              ; i0 = 1
MOVE.W #2, t1              ; i1 = 2
MOVE.W #3, t2              ; dim1 = 3
MOVE.W t0, D0
MULS t2, D0                ; D0 = 1 * 3 = 3
MOVE.W D0, t_mul
MOVE.W t_mul, D0
ADD.W t1, D0               ; D0 = 3 + 2 = 5
MOVE.W D0, t_offset
MOVE.W #4, t_nbytes        ; Tamaño de numero
MOVE.W t_offset, D0
MULS t_nbytes, D0          ; D0 = 5 * 4 = 20
MOVE.L D0, t_offsetBytes
; LOAD desde memoria
MOVEA.L matriz, A0         ; A0 = dirección base de matriz
MOVE.L 0(A0, D0.L), D1     ; Leer valor en dirección base + offset
MOVE.L D1, x               ; Guardar en x
```

#### 2.7.3. Asignación y Lectura de Valores en Arrays

**Lectura de un elemento (acceso de lectura):**

La instrucción `IND_VAL` (Indirect Value) carga un valor desde una posición calculada del array:

```
Código Intermedio:
t_offset = calcular_offset(indices)
IND_VAL nombre_array, t_offset → t_resultado
```

En 68K:
```asm
MOVEA.L nombre_array, A0           ; Cargar dirección base en A0
MOVE.L offset_calculado, D0        ; D0 = offset en bytes
MOVE.L 0(A0, D0.L), D1             ; Leer valor: D1 = MEM[A0 + D0]
MOVE.L D1, variable_destino        ; Guardar valor leído
```

**Escritura en un elemento (acceso de escritura):**

La instrucción `IND_ASS` (Indirect Assignment) escribe un valor en una posición calculada:

```
Código Intermedio:
t_valor = <expresión a asignar>
t_offset = calcular_offset(indices)
IND_ASS t_valor, t_offset → nombre_array
```

En 68K:
```asm
MOVEA.L nombre_array, A0           ; Cargar dirección base en A0
MOVE.L offset_calculado, D0        ; D0 = offset en bytes
MOVE.L valor_a_asignar, D1         ; D1 = valor a escribir
MOVE.L D1, 0(A0, D0.L)             ; Escribir: MEM[A0 + D0] = D1
```

**Ejemplo completo: Asignación matriz[1,0] = 10**

```
Código de usuario:
matriz posicion (1, 0) es 10.

Código Intermedio:
t0 = 1                             ; Índice 0
t1 = 0                             ; Índice 1  
t2 = 3                             ; Dimensión 1
t_mul = t0 * t2                   ; 1 * 3 = 3
t_offset = t_mul + t1             ; 3 + 0 = 3
t_nbytes = 4
t_offsetBytes = t_offset * 4      ; 3 * 4 = 12 bytes
t_valor = 10
IND_ASS t_valor, t_offsetBytes → matriz

Código 68K:
MOVE.W #10, D1                  ; D1 = valor a asignar
MOVEA.L matriz, A0              ; A0 = dirección base
MOVE.L #12, D0                  ; D0 = offset (12 bytes)
MOVE.L D1, 0(A0, D0.L)          ; MEM[A0 + 12] = 10
                                ; Escribe 10 en matriz[1,0]
```

**Memoria después de la operación:**
```
A0 → [dato] [dato] [dato] [10] [dato] [dato] [dato] [dato] [dato]
      [0,0] [0,1] [0,2] [1,0] [1,1] [1,2] [2,0] [2,1] [2,2]
            └─────────────────┘
            offset = 12 bytes (3 elementos × 4 bytes)
```

### 2.8. Sentencias de Control de Flujo
```
mientras condicion {
    si x es mayor que 100 {
        salir.  // break
    }
}
```
- **`salir`** (break): Abandona el bucle más cercano

break, tambien puede servir para salir del programa principal, a modo de exit.

### 2.9. Ejemplo Completo
Este ejemplo se encuentra en la carpeta "prueba_completa"
```
numero suma ( numero a , numero b ) {
    devuelve a mas b.
}

principal {
    // Test 1: Variables y operaciones básicas
    escribe "=== TEST 1: Operaciones Basicas ===".
    numero x es 10.
    numero y es 5.
    escribe "x + y =".
    escribe suma(x, y).
    
    // Test 2: Condicionales IF/ELSE
    escribe "=== TEST 2: Condicionales ===".
    si x es mayor que y {
        escribe "10 es mayor que 5".
    } sino {
        escribe "10 no es mayor que 5".
    }
    
    // Test 3: Bucle MIENTRAS (WHILE)
    escribe "=== TEST 3: While ===".
    numero contador es 0.
    mientras contador es menor que 3 {
        escribe "Iteracion:".
        escribe contador.
        incrementa contador.
    }
    
    // Test 4: Operaciones unarias
    escribe "=== TEST 4: Operaciones Unarias ===".
    numero z es 15.
    escribe "z =".
    escribe z.
    escribe "Negacion de z =".
    numero negZ es menos z.
    escribe negZ.
    
    // Test 5: Strings
    escribe "=== TEST 5: Strings ===".
    escribe "Hola Mundo".
    escribe "Compilador funcionando!".
    
    // Test 6: Comparaciones
    escribe "=== TEST 6: Comparaciones ===".
    si 10 es igual que 10 {
        escribe "10 igual a 10: VERDADERO".
    }
    
    si 5 es mayor que 8 {
        escribe "5 > 8: VERDADERO".
    } sino {
        escribe "5 > 8: FALSO".
    }
    
    escribe "=== FIN DE PRUEBAS ===".
}
```
---

# 3. ANÁLISIS LÉXICO, SINTÁCTICO Y SEMÁNTICO.

### ¿Qué es el Análisis Léxico?
- **Objetivo:** Convertir texto plano en una secuencia de tokens (unidades léxicas)
- **Entrada:** Código fuente como string
- **Salida:** Lista de tokens con tipo, valor, línea y columna
- **Errores detectados:** Caracteres desconocidos, literales mal formados
- **Herramienta:** JFlex (generador de scanners)

### 3.1. Ejemplo de Tokenización
```
Código fuente:
  numero x es 10.

Tokens generados:
  Token: INT             Valor: "numero"    (línea 1, col 1)
  Token: ID              Valor: "x"         (línea 1, col 8)
  Token: ASIGN           Valor: "es"        (línea 1, col 10)
  Token: NUMERO          Valor: "10"        (línea 1, col 13)
  Token: PUNTO           Valor: "."         (línea 1, col 15)
  Token: EOF
```

### 3.2. Palabras Reservadas del Lenguaje
- **Tipos de datos:** `numero`, `decimal`, `pregunta`, `letra`, `frase`, `vacio`, `lista de`
- **Control de flujo:** `si`, `sino`, `mientras`, `para`, `repite`, `mientras que`, `segun`, `si es`, `salir`
- **Constantes y booleanos:** `constante`, `cierto`, `mentira`
- **Operadores:** `mas`, `menos`, `multiplicado`, `dividido`, `resto`, `incrementa`, `decrementa`, `modifica`
- **Comparación:** `es mayor que`, `es menor que`, `es mayor o igual que`, `es menor o igual que`, `es igual que`, `es diferente de`
- **Lógicos:** `y ademas`, `o bien`, `no`, `solo uno` (XOR)
- **Entrada/Salida:** `lee`, `escribe`
- **Otros:** `devuelve`, `principal`, `posicion`, `de longitud`

### 3.3. Definición de Patrones (lexic_natural.flex)
```flex
// En JFlex

// Palabras reservadas
int		    = "numero"
float		= "decimal"
bool		= "pregunta"
char		= "letra"
string		= "frase"
vacio		= "vacio"
const		= "constante"
true		= "cierto"
false		= "mentira"
... (Mirar lexic_natural.flex)

// Operadores
suma    	= "mas"
resta    	= "menos"
incr    	= "incrementa"
decr    	= "decrementa"
modif    	= "modifica"
prod    	= "multiplicado"
div		    = "dividido"
mod		    = "resto"
... (Mirar lexic_natural.flex)

// Identificadores y literales
digito   	= [0-9]
digitos  	= {digito}+
decimal 	= {digitos}{punto}{digitos}
letra	  	= [A-Za-z]
id 		    = {letra}({letra}|{digito}|_)*
cadena 		= \"([^\"\\\n]|\\.)*\"|'([^'\\\n]|\\.)*'

// Comentarios
lcoment		= "//".*
mcoment 	= "/*" !([^]* "*/" [^]*) ("*/")?
blanco  	= [ \t\r\n]+
```

### 3.4. Clase Scanner.java (Generada por JFlex)
- **Generada automáticamente** a partir de `lexic_natural.flex`
- **Métodos principales:**
  - `next_token()`: Devuelve el siguiente token
  - Mantiene información de línea y columna
  - Soporta lookahead y backtracking
- **Integración:** El Scanner es usado por el Parser

### 3.5. ¿Qué es el Análisis Sintáctico?
- **Objetivo:** Verificar que los tokens forman una estructura válida según la gramática
- **Entrada:** Secuencia de tokens del Scanner
- **Salida:** Árbol de Sintaxis Abstracta (AST) + Tabla de Símbolos
- **Errors detectados:** Sintaxis incorrecta, conflictos de parsing
- **Herramienta:** Java CUP (generador de parsers LALR)

### 3.6. Gramática - Definición Simplificada
```cup
programa : listaDeclaraciones bloquePrincipal;

listaDeclaraciones : declaracion
                   | listaDeclaraciones declaracion;

declaracion : funcionDeclaration
            | variableGlobal;

funcionDeclaration : tipo IDENTIFICADOR LPAREN listaParametros RPAREN bloque;

bloque : LBRACE instrucciones RBRACE;

instrucciones : instruccion
              | instrucciones instruccion;

instruccion : asignacion
            | condicional
            | bucle
            | funcionLlamada
            | lectura
            | escritura
            | devuelve;
```
(mirar sintactic_natural.cup, o el pdf para ver mas en detalle la gramatica)

### 3.7. Parser.java (Generado por Java CUP)
- **Generado automáticamente** a partir de `sintactic_natural.cup`
- **Algoritmo:** LALR (Look-Ahead LR)
- **Métodos principales:**
  - `parse()`: Realiza el parsing de la entrada
  - Maneja errores y recuperación
  - Integra análisis semántico durante el parsing
- **Retorna:** NodoPrograma (raíz del AST)

### 3.8. Construcción del AST
```
Código:
  numero x es 10 mas 5.

AST resultante:
       Program
         |
    Declaration
      /      \
    var        expr
    (x)      /    \
           +       
          / \
        10   5
```
- **Cada nodo** representa una construcción sintáctica
- **Hojas** son tokens (literales, identificadores)
- **Nodos internos** son construcciones (operadores, funciones, etc.)

### 3.9. Ejemplo de Parsing Completo
```
Entrada (código):
  numero suma(numero a, numero b) { devuelve a mas b. }
  principal { escribe suma(2, 3). }

Fases:
1. Lexer tokeniza → TIPO, ID, LPAREN, TIPO, ID, COMA, ...
2. Parser construye AST
3. Análisis semántico valida tipos y alcance
4. Resultado: AST listo para generación de código
```

### 3.10. ¿Qué es el Análisis Semántico?
- **Objetivo:** Validar que el programa tenga sentido más allá de la sintaxis
- **Realizado:** Típicamente durante el parsing (acción semántica en CUP)
- **Validaciones:**
  - ✓ Variables declaradas antes de usarse
  - ✓ Variables inicializadas antes de usarse
  - ✓ Tipos compatibles en asignaciones y operaciones
  - ✓ Funciones llamadas con argumentos correctos
  - ✓ Retornos de función válidos
  - ✓ Constantes no reasignadas
  - ✓ Arrays con estructura válida
  - ✓ Cases de switch coinciden con tipo de expresión
  - ✗ Errores: variables duplicadas, tipo mismatch, constantes reasignadas, funciones indefinidas

### 3.11. Tabla de Símbolos
```
Estructura jerárquica de bloques (scopes):

┌─────────────────────────────────────┐
│      BLOQUE GLOBAL                  │
│  Variables globales                 │
│  Funciones                          │
│  ┌───────────────────────────┐      │
│  │ BLOQUE: función suma()    │      │
│  │ Variables locales: a, b   │      │
│  └───────────────────────────┘      │
│  ┌───────────────────────────┐      │
│  │ BLOQUE: principal         │      │
│  │ Variables locales: x, y   │      │
│  └───────────────────────────┘      │
└─────────────────────────────────────┘
```

### 3.12. Tabla de Símbolos - Detalle
```
Para cada símbolo (variable/función) se almacena:
  - Identificador: "x"
  - Tipo: numero (int)
  - Categoría: VARIABLE / FUNCIÓN
  - Inicializada: true/false
  - Es constante: true/false
  - Es global: true/false
  - Línea y columna: para reportar errores
  - Valor (si es constante): 42

No se muestran todos en la salida, sino que es lo que se guarda en la misma clase Simbolo
```

### 3.13. Ejemplo de Análisis Semántico
```
Código problemático:
  numero x es "hola".           // ERROR: tipo mismatch (string ≠ numero)
  numero z es y mas 1.          // ERROR: y no declarada
  numero w es 5.
  modifica w es 10.             // OK
  
  constante PI es 3.14.
  modifica PI es 2.71.          // ERROR: PI es constante
  
  lista de numero arr es [].    // ERROR: array vacío no inicializado
  numero e es arr posicion -1.  // ERROR: índice negativo
  
  numero sin_init.
  escribe sin_init.             // ERROR: variable no inicializada
```

### 3.14. Comprobación de Tipos
```
numero a es 10.
decimal b es 3.5.

numero c es a mas b.      // OK: int + float = float

decimal d es a dividido b. // OK: int / float = float

letra x es "a".           // OK: string de 1 char → char

letra y es "abc".         // ERROR: string > 1 char

pregunta p es cierto.
si p y ademas cierto {    // OK: bool AND bool
    escribe "Verdad".
}

si p solo uno mentira {   // OK: bool XOR bool
    escribe "XOR".
}

si 10 es mayor que 5 {    // OK: int > int
    escribe "Sí".
}
```
- **Promoción automática:** `int` → `float`
- **Operadores aritméticos:** INT±INT=INT, INT±FLOAT=FLOAT, FLOAT±FLOAT=FLOAT
- **Comparaciones numéricas:** Solo INT y FLOAT
- **Operadores lógicos:** AND, OR, XOR requieren BOOL en ambos operandos
- **CHAR especial:** Acepta strings de exactamente 1 carácter
- **Type checking fuerte** en compilación

---

# 4. CODIGO INTERMEDIO, OPTIMIZACIÓN Y GENERACIÓN DE CÓDIGO

## 4.1. Visualización del AST con Graphviz
```
 Para la visualización del Árbol de Sintaxis Abstracta (AST) se ha utilizado Graphviz, una herramienta externa destinada a la representación gráfica de grafos a partir de descripciones textuales.

digraph {
    node1 [label="Program"];
    node2 [label="Function suma"];
    node3 [label="Main"];
    
    node1 -> node2;
    node1 -> node3;
    node2 -> node4 [label="body"];
    node3 -> node5 [label="body"];
    ...
}

El compilador genera un fichero en formato .dot, que describe la estructura del AST mediante nodos y aristas dirigidas. Cada nodo representa un elemento sintáctico del lenguaje (por ejemplo, estructuras de control, operaciones o literales), y las aristas indican las relaciones jerárquicas entre ellos.
Graphviz no interviene en el proceso de análisis léxico ni sintáctico, ni tiene conocimiento de la gramática del lenguaje. Su función se limita exclusivamente a transformar el fichero .dot generado por el compilador en una representación gráfica del árbol, facilitando así su comprensión y depuración.
De este modo, la generación del fichero .dot se realiza completamente desde el compilador, mientras que Graphviz se utiliza únicamente como herramienta de visualización del resultado.

```

## 4.2. Generación de código
El compilador genera:
Código intermedio en forma de código de tres direcciones
Código ensamblador sin optimizar
Código ensamblador optimizado

### 4.2.1. CÓDIGO INTERMEDIO
El código intermedio separa el front-end (análisis léxico, sintáctico y semántico) del back-end (generación del código ensamblador y optimización).

Para este compilador se utiliza el código de tres direcciones, en el que cada instrucción contiene un operador, dos operandos (si es el caso) y una dirección donde se guarda el resultado.

#### 4.2.1.1. CLASES PRINCIPALES
El módulo de generación de código intermedio se ha implementado mediante dos clases principales:

##### 4.2.1.1.1. Generador
Esta clase se encarga de:
Generar variables temporales: variables intermedias que almacenan resultados parciales de operaciones complejas
Generar etiquetas: identificadores para marcar posiciones del código usadas en saltos condicionales, bucles y bloques de control.
Gestionar saltos de bucles: mantiene pilas de etiquetas (break, continue) para manejar correctamente bucles anidados.

En resumen, Generador proporciona los recursos necesarios para que el código intermedio pueda manejar operaciones complejas y estructuras de control de manera ordenada y consistente.

##### 4.2.1.1.2. Instruccion
Esta clase representa una instrucción individual del código intermedio. Cada instrucción incluye:
Operación (opCode): define la acción a realizar, como suma, resta, asignación, saltos condicionales, entrada o salida.
Operandos (operador1, operador2): variables constantes o temporales sobre las que actúa la operación.
Resultado (resultado): variable temporal o destino donde se almacena el resultado.
Tipo de dato (tipo): opcional, utilizado principalmente en operaciones de entrada y salida para indicar el tipo (entero, cadena, booleano, etc.).

Instruccion permite encapsular cada operación del programa de manera uniforme, facilitando su posterior traducción a ensamblador.

#### 4.2.1.2. GENERACIÓN DE VARIABLES TEMPORALES Y ETIQUETAS
Para implementar expresiones y control de flujo se utilizan:
Temporales: almacenan resultados intermedios de expresiones complejas.
Etiquetas: identificadores para saltos condicionales, bucles y bloques de control.
Stack de etiquetas: gestiona correctamente break y continue en bucles anidados.

Esto garantiza que el código intermedio sea consistente, evitando conflictos de nombres y asegurando la correcta ejecución del lenguaje del compilador.

#### 4.2.1.3. MANEJO DE OPERACIONES Y ESTRUCTURAS DE CONTROL
El código intermedio traduce:
Expresiones aritméticas y lógicas descomponiéndose en operaciones simples con temporales.
Condicionales, representando saltos hacia etiquetas que delimitan los bloques si y sino.
Bucles, utilizando etiquetas para marcar el inicio y fin de cada iteración.
Operaciones de entrada y salida, indicando opcionalmente el tipo de dato.

Esta representación permite que cualquier estructura del lenguaje se pueda traducir a código ensamblador de manera directa.

### 4.3. Optimización de Código

El módulo `Optimizador.java` realiza **7 optimizaciones** sobre el código intermedio mediante múltiples pasadas iterativas. El optimizador continúa ejecutándose mientras haya cambios (punto fijo):

```java
boolean cambio = true;
while (cambio) {
    cambio = false;
    cambio |= calcularConstantes(codigo);
    cambio |= fusionarLecturaAsignacion(codigo);
    cambio |= asignacionDiferida(codigo);
    cambio |= simplificacionAlgebraica(codigo);
    cambio |= ramificacionesAdyacentes(codigo);
    cambio |= eliminarEtiquetasMuertas(codigo);
    cambio |= eliminarCodigoMuerto(codigo);
}
```

**1. Cálculo de Constantes:** Evalúa operaciones binarias con operandos constantes en compilación.
```
Antes:  t1 = 10 + 5
Después: t1 = 15
```

**2. Fusión de Lectura de Array:** Elimina temporales al leer arrays.
```
Antes:  t_temp = IND_VAL matriz[offset]
        resultado = t_temp
Después: IND_VAL matriz[offset] → resultado
```

**3. Asignación Diferida:** Reemplaza temporales con uso único por sus valores.
```
Antes:  t1 = a + b
        resultado = t1
Después: resultado = a + b
```

**4. Simplificación Algebraica:** Elimina operaciones neutras.
```
x = y + 0  →  x = y
x = y * 1  →  x = y
x = y * 0  →  x = 0
```

**5. Ramificaciones Adyacentes:** Elimina saltos a etiqueta siguiente.
```
Antes:  código...
        GOTO L_2
        L_2: más código
Después: código...
        (GOTO eliminado)
```

**6. Etiquetas Muertas:** Elimina labels no usados en saltos.
```
Antes:  L_unused: código
Después: (L_unused eliminada si no hay GOTO a ella)
```

**7. Código Muerto:** Elimina asignaciones a variables no usadas después.
```
Antes:  x = 5
        y = 10
        resultado = y
Después: y = 10
        resultado = y
```

### 4.4. CÓDIGO ENSAMBLADOR
#### 4.4.1. ESTRUCTURA: EASY68K
Se ha utilizado Easy68K como arquitectura para realizar el compilador. Es un simulador para la arquitectura Motorola 68000. La memoria se organiza en:
Código: ORG $1000,donde empieza la ejecución del programa.
Pila: ORG $5000,utilizada para almacenar variables locales, parámetros de función y dirección de retorno en llamadas a subrutinas.

Easy68K es una arquitectura basada en registros:
Registros de datos (D0-D7): se usan para cálculos, almacenamiento temporal y paso de valores.
Registros de direcciones (A0-A7): se usan para apuntadores a memoria, stack y acceso a variables.

La comunicación con el usuario se realiza mediante traps, que son llamadas a funciones del simulador. Ejemplos:
TRAP #15 con D0=3 imprime un número en pantalla.
TRAP #15 con D0=13 imprime una cadena de texto.
TRAP #15 con D0=4 permite leer números desde teclado.

#### 4.4.2. Manejo de Arrays: HEAP y Asignación Dinámica

Los arrays se almacenan dinámicamente en el HEAP (memoria dinámica), usando un puntero global `HEAP_PTR` que apunta a la siguiente posición libre.

**Instrucción ALLOC: Reserva de memoria**

```
Código intermedio:
  ALLOC tamaño → variable_array

Código 68K:
  MOVE.L HEAP_PTR, D0         ; D0 = dirección libre actual
  MOVE.L D0, variable_array   ; Guardar dirección base
  ADD.L #tamaño, D0           ; Calcular siguiente pos. libre
  MOVE.L D0, HEAP_PTR         ; Actualizar puntero global
```

**Ejemplo: Matriz 3×3 de números**

```
Código natural:
  lista de numero matriz de longitud 3, 3.

Código 68K:
  MOVE.L HEAP_PTR, D0     ; D0 = dirección actual del heap
  MOVE.L D0, matriz       ; matriz apunta a D0
  ADD.L #36, D0           ; 3*3*4=36 bytes (números son 4 bytes)
  MOVE.L D0, HEAP_PTR     ; Actualizar heap
```

**Instrucción IND_ASS: Asignación a elemento de array**

Para asignar `matriz[1,2] = 999` con offset 20:

```
Código intermedio:
  IND_ASS 999, 20 → matriz

Código 68K:
  MOVEA.L matriz, A0      ; A0 = dirección base de matriz
  MOVE.L #20, D0          ; D0 = offset en bytes
  MOVE.L #999, D1         ; D1 = valor a asignar
  MOVE.L D1, 0(A0, D0.L)  ; MEM[A0+20] = 999
```

**Instrucción IND_VAL: Lectura de elemento de array**

Para leer `x = matriz[1,2]` con offset 20:

```
Código intermedio:
  IND_VAL matriz, 20 → x

Código 68K:
  MOVEA.L matriz, A0      ; A0 = dirección base
  MOVE.L #20, D0          ; D0 = offset en bytes
  MOVE.L 0(A0, D0.L), D1  ; D1 = MEM[A0+20]
  MOVE.L D1, x            ; x = D1
```

**Cálculo de offset para arrays multidimensionales**

Para matriz[i,j] en array [M,N]:
```
offset_lineal = i*N + j
offset_bytes = offset_lineal * 4
```

Ejemplo: matriz[1,2] en [3,3] de números (4 bytes):
```
offset_lineal = 1*3 + 2 = 5
offset_bytes = 5 * 4 = 20 bytes
```

#### 4.4.3. ESTRUCTURA DE LA SALIDA

El fichero Generador68K.java traduce el código intermedio a código ensamblador Easy68K.

**Cabecera e inicialización HEAP**

```asm
ORG $1000
START:
  LEA STACKPTR, A7         ; Inicializar pila
  MOVE.L #$2000, HEAP_PTR  ; Inicializar heap en $2000
  JMP main
```

**Sección de datos**

```asm
; Variables globales
var_global1:   DS.W 1      ; Variable 16-bit
arr_global1:   DS.L 1      ; Puntero a array (dirección base)

; Literales de string
str0:          DC.B 'Hola',0

; Puntero global del heap
HEAP_PTR:      DS.L 1      ; Dirección siguiente libre en heap
```

**Sección de código**

Contiene funciones y el main que usa ALLOC, IND_ASS e IND_VAL para arrays.

#### 4.4.4. TRADUCCIÓN DE CÓDIGO INTERMEDIO A ENSAMBLADOR
Cada instrucción del código intermedio de tres direcciones se traduce a instrucciones de Easy68K.
Asignaciones: t1 = t2 se traduce como MOVE.W t2, t1.
Operaciones aritméticas: +, -, *, / se realizan usando el registro D0 como temporal y luego se mueve el resultado al destino.
Operaciones unarias: Por ejemplo, NEG t1 se traduce a MOVE.W t1, D0 seguido de NEG.W D0 y MOVE.W D0, t1.
Comparaciones: Expresiones como t1 == t2, t1 != t2, <, > se traducen a CMP.W y saltos condicionales (BEQ, BNE, BLT, …).
IF / IF_ELSE: Si el operando incluye comparaciones, se descompone y se genera el salto correcto; si es un valor booleano, se compara con 0 para decidir el salto.
Llamadas a funciones: Los parámetros se guardan temporalmente (pendingParams) y se asignan a registros o variables de la función antes de ejecutar JSR.

# 5. RESUMEN Y CONCLUSION.

## 5.1. Fases del Compilador (Resumen)
```
┌────────────────────────────────────────────────────────────┐
│ ETAPA 1: ANÁLISIS LÉXICO (Scanner + JFlex)                │
│ Entrada: archivo.txt → Salida: tokens                      │
└────────────────────────────────────────────────────────────┘
            ↓
┌────────────────────────────────────────────────────────────┐
│ ETAPA 2: ANÁLISIS SINTÁCTICO (Parser + Java CUP)          │
│ Entrada: tokens → Salida: AST                              │
└────────────────────────────────────────────────────────────┘
            ↓
┌────────────────────────────────────────────────────────────┐
│ ETAPA 3: ANÁLISIS SEMÁNTICO                                │
│ Entrada: AST → Salida: AST anotado + Tabla de símbolos    │
└────────────────────────────────────────────────────────────┘
            ↓
┌────────────────────────────────────────────────────────────┐
│ ETAPA 4: GENERACIÓN CÓDIGO INTERMEDIO                      │
│ Entrada: AST → Salida: 3-Address Code                      │
└────────────────────────────────────────────────────────────┘
            ↓
┌────────────────────────────────────────────────────────────┐
│ ETAPA 5: OPTIMIZACIÓN                                      │
│ Entrada: Código intermedio → Salida: Código optimizado     │
└────────────────────────────────────────────────────────────┘
            ↓
┌────────────────────────────────────────────────────────────┐
│ ETAPA 6: GENERACIÓN CÓDIGO 68K                             │
│ Entrada: Código intermedio → Salida: archivo.x68           │
└────────────────────────────────────────────────────────────┘
```

### 5.2. Tecnologías Clave
Análisis léxico → JFlex
Generación del scanner (reconocimiento de tokens).

Análisis sintáctico → Java CUP
Generación del parser LALR.

Análisis semántico → Java (manual)
Comprobación de tipos y gestión de ámbitos (scope).

Código intermedio → Java (manual)
Generación de código de tres direcciones (3-Address Code).

Optimización → Java (manual)
Aplicación de optimizaciones básicas sobre el código intermedio.

Generación de ensamblador → Java (manual)
Traducción a ensamblador Motorola 68000.

Visualización del AST → Graphviz
Exportación del árbol sintáctico a formato .dot.

### 5.3. Características del Compilador
✓ Lenguaje con sintaxis natural en español
✓ Tipado fuerte con análisis semántico
✓ Soporta funciones, arrays, condicionales, bucles
✓ Manejo de alcance (variables globales/locales)
✓ Generación de múltiples formatos (intermedio, asm, dot)
✓ Optimización de código
✓ Manejo de errores con línea y columna
✓ Tabla de símbolos jerárquica

### 5.4. Desafíos y Soluciones Implementadas
Aqui deberiamos poner cosas nuestras

### 5.5. Estructura de Directorios
```
src/
  ├── lenguaje/
  │   └── LenguajeNatural.java         (punto de entrada)
  ├── compiler/
  │   ├── lexic/
  │   │   ├── lexic_natural.flex       (definición léxica)
  │   │   └── Scanner.java             (generado)
  │   ├── sintactic/
  │   │   ├── sintactic_natural.cup    (definición sintáctica)
  │   │   ├── Parser.java              (generado)
  │   │   ├── ParserSym.java           (generado)
  │   │   └── Symbols/*.java           (clases de nodos AST)
  │   ├── codigo_intermedio/
  │   │   ├── Generador.java
  │   │   ├── Instruccion.java
  │   │   └── Optimizador.java
  │   └── codigo_ensamblador/
  │       └── Generador68K.java
  └── programas/                       (ejemplos)
```

### 5.6. Conclusiones
1. **Implementación completa** de un compilador de lenguaje natural → Motorola 68K
2. **Herramientas estándar** (JFlex, JavaCUP) integradas correctamente
3. **Análisis semántico robusto** con tabla de símbolos jerárquica
4. **Generación de múltiples formatos** para facilitar depuración
5. **Optimización básica pero efectiva** en código intermedio
6. **Código educativo** que demuestra todos los conceptos de compiladores

### 5.7. Referencias y Recursos
- **Documentación de JFlex:** https://jflex.de/
- **Documentación de JavaCUP:** http://www2.cs.tum.edu/projects/cup/
- **Documentación de Graphviz:** https://graphviz.org/documentation/
- **Código fuente:** Disponible aqui y en el github https://github.com/TheStargate/Compilador-Natural

---

**Fecha: 2025-2026 | Asignatura: Compiladores | Profesor: Pere Palmer**
