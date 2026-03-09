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

PRINT_DECIMAL_2:
	MOVE.L D1, D3
	TST.L D3
	BPL .PD2_POSITIVE
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	NEG.L D3
.PD2_POSITIVE:
	MOVE.L D3, D2
	MOVE.W #100, D4
	DIVS D4, D2
	MOVE.L D2, D5
	MOVE.W #100, D4
	MOVE.L D5, D6
	CLR.L D0
	MOVE.W D4, D0
	MULS D0, D6
	SUB.L D6, D3
	CLR.L D1
	MOVE.W D2, D1
	MOVE.B #3, D0
	TRAP #15
	LEA DECIMAL_POINT, A1
	MOVE.B #14, D0
	TRAP #15
	CLR.L D0
	MOVE.W D3, D0
	CMP.W #10, D0
	BGE .PD2_SKIP_ZERO
	LEA ZERO_CHAR, A1
	MOVE.B #14, D0
	TRAP #15
.PD2_SKIP_ZERO:
	CLR.L D1
	MOVE.W D3, D1
	MOVE.B #3, D0
	TRAP #15
	RTS

main:
	; output "=== TEST: Arrays de decimal ==="
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
	MOVE.L D0, precios
	CLR.L D1
	MOVE.W t2, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	; t3 = 10.5
	MOVE.W #1050, t3
	; t4 = 0
	MOVE.W #0, t4
	; t5 = 4
	MOVE.W #4, t5
	; t6 = t4 * t5
	MOVE.W t4, D0
	MULS t5, D0
	MOVE.W D0, t6
	; precios[t6] = t3
	MOVEA.L precios, A0
	CLR.L D0
	MOVE.W t6, D0
	CLR.L D1
	MOVE.W t3, D1
	MOVE.L D1, 0(A0, D0.L)
	; t7 = 20.99
	MOVE.W #2099, t7
	; t8 = 1
	MOVE.W #1, t8
	; t9 = 4
	MOVE.W #4, t9
	; t10 = t8 * t9
	MOVE.W t8, D0
	MULS t9, D0
	MOVE.W D0, t10
	; precios[t10] = t7
	MOVEA.L precios, A0
	CLR.L D0
	MOVE.W t10, D0
	CLR.L D1
	MOVE.W t7, D1
	MOVE.L D1, 0(A0, D0.L)
	; t11 = 15.75
	MOVE.W #1575, t11
	; t12 = 2
	MOVE.W #2, t12
	; t13 = 4
	MOVE.W #4, t13
	; t14 = t12 * t13
	MOVE.W t12, D0
	MULS t13, D0
	MOVE.W D0, t14
	; precios[t14] = t11
	MOVEA.L precios, A0
	CLR.L D0
	MOVE.W t14, D0
	CLR.L D1
	MOVE.W t11, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Mostrando precios:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
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
	; t20 = precios[t17]
	MOVEA.L precios, A0
	CLR.L D0
	MOVE.W t17, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t20
	; p1 = t20
	MOVE.W t20, p1
	; t21 = p1
	MOVE.W p1, t21
	; output t21
	CLR.L D1
	MOVE.W t21, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t22 = 1
	MOVE.W #1, t22
	; t23 = 4
	MOVE.W #4, t23
	; t24 = t22 * t23
	MOVE.W t22, D0
	MULS t23, D0
	MOVE.W D0, t24
	; t26 = 3
	MOVE.W #3, t26
	; t25 = t26
	MOVE.W t26, t25
	; t27 = precios[t24]
	MOVEA.L precios, A0
	CLR.L D0
	MOVE.W t24, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t27
	; p2 = t27
	MOVE.W t27, p2
	; t28 = p2
	MOVE.W p2, t28
	; output t28
	CLR.L D1
	MOVE.W t28, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Suma de precios[0] + precios[2]:"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t29 = 2
	MOVE.W #2, t29
	; t30 = 4
	MOVE.W #4, t30
	; t31 = t29 * t30
	MOVE.W t29, D0
	MULS t30, D0
	MOVE.W D0, t31
	; t33 = 3
	MOVE.W #3, t33
	; t32 = t33
	MOVE.W t33, t32
	; t34 = precios[t31]
	MOVEA.L precios, A0
	CLR.L D0
	MOVE.W t31, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t34
	; p3 = t34
	MOVE.W t34, p3
	; t35 = p1
	MOVE.W p1, t35
	; t36 = p3
	MOVE.W p3, t36
	; t37 = t35 + t36
	MOVE.W t35, D0
	ADD.W t36, D0
	MOVE.W D0, t37
	; total = t37
	MOVE.W t37, total
	; t38 = total
	MOVE.W total, t38
	; output t38
	CLR.L D1
	MOVE.W t38, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
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
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t5:	DS.W 1
p1:	DS.W 1
t6:	DS.W 1
p2:	DS.W 1
t7:	DS.W 1
p3:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t30:	DS.W 1
t10:	DS.W 1
t32:	DS.W 1
total:	DS.W 1
t31:	DS.W 1
t12:	DS.W 1
t34:	DS.W 1
str3:	DC.B 'Test completado',0
t11:	DS.W 1
t33:	DS.W 1
t14:	DS.W 1
str1:	DC.B 'Mostrando precios:',0
t36:	DS.W 1
t13:	DS.W 1
str2:	DC.B 'Suma de precios[0] + precios[2]:',0
t35:	DS.W 1
t16:	DS.W 1
t38:	DS.W 1
t15:	DS.W 1
t37:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B '=== TEST: Arrays de decimal ===',0
precios:	DS.L 1
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
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
