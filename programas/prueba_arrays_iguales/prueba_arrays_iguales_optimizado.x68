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
	; filas = 2
	MOVE.W #2, filas
	; columnas = 3
	MOVE.W #3, columnas
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, A
	MOVE.L #24, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	ADD.L #24, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_A_LOOP_END
	MOVE.L A, A0
INIT_A_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_A_LOOP
INIT_A_LOOP_END:
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, B
	MOVE.L #24, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	ADD.L #24, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_B_LOOP_END
	MOVE.L B, A0
INIT_B_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_B_LOOP
INIT_B_LOOP_END:
	; B[0] = 1
	MOVEA.L B, A0
	MOVE.L #0, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #1, D1
	MOVE.L D1, 0(A0, D0.L)
	; B[4] = 2
	MOVEA.L B, A0
	MOVE.L #4, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #2, D1
	MOVE.L D1, 0(A0, D0.L)
	; B[8] = 3
	MOVEA.L B, A0
	MOVE.L #8, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #3, D1
	MOVE.L D1, 0(A0, D0.L)
	; B[12] = 4
	MOVEA.L B, A0
	MOVE.L #12, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #4, D1
	MOVE.L D1, 0(A0, D0.L)
	; B[16] = 5
	MOVEA.L B, A0
	MOVE.L #16, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #5, D1
	MOVE.L D1, 0(A0, D0.L)
	; B[20] = 6
	MOVEA.L B, A0
	MOVE.L #20, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #6, D1
	MOVE.L D1, 0(A0, D0.L)
	; A[0] = 1
	MOVEA.L A, A0
	MOVE.L #0, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #1, D1
	MOVE.L D1, 0(A0, D0.L)
	; A[4] = 2
	MOVEA.L A, A0
	MOVE.L #4, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #2, D1
	MOVE.L D1, 0(A0, D0.L)
	; A[8] = 3
	MOVEA.L A, A0
	MOVE.L #8, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #3, D1
	MOVE.L D1, 0(A0, D0.L)
	; A[12] = 4
	MOVEA.L A, A0
	MOVE.L #12, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #4, D1
	MOVE.L D1, 0(A0, D0.L)
	; A[16] = 5
	MOVEA.L A, A0
	MOVE.L #16, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #5, D1
	MOVE.L D1, 0(A0, D0.L)
	; A[20] = 6
	MOVEA.L A, A0
	MOVE.L #20, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #6, D1
	MOVE.L D1, 0(A0, D0.L)
	; igual = 1
	MOVE.W #1, igual
	; i = 0
	MOVE.W #0, i
e0:
	; t88 = i < filas
	MOVE.W #0, t88
	MOVE.W i, D0
	CMP.W filas, D0
	BLT t88_true
	JMP t88_false
t88_true:
	MOVE.W #1, t88
t88_false:
	; if !(t88) goto e1
	MOVE.W t88, D0
	CMP.W #0, D0
	BEQ e1
	; j = 0
	MOVE.W #0, j
e2:
	; t92 = j < columnas
	MOVE.W #0, t92
	MOVE.W j, D0
	CMP.W columnas, D0
	BLT t92_true
	JMP t92_false
t92_true:
	MOVE.W #1, t92
t92_false:
	; if !(t92) goto e3
	MOVE.W t92, D0
	CMP.W #0, D0
	BEQ e3
	; t96 = i * 3
	MOVE.W i, D0
	MULS #3, D0
	MOVE.W D0, t96
	; t97 = t96 + j
	MOVE.W t96, D0
	ADD.W j, D0
	MOVE.W D0, t97
	; t99 = t97 * 4
	MOVE.W t97, D0
	MULS #4, D0
	MOVE.W D0, t99
	; t100 = 6
	MOVE.W #6, t100
	; t104 = A[t99]
	MOVEA.L A, A0
	CLR.L D0
	MOVE.W t99, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t100, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t104
	; vaA = t104
	MOVE.W t104, vaA
	; t108 = i * 3
	MOVE.W i, D0
	MULS #3, D0
	MOVE.W D0, t108
	; t109 = t108 + j
	MOVE.W t108, D0
	ADD.W j, D0
	MOVE.W D0, t109
	; t111 = t109 * 4
	MOVE.W t109, D0
	MULS #4, D0
	MOVE.W D0, t111
	; t112 = 6
	MOVE.W #6, t112
	; t116 = B[t111]
	MOVEA.L B, A0
	CLR.L D0
	MOVE.W t111, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t112, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t116
	; vaB = t116
	MOVE.W t116, vaB
	; t119 = vaA == vaB
	MOVE.W #0, t119
	MOVE.W vaA, D0
	CMP.W vaB, D0
	BEQ t119_true
	JMP t119_false
t119_true:
	MOVE.W #1, t119
t119_false:
	; t122 = vaA == vaB
	MOVE.W #0, t122
	MOVE.W vaA, D0
	CMP.W vaB, D0
	BEQ t122_true
	JMP t122_false
t122_true:
	MOVE.W #1, t122
t122_false:
	; t123 = ! t122
	MOVE.W t122, D0
	CMP.W #0, D0
	BEQ t123_not_true
	MOVE.W #0, t123
	JMP t123_not_end
t123_not_true:
	MOVE.W #1, t123
t123_not_end:
	; if !(t123) goto e6
	MOVE.W t123, D0
	CMP.W #0, D0
	BEQ e6
	; igual = 0
	MOVE.W #0, igual
	; goto e3
	JMP e3
e6:
	; j = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, j
	; goto e2
	JMP e2
e3:
	; t127 = igual == 0
	MOVE.W #0, t127
	MOVE.W igual, D0
	CMP.W #0, D0
	BEQ t127_true
	JMP t127_false
t127_true:
	MOVE.W #1, t127
t127_false:
	; if !(t127) goto e8
	MOVE.W t127, D0
	CMP.W #0, D0
	BEQ e8
	; goto e1
	JMP e1
e8:
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e0
	JMP e0
e1:
	; t130 = igual == 1
	MOVE.W #0, t130
	MOVE.W igual, D0
	CMP.W #1, D0
	BEQ t130_true
	JMP t130_false
t130_true:
	MOVE.W #1, t130
t130_false:
	; if !(t130) goto e10
	MOVE.W t130, D0
	CMP.W #0, D0
	BEQ e10
	; output "Las matrices son IGUALES."
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
e10:
	; t133 = igual == 0
	MOVE.W #0, t133
	MOVE.W igual, D0
	CMP.W #0, D0
	BEQ t133_true
	JMP t133_false
t133_true:
	MOVE.W #1, t133
t133_false:
	; if !(t133) goto e12
	MOVE.W t133, D0
	CMP.W #0, D0
	BEQ e12
	; output "Las matrices son DISTINTAS."
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
e12:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
A:	DS.L 1
B:	DS.L 1
t100:	DS.W 1
t122:	DS.W 1
t123:	DS.W 1
t92:	DS.W 1
t96:	DS.W 1
t119:	DS.W 1
t97:	DS.W 1
t99:	DS.W 1
str1:	DC.B 'Las matrices son DISTINTAS.',0
t116:	DS.W 1
columnas:	DS.W 1
t111:	DS.W 1
t133:	DS.W 1
i:	DS.W 1
str0:	DC.B 'Las matrices son IGUALES.',0
j:	DS.W 1
t112:	DS.W 1
t130:	DS.W 1
t108:	DS.W 1
t109:	DS.W 1
t104:	DS.W 1
filas:	DS.W 1
t88:	DS.W 1
vaB:	DS.W 1
vaA:	DS.W 1
t127:	DS.W 1
igual:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
