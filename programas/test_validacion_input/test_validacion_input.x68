; Easy68K Assembly Generated
	ORG $1000
START:
	LEA STACKPTR, A7	; Initialize stack pointer
	JMP main		; Jump to main program

; ===== RUTINAS AUXILIARES =====
PRINT_SIGNED:
	; D1 contiene el número a mostrar (con signo)
	; Si es negativo, muestra '-' y el valor absoluto
	TST.W D1		; Probar el signo
	BPL PRINT_UNSIGNED	; Si es positivo, saltar
	; Es negativo: mostrar '-'
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	; Negar el valor
	NEG.W D1
PRINT_UNSIGNED:
	; Mostrar el número (ahora positivo) usando Task #3
	MOVE.B #3, D0	; Task 3 = Display number
	TRAP #15
	RTS

PRINT_SIGNED_LONG:
	; D1 contiene el número de 32 bits a mostrar (con signo)
	TST.L D1		; Probar el signo
	BPL PRINT_UNSIGNED_LONG	; Si es positivo, saltar
	; Es negativo: mostrar '-'
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	; Negar el valor
	NEG.L D1
PRINT_UNSIGNED_LONG:
	; Mostrar el número de 32 bits (ahora positivo)
	MOVE.B #3, D0	; Task 3 = Display signed number at D1.L
	TRAP #15
	RTS

PRINT_DECIMAL_2:
	; D1 = numero escalado x100 (ej: 350 = 3.50)
	; Guardar original en D3 (32-bit)
	MOVE.L D1, D3
	; Manejar signo: si negativo, imprimir '-' y tomar abs
	TST.L D3
	BPL .PD2_POSITIVE
	; imprimir '-'
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	NEG.L D3
.PD2_POSITIVE:
	; Calcular parte entera: D2 = original / 100
	MOVE.L D3, D2
	MOVE.W #100, D4
	DIVS D4, D2
	; Calcular fracción: D3 = remainder = original - (parte_entera*100)
	MOVE.L D2, D5
	MOVE.W #100, D4
	MOVE.L D5, D6
	CLR.L D0
	MOVE.W D4, D0
	MULS D0, D6
	SUB.L D6, D3
	; Imprimir parte entera usando Task 3
	CLR.L D1
	MOVE.W D2, D1
	MOVE.B #3, D0
	TRAP #15
	; Imprimir punto decimal
	LEA DECIMAL_POINT, A1
	MOVE.B #14, D0
	TRAP #15
	; Imprimir fracción con 2 dígitos
	CLR.L D0
	MOVE.W D3, D0
	CMP.W #10, D0
	BGE .PD2_SKIP_ZERO
	; imprimir '0' si <10
	LEA ZERO_CHAR, A1
	MOVE.B #14, D0
	TRAP #15
.PD2_SKIP_ZERO:
	CLR.L D1
	MOVE.W D3, D1
	MOVE.B #3, D0
	TRAP #15
	RTS

PRINT_BOOL:
	; D1 contiene el valor booleano (0=mentira, 1=cierto)
	TST.W D1		; Probar si es 0
	BEQ .PRINT_MENTIRA	; Si es 0, imprimir 'mentira'
	; Es cierto (1)
	LEA STR_CIERTO, A1
	BRA .PRINT_BOOL_STR
.PRINT_MENTIRA:
	LEA STR_MENTIRA, A1
.PRINT_BOOL_STR:
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	RTS

READ_NUM_VALID:
	; Lee un número validando que la entrada sea válida
	; Si la entrada no es válida, muestra error y vuelve a pedir
	; Resultado en D1.W
.RNV_RETRY:
	; Leer string desde teclado (Task 2)
	LEA INPUT_BUFFER, A1
	MOVE.B #2, D0	; Task 2 = Read string
	TRAP #15
	; A1 apunta al buffer con el string leído
	LEA INPUT_BUFFER, A1
	; Validar: Verificar que solo contenga dígitos y opcionalmente signo
	CLR.W D2		; Flag: 0=positivo, 1=negativo
	CLR.L D3		; Acumulador del número
	CLR.L D4		; Contador de dígitos válidos
	; Verificar primer carácter (puede ser '-' o dígito)
	MOVE.B (A1), D5
	CMP.B #0, D5	; String vacío?
	BEQ .RNV_ERR
	CMP.B #'-', D5	; Es signo negativo?
	BNE .RNV_CHK
	; Es negativo
	MOVE.W #1, D2	; Flag negativo
	ADDA.L #1, A1	; Avanzar al siguiente carácter
.RNV_CHK:
	; Ahora todos los caracteres deben ser dígitos
.RNV_LOOP:
	MOVE.B (A1)+, D5	; Leer carácter
	CMP.B #0, D5		; Fin del string?
	BEQ .RNV_VALID
	CMP.B #10, D5		; Salto de línea?
	BEQ .RNV_VALID
	CMP.B #13, D5		; Retorno de carro?
	BEQ .RNV_VALID
	; Verificar que sea dígito (0-9 = ASCII 48-57)
	CMP.B #'0', D5
	BLT .RNV_ERR		; Menor que '0'
	CMP.B #'9', D5
	BGT .RNV_ERR		; Mayor que '9'
	; Es un dígito válido
	ADD.L #1, D4		; Incrementar contador de dígitos
	; Convertir carácter a número: D5 = D5 - '0'
	SUB.B #'0', D5
	; Acumular: D3 = D3 * 10 + D5
	MOVE.L D3, D6
	MULS #10, D3
	EXT.W D5
	EXT.L D5
	ADD.L D5, D3
	BRA .RNV_LOOP
.RNV_VALID:
	; Verificar que se leyó al menos un dígito
	TST.L D4
	BEQ .RNV_ERR
	; Número válido, mover a D1
	MOVE.W D3, D1
	; Aplicar signo si es negativo
	TST.W D2
	BEQ .RNV_END
	NEG.W D1
.RNV_END:
	RTS
.RNV_ERR:
	; Mostrar mensaje de error
	LEA ERROR_INPUT_MSG, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; Reintentar
	BRA .RNV_RETRY

main:
	; output "Introduce un numero entero:"
	LEA str0, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; input miNumero
	JSR READ_NUM_VALID
	MOVE.W D1, miNumero
	; output "Has introducido: "
	LEA str1, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t0 = miNumero
	MOVE.W miNumero, t0
	; output t0
	MOVE.W t0, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "Introduce otro numero:"
	LEA str2, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; input otroNumero
	JSR READ_NUM_VALID
	MOVE.W D1, otroNumero
	; t1 = miNumero
	MOVE.W miNumero, t1
	; t2 = otroNumero
	MOVE.W otroNumero, t2
	; t3 = t1 + t2
	MOVE.W t1, D0
	ADD.W t2, D0
	MOVE.W D0, t3
	; suma = t3
	MOVE.W t3, suma
	; output "La suma es: "
	LEA str3, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t4 = suma
	MOVE.W suma, t4
	; output t4
	MOVE.W t4, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
ERROR_INPUT_MSG:	DC.B 'ERROR: Entrada invalida. Ingrese un numero valido: ',0
STR_CIERTO:	DC.B 'cierto',0
STR_MENTIRA:	DC.B 'mentira',0
INPUT_BUFFER:	DS.B 80	; Buffer para leer entrada del usuario
HEAP_PTR:	DC.L $8000	; Inicio del heap para arrays
suma:	DS.W 1
t4:	DS.W 1
miNumero:	DS.W 1
str3:	DC.B 'La suma es: ',0
str1:	DC.B 'Has introducido: ',0
str2:	DC.B 'Introduce otro numero:',0
str0:	DC.B 'Introduce un numero entero:',0
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
otroNumero:	DS.W 1
t3:	DS.W 1

; ===== MANEJADOR DE ERROR DE DIVISION ENTRE CERO =====
DIV_ZERO_ERROR:
	LEA DIV_ZERO_MSG, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	BRA HALT

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
