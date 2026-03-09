; Easy68K Assembly Generated
	ORG $1000
START:
	LEA STACKPTR, A7	; Initialize stack pointer
	JMP main		; Jump to main program

; ===== RUTINAS AUXILIARES =====
PRINT_SIGNED:
	; D1 contiene el número a mostrar (con signo)
	; Si es negativo, muestra '-' y el valor absoluto
	TST.W D1		; Probar el signo
	BPL PRINT_UNSIGNED	; Si es positivo, saltar
	; Es negativo: mostrar '-'
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	; Negar el valor
	NEG.W D1
PRINT_UNSIGNED:
	; Mostrar el número (ahora positivo) usando Task #3
	MOVE.B #3, D0	; Task 3 = Display number
	TRAP #15
	RTS

PRINT_SIGNED_LONG:
	; D1 contiene el número de 32 bits a mostrar (con signo)
	TST.L D1		; Probar el signo
	BPL PRINT_UNSIGNED_LONG	; Si es positivo, saltar
	; Es negativo: mostrar '-'
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	; Negar el valor
	NEG.L D1
PRINT_UNSIGNED_LONG:
	; Mostrar el número de 32 bits (ahora positivo)
	MOVE.B #3, D0	; Task 3 = Display signed number at D1.L
	TRAP #15
	RTS

PRINT_DECIMAL_2:
	; D1 = numero escalado x100 (ej: 350 = 3.50)
	; Guardar original en D3 (32-bit)
	MOVE.L D1, D3
	; Manejar signo: si negativo, imprimir '-' y tomar abs
	TST.L D3
	BPL .PD2_POSITIVE
	; imprimir '-'
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	NEG.L D3
.PD2_POSITIVE:
	; Calcular parte entera: D2 = original / 100
	MOVE.L D3, D2
	MOVE.W #100, D4
	DIVS D4, D2
	; Calcular fracción: D3 = remainder = original - (parte_entera*100)
	MOVE.L D2, D5
	MOVE.W #100, D4
	MOVE.L D5, D6
	CLR.L D0
	MOVE.W D4, D0
	MULS D0, D6
	SUB.L D6, D3
	; Imprimir parte entera usando Task 3
	CLR.L D1
	MOVE.W D2, D1
	MOVE.B #3, D0
	TRAP #15
	; Imprimir punto decimal
	LEA DECIMAL_POINT, A1
	MOVE.B #14, D0
	TRAP #15
	; Imprimir fracción con 2 dígitos
	CLR.L D0
	MOVE.W D3, D0
	CMP.W #10, D0
	BGE .PD2_SKIP_ZERO
	; imprimir '0' si <10
	LEA ZERO_CHAR, A1
	MOVE.B #14, D0
	TRAP #15
.PD2_SKIP_ZERO:
	CLR.L D1
	MOVE.W D3, D1
	MOVE.B #3, D0
	TRAP #15
	RTS

PRINT_BOOL:
	; D1 contiene el valor booleano (0=mentira, 1=cierto)
	TST.W D1		; Probar si es 0
	BEQ .PRINT_MENTIRA	; Si es 0, imprimir 'mentira'
	; Es cierto (1)
	LEA STR_CIERTO, A1
	BRA .PRINT_BOOL_STR
.PRINT_MENTIRA:
	LEA STR_MENTIRA, A1
.PRINT_BOOL_STR:
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	RTS

main:
	; output "=== PRUEBA DE OPERADORES LOGICOS ==="
	LEA str0, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; x = 5
	MOVE.W #5, x
	; y = 10
	MOVE.W #10, y
	; z = 15
	MOVE.W #15, z
	; output "TEST 1: AND (y ademas)"
	LEA str1, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t5 = x < y
	MOVE.W #0, t5
	MOVE.W x, D0
	CMP.W y, D0
	BLT t5_true
	JMP t5_false
t5_true:
	MOVE.W #1, t5
t5_false:
	; t8 = y < z
	MOVE.W #0, t8
	MOVE.W y, D0
	CMP.W z, D0
	BLT t8_true
	JMP t8_false
t8_true:
	MOVE.W #1, t8
t8_false:
	; t9 = t5 && t8
	MOVE.W #0, t9
	MOVE.W t5, D0
	CMP.W #0, D0
	BEQ t9_false
	MOVE.W t8, D0
	CMP.W #0, D0
	BEQ t9_false
	MOVE.W #1, t9
t9_false:
	; if !(t9) goto e0
	MOVE.W t9, D0
	CMP.W #0, D0
	BEQ e0
	; output "5 < 10 AND 10 < 15: VERDADERO"
	LEA str2, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; goto e1
	JMP e1
e0:
	; output "5 < 10 AND 10 < 15: FALSO"
	LEA str3, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
e1:
	; t12 = x > y
	MOVE.W #0, t12
	MOVE.W x, D0
	CMP.W y, D0
	BGT t12_true
	JMP t12_false
t12_true:
	MOVE.W #1, t12
t12_false:
	; t15 = y < z
	MOVE.W #0, t15
	MOVE.W y, D0
	CMP.W z, D0
	BLT t15_true
	JMP t15_false
t15_true:
	MOVE.W #1, t15
t15_false:
	; t16 = t12 && t15
	MOVE.W #0, t16
	MOVE.W t12, D0
	CMP.W #0, D0
	BEQ t16_false
	MOVE.W t15, D0
	CMP.W #0, D0
	BEQ t16_false
	MOVE.W #1, t16
t16_false:
	; if !(t16) goto e2
	MOVE.W t16, D0
	CMP.W #0, D0
	BEQ e2
	; output "5 > 10 AND 10 < 15: VERDADERO"
	LEA str4, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; goto e3
	JMP e3
e2:
	; output "5 > 10 AND 10 < 15: FALSO"
	LEA str5, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
e3:
	; output "TEST 2: OR (o bien)"
	LEA str6, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t19 = x > y
	MOVE.W #0, t19
	MOVE.W x, D0
	CMP.W y, D0
	BGT t19_true
	JMP t19_false
t19_true:
	MOVE.W #1, t19
t19_false:
	; t22 = y < z
	MOVE.W #0, t22
	MOVE.W y, D0
	CMP.W z, D0
	BLT t22_true
	JMP t22_false
t22_true:
	MOVE.W #1, t22
t22_false:
	; t23 = t19 || t22
	MOVE.W #0, t23
	MOVE.W t19, D0
	CMP.W #0, D0
	BNE t23_true
	MOVE.W t22, D0
	CMP.W #0, D0
	BNE t23_true
	JMP t23_false
t23_true:
	MOVE.W #1, t23
t23_false:
	; if !(t23) goto e4
	MOVE.W t23, D0
	CMP.W #0, D0
	BEQ e4
	; output "5 > 10 OR 10 < 15: VERDADERO"
	LEA str7, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; goto e5
	JMP e5
e4:
	; output "5 > 10 OR 10 < 15: FALSO"
	LEA str8, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
e5:
	; t26 = x > y
	MOVE.W #0, t26
	MOVE.W x, D0
	CMP.W y, D0
	BGT t26_true
	JMP t26_false
t26_true:
	MOVE.W #1, t26
t26_false:
	; t29 = y > z
	MOVE.W #0, t29
	MOVE.W y, D0
	CMP.W z, D0
	BGT t29_true
	JMP t29_false
t29_true:
	MOVE.W #1, t29
t29_false:
	; t30 = t26 || t29
	MOVE.W #0, t30
	MOVE.W t26, D0
	CMP.W #0, D0
	BNE t30_true
	MOVE.W t29, D0
	CMP.W #0, D0
	BNE t30_true
	JMP t30_false
t30_true:
	MOVE.W #1, t30
t30_false:
	; if !(t30) goto e6
	MOVE.W t30, D0
	CMP.W #0, D0
	BEQ e6
	; output "5 > 10 OR 10 > 15: VERDADERO"
	LEA str9, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; goto e7
	JMP e7
e6:
	; output "5 > 10 OR 10 > 15: FALSO"
	LEA str10, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
e7:
	; output "TEST 3: NOT (no)"
	LEA str11, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; verd = true
	MOVE.W #1, verd
	; fals = false
	MOVE.W #0, fals
	; t33 = ! verd
	MOVE.W verd, D0
	CMP.W #0, D0
	BEQ t33_not_true
	MOVE.W #0, t33
	JMP t33_not_end
t33_not_true:
	MOVE.W #1, t33
t33_not_end:
	; if !(t33) goto e8
	MOVE.W t33, D0
	CMP.W #0, D0
	BEQ e8
	; output "NOT(true): VERDADERO"
	LEA str12, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; goto e9
	JMP e9
e8:
	; output "NOT(true): FALSO"
	LEA str13, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
e9:
	; t34 = ! fals
	MOVE.W fals, D0
	CMP.W #0, D0
	BEQ t34_not_true
	MOVE.W #0, t34
	JMP t34_not_end
t34_not_true:
	MOVE.W #1, t34
t34_not_end:
	; if !(t34) goto e10
	MOVE.W t34, D0
	CMP.W #0, D0
	BEQ e10
	; output "NOT(false): VERDADERO"
	LEA str14, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; goto e11
	JMP e11
e10:
	; output "NOT(false): FALSO"
	LEA str15, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
e11:
	; output "FIN"
	LEA str16, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
STR_CIERTO:	DC.B 'cierto',0
STR_MENTIRA:	DC.B 'mentira',0
HEAP_PTR:	DC.L $8000	; Inicio del heap para arrays
t5:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
str7:	DC.B '5 > 10 OR 10 < 15: VERDADERO',0
t30:	DS.W 1
str8:	DC.B '5 > 10 OR 10 < 15: FALSO',0
str5:	DC.B '5 > 10 AND 10 < 15: FALSO',0
str6:	DC.B 'TEST 2: OR (o bien)',0
str3:	DC.B '5 < 10 AND 10 < 15: FALSO',0
t12:	DS.W 1
t34:	DS.W 1
str4:	DC.B '5 > 10 AND 10 < 15: VERDADERO',0
t33:	DS.W 1
str1:	DC.B 'TEST 1: AND (y ademas)',0
verd:	DS.W 1
str2:	DC.B '5 < 10 AND 10 < 15: VERDADERO',0
t16:	DS.W 1
str12:	DC.B 'NOT(true): VERDADERO',0
t15:	DS.W 1
str13:	DC.B 'NOT(true): FALSO',0
str10:	DC.B '5 > 10 OR 10 > 15: FALSO',0
str11:	DC.B 'TEST 3: NOT (no)',0
str16:	DC.B 'FIN',0
t19:	DS.W 1
str9:	DC.B '5 > 10 OR 10 > 15: VERDADERO',0
str14:	DC.B 'NOT(false): VERDADERO',0
str15:	DC.B 'NOT(false): FALSO',0
false:	DS.W 1
str0:	DC.B '=== PRUEBA DE OPERADORES LOGICOS ===',0
fals:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
x:	DS.W 1
true:	DS.W 1
y:	DS.W 1
t26:	DS.W 1
z:	DS.W 1
t29:	DS.W 1

; ===== MANEJADOR DE ERROR DE DIVISION ENTRE CERO =====
DIV_ZERO_ERROR:
	LEA DIV_ZERO_MSG, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	BRA HALT

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
