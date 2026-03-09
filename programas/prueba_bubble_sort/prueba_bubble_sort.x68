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
	; t0 = 7
	MOVE.W #7, t0
	; n = t0
	MOVE.W t0, n
	; t1 = 1
	MOVE.W #1, t1
	; t2 = 7
	MOVE.W #7, t2
	; t3 = t1 * t2
	MOVE.W t1, D0
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
	MOVE.L D0, res
	CLR.L D1
	MOVE.W t5, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t5, D1
	ADD.L D1, D0
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
	; t6 = 0
	MOVE.W #0, t6
	; t7 = 4
	MOVE.W #4, t7
	; t8 = t6 * t7
	MOVE.W t6, D0
	MULS t7, D0
	MOVE.W D0, t8
	; t9 = 5
	MOVE.W #5, t9
	; res[t8] = t9
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t8, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t9, D1
	MOVE.L D1, 0(A0, D0.L)
	; t10 = 1
	MOVE.W #1, t10
	; t11 = 4
	MOVE.W #4, t11
	; t12 = t10 * t11
	MOVE.W t10, D0
	MULS t11, D0
	MOVE.W D0, t12
	; t13 = 2
	MOVE.W #2, t13
	; res[t12] = t13
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t12, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t13, D1
	MOVE.L D1, 0(A0, D0.L)
	; t14 = 2
	MOVE.W #2, t14
	; t15 = 4
	MOVE.W #4, t15
	; t16 = t14 * t15
	MOVE.W t14, D0
	MULS t15, D0
	MOVE.W D0, t16
	; t17 = 9
	MOVE.W #9, t17
	; res[t16] = t17
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t16, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t17, D1
	MOVE.L D1, 0(A0, D0.L)
	; t18 = 3
	MOVE.W #3, t18
	; t19 = 4
	MOVE.W #4, t19
	; t20 = t18 * t19
	MOVE.W t18, D0
	MULS t19, D0
	MOVE.W D0, t20
	; t21 = 1
	MOVE.W #1, t21
	; res[t20] = t21
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t20, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t21, D1
	MOVE.L D1, 0(A0, D0.L)
	; t22 = 4
	MOVE.W #4, t22
	; t23 = 4
	MOVE.W #4, t23
	; t24 = t22 * t23
	MOVE.W t22, D0
	MULS t23, D0
	MOVE.W D0, t24
	; t25 = 4
	MOVE.W #4, t25
	; res[t24] = t25
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t24, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t25, D1
	MOVE.L D1, 0(A0, D0.L)
	; t26 = 5
	MOVE.W #5, t26
	; t27 = 4
	MOVE.W #4, t27
	; t28 = t26 * t27
	MOVE.W t26, D0
	MULS t27, D0
	MOVE.W D0, t28
	; t29 = 7
	MOVE.W #7, t29
	; res[t28] = t29
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t28, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t29, D1
	MOVE.L D1, 0(A0, D0.L)
	; t30 = 6
	MOVE.W #6, t30
	; t31 = 4
	MOVE.W #4, t31
	; t32 = t30 * t31
	MOVE.W t30, D0
	MULS t31, D0
	MOVE.W D0, t32
	; t33 = 3
	MOVE.W #3, t33
	; res[t32] = t33
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t32, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t33, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Lista original:"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; t34 = 0
	MOVE.W #0, t34
	; i = t34
	MOVE.W t34, i
e0:
	; t35 = i
	MOVE.W i, t35
	; t36 = n
	MOVE.W n, t36
	; t37 = t35 < t36
	MOVE.W #0, t37
	MOVE.W t35, D0
	CMP.W t36, D0
	BLT t37_true
	JMP t37_false
t37_true:
	MOVE.W #1, t37
t37_false:
	; if !(t37) goto e1
	MOVE.W t37, D0
	CMP.W #0, D0
	BEQ e1
	; t38 = i
	MOVE.W i, t38
	; t39 = 4
	MOVE.W #4, t39
	; t40 = t38 * t39
	MOVE.W t38, D0
	MULS t39, D0
	MOVE.W D0, t40
	; t42 = 7
	MOVE.W #7, t42
	; t41 = t42
	MOVE.W t42, t41
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
	; t44 = 0
	MOVE.W #0, t44
	; i = t44
	MOVE.W t44, i
e2:
	; t45 = i
	MOVE.W i, t45
	; t46 = n
	MOVE.W n, t46
	; t47 = 1
	MOVE.W #1, t47
	; t48 = t46 - t47
	MOVE.W t46, D0
	SUB.W t47, D0
	MOVE.W D0, t48
	; t49 = t45 < t48
	MOVE.W #0, t49
	MOVE.W t45, D0
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
	; t50 = 0
	MOVE.W #0, t50
	; j = t50
	MOVE.W t50, j
e4:
	; t51 = j
	MOVE.W j, t51
	; t52 = n
	MOVE.W n, t52
	; t53 = i
	MOVE.W i, t53
	; t54 = t52 - t53
	MOVE.W t52, D0
	SUB.W t53, D0
	MOVE.W D0, t54
	; t55 = 1
	MOVE.W #1, t55
	; t56 = t54 - t55
	MOVE.W t54, D0
	SUB.W t55, D0
	MOVE.W D0, t56
	; t57 = t51 < t56
	MOVE.W #0, t57
	MOVE.W t51, D0
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
	; t58 = j
	MOVE.W j, t58
	; t59 = 4
	MOVE.W #4, t59
	; t60 = t58 * t59
	MOVE.W t58, D0
	MULS t59, D0
	MOVE.W D0, t60
	; t62 = 7
	MOVE.W #7, t62
	; t61 = t62
	MOVE.W t62, t61
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
	; t64 = j
	MOVE.W j, t64
	; t65 = 1
	MOVE.W #1, t65
	; t66 = t64 + t65
	MOVE.W t64, D0
	ADD.W t65, D0
	MOVE.W D0, t66
	; t67 = 4
	MOVE.W #4, t67
	; t68 = t66 * t67
	MOVE.W t66, D0
	MULS t67, D0
	MOVE.W D0, t68
	; t70 = 7
	MOVE.W #7, t70
	; t69 = t70
	MOVE.W t70, t69
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
	; t73 = 0
	MOVE.W #0, t73
	; temp = t73
	MOVE.W t73, temp
	; t74 = j
	MOVE.W j, t74
	; t75 = 4
	MOVE.W #4, t75
	; t76 = t74 * t75
	MOVE.W t74, D0
	MULS t75, D0
	MOVE.W D0, t76
	; t78 = 7
	MOVE.W #7, t78
	; t77 = t78
	MOVE.W t78, t77
	; t79 = res[t76]
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
	MOVE.W D1, t79
	; temp = t79
	MOVE.W t79, temp
	; t80 = j
	MOVE.W j, t80
	; t81 = 4
	MOVE.W #4, t81
	; t82 = t80 * t81
	MOVE.W t80, D0
	MULS t81, D0
	MOVE.W D0, t82
	; t83 = j
	MOVE.W j, t83
	; t84 = 1
	MOVE.W #1, t84
	; t85 = t83 + t84
	MOVE.W t83, D0
	ADD.W t84, D0
	MOVE.W D0, t85
	; t86 = 4
	MOVE.W #4, t86
	; t87 = t85 * t86
	MOVE.W t85, D0
	MULS t86, D0
	MOVE.W D0, t87
	; t89 = 7
	MOVE.W #7, t89
	; t88 = t89
	MOVE.W t89, t88
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
	; t91 = j
	MOVE.W j, t91
	; t92 = 1
	MOVE.W #1, t92
	; t93 = t91 + t92
	MOVE.W t91, D0
	ADD.W t92, D0
	MOVE.W D0, t93
	; t94 = 4
	MOVE.W #4, t94
	; t95 = t93 * t94
	MOVE.W t93, D0
	MULS t94, D0
	MOVE.W D0, t95
	; t96 = temp
	MOVE.W temp, t96
	; res[t95] = t96
	MOVEA.L res, A0
	CLR.L D0
	MOVE.W t95, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t96, D1
	MOVE.L D1, 0(A0, D0.L)
	; goto e7
	JMP e7
e6:
e7:
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
	; t97 = 0
	MOVE.W #0, t97
	; i = t97
	MOVE.W t97, i
e8:
	; t98 = i
	MOVE.W i, t98
	; t99 = n
	MOVE.W n, t99
	; t100 = t98 < t99
	MOVE.W #0, t100
	MOVE.W t98, D0
	CMP.W t99, D0
	BLT t100_true
	JMP t100_false
t100_true:
	MOVE.W #1, t100
t100_false:
	; if !(t100) goto e9
	MOVE.W t100, D0
	CMP.W #0, D0
	BEQ e9
	; t101 = i
	MOVE.W i, t101
	; t102 = 4
	MOVE.W #4, t102
	; t103 = t101 * t102
	MOVE.W t101, D0
	MULS t102, D0
	MOVE.W D0, t103
	; t105 = 7
	MOVE.W #7, t105
	; t104 = t105
	MOVE.W t105, t104
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
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t50:	DS.W 1
t52:	DS.W 1
t51:	DS.W 1
t54:	DS.W 1
t53:	DS.W 1
t56:	DS.W 1
t55:	DS.W 1
t58:	DS.W 1
str1:	DC.B 'Lista ordenada:',0
t57:	DS.W 1
t59:	DS.W 1
str0:	DC.B 'Lista original:',0
t61:	DS.W 1
t60:	DS.W 1
t63:	DS.W 1
t62:	DS.W 1
t65:	DS.W 1
t64:	DS.W 1
t67:	DS.W 1
t104:	DS.W 1
t66:	DS.W 1
t103:	DS.W 1
t69:	DS.W 1
t106:	DS.W 1
t68:	DS.W 1
t105:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t70:	DS.W 1
t72:	DS.W 1
t71:	DS.W 1
t74:	DS.W 1
t73:	DS.W 1
t76:	DS.W 1
t75:	DS.W 1
t78:	DS.W 1
t77:	DS.W 1
t79:	DS.W 1
i:	DS.W 1
j:	DS.W 1
t81:	DS.W 1
t80:	DS.W 1
n:	DS.W 1
t83:	DS.W 1
t82:	DS.W 1
t85:	DS.W 1
t84:	DS.W 1
t87:	DS.W 1
t86:	DS.W 1
t89:	DS.W 1
t88:	DS.W 1
t90:	DS.W 1
t92:	DS.W 1
t91:	DS.W 1
t94:	DS.W 1
t93:	DS.W 1
t96:	DS.W 1
t95:	DS.W 1
t10:	DS.W 1
t98:	DS.W 1
t97:	DS.W 1
t12:	DS.W 1
t11:	DS.W 1
t99:	DS.W 1
t14:	DS.W 1
t13:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
res:	DS.L 1
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.W 1
t24:	DS.W 1
t27:	DS.W 1
t26:	DS.W 1
t29:	DS.W 1
t28:	DS.W 1
t100:	DS.W 1
t102:	DS.W 1
t101:	DS.W 1
t30:	DS.W 1
t32:	DS.W 1
t31:	DS.W 1
t34:	DS.W 1
t33:	DS.W 1
t36:	DS.W 1
t35:	DS.W 1
t38:	DS.W 1
t37:	DS.W 1
t39:	DS.W 1
temp:	DS.W 1
t41:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t42:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1
t47:	DS.W 1
t46:	DS.W 1
t49:	DS.W 1
t48:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
