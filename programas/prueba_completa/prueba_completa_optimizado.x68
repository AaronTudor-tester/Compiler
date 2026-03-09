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

suma:
	; ; param a : INT
	; ; param b : INT
	; t2 = a + b
	MOVE.W a, D0
	ADD.W b, D0
	MOVE.W D0, t2
	; return t2
	MOVE.W t2, D0
	RTS
main:
	; output "=== TEST 1: Operaciones Basicas ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; x = 10
	MOVE.W #10, x
	; y = 5
	MOVE.W #5, y
	; output "x + y = "
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; param_s x  
	; param_s y  
	; t5 = call suma
	MOVE.W x, a
	MOVE.W y, b
	JSR suma
	MOVE.W D0, t5
	; output t5
	MOVE.W t5, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "=== TEST 2: Condicionales ==="
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t8 = x > y
	MOVE.W #0, t8
	MOVE.W x, D0
	CMP.W y, D0
	BGT t8_true
	JMP t8_false
t8_true:
	MOVE.W #1, t8
t8_false:
	; if !(t8) goto e0
	MOVE.W t8, D0
	CMP.W #0, D0
	BEQ e0
	; output "10 es mayor que 5"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e1
	JMP e1
e0:
	; output "10 no es mayor que 5"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e1:
	; output "=== TEST 3: While ==="
	LEA str5, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; contador = 0
	MOVE.W #0, contador
e2:
	; t12 = contador < 3
	MOVE.W #0, t12
	MOVE.W contador, D0
	CMP.W #3, D0
	BLT t12_true
	JMP t12_false
t12_true:
	MOVE.W #1, t12
t12_false:
	; if !(t12) goto e3
	MOVE.W t12, D0
	CMP.W #0, D0
	BEQ e3
	; output "Iteracion: "
	LEA str6, A1
	MOVE.B #14, D0
	TRAP #15
	; output contador
	MOVE.W contador, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; contador = contador + 1
	MOVE.W contador, D0
	ADD.W #1, D0
	MOVE.W D0, contador
	; goto e2
	JMP e2
e3:
	; output "=== TEST 4: Operaciones Unarias ==="
	LEA str7, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; z = 15
	MOVE.W #15, z
	; output "z = "
	LEA str8, A1
	MOVE.B #14, D0
	TRAP #15
	; output z
	MOVE.W z, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Negacion de z = "
	LEA str9, A1
	MOVE.B #14, D0
	TRAP #15
	; t16 = NEG z
	MOVE.W z, D0
	NEG.W D0
	MOVE.W D0, t16
	; negZ = t16
	MOVE.W t16, negZ
	; output negZ
	MOVE.W negZ, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "=== TEST 5: Strings ==="
	LEA str10, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Hola Mundo"
	LEA str11, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Compilador funcionando!"
	LEA str12, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "=== TEST 6: Comparaciones ==="
	LEA str13, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t20 = 10 == 10
	MOVE.W #0, t20
	MOVE.W #10, D0
	CMP.W #10, D0
	BEQ t20_true
	JMP t20_false
t20_true:
	MOVE.W #1, t20
t20_false:
	; if !(t20) goto e4
	MOVE.W t20, D0
	CMP.W #0, D0
	BEQ e4
	; output "10 igual a 10: VERDADERO"
	LEA str14, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e4:
	; t23 = 5 > 8
	MOVE.W #0, t23
	MOVE.W #5, D0
	CMP.W #8, D0
	BGT t23_true
	JMP t23_false
t23_true:
	MOVE.W #1, t23
t23_false:
	; if !(t23) goto e6
	MOVE.W t23, D0
	CMP.W #0, D0
	BEQ e6
	; output "5 > 8: VERDADERO"
	LEA str15, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e7
	JMP e7
e6:
	; output "5 > 8: FALSO"
	LEA str16, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e7:
	; output "=== FIN DE PRUEBAS ==="
	LEA str17, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
t5:	DS.W 1
t8:	DS.W 1
str7:	DC.B '=== TEST 4: Operaciones Unarias ===',0
str8:	DC.B 'z = ',0
str5:	DC.B '=== TEST 3: While ===',0
str6:	DC.B 'Iteracion: ',0
str3:	DC.B '10 es mayor que 5',0
t12:	DS.W 1
str4:	DC.B '10 no es mayor que 5',0
contador:	DS.W 1
str1:	DC.B 'x + y = ',0
str2:	DC.B '=== TEST 2: Condicionales ===',0
t16:	DS.W 1
str12:	DC.B 'Compilador funcionando!',0
str13:	DC.B '=== TEST 6: Comparaciones ===',0
str10:	DC.B '=== TEST 5: Strings ===',0
str11:	DC.B 'Hola Mundo',0
str16:	DC.B '5 > 8: FALSO',0
str17:	DC.B '=== FIN DE PRUEBAS ===',0
str9:	DC.B 'Negacion de z = ',0
str14:	DC.B '10 igual a 10: VERDADERO',0
str15:	DC.B '5 > 8: VERDADERO',0
a:	DS.W 1
b:	DS.W 1
str0:	DC.B '=== TEST 1: Operaciones Basicas ===',0
t20:	DS.W 1
t23:	DS.W 1
x:	DS.W 1
y:	DS.W 1
negZ:	DS.W 1
z:	DS.W 1
t2:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
