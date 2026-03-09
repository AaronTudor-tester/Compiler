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
	; t2 = NEG 5
	MOVE.W #5, D0
	NEG.W D0
	MOVE.W D0, t2
	; t3 = 1 * t2
	MOVE.W #1, D0
	MULS t2, D0
	MOVE.W D0, t3
	; t5 = t3 * 4
	MOVE.W t3, D0
	MULS #4, D0
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
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, arr_zero
	MOVE.L #0, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	ADD.L #0, D0
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
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, arr_ok
	MOVE.L #12, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	ADD.L #12, D0
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
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t5:	DS.W 1
arr_zero:	DS.L 1
str0:	DC.B 'Fin de prueba dimensiones: arr_neg (negativa), arr_zero (cero), arr_ok (positiva)',0
arr_neg:	DS.L 1
arr_ok:	DS.L 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
