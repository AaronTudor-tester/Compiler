	ORG $1000
START:
	LEA STACKPTR, A7
	JMP main

; ===== RUTINAS AUXILIARES =====

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
	; t0 = 1
	MOVE.W #1, t0
	; t1 = 4
	MOVE.W #4, t1
	; t2 = t0 * t1
	MOVE.W t0, D0
	MULS t1, D0
	MOVE.W D0, t2
	; t3 = 4
	MOVE.W #4, t3
	; t4 = t2 * t3
	MOVE.W t2, D0
	MULS t3, D0
	MOVE.W D0, t4
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, arr
	CLR.L D1
	MOVE.W t4, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t4, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_arr_LOOP_END
	MOVE.L arr, A0
INIT_arr_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_arr_LOOP
INIT_arr_LOOP_END:
	; t5 = 0
	MOVE.W #0, t5
	; t6 = 4
	MOVE.W #4, t6
	; t7 = t5 * t6
	MOVE.W t5, D0
	MULS t6, D0
	MOVE.W D0, t7
	; t8 = 10
	MOVE.W #10, t8
	; arr[t7] = t8
	MOVEA.L arr, A0
	CLR.L D0
	MOVE.W t7, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t8, D1
	MOVE.L D1, 0(A0, D0.L)
	; t9 = 1
	MOVE.W #1, t9
	; t10 = 4
	MOVE.W #4, t10
	; t11 = t9 * t10
	MOVE.W t9, D0
	MULS t10, D0
	MOVE.W D0, t11
	; t12 = 20
	MOVE.W #20, t12
	; arr[t11] = t12
	MOVEA.L arr, A0
	CLR.L D0
	MOVE.W t11, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t12, D1
	MOVE.L D1, 0(A0, D0.L)
	; t13 = 3
	MOVE.W #3, t13
	; t14 = 4
	MOVE.W #4, t14
	; t15 = t13 * t14
	MOVE.W t13, D0
	MULS t14, D0
	MOVE.W D0, t15
	; t16 = 40
	MOVE.W #40, t16
	; arr[t15] = t16
	MOVEA.L arr, A0
	CLR.L D0
	MOVE.W t15, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t16, D1
	MOVE.L D1, 0(A0, D0.L)
	; t17 = 2
	MOVE.W #2, t17
	; t18 = 4
	MOVE.W #4, t18
	; t19 = t17 * t18
	MOVE.W t17, D0
	MULS t18, D0
	MOVE.W D0, t19
	; t21 = 4
	MOVE.W #4, t21
	; t20 = t21
	MOVE.W t21, t20
	; t22 = arr[t19]
	MOVEA.L arr, A0
	CLR.L D0
	MOVE.W t19, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t20, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t22
	; x = t22
	MOVE.W t22, x
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
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
t11:	DS.W 1
t14:	DS.W 1
t13:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
arr:	DS.L 1
t21:	DS.W 1
t20:	DS.W 1
t22:	DS.W 1
x:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
