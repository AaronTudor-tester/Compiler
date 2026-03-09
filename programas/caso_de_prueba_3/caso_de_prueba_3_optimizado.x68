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
	; suma = 0
	MOVE.W #0, suma
	; contador = 0
	MOVE.W #0, contador
e0:
	; t4 = contador < 5
	MOVE.W #0, t4
	MOVE.W contador, D0
	CMP.W #5, D0
	BLT t4_true
	JMP t4_false
t4_true:
	MOVE.W #1, t4
t4_false:
	; if !(t4) goto e1
	MOVE.W t4, D0
	CMP.W #0, D0
	BEQ e1
	; t7 = contador + 1
	MOVE.W contador, D0
	ADD.W #1, D0
	MOVE.W D0, t7
	; contador = t7
	MOVE.W t7, contador
	; t10 = suma + contador
	MOVE.W suma, D0
	ADD.W contador, D0
	MOVE.W D0, t10
	; suma = t10
	MOVE.W t10, suma
	; output "Suma parcial: "
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output suma
	MOVE.W suma, D1
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
	; output suma
	MOVE.W suma, D1
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
	; i = 1
	MOVE.W #1, i
e2:
	; t16 = i <= 10
	MOVE.W #0, t16
	MOVE.W i, D0
	CMP.W #10, D0
	BLE t16_true
	JMP t16_false
t16_true:
	MOVE.W #1, t16
t16_false:
	; if !(t16) goto e3
	MOVE.W t16, D0
	CMP.W #0, D0
	BEQ e3
	; t19 = 3 * i
	MOVE.W #3, D0
	MULS i, D0
	MOVE.W D0, t19
	; resultado = t19
	MOVE.W t19, resultado
	; output resultado
	MOVE.W resultado, D1
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
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
suma:	DS.W 1
t4:	DS.W 1
t7:	DS.W 1
resultado:	DS.W 1
str0:	DC.B '=== CASO 3: SUMA CON BUCLE ===',0
i:	DS.W 1
t10:	DS.W 1
str3:	DC.B 'Tabla de multiplicar del 3:',0
contador:	DS.W 1
str4:	DC.B ' ',0
str1:	DC.B 'Suma parcial: ',0
str2:	DC.B 'Suma total:',0
t16:	DS.W 1
t19:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
