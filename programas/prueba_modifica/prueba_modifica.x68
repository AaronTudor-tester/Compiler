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
	; t0 = 2.0
	MOVE.W #200, t0
	; x = t0
	MOVE.W t0, x
	; t1 = x
	MOVE.W x, t1
	; output t1
	CLR.L D1
	MOVE.W t1, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t2 = x
	MOVE.W x, t2
	; t3 = 3.0
	MOVE.W #300, t3
	; t4 = t2 + t3
	MOVE.W t2, D0
	ADD.W t3, D0
	MOVE.W D0, t4
	; x = t4
	MOVE.W t4, x
	; t5 = x
	MOVE.W x, t5
	; output t5
	CLR.L D1
	MOVE.W t5, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t6 = x
	MOVE.W x, t6
	; t7 = 2.0
	MOVE.W #200, t7
	; t8 = t6 - t7
	MOVE.W t6, D0
	SUB.W t7, D0
	MOVE.W D0, t8
	; x = t8
	MOVE.W t8, x
	; t9 = x
	MOVE.W x, t9
	; output t9
	CLR.L D1
	MOVE.W t9, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t10 = x
	MOVE.W x, t10
	; t11 = 4.0
	MOVE.W #400, t11
	; t12 = t10 * t11
	MOVE.W t10, D0
	MOVE.W t11, D1
	MULS D1, D0
	MOVE.W #100, D2
	DIVS D2, D0
	MOVE.W D0, t12
	; x = t12
	MOVE.W t12, x
	; t13 = x
	MOVE.W x, t13
	; output t13
	CLR.L D1
	MOVE.W t13, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t14 = x
	MOVE.W x, t14
	; t15 = 3.0
	MOVE.W #300, t15
	; t16 = t14 / t15
	MOVE.W t14, D0
	MOVE.W t15, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	MOVE.W #100, D2
	MULS D2, D0
	DIVS D1, D0
	MOVE.W D0, t16
	; x = t16
	MOVE.W t16, x
	; t17 = x
	MOVE.W x, t17
	; output t17
	CLR.L D1
	MOVE.W t17, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; x = x - 1.0
	MOVE.W x, D0
	SUB.W #100, D0
	MOVE.W D0, x
	; t18 = x
	MOVE.W x, t18
	; t19 = 2.0
	MOVE.W #200, t19
	; t20 = t18 % t19
	MOVE.W t18, D0
	MOVE.W t19, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	EXT.L D0
	MOVE.L D0, D2
	DIVS D1, D0
	CLR.L D3
	MOVE.W D0, D3
	MULS D1, D3
	SUB.L D3, D2
	MOVE.W D2, t20
	; x = t20
	MOVE.W t20, x
	; t21 = x
	MOVE.W x, t21
	; output t21
	CLR.L D1
	MOVE.W t21, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t22 = 1.0
	MOVE.W #100, t22
	; x = t22
	MOVE.W t22, x
	; output "x es: "
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; t23 = x
	MOVE.W x, t23
	; output t23
	CLR.L D1
	MOVE.W t23, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "x es: "
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; t24 = x
	MOVE.W x, t24
	; t25 = 5.0
	MOVE.W #500, t25
	; t26 = x
	MOVE.W x, t26
	; x = x + 1.0
	MOVE.W x, D0
	ADD.W #100, D0
	MOVE.W D0, x
	; t27 = t25 - t26
	MOVE.W t25, D0
	SUB.W t26, D0
	MOVE.W D0, t27
	; t28 = 2.0
	MOVE.W #200, t28
	; t29 = t27 + t28
	MOVE.W t27, D0
	ADD.W t28, D0
	MOVE.W D0, t29
	; t30 = x
	MOVE.W x, t30
	; x = x - 1.0
	MOVE.W x, D0
	SUB.W #100, D0
	MOVE.W D0, x
	; t31 = t29 + t30
	MOVE.W t29, D0
	ADD.W t30, D0
	MOVE.W D0, t31
	; t32 = 1.0
	MOVE.W #100, t32
	; t33 = t31 + t32
	MOVE.W t31, D0
	ADD.W t32, D0
	MOVE.W D0, t33
	; x = x + 1.0
	MOVE.W x, D0
	ADD.W #100, D0
	MOVE.W D0, x
	; t34 = t33 - x
	MOVE.W t33, D0
	SUB.W x, D0
	MOVE.W D0, t34
	; t35 = t24 + t34
	MOVE.W t24, D0
	ADD.W t34, D0
	MOVE.W D0, t35
	; x = t35
	MOVE.W t35, x
	; t36 = x
	MOVE.W x, t36
	; output t36
	CLR.L D1
	MOVE.W t36, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "BUCLES:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t37 = 1.0
	MOVE.W #100, t37
	; i = t37
	MOVE.W t37, i
e0:
	; t38 = i
	MOVE.W i, t38
	; t39 = 5.0
	MOVE.W #500, t39
	; t40 = t38 <= t39
	MOVE.W #0, t40
	MOVE.W t38, D0
	CMP.W t39, D0
	BLE t40_true
	JMP t40_false
t40_true:
	MOVE.W #1, t40
t40_false:
	; if !(t40) goto e1
	MOVE.W t40, D0
	CMP.W #0, D0
	BEQ e1
	; output "ITERAMOS"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t41 = x
	MOVE.W x, t41
	; output t41
	CLR.L D1
	MOVE.W t41, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t42 = i
	MOVE.W i, t42
	; output t42
	CLR.L D1
	MOVE.W t42, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t43 = i
	MOVE.W i, t43
	; t44 = 1.0
	MOVE.W #100, t44
	; t45 = t43 + t44
	MOVE.W t43, D0
	ADD.W t44, D0
	MOVE.W D0, t45
	; i = t45
	MOVE.W t45, i
	; t46 = i
	MOVE.W i, t46
	; t47 = 0.5
	MOVE.W #50, t47
	; t48 = t46 + t47
	MOVE.W t46, D0
	ADD.W t47, D0
	MOVE.W D0, t48
	; x = t48
	MOVE.W t48, x
	; goto e0
	JMP e0
e1:
	; output "hola"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t49 = 1.0
	MOVE.W #100, t49
	; i = t49
	MOVE.W t49, i
e2:
	; t50 = i
	MOVE.W i, t50
	; t51 = 5
	MOVE.W #5, t51
	; t52 = t50 <= t51
	MOVE.W #0, t52
	MOVE.W t50, D0
	CMP.W t51, D0
	BLE t52_true
	JMP t52_false
t52_true:
	MOVE.W #1, t52
t52_false:
	; if !(t52) goto e3
	MOVE.W t52, D0
	CMP.W #0, D0
	BEQ e3
	; output "otro bucle"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t53 = i
	MOVE.W i, t53
	; t54 = 1.0
	MOVE.W #100, t54
	; t55 = t53 + t54
	MOVE.W t53, D0
	ADD.W t54, D0
	MOVE.W D0, t55
	; i = t55
	MOVE.W t55, i
	; goto e2
	JMP e2
e3:
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
t50:	DS.W 1
t52:	DS.W 1
t51:	DS.W 1
t10:	DS.W 1
t54:	DS.W 1
t53:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'hola',0
t11:	DS.W 1
str4:	DC.B 'otro bucle',0
t55:	DS.W 1
t14:	DS.W 1
str1:	DC.B 'BUCLES:',0
t13:	DS.W 1
str2:	DC.B 'ITERAMOS',0
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B 'x es: ',0
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
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
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
i:	DS.W 1
t41:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t42:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1
t47:	DS.W 1
t46:	DS.W 1
x:	DS.W 1
t49:	DS.W 1
t48:	DS.W 1

; ===== MANEJADOR DE ERROR DE DIVISION ENTRE CERO =====
DIV_ZERO_ERROR:
	LEA DIV_ZERO_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
