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
	; t0 = 10
	MOVE.W #10, t0
	; a = t0
	MOVE.W t0, a
	; t1 = 0
	MOVE.W #0, t1
	; b = t1
	MOVE.W t1, b
	; t2 = 5
	MOVE.W #5, t2
	; c = t2
	MOVE.W t2, c
	; t3 = a
	MOVE.W a, t3
	; t4 = c
	MOVE.W c, t4
	; t5 = t3 / t4
	MOVE.W t3, D0
	TST.W t4
	BEQ DIV_ZERO_ERROR
	DIVS t4, D0
	MOVE.W D0, t5
	; resultado = t5
	MOVE.W t5, resultado
	; t6 = resultado
	MOVE.W resultado, t6
	; output t6
	MOVE.W t6, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t7 = a
	MOVE.W a, t7
	; t8 = b
	MOVE.W b, t8
	; t9 = t7 / t8
	MOVE.W t7, D0
	TST.W t8
	BEQ DIV_ZERO_ERROR
	DIVS t8, D0
	MOVE.W D0, t9
	; resultado = t9
	MOVE.W t9, resultado
	; t10 = resultado
	MOVE.W resultado, t10
	; output t10
	MOVE.W t10, D1
	JSR PRINT_SIGNED
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
a:	DS.W 1
t5:	DS.W 1
b:	DS.W 1
t6:	DS.W 1
c:	DS.W 1
t7:	DS.W 1
resultado:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t10:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
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
