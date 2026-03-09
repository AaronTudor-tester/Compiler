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
	; t0 = 2
	MOVE.W #2, t0
	; filas = t0
	MOVE.W t0, filas
	; t1 = 3
	MOVE.W #3, t1
	; columnas = t1
	MOVE.W t1, columnas
	; t2 = 1
	MOVE.W #1, t2
	; t3 = 2
	MOVE.W #2, t3
	; t4 = t2 * t3
	MOVE.W t2, D0
	MULS t3, D0
	MOVE.W D0, t4
	; t5 = 3
	MOVE.W #3, t5
	; t6 = t4 * t5
	MOVE.W t4, D0
	MULS t5, D0
	MOVE.W D0, t6
	; t7 = 4
	MOVE.W #4, t7
	; t8 = t6 * t7
	MOVE.W t6, D0
	MULS t7, D0
	MOVE.W D0, t8
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, A
	CLR.L D1
	MOVE.W t8, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t8, D1
	ADD.L D1, D0
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
	; t9 = 6
	MOVE.W #6, t9
	; t10 = 4
	MOVE.W #4, t10
	; t11 = t9 * t10
	MOVE.W t9, D0
	MULS t10, D0
	MOVE.W D0, t11
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, B
	CLR.L D1
	MOVE.W t11, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t11, D1
	ADD.L D1, D0
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
	; t12 = 1
	MOVE.W #1, t12
	; t13 = 0
	MOVE.W #0, t13
	; t14 = 4
	MOVE.W #4, t14
	; t15 = t13 * t14
	MOVE.W t13, D0
	MULS t14, D0
	MOVE.W D0, t15
	; B[t15] = t12
	MOVEA.L B, A0
	CLR.L D0
	MOVE.W t15, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t12, D1
	MOVE.L D1, 0(A0, D0.L)
	; t16 = 2
	MOVE.W #2, t16
	; t17 = 1
	MOVE.W #1, t17
	; t18 = 4
	MOVE.W #4, t18
	; t19 = t17 * t18
	MOVE.W t17, D0
	MULS t18, D0
	MOVE.W D0, t19
	; B[t19] = t16
	MOVEA.L B, A0
	CLR.L D0
	MOVE.W t19, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t16, D1
	MOVE.L D1, 0(A0, D0.L)
	; t20 = 3
	MOVE.W #3, t20
	; t21 = 2
	MOVE.W #2, t21
	; t22 = 4
	MOVE.W #4, t22
	; t23 = t21 * t22
	MOVE.W t21, D0
	MULS t22, D0
	MOVE.W D0, t23
	; B[t23] = t20
	MOVEA.L B, A0
	CLR.L D0
	MOVE.W t23, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t20, D1
	MOVE.L D1, 0(A0, D0.L)
	; t24 = 4
	MOVE.W #4, t24
	; t25 = 3
	MOVE.W #3, t25
	; t26 = 4
	MOVE.W #4, t26
	; t27 = t25 * t26
	MOVE.W t25, D0
	MULS t26, D0
	MOVE.W D0, t27
	; B[t27] = t24
	MOVEA.L B, A0
	CLR.L D0
	MOVE.W t27, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t24, D1
	MOVE.L D1, 0(A0, D0.L)
	; t28 = 5
	MOVE.W #5, t28
	; t29 = 4
	MOVE.W #4, t29
	; t30 = 4
	MOVE.W #4, t30
	; t31 = t29 * t30
	MOVE.W t29, D0
	MULS t30, D0
	MOVE.W D0, t31
	; B[t31] = t28
	MOVEA.L B, A0
	CLR.L D0
	MOVE.W t31, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t28, D1
	MOVE.L D1, 0(A0, D0.L)
	; t32 = 6
	MOVE.W #6, t32
	; t33 = 5
	MOVE.W #5, t33
	; t34 = 4
	MOVE.W #4, t34
	; t35 = t33 * t34
	MOVE.W t33, D0
	MULS t34, D0
	MOVE.W D0, t35
	; B[t35] = t32
	MOVEA.L B, A0
	CLR.L D0
	MOVE.W t35, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t32, D1
	MOVE.L D1, 0(A0, D0.L)
	; t36 = 0
	MOVE.W #0, t36
	; t37 = 0
	MOVE.W #0, t37
	; t38 = 3
	MOVE.W #3, t38
	; t39 = t36 * 3
	MOVE.W t36, D0
	MULS #3, D0
	MOVE.W D0, t39
	; t40 = t39 + 0
	MOVE.W t39, D0
	ADD.W #0, D0
	MOVE.W D0, t40
	; t41 = 4
	MOVE.W #4, t41
	; t42 = t40 * t41
	MOVE.W t40, D0
	MULS t41, D0
	MOVE.W D0, t42
	; t43 = 1
	MOVE.W #1, t43
	; A[t42] = t43
	MOVEA.L A, A0
	CLR.L D0
	MOVE.W t42, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t43, D1
	MOVE.L D1, 0(A0, D0.L)
	; t44 = 0
	MOVE.W #0, t44
	; t45 = 1
	MOVE.W #1, t45
	; t46 = 3
	MOVE.W #3, t46
	; t47 = t44 * 3
	MOVE.W t44, D0
	MULS #3, D0
	MOVE.W D0, t47
	; t48 = t47 + 1
	MOVE.W t47, D0
	ADD.W #1, D0
	MOVE.W D0, t48
	; t49 = 4
	MOVE.W #4, t49
	; t50 = t48 * t49
	MOVE.W t48, D0
	MULS t49, D0
	MOVE.W D0, t50
	; t51 = 2
	MOVE.W #2, t51
	; A[t50] = t51
	MOVEA.L A, A0
	CLR.L D0
	MOVE.W t50, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t51, D1
	MOVE.L D1, 0(A0, D0.L)
	; t52 = 0
	MOVE.W #0, t52
	; t53 = 2
	MOVE.W #2, t53
	; t54 = 3
	MOVE.W #3, t54
	; t55 = t52 * 3
	MOVE.W t52, D0
	MULS #3, D0
	MOVE.W D0, t55
	; t56 = t55 + 2
	MOVE.W t55, D0
	ADD.W #2, D0
	MOVE.W D0, t56
	; t57 = 4
	MOVE.W #4, t57
	; t58 = t56 * t57
	MOVE.W t56, D0
	MULS t57, D0
	MOVE.W D0, t58
	; t59 = 3
	MOVE.W #3, t59
	; A[t58] = t59
	MOVEA.L A, A0
	CLR.L D0
	MOVE.W t58, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t59, D1
	MOVE.L D1, 0(A0, D0.L)
	; t60 = 1
	MOVE.W #1, t60
	; t61 = 0
	MOVE.W #0, t61
	; t62 = 3
	MOVE.W #3, t62
	; t63 = t60 * 3
	MOVE.W t60, D0
	MULS #3, D0
	MOVE.W D0, t63
	; t64 = t63 + 0
	MOVE.W t63, D0
	ADD.W #0, D0
	MOVE.W D0, t64
	; t65 = 4
	MOVE.W #4, t65
	; t66 = t64 * t65
	MOVE.W t64, D0
	MULS t65, D0
	MOVE.W D0, t66
	; t67 = 4
	MOVE.W #4, t67
	; A[t66] = t67
	MOVEA.L A, A0
	CLR.L D0
	MOVE.W t66, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t67, D1
	MOVE.L D1, 0(A0, D0.L)
	; t68 = 1
	MOVE.W #1, t68
	; t69 = 1
	MOVE.W #1, t69
	; t70 = 3
	MOVE.W #3, t70
	; t71 = t68 * 3
	MOVE.W t68, D0
	MULS #3, D0
	MOVE.W D0, t71
	; t72 = t71 + 1
	MOVE.W t71, D0
	ADD.W #1, D0
	MOVE.W D0, t72
	; t73 = 4
	MOVE.W #4, t73
	; t74 = t72 * t73
	MOVE.W t72, D0
	MULS t73, D0
	MOVE.W D0, t74
	; t75 = 5
	MOVE.W #5, t75
	; A[t74] = t75
	MOVEA.L A, A0
	CLR.L D0
	MOVE.W t74, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t75, D1
	MOVE.L D1, 0(A0, D0.L)
	; t76 = 1
	MOVE.W #1, t76
	; t77 = 2
	MOVE.W #2, t77
	; t78 = 3
	MOVE.W #3, t78
	; t79 = t76 * 3
	MOVE.W t76, D0
	MULS #3, D0
	MOVE.W D0, t79
	; t80 = t79 + 2
	MOVE.W t79, D0
	ADD.W #2, D0
	MOVE.W D0, t80
	; t81 = 4
	MOVE.W #4, t81
	; t82 = t80 * t81
	MOVE.W t80, D0
	MULS t81, D0
	MOVE.W D0, t82
	; t83 = 6
	MOVE.W #6, t83
	; A[t82] = t83
	MOVEA.L A, A0
	CLR.L D0
	MOVE.W t82, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	CLR.L D1
	MOVE.W t83, D1
	MOVE.L D1, 0(A0, D0.L)
	; t84 = 1
	MOVE.W #1, t84
	; igual = t84
	MOVE.W t84, igual
	; t85 = 0
	MOVE.W #0, t85
	; i = t85
	MOVE.W t85, i
e0:
	; t86 = i
	MOVE.W i, t86
	; t87 = filas
	MOVE.W filas, t87
	; t88 = t86 < t87
	MOVE.W #0, t88
	MOVE.W t86, D0
	CMP.W t87, D0
	BLT t88_true
	JMP t88_false
t88_true:
	MOVE.W #1, t88
t88_false:
	; if !(t88) goto e1
	MOVE.W t88, D0
	CMP.W #0, D0
	BEQ e1
	; t89 = 0
	MOVE.W #0, t89
	; j = t89
	MOVE.W t89, j
e2:
	; t90 = j
	MOVE.W j, t90
	; t91 = columnas
	MOVE.W columnas, t91
	; t92 = t90 < t91
	MOVE.W #0, t92
	MOVE.W t90, D0
	CMP.W t91, D0
	BLT t92_true
	JMP t92_false
t92_true:
	MOVE.W #1, t92
t92_false:
	; if !(t92) goto e3
	MOVE.W t92, D0
	CMP.W #0, D0
	BEQ e3
	; t93 = i
	MOVE.W i, t93
	; t94 = j
	MOVE.W j, t94
	; t95 = 3
	MOVE.W #3, t95
	; t96 = t93 * t95
	MOVE.W t93, D0
	MULS t95, D0
	MOVE.W D0, t96
	; t97 = t96 + t94
	MOVE.W t96, D0
	ADD.W t94, D0
	MOVE.W D0, t97
	; t98 = 4
	MOVE.W #4, t98
	; t99 = t97 * t98
	MOVE.W t97, D0
	MULS t98, D0
	MOVE.W D0, t99
	; t101 = 2
	MOVE.W #2, t101
	; t102 = 3
	MOVE.W #3, t102
	; t103 = t101 * t102
	MOVE.W t101, D0
	MULS t102, D0
	MOVE.W D0, t103
	; t100 = t103
	MOVE.W t103, t100
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
	; t105 = i
	MOVE.W i, t105
	; t106 = j
	MOVE.W j, t106
	; t107 = 3
	MOVE.W #3, t107
	; t108 = t105 * t107
	MOVE.W t105, D0
	MULS t107, D0
	MOVE.W D0, t108
	; t109 = t108 + t106
	MOVE.W t108, D0
	ADD.W t106, D0
	MOVE.W D0, t109
	; t110 = 4
	MOVE.W #4, t110
	; t111 = t109 * t110
	MOVE.W t109, D0
	MULS t110, D0
	MOVE.W D0, t111
	; t113 = 2
	MOVE.W #2, t113
	; t114 = 3
	MOVE.W #3, t114
	; t115 = t113 * t114
	MOVE.W t113, D0
	MULS t114, D0
	MOVE.W D0, t115
	; t112 = t115
	MOVE.W t115, t112
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
	; t117 = vaA
	MOVE.W vaA, t117
	; t118 = vaB
	MOVE.W vaB, t118
	; t119 = t117 == t118
	MOVE.W #0, t119
	MOVE.W t117, D0
	CMP.W t118, D0
	BEQ t119_true
	JMP t119_false
t119_true:
	MOVE.W #1, t119
t119_false:
	; if !(t119) goto e4
	MOVE.W t119, D0
	CMP.W #0, D0
	BEQ e4
	; goto e5
	JMP e5
e4:
e5:
	; t120 = vaA
	MOVE.W vaA, t120
	; t121 = vaB
	MOVE.W vaB, t121
	; t122 = t120 == t121
	MOVE.W #0, t122
	MOVE.W t120, D0
	CMP.W t121, D0
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
	; t124 = 0
	MOVE.W #0, t124
	; igual = t124
	MOVE.W t124, igual
	; goto e3
	JMP e3
	; goto e7
	JMP e7
e6:
e7:
	; j = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, j
	; goto e2
	JMP e2
e3:
	; t125 = igual
	MOVE.W igual, t125
	; t126 = 0
	MOVE.W #0, t126
	; t127 = t125 == t126
	MOVE.W #0, t127
	MOVE.W t125, D0
	CMP.W t126, D0
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
	; goto e9
	JMP e9
e8:
e9:
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e0
	JMP e0
e1:
	; t128 = igual
	MOVE.W igual, t128
	; t129 = 1
	MOVE.W #1, t129
	; t130 = t128 == t129
	MOVE.W #0, t130
	MOVE.W t128, D0
	CMP.W t129, D0
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
	; goto e11
	JMP e11
e10:
e11:
	; t131 = igual
	MOVE.W igual, t131
	; t132 = 0
	MOVE.W #0, t132
	; t133 = t131 == t132
	MOVE.W #0, t133
	MOVE.W t131, D0
	CMP.W t132, D0
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
	; goto e13
	JMP e13
e12:
e13:
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t122:	DS.W 1
t121:	DS.W 1
t124:	DS.W 1
t123:	DS.W 1
t50:	DS.W 1
t120:	DS.W 1
t52:	DS.W 1
t119:	DS.W 1
t51:	DS.W 1
t118:	DS.W 1
t54:	DS.W 1
t53:	DS.W 1
t56:	DS.W 1
t115:	DS.W 1
t55:	DS.W 1
t114:	DS.W 1
t58:	DS.W 1
t117:	DS.W 1
str1:	DC.B 'Las matrices son DISTINTAS.',0
t57:	DS.W 1
t116:	DS.W 1
t59:	DS.W 1
t111:	DS.W 1
t110:	DS.W 1
str0:	DC.B 'Las matrices son IGUALES.',0
t113:	DS.W 1
t112:	DS.W 1
t61:	DS.W 1
t60:	DS.W 1
t63:	DS.W 1
t108:	DS.W 1
t62:	DS.W 1
t107:	DS.W 1
t65:	DS.W 1
t64:	DS.W 1
t109:	DS.W 1
t67:	DS.W 1
t104:	DS.W 1
filas:	DS.W 1
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
A:	DS.L 1
t6:	DS.W 1
B:	DS.L 1
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
t133:	DS.W 1
i:	DS.W 1
t132:	DS.W 1
j:	DS.W 1
t81:	DS.W 1
t80:	DS.W 1
t83:	DS.W 1
t131:	DS.W 1
t82:	DS.W 1
t130:	DS.W 1
t85:	DS.W 1
t84:	DS.W 1
t129:	DS.W 1
t87:	DS.W 1
t86:	DS.W 1
t89:	DS.W 1
t126:	DS.W 1
t88:	DS.W 1
t125:	DS.W 1
t128:	DS.W 1
t127:	DS.W 1
igual:	DS.W 1
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
columnas:	DS.W 1
t41:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t42:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1
t47:	DS.W 1
vaB:	DS.W 1
t46:	DS.W 1
vaA:	DS.W 1
t49:	DS.W 1
t48:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
