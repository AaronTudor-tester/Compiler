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

READ_CHAR:
	MOVE.B #5, D0
	TRAP #15
	RTS

main:
	; output "=== TEST: Lectura de char ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Introduce un char (ej: g):"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; input c
	JSR READ_CHAR
	MOVE.B D1, c
	; output "Has introducido: "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; t0 = c
	MOVE.B c, t0
	; output t0
	MOVE.B t0, D1
	MOVE.B #6, D0
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
INPUT_BUFFER:	DS.B 80
HEAP_PTR:	DC.L $8000
c:	DS.B 1
str3:	DC.B 'Test completado',0
str1:	DC.B 'Introduce un char (ej: g):',0
str2:	DC.B 'Has introducido: ',0
str0:	DC.B '=== TEST: Lectura de char ===',0
t0:	DS.B 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
