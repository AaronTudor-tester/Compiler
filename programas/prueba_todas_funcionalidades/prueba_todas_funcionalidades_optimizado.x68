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
	; ; param n1 : INT
	; ; param n2 : INT
	; t2 = n1 + n2
	MOVE.W n1, D0
	ADD.W n2, D0
	MOVE.W D0, t2
	; return t2
	MOVE.W t2, D0
	RTS
contarPares:
	; ; param inicio : INT
	; ; param fin : INT
	; contador = 0
	MOVE.W #0, contador
	; i = inicio
	MOVE.W inicio, i
	; limite = fin
	MOVE.W fin, limite
e0:
	; t8 = i < limite
	MOVE.W #0, t8
	MOVE.W i, D0
	CMP.W limite, D0
	BLT t8_true
	JMP t8_false
t8_true:
	MOVE.W #1, t8
t8_false:
	; if !(t8) goto e1
	MOVE.W t8, D0
	CMP.W #0, D0
	BEQ e1
	; t11 = i != 0
	MOVE.W #0, t11
	MOVE.W i, D0
	CMP.W #0, D0
	BNE t11_true
	JMP t11_false
t11_true:
	MOVE.W #1, t11
t11_false:
	; if !(t11) goto e2
	MOVE.W t11, D0
	CMP.W #0, D0
	BEQ e2
	; t14 = i % 2
	MOVE.W i, D0
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
	MOVE.W D2, t14
	; residuo = t14
	MOVE.W t14, residuo
	; t17 = residuo == 0
	MOVE.W #0, t17
	MOVE.W residuo, D0
	CMP.W #0, D0
	BEQ t17_true
	JMP t17_false
t17_true:
	MOVE.W #1, t17
t17_false:
	; if !(t17) goto e3
	MOVE.W t17, D0
	CMP.W #0, D0
	BEQ e3
	; contador = contador + 1
	MOVE.W contador, D0
	ADD.W #1, D0
	MOVE.W D0, contador
e2:
e3:
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e0
	JMP e0
e1:
	; return contador
	MOVE.W contador, D0
	RTS
main:
	; output "PRUEBA COMPLETA"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "TEST 1: Variables"
	LEA str1, A1
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
	; output "x+y= "
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; param_s x  
	; param_s y  
	; t21 = call suma
	MOVE.W x, n1
	MOVE.W y, n2
	JSR suma
	MOVE.W D0, t21
	; output t21
	MOVE.W t21, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "TEST 2: Condicionales"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t24 = x > y
	MOVE.W #0, t24
	MOVE.W x, D0
	CMP.W y, D0
	BGT t24_true
	JMP t24_false
t24_true:
	MOVE.W #1, t24
t24_false:
	; if !(t24) goto e6
	MOVE.W t24, D0
	CMP.W #0, D0
	BEQ e6
	; output "10>5: SI"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
e6:
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "TEST 3: While (1 a 3)"
	LEA str5, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; c = 1
	MOVE.W #1, c
e8:
	; t28 = c <= 3
	MOVE.W #0, t28
	MOVE.W c, D0
	CMP.W #3, D0
	BLE t28_true
	JMP t28_false
t28_true:
	MOVE.W #1, t28
t28_false:
	; if !(t28) goto e9
	MOVE.W t28, D0
	CMP.W #0, D0
	BEQ e9
	; output c
	MOVE.W c, D1
	JSR PRINT_SIGNED
	; output " "
	LEA str6, A1
	MOVE.B #14, D0
	TRAP #15
	; c = c + 1
	MOVE.W c, D0
	ADD.W #1, D0
	MOVE.W D0, c
	; goto e8
	JMP e8
e9:
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "TEST 4: Logica"
	LEA str7, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; a = true
	MOVE.W #1, a
	; b = false
	MOVE.W #0, b
	; t34 = a && a
	MOVE.W #0, t34
	MOVE.W a, D0
	CMP.W #0, D0
	BEQ t34_false
	MOVE.W a, D0
	CMP.W #0, D0
	BEQ t34_false
	MOVE.W #1, t34
t34_false:
	; if !(t34) goto e10
	MOVE.W t34, D0
	CMP.W #0, D0
	BEQ e10
	; output "AND: SI"
	LEA str8, A1
	MOVE.B #14, D0
	TRAP #15
e10:
	; t37 = a || b
	MOVE.W #0, t37
	MOVE.W a, D0
	CMP.W #0, D0
	BNE t37_true
	MOVE.W b, D0
	CMP.W #0, D0
	BNE t37_true
	JMP t37_false
t37_true:
	MOVE.W #1, t37
t37_false:
	; if !(t37) goto e12
	MOVE.W t37, D0
	CMP.W #0, D0
	BEQ e12
	; output "OR: SI"
	LEA str9, A1
	MOVE.B #14, D0
	TRAP #15
e12:
	; t38 = ! b
	MOVE.W b, D0
	CMP.W #0, D0
	BEQ t38_not_true
	MOVE.W #0, t38
	JMP t38_not_end
t38_not_true:
	MOVE.W #1, t38
t38_not_end:
	; if !(t38) goto e14
	MOVE.W t38, D0
	CMP.W #0, D0
	BEQ e14
	; output "NOT: SI"
	LEA str10, A1
	MOVE.B #14, D0
	TRAP #15
e14:
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "TEST 5: Pares(1-11)= "
	LEA str11, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; param_s 1  
	; param_s 11  
	; t41 = call contarPares
	MOVE.W #1, inicio
	MOVE.W #11, fin
	JSR contarPares
	MOVE.W D0, t41
	; pares = t41
	MOVE.W t41, pares
	; output pares
	MOVE.W pares, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "FIN"
	LEA str12, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
n1:	DS.W 1
n2:	DS.W 1
t8:	DS.W 1
inicio:	DS.W 1
fin:	DS.W 1
limite:	DS.W 1
str7:	DC.B 'TEST 4: Logica',0
str8:	DC.B 'AND: SI',0
str5:	DC.B 'TEST 3: While (1 a 3)',0
str6:	DC.B ' ',0
str3:	DC.B 'TEST 2: Condicionales',0
t34:	DS.W 1
contador:	DS.W 1
t11:	DS.W 1
str4:	DC.B '10>5: SI',0
t14:	DS.W 1
str1:	DC.B 'TEST 1: Variables',0
str2:	DC.B 'x+y= ',0
pares:	DS.W 1
t38:	DS.W 1
str12:	DC.B 'FIN',0
t37:	DS.W 1
str10:	DC.B 'NOT: SI',0
t17:	DS.W 1
str11:	DC.B 'TEST 5: Pares(1-11)= ',0
str9:	DC.B 'OR: SI',0
a:	DS.W 1
b:	DS.W 1
c:	DS.W 1
false:	DS.W 1
i:	DS.W 1
str0:	DC.B 'PRUEBA COMPLETA',0
residuo:	DS.W 1
t41:	DS.W 1
t21:	DS.W 1
t24:	DS.W 1
x:	DS.W 1
true:	DS.W 1
y:	DS.W 1
t28:	DS.W 1
t2:	DS.W 1

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
