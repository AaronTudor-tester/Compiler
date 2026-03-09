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
	; t0 = 10
	MOVE.W #10, t0
	; a = t0
	MOVE.W t0, a
	; t1 = 5
	MOVE.W #5, t1
	; b = t1
	MOVE.W t1, b
	; t2 = a
	MOVE.W a, t2
	; t3 = b
	MOVE.W b, t3
	; t4 = t2 + t3
	MOVE.W t2, D0
	ADD.W t3, D0
	MOVE.W D0, t4
	; suma = t4
	MOVE.W t4, suma
	; output "Suma: "
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; t5 = suma
	MOVE.W suma, t5
	; output t5
	MOVE.W t5, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t6 = a
	MOVE.W a, t6
	; t7 = b
	MOVE.W b, t7
	; t8 = t6 - t7
	MOVE.W t6, D0
	SUB.W t7, D0
	MOVE.W D0, t8
	; resta = t8
	MOVE.W t8, resta
	; output "Resta: "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; t9 = resta
	MOVE.W resta, t9
	; output t9
	MOVE.W t9, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t10 = a
	MOVE.W a, t10
	; t11 = b
	MOVE.W b, t11
	; t12 = t10 * t11
	MOVE.W t10, D0
	MULS t11, D0
	MOVE.W D0, t12
	; multiplicacion = t12
	MOVE.W t12, multiplicacion
	; output "Multiplicación: "
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; t13 = multiplicacion
	MOVE.W multiplicacion, t13
	; output t13
	MOVE.W t13, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t14 = a
	MOVE.W a, t14
	; t15 = b
	MOVE.W b, t15
	; t16 = t14 / t15
	MOVE.W t14, D0
	TST.W t15
	BEQ DIV_ZERO_ERROR
	DIVS t15, D0
	MOVE.W D0, t16
	; division = t16
	MOVE.W t16, division
	; output "División: "
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; t17 = division
	MOVE.W division, t17
	; output t17
	MOVE.W t17, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t18 = a
	MOVE.W a, t18
	; t19 = b
	MOVE.W b, t19
	; t20 = t18 % t19
	MOVE.W t18, D0
	MOVE.W t19, D1
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
	; t21 = modulo
	MOVE.W modulo, t21
	; output t21
	MOVE.W t21, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
suma:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
division:	DS.W 1
t10:	DS.W 1
str5:	DC.B 'Módulo: ',0
t12:	DS.W 1
str3:	DC.B 'Multiplicación: ',0
t11:	DS.W 1
str4:	DC.B 'División: ',0
str1:	DC.B 'Suma: ',0
t14:	DS.W 1
str2:	DC.B 'Resta: ',0
t13:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
a:	DS.W 1
multiplicacion:	DS.W 1
b:	DS.W 1
str0:	DC.B '=== CASO 1: OPERACIONES BASICAS ===',0
t21:	DS.W 1
t20:	DS.W 1
resta:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
modulo:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

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
