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
	; a = 10
	MOVE.W #10, a
	; b = 0
	MOVE.W #0, b
	; c = 5
	MOVE.W #5, c
	; t5 = a / c
	MOVE.W a, D0
	TST.W c
	BEQ DIV_ZERO_ERROR
	DIVS c, D0
	MOVE.W D0, t5
	; resultado = t5
	MOVE.W t5, resultado
	; output resultado
	MOVE.W resultado, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t9 = a / b
	MOVE.W a, D0
	TST.W b
	BEQ DIV_ZERO_ERROR
	DIVS b, D0
	MOVE.W D0, t9
	; resultado = t9
	MOVE.W t9, resultado
	; output resultado
	MOVE.W resultado, D1
	JSR PRINT_SIGNED
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
a:	DS.W 1
t5:	DS.W 1
b:	DS.W 1
c:	DS.W 1
resultado:	DS.W 1
t9:	DS.W 1

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
