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

main:
	; output "=== CASO 2: BUCLES Y CONDICIONALES ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Numeros del 1 al 10:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t0 = 1
	MOVE.W #1, t0
	; i = t0
	MOVE.W t0, i
e0:
	; t1 = i
	MOVE.W i, t1
	; t2 = 10
	MOVE.W #10, t2
	; t3 = t1 <= t2
	MOVE.W #0, t3
	MOVE.W t1, D0
	CMP.W t2, D0
	BLE t3_true
	JMP t3_false
t3_true:
	MOVE.W #1, t3
t3_false:
	; if !(t3) goto e1
	MOVE.W t3, D0
	CMP.W #0, D0
	BEQ e1
	; t4 = i
	MOVE.W i, t4
	; output t4
	MOVE.W t4, D1
	JSR PRINT_SIGNED
	; output " "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e0
	JMP e0
e1:
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Numeros pares del 1 al 10:"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t5 = 1
	MOVE.W #1, t5
	; j = t5
	MOVE.W t5, j
e2:
	; t6 = j
	MOVE.W j, t6
	; t7 = 10
	MOVE.W #10, t7
	; t8 = t6 <= t7
	MOVE.W #0, t8
	MOVE.W t6, D0
	CMP.W t7, D0
	BLE t8_true
	JMP t8_false
t8_true:
	MOVE.W #1, t8
t8_false:
	; if !(t8) goto e3
	MOVE.W t8, D0
	CMP.W #0, D0
	BEQ e3
	; t9 = j
	MOVE.W j, t9
	; t10 = 2
	MOVE.W #2, t10
	; t11 = t9 % t10
	MOVE.W t9, D0
	MOVE.W t10, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	EXT.L D0
	MOVE.L D0, D2
	DIVS D1, D0
	CLR.L D3
	MOVE.W D0, D3
	MULS D1, D3
	SUB.L D3, D2
	MOVE.W D2, t11
	; t12 = 0
	MOVE.W #0, t12
	; t13 = t11 == t12
	MOVE.W #0, t13
	MOVE.W t11, D0
	CMP.W t12, D0
	BEQ t13_true
	JMP t13_false
t13_true:
	MOVE.W #1, t13
t13_false:
	; if !(t13) goto e4
	MOVE.W t13, D0
	CMP.W #0, D0
	BEQ e4
	; t14 = j
	MOVE.W j, t14
	; output t14
	MOVE.W t14, D1
	JSR PRINT_SIGNED
	; output " "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e5
	JMP e5
e4:
e5:
	; j = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, j
	; goto e2
	JMP e2
e3:
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Numeros impares del 1 al 10:"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t15 = 1
	MOVE.W #1, t15
	; k = t15
	MOVE.W t15, k
e6:
	; t16 = k
	MOVE.W k, t16
	; t17 = 10
	MOVE.W #10, t17
	; t18 = t16 <= t17
	MOVE.W #0, t18
	MOVE.W t16, D0
	CMP.W t17, D0
	BLE t18_true
	JMP t18_false
t18_true:
	MOVE.W #1, t18
t18_false:
	; if !(t18) goto e7
	MOVE.W t18, D0
	CMP.W #0, D0
	BEQ e7
	; t19 = k
	MOVE.W k, t19
	; t20 = 2
	MOVE.W #2, t20
	; t21 = t19 % t20
	MOVE.W t19, D0
	MOVE.W t20, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	EXT.L D0
	MOVE.L D0, D2
	DIVS D1, D0
	CLR.L D3
	MOVE.W D0, D3
	MULS D1, D3
	SUB.L D3, D2
	MOVE.W D2, t21
	; t22 = 0
	MOVE.W #0, t22
	; t23 = t21 != t22
	MOVE.W #0, t23
	MOVE.W t21, D0
	CMP.W t22, D0
	BNE t23_true
	JMP t23_false
t23_true:
	MOVE.W #1, t23
t23_false:
	; if !(t23) goto e8
	MOVE.W t23, D0
	CMP.W #0, D0
	BEQ e8
	; t24 = k
	MOVE.W k, t24
	; output t24
	MOVE.W t24, D1
	JSR PRINT_SIGNED
	; output " "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e9
	JMP e9
e8:
e9:
	; k = k + 1
	MOVE.W k, D0
	ADD.W #1, D0
	MOVE.W D0, k
	; goto e6
	JMP e6
e7:
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t10:	DS.W 1
str3:	DC.B 'Numeros pares del 1 al 10:',0
t12:	DS.W 1
t11:	DS.W 1
str4:	DC.B 'Numeros impares del 1 al 10:',0
str1:	DC.B 'Numeros del 1 al 10:',0
t14:	DS.W 1
str2:	DC.B ' ',0
t13:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B '=== CASO 2: BUCLES Y CONDICIONALES ===',0
i:	DS.W 1
j:	DS.W 1
k:	DS.W 1
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t24:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
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
