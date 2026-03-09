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
	; t0 = a
	MOVE.W a, t0
	; t1 = b
	MOVE.W b, t1
	; t2 = t0 + t1
	MOVE.W t0, D0
	ADD.W t1, D0
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
	; t3 = 10
	MOVE.W #10, t3
	; x = t3
	MOVE.W t3, x
	; t4 = 5
	MOVE.W #5, t4
	; y = t4
	MOVE.W t4, y
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
	; t6 = x
	MOVE.W x, t6
	; t7 = y
	MOVE.W y, t7
	; t8 = t6 > t7
	MOVE.W #0, t8
	MOVE.W t6, D0
	CMP.W t7, D0
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
	; t9 = 0
	MOVE.W #0, t9
	; contador = t9
	MOVE.W t9, contador
e2:
	; t10 = contador
	MOVE.W contador, t10
	; t11 = 3
	MOVE.W #3, t11
	; t12 = t10 < t11
	MOVE.W #0, t12
	MOVE.W t10, D0
	CMP.W t11, D0
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
	; t13 = contador
	MOVE.W contador, t13
	; output t13
	MOVE.W t13, D1
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
	; t14 = 15
	MOVE.W #15, t14
	; z = t14
	MOVE.W t14, z
	; output "z = "
	LEA str8, A1
	MOVE.B #14, D0
	TRAP #15
	; t15 = z
	MOVE.W z, t15
	; output t15
	MOVE.W t15, D1
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
	; t17 = negZ
	MOVE.W negZ, t17
	; output t17
	MOVE.W t17, D1
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
	; t18 = 10
	MOVE.W #10, t18
	; t19 = 10
	MOVE.W #10, t19
	; t20 = t18 == t19
	MOVE.W #0, t20
	MOVE.W t18, D0
	CMP.W t19, D0
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
	; goto e5
	JMP e5
e4:
e5:
	; t21 = 5
	MOVE.W #5, t21
	; t22 = 8
	MOVE.W #8, t22
	; t23 = t21 > t22
	MOVE.W #0, t23
	MOVE.W t21, D0
	CMP.W t22, D0
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
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
str7:	DC.B '=== TEST 4: Operaciones Unarias ===',0
str8:	DC.B 'z = ',0
str5:	DC.B '=== TEST 3: While ===',0
t10:	DS.W 1
str6:	DC.B 'Iteracion: ',0
str3:	DC.B '10 es mayor que 5',0
t12:	DS.W 1
str4:	DC.B '10 no es mayor que 5',0
t11:	DS.W 1
str1:	DC.B 'x + y = ',0
t14:	DS.W 1
str2:	DC.B '=== TEST 2: Condicionales ===',0
t13:	DS.W 1
t16:	DS.W 1
str12:	DC.B 'Compilador funcionando!',0
t15:	DS.W 1
str13:	DC.B '=== TEST 6: Comparaciones ===',0
str10:	DC.B '=== TEST 5: Strings ===',0
t18:	DS.W 1
t17:	DS.W 1
str11:	DC.B 'Hola Mundo',0
str16:	DC.B '5 > 8: FALSO',0
t19:	DS.W 1
str17:	DC.B '=== FIN DE PRUEBAS ===',0
str9:	DC.B 'Negacion de z = ',0
str14:	DC.B '10 igual a 10: VERDADERO',0
str15:	DC.B '5 > 8: VERDADERO',0
str0:	DC.B '=== TEST 1: Operaciones Basicas ===',0
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
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
contador:	DS.W 1
a:	DS.W 1
b:	DS.W 1
x:	DS.W 1
y:	DS.W 1
negZ:	DS.W 1
z:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
