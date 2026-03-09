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

sumaDosNumeros:
	; ; param a : INT
	; ; param b : INT
	; t2 = a + b
	MOVE.W a, D0
	ADD.W b, D0
	MOVE.W D0, t2
	; return t2
	MOVE.W t2, D0
	RTS
multiplicar:
	; ; param x : INT
	; ; param y : INT
	; t5 = x * y
	MOVE.W x, D0
	MULS y, D0
	MOVE.W D0, t5
	; return t5
	MOVE.W t5, D0
	RTS
main:
	; output "=== PROGRAMA COMPLETO DE PRUEBAS ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "PRUEBA 1: Funciones"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; num1 = 5
	MOVE.W #5, num1
	; num2 = 3
	MOVE.W #3, num2
	; param_s num1  
	; param_s num2  
	; t8 = call sumaDosNumeros
	MOVE.W num1, a
	MOVE.W num2, b
	JSR sumaDosNumeros
	MOVE.W D0, t8
	; suma = t8
	MOVE.W t8, suma
	; output "5 + 3 = "
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
	; output "PRUEBA 2: IF"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t12 = suma > 7
	MOVE.W #0, t12
	MOVE.W suma, D0
	CMP.W #7, D0
	BGT t12_true
	JMP t12_false
t12_true:
	MOVE.W #1, t12
t12_false:
	; if !(t12) goto e0
	MOVE.W t12, D0
	CMP.W #0, D0
	BEQ e0
	; output "Suma es mayor que 7"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e1
	JMP e1
e0:
	; output "Suma no es mayor que 7"
	LEA str5, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e1:
	; output "PRUEBA 3: WHILE - Cuenta del 1 al 5"
	LEA str6, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; contador = 1
	MOVE.W #1, contador
e2:
	; t16 = contador <= 5
	MOVE.W #0, t16
	MOVE.W contador, D0
	CMP.W #5, D0
	BLE t16_true
	JMP t16_false
t16_true:
	MOVE.W #1, t16
t16_false:
	; if !(t16) goto e3
	MOVE.W t16, D0
	CMP.W #0, D0
	BEQ e3
	; output contador
	MOVE.W contador, D1
	JSR PRINT_SIGNED
	; output " "
	LEA str7, A1
	MOVE.B #14, D0
	TRAP #15
	; t20 = contador + 1
	MOVE.W contador, D0
	ADD.W #1, D0
	MOVE.W D0, t20
	; contador = t20
	MOVE.W t20, contador
	; goto e2
	JMP e2
e3:
	; output "PRUEBA 4: SWITCH - Menu"
	LEA str8, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; opcion = 2
	MOVE.W #2, opcion
	; t22 = opcion
	MOVE.W opcion, t22
	; t23 = 1
	MOVE.W #1, t23
	; if t22 != t23 goto e5
	MOVE.W t22, D0
	CMP.W t23, D0
	BNE e5
	; output "Elegiste opcion 1"
	LEA str9, A1
	MOVE.B #14, D0
	TRAP #15
e5:
	; t24 = 2
	MOVE.W #2, t24
	; if t22 != t24 goto e6
	MOVE.W t22, D0
	CMP.W t24, D0
	BNE e6
	; output "Elegiste opcion 2"
	LEA str10, A1
	MOVE.B #14, D0
	TRAP #15
e6:
	; t25 = 3
	MOVE.W #3, t25
	; if t22 != t25 goto e4
	MOVE.W t22, D0
	CMP.W t25, D0
	BNE e4
	; output "Elegiste opcion 3"
	LEA str11, A1
	MOVE.B #14, D0
	TRAP #15
e4:
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "PRUEBA 5: REPEAT - Numeros impares hasta 9"
	LEA str12, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; num = 1
	MOVE.W #1, num
e7:
	; output num
	MOVE.W num, D1
	JSR PRINT_SIGNED
	; t30 = num + 2
	MOVE.W num, D0
	ADD.W #2, D0
	MOVE.W D0, t30
	; num = t30
	MOVE.W t30, num
	; output " "
	LEA str7, A1
	MOVE.B #14, D0
	TRAP #15
	; t33 = num <= 9
	MOVE.W #0, t33
	MOVE.W num, D0
	CMP.W #9, D0
	BLE t33_true
	JMP t33_false
t33_true:
	MOVE.W #1, t33
t33_false:
	; if t33 goto e7
	MOVE.W t33, D0
	CMP.W #0, D0
	BNE e7
	; output "PRUEBA 6: Operador NOT"
	LEA str13, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; esVerdadero = true
	MOVE.W #1, esVerdadero
	; t35 = ! esVerdadero
	MOVE.W esVerdadero, D0
	CMP.W #0, D0
	BEQ t35_not_true
	MOVE.W #0, t35
	JMP t35_not_end
t35_not_true:
	MOVE.W #1, t35
t35_not_end:
	; if !(t35) goto e9
	MOVE.W t35, D0
	CMP.W #0, D0
	BEQ e9
	; output "NO es verdadero"
	LEA str14, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e10
	JMP e10
e9:
	; output "SI es verdadero"
	LEA str15, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e10:
	; output "PRUEBA 7: Funcion multiplicar"
	LEA str16, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; param_s 4  
	; param_s 6  
	; t38 = call multiplicar
	MOVE.W #4, x
	MOVE.W #6, y
	JSR multiplicar
	MOVE.W D0, t38
	; resultado = t38
	MOVE.W t38, resultado
	; output "4 * 6 = "
	LEA str17, A1
	MOVE.B #14, D0
	TRAP #15
	; output resultado
	MOVE.W resultado, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "FIN DEL PROGRAMA"
	LEA str18, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
suma:	DS.W 1
t5:	DS.W 1
t8:	DS.W 1
num:	DS.W 1
str7:	DC.B ' ',0
t30:	DS.W 1
str8:	DC.B 'PRUEBA 4: SWITCH - Menu',0
str5:	DC.B 'Suma no es mayor que 7',0
str18:	DC.B 'FIN DEL PROGRAMA',0
str6:	DC.B 'PRUEBA 3: WHILE - Cuenta del 1 al 5',0
str3:	DC.B 'PRUEBA 2: IF',0
t12:	DS.W 1
str4:	DC.B 'Suma es mayor que 7',0
contador:	DS.W 1
t33:	DS.W 1
str1:	DC.B 'PRUEBA 1: Funciones',0
str2:	DC.B '5 + 3 = ',0
t35:	DS.W 1
num1:	DS.W 1
t16:	DS.W 1
str12:	DC.B 'PRUEBA 5: REPEAT - Numeros impares hasta 9',0
t38:	DS.W 1
str13:	DC.B 'PRUEBA 6: Operador NOT',0
str10:	DC.B 'Elegiste opcion 2',0
str11:	DC.B 'Elegiste opcion 3',0
str16:	DC.B 'PRUEBA 7: Funcion multiplicar',0
str17:	DC.B '4 * 6 = ',0
str9:	DC.B 'Elegiste opcion 1',0
str14:	DC.B 'NO es verdadero',0
num2:	DS.W 1
str15:	DC.B 'SI es verdadero',0
a:	DS.W 1
b:	DS.W 1
opcion:	DS.W 1
resultado:	DS.W 1
str0:	DC.B '=== PROGRAMA COMPLETO DE PRUEBAS ===',0
esVerdadero:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.W 1
t24:	DS.W 1
x:	DS.W 1
true:	DS.W 1
y:	DS.W 1
t2:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
