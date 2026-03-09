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

READ_STRING:
	MOVE.L D0, -(A7)
	MOVE.B #2, D0
	TRAP #15
	MOVE.L (A7)+, D0
	RTS

main:
	; output "=== TEST: Lectura de frase ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Introduce una frase (ej: g):"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; input c
	LEA c, A1
	MOVE.W #80, D1
	JSR READ_STRING
	; output "Has introducido: "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; t0 = c
	MOVE.L c, t0
	; output t0
	LEA t0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Test completado"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
c:	DS.B 80
str3:	DC.B 'Test completado',0
str1:	DC.B 'Introduce una frase (ej: g):',0
str2:	DC.B 'Has introducido: ',0
str0:	DC.B '=== TEST: Lectura de frase ===',0
t0:	DS.B 80

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
