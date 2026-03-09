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


ARRAY_INDEX_OUT_OF_BOUNDS:
	; Indice fuera de rango - mostrar mensaje y detener la simulacion
	LEA ERROR_INDEX_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	SIMHALT

ALLOC_SIZE_INVALID:
	; Tamaño de array inválido en tiempo de ejecución - mostrar mensaje y detener
	LEA ERROR_ALLOC_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	SIMHALT
main:
	; output "=== TEST: Arrays de char ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, vocales
	MOVE.L #10, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	ADD.L #10, D0
	MOVE.L D0, HEAP_PTR
	; vocales[0] = 97
	MOVEA.L vocales, A0
	MOVE.L #0, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W #97, D1
	MOVE.W D1, 0(A0, D0.L)
	; vocales[2] = 101
	MOVEA.L vocales, A0
	MOVE.L #2, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W #101, D1
	MOVE.W D1, 0(A0, D0.L)
	; vocales[4] = 105
	MOVEA.L vocales, A0
	MOVE.L #4, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W #105, D1
	MOVE.W D1, 0(A0, D0.L)
	; vocales[6] = 111
	MOVEA.L vocales, A0
	MOVE.L #6, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W #111, D1
	MOVE.W D1, 0(A0, D0.L)
	; vocales[8] = 117
	MOVEA.L vocales, A0
	MOVE.L #8, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W #117, D1
	MOVE.W D1, 0(A0, D0.L)
	; output "Mostrando vocales:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t29 = vocales[0]
	MOVEA.L vocales, A0
	MOVE.L #0, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t26, D2
	EXT.L D2
	MOVE.W #2, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t29
	; output t29
	MOVE.B t29, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t36 = vocales[4]
	MOVEA.L vocales, A0
	MOVE.L #4, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t33, D2
	EXT.L D2
	MOVE.W #2, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t36
	; output t36
	MOVE.B t36, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Modificando posicion 1:"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; vocales[2] = 69
	MOVEA.L vocales, A0
	MOVE.L #2, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W #69, D1
	MOVE.W D1, 0(A0, D0.L)
	; t47 = vocales[2]
	MOVEA.L vocales, A0
	MOVE.L #2, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t44, D2
	EXT.L D2
	MOVE.W #2, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t47
	; output t47
	MOVE.B t47, D1
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
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
str3:	DC.B 'Test completado',0
str1:	DC.B 'Mostrando vocales:',0
t36:	DS.B 1
t47:	DS.B 1
str2:	DC.B 'Modificando posicion 1:',0
str0:	DC.B '=== TEST: Arrays de char ===',0
vocales:	DS.L 1
t29:	DS.B 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
