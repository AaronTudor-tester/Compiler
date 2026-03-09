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


ALLOC_SIZE_INVALID:
	; Tamaño de array inválido en tiempo de ejecución - mostrar mensaje y detener
	LEA ERROR_ALLOC_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	SIMHALT
main:
	; t0 = 1
	MOVE.W #1, t0
	; t1 = 5
	MOVE.W #5, t1
	; t2 = NEG t1
	MOVE.W t1, D0
	NEG.W D0
	MOVE.W D0, t2
	; t3 = t0 * t2
	MOVE.W t0, D0
	MULS t2, D0
	MOVE.W D0, t3
	; t4 = 4
	MOVE.W #4, t4
	; t5 = t3 * t4
	MOVE.W t3, D0
	MULS t4, D0
	MOVE.W D0, t5
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, arr_neg
	CLR.L D1
	MOVE.W t5, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t5, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_arr_neg_LOOP_END
	MOVE.L arr_neg, A0
INIT_arr_neg_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_arr_neg_LOOP
INIT_arr_neg_LOOP_END:
	; t6 = 1
	MOVE.W #1, t6
	; t7 = 0
	MOVE.W #0, t7
	; t8 = t6 * t7
	MOVE.W t6, D0
	MULS t7, D0
	MOVE.W D0, t8
	; t9 = 4
	MOVE.W #4, t9
	; t10 = t8 * t9
	MOVE.W t8, D0
	MULS t9, D0
	MOVE.W D0, t10
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, arr_zero
	CLR.L D1
	MOVE.W t10, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t10, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_arr_zero_LOOP_END
	MOVE.L arr_zero, A0
INIT_arr_zero_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_arr_zero_LOOP
INIT_arr_zero_LOOP_END:
	; t11 = 1
	MOVE.W #1, t11
	; t12 = 3
	MOVE.W #3, t12
	; t13 = t11 * t12
	MOVE.W t11, D0
	MULS t12, D0
	MOVE.W D0, t13
	; t14 = 4
	MOVE.W #4, t14
	; t15 = t13 * t14
	MOVE.W t13, D0
	MULS t14, D0
	MOVE.W D0, t15
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, arr_ok
	CLR.L D1
	MOVE.W t15, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t15, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_arr_ok_LOOP_END
	MOVE.L arr_ok, A0
INIT_arr_ok_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_arr_ok_LOOP
INIT_arr_ok_LOOP_END:
	; output "Fin de prueba dimensiones: arr_neg (negativa), arr_zero (cero), arr_ok (positiva)"
	LEA str0, A1
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
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
str0:	DC.B 'Fin de prueba dimensiones: arr_neg (negativa), arr_zero (cero), arr_ok (positiva)',0
arr_neg:	DS.L 1
t10:	DS.W 1
arr_zero:	DS.L 1
t12:	DS.W 1
t11:	DS.W 1
t14:	DS.W 1
t13:	DS.W 1
t15:	DS.W 1
arr_ok:	DS.L 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
