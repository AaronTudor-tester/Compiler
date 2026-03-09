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

UNINITIALIZED_ACCESS:
	; Acceso a posicion no inicializada - mostrar mensaje y detener la simulacion
	LEA ERROR_UNINIT_MSG, A1
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
	; output "=== TEST: Lectura de array ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, vector
	MOVE.L #12, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	ADD.L #12, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_vector_LOOP_END
	MOVE.L vector, A0
INIT_vector_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_vector_LOOP
INIT_vector_LOOP_END:
	; vector[0] = 10
	MOVEA.L vector, A0
	MOVE.L #0, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #10, D1
	MOVE.L D1, 0(A0, D0.L)
	; vector[4] = 20
	MOVEA.L vector, A0
	MOVE.L #4, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #20, D1
	MOVE.L D1, 0(A0, D0.L)
	; vector[8] = 30
	MOVEA.L vector, A0
	MOVE.L #8, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #30, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Leyendo posicion 0:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; t18 = 3
	MOVE.W #3, t18
	; t20 = vector[0]
	MOVEA.L vector, A0
	MOVE.L #0, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t18, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t20
	; output t20
	MOVE.W t20, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Leyendo posicion 1:"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; t24 = 3
	MOVE.W #3, t24
	; t26 = vector[4]
	MOVEA.L vector, A0
	MOVE.L #4, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t24, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t26
	; output t26
	MOVE.W t26, D1
	JSR PRINT_SIGNED
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
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t20:	DS.W 1
str3:	DC.B 'Test completado',0
str1:	DC.B 'Leyendo posicion 0:',0
str2:	DC.B 'Leyendo posicion 1:',0
t24:	DS.W 1
str0:	DC.B '=== TEST: Lectura de array ===',0
t26:	DS.W 1
vector:	DS.L 1
t18:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
