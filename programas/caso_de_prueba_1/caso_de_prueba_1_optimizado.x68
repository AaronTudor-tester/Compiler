	ORG $1000
START:
	LEA STACKPTR, A7
	JMP main

; ===== RUTINAS AUXILIARES =====
PRINT_SIGNED:
	TST.W D1
	BPL PRINT_UNSIGNED
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	NEG.W D1
PRINT_UNSIGNED:
	MOVE.B #3, D0
	TRAP #15
	RTS

main:
	; output "=== CASO 1: OPERACIONES BASICAS ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; a = 10
	MOVE.W #10, a
	; b = 5
	MOVE.W #5, b
	; t4 = a + b
	MOVE.W a, D0
	ADD.W b, D0
	MOVE.W D0, t4
	; suma = t4
	MOVE.W t4, suma
	; output "Suma: "
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output suma
	MOVE.W suma, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t8 = a - b
	MOVE.W a, D0
	SUB.W b, D0
	MOVE.W D0, t8
	; resta = t8
	MOVE.W t8, resta
	; output "Resta: "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output resta
	MOVE.W resta, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t12 = a * b
	MOVE.W a, D0
	MULS b, D0
	MOVE.W D0, t12
	; multiplicacion = t12
	MOVE.W t12, multiplicacion
	; output "Multiplicación: "
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output multiplicacion
	MOVE.W multiplicacion, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t16 = a / b
	MOVE.W a, D0
	TST.W b
	BEQ DIV_ZERO_ERROR
	DIVS b, D0
	MOVE.W D0, t16
	; division = t16
	MOVE.W t16, division
	; output "División: "
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output division
	MOVE.W division, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t20 = a % b
	MOVE.W a, D0
	MOVE.W b, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	EXT.L D0
	MOVE.L D0, D2
	DIVS D1, D0
	CLR.L D3
	MOVE.W D0, D3
	MULS D1, D3
	SUB.L D3, D2
	MOVE.W D2, t20
	; modulo = t20
	MOVE.W t20, modulo
	; output "Módulo: "
	LEA str5, A1
	MOVE.B #14, D0
	TRAP #15
	; output modulo
	MOVE.W modulo, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
suma:	DS.W 1
a:	DS.W 1
multiplicacion:	DS.W 1
b:	DS.W 1
t8:	DS.W 1
str0:	DC.B '=== CASO 1: OPERACIONES BASICAS ===',0
division:	DS.W 1
str5:	DC.B 'Módulo: ',0
t20:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'Multiplicación: ',0
str4:	DC.B 'División: ',0
str1:	DC.B 'Suma: ',0
str2:	DC.B 'Resta: ',0
t16:	DS.W 1
resta:	DS.W 1
modulo:	DS.W 1

; ===== MANEJADOR DE ERROR DE DIVISION ENTRE CERO =====
DIV_ZERO_ERROR:
	LEA DIV_ZERO_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
