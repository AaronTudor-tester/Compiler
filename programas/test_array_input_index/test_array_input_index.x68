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

READ_NUM_VALID:
.RNV_RETRY:
	LEA INPUT_BUFFER, A1
	MOVE.B #2, D0
	TRAP #15
	LEA INPUT_BUFFER, A1
	CLR.W D2
	CLR.L D3
	CLR.L D4
	MOVE.B (A1), D5
	CMP.B #0, D5
	BEQ .RNV_ERR
	CMP.B #'-', D5
	BNE .RNV_CHK
	MOVE.W #1, D2
	ADDA.L #1, A1
.RNV_CHK:
.RNV_LOOP:
	MOVE.B (A1)+, D5
	CMP.B #0, D5
	BEQ .RNV_VALID
	CMP.B #10, D5
	BEQ .RNV_VALID
	CMP.B #13, D5
	BEQ .RNV_VALID
	CMP.B #'0', D5
	BLT .RNV_ERR
	CMP.B #'9', D5
	BGT .RNV_ERR
	ADD.L #1, D4
	SUB.B #'0', D5
	MOVE.L D3, D6
	MULS #10, D3
	EXT.W D5
	EXT.L D5
	ADD.L D5, D3
	BRA .RNV_LOOP
.RNV_VALID:
	TST.L D4
	BEQ .RNV_ERR
	MOVE.W D3, D1
	TST.W D2
	BEQ .RNV_END
	NEG.W D1
.RNV_END:
	RTS
.RNV_ERR:
	LEA ERROR_INPUT_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	BRA .RNV_RETRY


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
	; output "Introduce un indice (0-2):"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; input idx
	JSR READ_NUM_VALID
	MOVE.W D1, idx
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
	MOVE.L D0, arr
	CLR.L D1
	MOVE.W t2, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t2, D1
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
	; arr[t6] = t3
	MOVEA.L arr, A0
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
	; arr[t10] = t7
	MOVEA.L arr, A0
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
	; arr[t14] = t11
	MOVEA.L arr, A0
	CLR.L D0
	MOVE.W t14, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t11, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Valor en arr["
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; t15 = idx
	MOVE.W idx, t15
	; output t15
	MOVE.W t15, D1
	JSR PRINT_SIGNED
	; output "]: "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; t16 = idx
	MOVE.W idx, t16
	; t17 = 4
	MOVE.W #4, t17
	; t18 = t16 * t17
	MOVE.W t16, D0
	MULS t17, D0
	MOVE.W D0, t18
	; t20 = 3
	MOVE.W #3, t20
	; t19 = t20
	MOVE.W t20, t19
	; t21 = arr[t18]
	MOVEA.L arr, A0
	CLR.L D0
	MOVE.W t18, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t19, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t21
	; output t21
	MOVE.W t21, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INPUT_MSG:	DC.B 'ERROR: Entrada invalida. Ingrese un numero valido: ',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
INPUT_BUFFER:	DS.B 80
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
str1:	DC.B 'Valor en arr[',0
t13:	DS.W 1
str2:	DC.B ']: ',0
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
arr:	DS.L 1
str0:	DC.B 'Introduce un indice (0-2):',0
t21:	DS.W 1
t20:	DS.W 1
idx:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
