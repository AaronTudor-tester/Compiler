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
	; output "=== CASO 3: SUMA CON BUCLE ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t0 = 0
	MOVE.W #0, t0
	; suma = t0
	MOVE.W t0, suma
	; t1 = 0
	MOVE.W #0, t1
	; contador = t1
	MOVE.W t1, contador
e0:
	; t2 = contador
	MOVE.W contador, t2
	; t3 = 5
	MOVE.W #5, t3
	; t4 = t2 < t3
	MOVE.W #0, t4
	MOVE.W t2, D0
	CMP.W t3, D0
	BLT t4_true
	JMP t4_false
t4_true:
	MOVE.W #1, t4
t4_false:
	; if !(t4) goto e1
	MOVE.W t4, D0
	CMP.W #0, D0
	BEQ e1
	; t5 = contador
	MOVE.W contador, t5
	; t6 = 1
	MOVE.W #1, t6
	; t7 = t5 + t6
	MOVE.W t5, D0
	ADD.W t6, D0
	MOVE.W D0, t7
	; contador = t7
	MOVE.W t7, contador
	; t8 = suma
	MOVE.W suma, t8
	; t9 = contador
	MOVE.W contador, t9
	; t10 = t8 + t9
	MOVE.W t8, D0
	ADD.W t9, D0
	MOVE.W D0, t10
	; suma = t10
	MOVE.W t10, suma
	; output "Suma parcial: "
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; t11 = suma
	MOVE.W suma, t11
	; output t11
	MOVE.W t11, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e0
	JMP e0
e1:
	; output "Suma total:"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; t12 = suma
	MOVE.W suma, t12
	; output t12
	MOVE.W t12, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Tabla de multiplicar del 3:"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t13 = 1
	MOVE.W #1, t13
	; i = t13
	MOVE.W t13, i
e2:
	; t14 = i
	MOVE.W i, t14
	; t15 = 10
	MOVE.W #10, t15
	; t16 = t14 <= t15
	MOVE.W #0, t16
	MOVE.W t14, D0
	CMP.W t15, D0
	BLE t16_true
	JMP t16_false
t16_true:
	MOVE.W #1, t16
t16_false:
	; if !(t16) goto e3
	MOVE.W t16, D0
	CMP.W #0, D0
	BEQ e3
	; t17 = 3
	MOVE.W #3, t17
	; t18 = i
	MOVE.W i, t18
	; t19 = t17 * t18
	MOVE.W t17, D0
	MULS t18, D0
	MOVE.W D0, t19
	; resultado = t19
	MOVE.W t19, resultado
	; t20 = resultado
	MOVE.W resultado, t20
	; output t20
	MOVE.W t20, D1
	JSR PRINT_SIGNED
	; output " "
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e2
	JMP e2
e3:
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
suma:	DS.W 1
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t10:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'Tabla de multiplicar del 3:',0
contador:	DS.W 1
t11:	DS.W 1
str4:	DC.B ' ',0
str1:	DC.B 'Suma parcial: ',0
t14:	DS.W 1
str2:	DC.B 'Suma total:',0
t13:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
resultado:	DS.W 1
str0:	DC.B '=== CASO 3: SUMA CON BUCLE ===',0
i:	DS.W 1
t20:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
