	ORG $1000
START:
	LEA STACKPTR, A7
	; t0 = 2
	MOVE.W #2, t0
	; a = t0
	MOVE.W t0, a
	; t1 = 3
	MOVE.W #3, t1
	; b = t1
	MOVE.W t1, b
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

suma2:
	; ; param x : INT
	; t2 = x
	MOVE.W x, t2
	; t3 = 100
	MOVE.W #100, t3
	; t4 = t2 < t3
	MOVE.W #0, t4
	MOVE.W t2, D0
	CMP.W t3, D0
	BLT t4_true
	JMP t4_false
t4_true:
	MOVE.W #1, t4
t4_false:
	; if !(t4) goto e0
	MOVE.W t4, D0
	CMP.W #0, D0
	BEQ e0
	; t5 = x
	MOVE.W x, t5
	; output t5
	MOVE.W t5, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t6 = x
	MOVE.W x, t6
	; t7 = 37
	MOVE.W #37, t7
	; t8 = t6 + t7
	MOVE.W t6, D0
	ADD.W t7, D0
	MOVE.W D0, t8
	; param_s t8  
	; t9 = call suma2
	MOVE.W t8, x
	JSR suma2
	MOVE.W D0, t9
	; return t9
	MOVE.W t9, D0
	RTS
	; goto e1
	JMP e1
e0:
e1:
	; t10 = 9
	MOVE.W #9, t10
	; x = t10
	MOVE.W t10, x
	; t11 = 1
	MOVE.W #1, t11
	; t12 = NEG t11
	MOVE.W t11, D0
	NEG.W D0
	MOVE.W D0, t12
	; t13 = x
	MOVE.W x, t13
	; t14 = t12 + t13
	MOVE.W t12, D0
	ADD.W t13, D0
	MOVE.W D0, t14
	; return t14
	MOVE.W t14, D0
	RTS
funcVoid:
	; output "hola"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; return null
	RTS
suma:
	; t15 = a
	MOVE.W a, t15
	; t16 = 2
	MOVE.W #2, t16
	; t17 = t15 + t16
	MOVE.W t15, D0
	ADD.W t16, D0
	MOVE.W D0, t17
	; a = t17
	MOVE.W t17, a
	; t18 = a
	MOVE.W a, t18
	; t19 = b
	MOVE.W b, t19
	; t20 = t18 + t19
	MOVE.W t18, D0
	ADD.W t19, D0
	MOVE.W D0, t20
	; resultado = t20
	MOVE.W t20, resultado
	; t21 = a
	MOVE.W a, t21
	; t22 = 100
	MOVE.W #100, t22
	; t23 = t21 < t22
	MOVE.W #0, t23
	MOVE.W t21, D0
	CMP.W t22, D0
	BLT t23_true
	JMP t23_false
t23_true:
	MOVE.W #1, t23
t23_false:
	; if !(t23) goto e2
	MOVE.W t23, D0
	CMP.W #0, D0
	BEQ e2
	; t24 = 23
	MOVE.W #23, t24
	; param_s t24  
	; t25 = call suma2
	MOVE.W t24, x
	JSR suma2
	MOVE.W D0, t25
	; t26 = a
	MOVE.W a, t26
	; t27 = 1
	MOVE.W #1, t27
	; t28 = t26 + t27
	MOVE.W t26, D0
	ADD.W t27, D0
	MOVE.W D0, t28
	; param_s t28  
	; t29 = call suma2
	MOVE.W t28, x
	JSR suma2
	MOVE.W D0, t29
	; t30 = t25 + t29
	MOVE.W t25, D0
	ADD.W t29, D0
	MOVE.W D0, t30
	; t31 = 3
	MOVE.W #3, t31
	; t32 = t30 + t31
	MOVE.W t30, D0
	ADD.W t31, D0
	MOVE.W D0, t32
	; return t32
	MOVE.W t32, D0
	RTS
	; goto e3
	JMP e3
e2:
e3:
	; t33 = resultado
	MOVE.W resultado, t33
	; return t33
	MOVE.W t33, D0
	RTS
sumaNormal:
	; ; param a1 : INT
	; ; param b1 : INT
	; t34 = a1
	MOVE.W a1, t34
	; t35 = b1
	MOVE.W b1, t35
	; t36 = t34 + t35
	MOVE.W t34, D0
	ADD.W t35, D0
	MOVE.W D0, t36
	; return t36
	MOVE.W t36, D0
	RTS
main:
	; t37 = 2.0
	MOVE.W #200, t37
	; t38 = 2.3
	MOVE.W #230, t38
	; t39 = t37 + t38
	MOVE.W t37, D0
	ADD.W t38, D0
	MOVE.W D0, t39
	; www = t39
	MOVE.W t39, www
	; t40 = www
	MOVE.W www, t40
	; output t40
	CLR.L D1
	MOVE.W t40, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; t41 = call suma
	JSR suma
	MOVE.W D0, t41
	; output t41
	MOVE.W t41, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t42 = 3
	MOVE.W #3, t42
	; b = t42
	MOVE.W t42, b
	; t43 = call suma
	JSR suma
	MOVE.W D0, t43
	; t44 = call suma
	JSR suma
	MOVE.W D0, t44
	; t45 = t43 + t44
	MOVE.W t43, D0
	ADD.W t44, D0
	MOVE.W D0, t45
	; t46 = 1
	MOVE.W #1, t46
	; param_s t46  
	; t47 = call suma2
	MOVE.W t46, x
	JSR suma2
	MOVE.W D0, t47
	; t48 = t45 + t47
	MOVE.W t45, D0
	ADD.W t47, D0
	MOVE.W D0, t48
	; output t48
	MOVE.W t48, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; call funcVoid  
	JSR funcVoid
	; t49 = 3
	MOVE.W #3, t49
	; y = t49
	MOVE.W t49, y
	; t50 = 200
	MOVE.W #200, t50
	; param_s t50  
	; t51 = call suma2
	MOVE.W t50, x
	JSR suma2
	MOVE.W D0, t51
	; output t51
	MOVE.W t51, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t52 = 2
	MOVE.W #2, t52
	; t53 = 3
	MOVE.W #3, t53
	; param_s t52  
	; param_s t53  
	; t54 = call sumaNormal
	MOVE.W t52, a1
	MOVE.W t53, b1
	JSR sumaNormal
	MOVE.W D0, t54
	; output t54
	MOVE.W t54, D1
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
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
HEAP_PTR:	DC.L $8000
t50:	DS.W 1
b1:	DS.W 1
t52:	DS.W 1
t51:	DS.W 1
t10:	DS.W 1
t54:	DS.W 1
t53:	DS.W 1
t12:	DS.W 1
t11:	DS.W 1
t14:	DS.W 1
www:	DS.W 1
t13:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B 'hola',0
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
a:	DS.W 1
b:	DS.W 1
resultado:	DS.W 1
a1:	DS.W 1
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
y:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
