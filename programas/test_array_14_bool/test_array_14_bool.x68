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

PRINT_BOOL:
	TST.W D1
	BEQ .PRINT_MENTIRA
	LEA STR_CIERTO, A1
	BRA .PRINT_BOOL_STR
.PRINT_MENTIRA:
	LEA STR_MENTIRA, A1
.PRINT_BOOL_STR:
	MOVE.B #14, D0
	TRAP #15
	RTS

main:
	; output "=== TEST: Arrays de booleano ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t0 = 1
	MOVE.W #1, t0
	; t1 = 4
	MOVE.W #4, t1
	; t2 = t0 * t1
	MOVE.W t0, D0
	MULS t1, D0
	MOVE.W D0, t2
	; t3 = 2
	MOVE.W #2, t3
	; t4 = t2 * t3
	MOVE.W t2, D0
	MULS t3, D0
	MOVE.W D0, t4
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, flags
	CLR.L D1
	MOVE.W t4, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	; output "Inicializando flags:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t5 = 0
	MOVE.W #0, t5
	; t6 = 2
	MOVE.W #2, t6
	; t7 = t5 * t6
	MOVE.W t5, D0
	MULS t6, D0
	MOVE.W D0, t7
	; t8 = true
	MOVE.W #1, t8
	; flags[t7] = t8
	MOVEA.L flags, A0
	CLR.L D0
	MOVE.W t7, D0
	MOVE.W t8, D1
	MOVE.W D1, 0(A0, D0.L)
	; t9 = 1
	MOVE.W #1, t9
	; t10 = 2
	MOVE.W #2, t10
	; t11 = t9 * t10
	MOVE.W t9, D0
	MULS t10, D0
	MOVE.W D0, t11
	; t12 = false
	MOVE.W #0, t12
	; flags[t11] = t12
	MOVEA.L flags, A0
	CLR.L D0
	MOVE.W t11, D0
	MOVE.W t12, D1
	MOVE.W D1, 0(A0, D0.L)
	; t13 = 2
	MOVE.W #2, t13
	; t14 = 2
	MOVE.W #2, t14
	; t15 = t13 * t14
	MOVE.W t13, D0
	MULS t14, D0
	MOVE.W D0, t15
	; t16 = true
	MOVE.W #1, t16
	; flags[t15] = t16
	MOVEA.L flags, A0
	CLR.L D0
	MOVE.W t15, D0
	MOVE.W t16, D1
	MOVE.W D1, 0(A0, D0.L)
	; t17 = 3
	MOVE.W #3, t17
	; t18 = 2
	MOVE.W #2, t18
	; t19 = t17 * t18
	MOVE.W t17, D0
	MULS t18, D0
	MOVE.W D0, t19
	; t20 = false
	MOVE.W #0, t20
	; flags[t19] = t20
	MOVEA.L flags, A0
	CLR.L D0
	MOVE.W t19, D0
	MOVE.W t20, D1
	MOVE.W D1, 0(A0, D0.L)
	; output "Mostrando flags:"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t21 = 0
	MOVE.W #0, t21
	; t22 = 2
	MOVE.W #2, t22
	; t23 = t21 * t22
	MOVE.W t21, D0
	MULS t22, D0
	MOVE.W D0, t23
	; t25 = 4
	MOVE.W #4, t25
	; t24 = t25
	MOVE.W t25, t24
	; t26 = flags[t23]
	MOVEA.L flags, A0
	CLR.L D0
	MOVE.W t23, D0
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t26
	; f1 = t26
	MOVE.W t26, f1
	; t27 = f1
	MOVE.W f1, t27
	; output t27
	MOVE.W t27, D1
	JSR PRINT_BOOL
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t28 = 1
	MOVE.W #1, t28
	; t29 = 2
	MOVE.W #2, t29
	; t30 = t28 * t29
	MOVE.W t28, D0
	MULS t29, D0
	MOVE.W D0, t30
	; t32 = 4
	MOVE.W #4, t32
	; t31 = t32
	MOVE.W t32, t31
	; t33 = flags[t30]
	MOVEA.L flags, A0
	CLR.L D0
	MOVE.W t30, D0
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t33
	; f2 = t33
	MOVE.W t33, f2
	; t34 = f2
	MOVE.W f2, t34
	; output t34
	MOVE.W t34, D1
	JSR PRINT_BOOL
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Modificando posicion 2:"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t35 = 2
	MOVE.W #2, t35
	; t36 = 2
	MOVE.W #2, t36
	; t37 = t35 * t36
	MOVE.W t35, D0
	MULS t36, D0
	MOVE.W D0, t37
	; t38 = false
	MOVE.W #0, t38
	; flags[t37] = t38
	MOVEA.L flags, A0
	CLR.L D0
	MOVE.W t37, D0
	MOVE.W t38, D1
	MOVE.W D1, 0(A0, D0.L)
	; t39 = 2
	MOVE.W #2, t39
	; t40 = 2
	MOVE.W #2, t40
	; t41 = t39 * t40
	MOVE.W t39, D0
	MULS t40, D0
	MOVE.W D0, t41
	; t43 = 4
	MOVE.W #4, t43
	; t42 = t43
	MOVE.W t43, t42
	; t44 = flags[t41]
	MOVEA.L flags, A0
	CLR.L D0
	MOVE.W t41, D0
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t44
	; f3 = t44
	MOVE.W t44, f3
	; t45 = f3
	MOVE.W f3, t45
	; output t45
	MOVE.W t45, D1
	JSR PRINT_BOOL
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Test completado"
	LEA str4, A1
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
STR_CIERTO:	DC.B 'cierto',0
STR_MENTIRA:	DC.B 'mentira',0
HEAP_PTR:	DC.L $8000
f1:	DS.W 1
f2:	DS.W 1
f3:	DS.W 1
t10:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'Modificando posicion 2:',0
t11:	DS.W 1
str4:	DC.B 'Test completado',0
str1:	DC.B 'Inicializando flags:',0
t14:	DS.W 1
t13:	DS.W 1
str2:	DC.B 'Mostrando flags:',0
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B '=== TEST: Arrays de booleano ===',0
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.W 1
t24:	DS.W 1
true:	DS.W 1
t27:	DS.W 1
t26:	DS.W 1
t29:	DS.W 1
t28:	DS.W 1
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
flags:	DS.L 1
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
false:	DS.W 1
t41:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t42:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
