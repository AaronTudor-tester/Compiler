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

suma:
	; ; param a : INT
	; ; param b : INT
	; t0 = a
	MOVE.W a, t0
	; t1 = b
	MOVE.W b, t1
	; t2 = t0 + t1
	MOVE.W t0, D0
	ADD.W t1, D0
	MOVE.W D0, t2
	; return t2
	MOVE.W t2, D0
	RTS
saludo:
	; output "Hola mundo"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; return null
	RTS
main:
	; t3 = 2
	MOVE.W #2, t3
	; t4 = 3
	MOVE.W #3, t4
	; param_s t3  
	; param_s t4  
	; t5 = call suma
	MOVE.W t3, a
	MOVE.W t4, b
	JSR suma
	MOVE.W D0, t5
	; output t5
	MOVE.W t5, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; call saludo  
	JSR saludo
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
a:	DS.W 1
t5:	DS.W 1
b:	DS.W 1
str0:	DC.B 'Hola mundo',0
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
