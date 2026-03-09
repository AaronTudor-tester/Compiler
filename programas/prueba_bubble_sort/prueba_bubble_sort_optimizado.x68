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
	; n = 7
	MOVE.W #7, n
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, res
	MOVE.L #28, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	ADD.L #28, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_res_LOOP_END
	MOVE.L res, A0
INIT_res_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_res_LOOP
INIT_res_LOOP_END:
	; res[0] = 5
	MOVEA.L res, A0
	MOVE.L #0, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #5, D1
	MOVE.L D1, 0(A0, D0.L)
	; res[4] = 2
	MOVEA.L res, A0
	MOVE.L #4, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #2, D1
	MOVE.L D1, 0(A0, D0.L)
	; res[8] = 9
	MOVEA.L res, A0
	MOVE.L #8, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #9, D1
	MOVE.L D1, 0(A0, D0.L)
	; res[12] = 1
	MOVEA.L res, A0
	MOVE.L #12, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #1, D1
	MOVE.L D1, 0(A0, D0.L)
	; res[16] = 4
	MOVEA.L res, A0
	MOVE.L #16, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #4, D1
	MOVE.L D1, 0(A0, D0.L)
	; res[20] = 7
	MOVEA.L res, A0
	MOVE.L #20, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #7, D1
	MOVE.L D1, 0(A0, D0.L)
	; res[24] = 3
	MOVEA.L res, A0
	MOVE.L #24, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L #3, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Lista original:"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; i = 0
	MOVE.W #0, i
e0:
	; t37 = i < n
	MOVE.W #0, t37
	MOVE.W i, D0
	CMP.W n, D0
	BLT t37_true
	JMP t37_false
t37_true:
	MOVE.W #1, t37
t37_false:
	; if !(t37) goto e1
	MOVE.W t37, D0
	CMP.W #0, D0
	BEQ e1
	; t40 = i * 4
	MOVE.W i, D0
	MULS #4, D0
	MOVE.W D0, t40
	; t41 = 7
	MOVE.W #7, t41
	; t43 = res[t40]
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t40, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t41, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t43
	; output t43
	MOVE.W t43, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e0
	JMP e0
e1:
	; i = 0
	MOVE.W #0, i
e2:
	; t48 = n - 1
	MOVE.W n, D0
	SUB.W #1, D0
	MOVE.W D0, t48
	; t49 = i < t48
	MOVE.W #0, t49
	MOVE.W i, D0
	CMP.W t48, D0
	BLT t49_true
	JMP t49_false
t49_true:
	MOVE.W #1, t49
t49_false:
	; if !(t49) goto e3
	MOVE.W t49, D0
	CMP.W #0, D0
	BEQ e3
	; j = 0
	MOVE.W #0, j
e4:
	; t54 = n - i
	MOVE.W n, D0
	SUB.W i, D0
	MOVE.W D0, t54
	; t56 = t54 - 1
	MOVE.W t54, D0
	SUB.W #1, D0
	MOVE.W D0, t56
	; t57 = j < t56
	MOVE.W #0, t57
	MOVE.W j, D0
	CMP.W t56, D0
	BLT t57_true
	JMP t57_false
t57_true:
	MOVE.W #1, t57
t57_false:
	; if !(t57) goto e5
	MOVE.W t57, D0
	CMP.W #0, D0
	BEQ e5
	; t60 = j * 4
	MOVE.W j, D0
	MULS #4, D0
	MOVE.W D0, t60
	; t61 = 7
	MOVE.W #7, t61
	; t63 = res[t60]
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t60, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t61, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t63
	; t66 = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, t66
	; t68 = t66 * 4
	MOVE.W t66, D0
	MULS #4, D0
	MOVE.W D0, t68
	; t69 = 7
	MOVE.W #7, t69
	; t71 = res[t68]
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t68, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t69, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t71
	; t72 = t63 > t71
	MOVE.W #0, t72
	MOVE.W t63, D0
	CMP.W t71, D0
	BGT t72_true
	JMP t72_false
t72_true:
	MOVE.W #1, t72
t72_false:
	; if !(t72) goto e6
	MOVE.W t72, D0
	CMP.W #0, D0
	BEQ e6
	; t76 = j * 4
	MOVE.W j, D0
	MULS #4, D0
	MOVE.W D0, t76
	; t77 = 7
	MOVE.W #7, t77
	; 0 = res[t76]
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t76, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t77, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, 0
	; t82 = j * 4
	MOVE.W j, D0
	MULS #4, D0
	MOVE.W D0, t82
	; t85 = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, t85
	; t87 = t85 * 4
	MOVE.W t85, D0
	MULS #4, D0
	MOVE.W D0, t87
	; t88 = 7
	MOVE.W #7, t88
	; t90 = res[t87]
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t87, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t88, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t90
	; res[t82] = t90
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t82, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t90, D1
	MOVE.L D1, 0(A0, D0.L)
	; t93 = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, t93
	; t95 = t93 * 4
	MOVE.W t93, D0
	MULS #4, D0
	MOVE.W D0, t95
	; res[t95] = temp
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t95, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W temp, D1
	MOVE.L D1, 0(A0, D0.L)
e6:
	; j = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, j
	; goto e4
	JMP e4
e5:
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e2
	JMP e2
e3:
	; output "Lista ordenada:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; i = 0
	MOVE.W #0, i
e8:
	; t100 = i < n
	MOVE.W #0, t100
	MOVE.W i, D0
	CMP.W n, D0
	BLT t100_true
	JMP t100_false
t100_true:
	MOVE.W #1, t100
t100_false:
	; if !(t100) goto e9
	MOVE.W t100, D0
	CMP.W #0, D0
	BEQ e9
	; t103 = i * 4
	MOVE.W i, D0
	MULS #4, D0
	MOVE.W D0, t103
	; t104 = 7
	MOVE.W #7, t104
	; t106 = res[t103]
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t103, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t104, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.W D1, t106
	; output t106
	MOVE.W t106, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e8
	JMP e8
e9:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t100:	DS.W 1
t90:	DS.W 1
t72:	DS.W 1
t71:	DS.W 1
t93:	DS.W 1
t95:	DS.W 1
t54:	DS.W 1
t76:	DS.W 1
t56:	DS.W 1
t77:	DS.W 1
str1:	DC.B 'Lista ordenada:',0
t57:	DS.W 1
t37:	DS.W 1
res:	DS.L 1
temp:	DS.W 1
str0:	DC.B 'Lista original:',0
i:	DS.W 1
j:	DS.W 1
n:	DS.W 1
t61:	DS.W 1
t60:	DS.W 1
t82:	DS.W 1
t41:	DS.W 1
t63:	DS.W 1
t85:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t87:	DS.W 1
t104:	DS.W 1
t66:	DS.W 1
t88:	DS.W 1
t103:	DS.W 1
t69:	DS.W 1
t106:	DS.W 1
t68:	DS.W 1
t49:	DS.W 1
t48:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
