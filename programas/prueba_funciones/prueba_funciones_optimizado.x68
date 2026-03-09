	ORG $1000
START:
	LEA STACKPTR, A7
	; a = 2
	MOVE.W #2, a
	; b = 3
	MOVE.W #3, b
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
	; t4 = x < 100
	MOVE.W #0, t4
	MOVE.W x, D0
	CMP.W #100, D0
	BLT t4_true
	JMP t4_false
t4_true:
	MOVE.W #1, t4
t4_false:
	; if !(t4) goto e0
	MOVE.W t4, D0
	CMP.W #0, D0
	BEQ e0
	; output x
	MOVE.W x, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t8 = x + 37
	MOVE.W x, D0
	ADD.W #37, D0
	MOVE.W D0, t8
	; param_s t8  
	; t9 = call suma2
	MOVE.W t8, x
	JSR suma2
	MOVE.W D0, t9
	; return t9
	MOVE.W t9, D0
	RTS
e0:
	; x = 9
	MOVE.W #9, x
	; t12 = NEG 1
	MOVE.W #1, D0
	NEG.W D0
	MOVE.W D0, t12
	; t14 = t12 + x
	MOVE.W t12, D0
	ADD.W x, D0
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
	; t17 = a + 2
	MOVE.W a, D0
	ADD.W #2, D0
	MOVE.W D0, t17
	; a = t17
	MOVE.W t17, a
	; t20 = a + b
	MOVE.W a, D0
	ADD.W b, D0
	MOVE.W D0, t20
	; resultado = t20
	MOVE.W t20, resultado
	; t23 = a < 100
	MOVE.W #0, t23
	MOVE.W a, D0
	CMP.W #100, D0
	BLT t23_true
	JMP t23_false
t23_true:
	MOVE.W #1, t23
t23_false:
	; if !(t23) goto e2
	MOVE.W t23, D0
	CMP.W #0, D0
	BEQ e2
	; param_s 23  
	; t25 = call suma2
	MOVE.W #23, x
	JSR suma2
	MOVE.W D0, t25
	; t28 = a + 1
	MOVE.W a, D0
	ADD.W #1, D0
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
	; t32 = t30 + 3
	MOVE.W t30, D0
	ADD.W #3, D0
	MOVE.W D0, t32
	; return t32
	MOVE.W t32, D0
	RTS
e2:
	; return resultado
	MOVE.W resultado, D0
	RTS
sumaNormal:
	; ; param a1 : INT
	; ; param b1 : INT
	; t36 = a1 + b1
	MOVE.W a1, D0
	ADD.W b1, D0
	MOVE.W D0, t36
	; return t36
	MOVE.W t36, D0
	RTS
main:
	; www = 4.3
	MOVE.W #430, www
	; output www
	CLR.L D1
	MOVE.W www, D1
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
	; b = 3
	MOVE.W #3, b
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
	; param_s 1  
	; t47 = call suma2
	MOVE.W #1, x
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
	; param_s 200  
	; t51 = call suma2
	MOVE.W #200, x
	JSR suma2
	MOVE.W D0, t51
	; output t51
	MOVE.W t51, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; param_s 2  
	; param_s 3  
	; t54 = call sumaNormal
	MOVE.W #2, a1
	MOVE.W #3, b1
	JSR sumaNormal
	MOVE.W D0, t54
	; output t54
	MOVE.W t54, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
b1:	DS.W 1
t30:	DS.W 1
t51:	DS.W 1
t32:	DS.W 1
t54:	DS.W 1
t12:	DS.W 1
t14:	DS.W 1
t36:	DS.W 1
www:	DS.W 1
t17:	DS.W 1
a:	DS.W 1
b:	DS.W 1
resultado:	DS.W 1
str0:	DC.B 'hola',0
a1:	DS.W 1
t41:	DS.W 1
t43:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1
t25:	DS.W 1
t47:	DS.W 1
x:	DS.W 1
t48:	DS.W 1
t29:	DS.W 1
t28:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
