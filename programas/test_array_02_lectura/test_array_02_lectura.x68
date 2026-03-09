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
	; t0 = 3
	MOVE.W #3, t0
	; t1 = 4
	MOVE.W #4, t1
	; t2 = t0 * t1
	MOVE.W t0, D0
	MULS t1, D0
	MOVE.W D0, t2
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, vector
	CLR.L D1
	MOVE.W t2, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t2, D1
	ADD.L D1, D0
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
	; t3 = 10
	MOVE.W #10, t3
	; t4 = 0
	MOVE.W #0, t4
	; t5 = 4
	MOVE.W #4, t5
	; t6 = t4 * t5
	MOVE.W t4, D0
	MULS t5, D0
	MOVE.W D0, t6
	; vector[t6] = t3
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t6, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t3, D1
	MOVE.L D1, 0(A0, D0.L)
	; t7 = 20
	MOVE.W #20, t7
	; t8 = 1
	MOVE.W #1, t8
	; t9 = 4
	MOVE.W #4, t9
	; t10 = t8 * t9
	MOVE.W t8, D0
	MULS t9, D0
	MOVE.W D0, t10
	; vector[t10] = t7
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t10, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t7, D1
	MOVE.L D1, 0(A0, D0.L)
	; t11 = 30
	MOVE.W #30, t11
	; t12 = 2
	MOVE.W #2, t12
	; t13 = 4
	MOVE.W #4, t13
	; t14 = t12 * t13
	MOVE.W t12, D0
	MULS t13, D0
	MOVE.W D0, t14
	; vector[t14] = t11
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t14, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t11, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Leyendo posicion 0:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; t15 = 0
	MOVE.W #0, t15
	; t16 = 4
	MOVE.W #4, t16
	; t17 = t15 * t16
	MOVE.W t15, D0
	MULS t16, D0
	MOVE.W D0, t17
	; t19 = 3
	MOVE.W #3, t19
	; t18 = t19
	MOVE.W t19, t18
	; t20 = vector[t17]
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t17, D0
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
	; t21 = 1
	MOVE.W #1, t21
	; t22 = 4
	MOVE.W #4, t22
	; t23 = t21 * t22
	MOVE.W t21, D0
	MULS t22, D0
	MOVE.W D0, t23
	; t25 = 3
	MOVE.W #3, t25
	; t24 = t25
	MOVE.W t25, t24
	; t26 = vector[t23]
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t23, D0
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
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t10:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'Test completado',0
t11:	DS.W 1
t14:	DS.W 1
str1:	DC.B 'Leyendo posicion 0:',0
t13:	DS.W 1
str2:	DC.B 'Leyendo posicion 1:',0
t16:	DS.W 1
t15:	DS.W 1
vector:	DS.L 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B '=== TEST: Lectura de array ===',0
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.W 1
t24:	DS.W 1
t26:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
