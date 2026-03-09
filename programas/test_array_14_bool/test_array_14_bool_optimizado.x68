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

PRINT_BOOL:
	TST.W D1
	BEQ .PRINT_MENTIRA
	LEA STR_CIERTO, A1
	BRA .PRINT_BOOL_STR
.PRINT_MENTIRA:
	LEA STR_MENTIRA, A1
.PRINT_BOOL_STR:
	MOVE.B #14, D0
	TRAP #15
	RTS

main:
	; output "=== TEST: Arrays de booleano ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, flags
	ADD.L #8, D0
	MOVE.L D0, HEAP_PTR
	; output "Inicializando flags:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; flags[0] = true
	MOVEA.L flags, A0
	MOVE.L #0, D0
	MOVE.W #1, D1
	MOVE.W D1, 0(A0, D0.L)
	; flags[2] = false
	MOVEA.L flags, A0
	MOVE.L #2, D0
	MOVE.W #0, D1
	MOVE.W D1, 0(A0, D0.L)
	; flags[4] = true
	MOVEA.L flags, A0
	MOVE.L #4, D0
	MOVE.W #1, D1
	MOVE.W D1, 0(A0, D0.L)
	; flags[6] = false
	MOVEA.L flags, A0
	MOVE.L #6, D0
	MOVE.W #0, D1
	MOVE.W D1, 0(A0, D0.L)
	; output "Mostrando flags:"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t27 = flags[0]
	MOVEA.L flags, A0
	MOVE.L #0, D0
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t27
	; output t27
	MOVE.W t27, D1
	JSR PRINT_BOOL
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t34 = flags[2]
	MOVEA.L flags, A0
	MOVE.L #2, D0
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t34
	; output t34
	MOVE.W t34, D1
	JSR PRINT_BOOL
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Modificando posicion 2:"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; flags[4] = false
	MOVEA.L flags, A0
	MOVE.L #4, D0
	MOVE.W #0, D1
	MOVE.W D1, 0(A0, D0.L)
	; t45 = flags[4]
	MOVEA.L flags, A0
	MOVE.L #4, D0
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t45
	; output t45
	MOVE.W t45, D1
	JSR PRINT_BOOL
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Test completado"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
STR_CIERTO:	DC.B 'cierto',0
STR_MENTIRA:	DC.B 'mentira',0
HEAP_PTR:	DC.L $8000
t34:	DS.W 1
str3:	DC.B 'Modificando posicion 2:',0
t45:	DS.W 1
str4:	DC.B 'Test completado',0
str1:	DC.B 'Inicializando flags:',0
str2:	DC.B 'Mostrando flags:',0
flags:	DS.L 1
true:	DS.W 1
false:	DS.W 1
t27:	DS.W 1
str0:	DC.B '=== TEST: Arrays de booleano ===',0

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
