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

main:
	; output "=== TEST: Indice con variable ==="
	LEA str0, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, vector
	ADD.L #20, D0
	MOVE.L D0, HEAP_PTR
	; vector[0] = 10
	MOVEA.L vector, A0
	MOVE.L #0, D0
	MOVE.L #10, D1
	MOVE.L D1, 0(A0, D0.L)
	; vector[4] = 20
	MOVEA.L vector, A0
	MOVE.L #4, D0
	MOVE.L #20, D1
	MOVE.L D1, 0(A0, D0.L)
	; vector[8] = 30
	MOVEA.L vector, A0
	MOVE.L #8, D0
	MOVE.L #30, D1
	MOVE.L D1, 0(A0, D0.L)
	; vector[12] = 40
	MOVEA.L vector, A0
	MOVE.L #12, D0
	MOVE.L #40, D1
	MOVE.L D1, 0(A0, D0.L)
	; vector[16] = 50
	MOVEA.L vector, A0
	MOVE.L #16, D0
	MOVE.L #50, D1
	MOVE.L D1, 0(A0, D0.L)
	; indice = 2
	MOVE.W #2, indice
	; output "Leyendo posicion con variable (indice=2):"
	LEA str1, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t26 = indice * 4
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W indice, D0
	MULS #4, D0
	MOVE.W D0, t26
	; t27 = vector[t26]
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t26, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t27
	; output t27
	MOVE.W t27, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "Test completado"
	LEA str2, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
STR_CIERTO:	DC.B 'cierto',0
STR_MENTIRA:	DC.B 'mentira',0
HEAP_PTR:	DC.L $8000	; Inicio del heap para arrays
indice:	DS.W 1
str1:	DC.B 'Leyendo posicion con variable (indice=2):',0
str2:	DC.B 'Test completado',0
t27:	DS.W 1
str0:	DC.B '=== TEST: Indice con variable ===',0
t26:	DS.W 1
vector:	DS.L 1

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
