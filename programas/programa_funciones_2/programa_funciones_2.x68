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

suma:
	; ; param a : INT
	; t0 = a
	MOVE.W a, t0
	; t1 = 1
	MOVE.W #1, t1
	; t2 = t0 + t1
	MOVE.W t0, D0
	ADD.W t1, D0
	MOVE.W D0, t2
	; a = t2
	MOVE.W t2, a
	; t3 = a
	MOVE.W a, t3
	; return t3
	MOVE.W t3, D0
	RTS
main:
	; t4 = 4.12
	MOVE.W #412, t4
	; t5 = 3.0
	MOVE.W #300, t5
	; t6 = t4 * t5
	MOVE.W t4, D0
	MOVE.W t5, D1
	MULS D1, D0
	MOVE.W #100, D2
	DIVS D2, D0
	MOVE.W D0, t6
	; t7 = 1.75
	MOVE.W #175, t7
	; t8 = t6 / t7
	MOVE.W t6, D0
	MOVE.W t7, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	MOVE.W #100, D2
	MULS D2, D0
	DIVS D1, D0
	MOVE.W D0, t8
	; t9 = 2.0
	MOVE.W #200, t9
	; t10 = t8 % t9
	MOVE.W t8, D0
	MOVE.W t9, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	EXT.L D0
	MOVE.L D0, D2
	DIVS D1, D0
	CLR.L D3
	MOVE.W D0, D3
	MULS D1, D3
	SUB.L D3, D2
	MOVE.W D2, t10
	; output t10
	CLR.L D1
	MOVE.W t10, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t11 = 3
	MOVE.W #3, t11
	; sum = t11
	MOVE.W t11, sum
	; param_s sum  
	; t12 = call suma
	JSR suma
	MOVE.W D0, t12
	; sum = t12
	MOVE.W t12, sum
	; t13 = sum
	MOVE.W sum, t13
	; output t13
	MOVE.W t13, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t14 = 4.3
	MOVE.W #430, t14
	; t15 = 3
	MOVE.W #3, t15
	; t16 = t14 > t15
	MOVE.W #0, t16
	MOVE.W t14, D0
	CMP.W t15, D0
	BGT t16_true
	JMP t16_false
t16_true:
	MOVE.W #1, t16
t16_false:
	; t17 = a
	MOVE.W a, t17
	; t18 = 0
	MOVE.W #0, t18
	; t19 = t17 > t18
	MOVE.W #0, t19
	MOVE.W t17, D0
	CMP.W t18, D0
	BGT t19_true
	JMP t19_false
t19_true:
	MOVE.W #1, t19
t19_false:
	; t20 = t16 && t19
	MOVE.W #0, t20
	MOVE.W t16, D0
	CMP.W #0, D0
	BEQ t20_false
	MOVE.W t19, D0
	CMP.W #0, D0
	BEQ t20_false
	MOVE.W #1, t20
t20_false:
	; if !(t20) goto e0
	MOVE.W t20, D0
	CMP.W #0, D0
	BEQ e0
	; output "hola"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e1
	JMP e1
e0:
e1:
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
a:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
str0:	DC.B 'hola',0
sum:	DS.W 1
t10:	DS.W 1
t20:	DS.W 1
t12:	DS.W 1
t11:	DS.W 1
t14:	DS.W 1
t13:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t19:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

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
