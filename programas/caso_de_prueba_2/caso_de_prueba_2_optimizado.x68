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
	; i = 1
	MOVE.W #1, i
e0:
	; t3 = i <= 10
	MOVE.W #0, t3
	MOVE.W i, D0
	CMP.W #10, D0
	BLE t3_true
	JMP t3_false
t3_true:
	MOVE.W #1, t3
t3_false:
	; if !(t3) goto e1
	MOVE.W t3, D0
	CMP.W #0, D0
	BEQ e1
	; output i
	MOVE.W i, D1
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
	; j = 1
	MOVE.W #1, j
e2:
	; t8 = j <= 10
	MOVE.W #0, t8
	MOVE.W j, D0
	CMP.W #10, D0
	BLE t8_true
	JMP t8_false
t8_true:
	MOVE.W #1, t8
t8_false:
	; if !(t8) goto e3
	MOVE.W t8, D0
	CMP.W #0, D0
	BEQ e3
	; t11 = j % 2
	MOVE.W j, D0
	MOVE.W #2, D1
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
	; t13 = t11 == 0
	MOVE.W #0, t13
	MOVE.W t11, D0
	CMP.W #0, D0
	BEQ t13_true
	JMP t13_false
t13_true:
	MOVE.W #1, t13
t13_false:
	; if !(t13) goto e4
	MOVE.W t13, D0
	CMP.W #0, D0
	BEQ e4
	; output j
	MOVE.W j, D1
	JSR PRINT_SIGNED
	; output " "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
e4:
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
	; k = 1
	MOVE.W #1, k
e6:
	; t18 = k <= 10
	MOVE.W #0, t18
	MOVE.W k, D0
	CMP.W #10, D0
	BLE t18_true
	JMP t18_false
t18_true:
	MOVE.W #1, t18
t18_false:
	; if !(t18) goto e7
	MOVE.W t18, D0
	CMP.W #0, D0
	BEQ e7
	; t21 = k % 2
	MOVE.W k, D0
	MOVE.W #2, D1
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
	; t23 = t21 != 0
	MOVE.W #0, t23
	MOVE.W t21, D0
	CMP.W #0, D0
	BNE t23_true
	JMP t23_false
t23_true:
	MOVE.W #1, t23
t23_false:
	; if !(t23) goto e8
	MOVE.W t23, D0
	CMP.W #0, D0
	BEQ e8
	; output k
	MOVE.W k, D1
	JSR PRINT_SIGNED
	; output " "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
e8:
	; k = k + 1
	MOVE.W k, D0
	ADD.W #1, D0
	MOVE.W D0, k
	; goto e6
	JMP e6
e7:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
t8:	DS.W 1
str0:	DC.B '=== CASO 2: BUCLES Y CONDICIONALES ===',0
i:	DS.W 1
j:	DS.W 1
k:	DS.W 1
t21:	DS.W 1
str3:	DC.B 'Numeros pares del 1 al 10:',0
t23:	DS.W 1
t11:	DS.W 1
str4:	DC.B 'Numeros impares del 1 al 10:',0
str1:	DC.B 'Numeros del 1 al 10:',0
str2:	DC.B ' ',0
t13:	DS.W 1
t18:	DS.W 1
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
