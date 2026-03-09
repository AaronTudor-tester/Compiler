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
	; t0 = n1
	MOVE.W n1, t0
	; t1 = n2
	MOVE.W n2, t1
	; t2 = t0 + t1
	MOVE.W t0, D0
	ADD.W t1, D0
	MOVE.W D0, t2
	; return t2
	MOVE.W t2, D0
	RTS
contarPares:
	; ; param inicio : INT
	; ; param fin : INT
	; t3 = 0
	MOVE.W #0, t3
	; contador = t3
	MOVE.W t3, contador
	; t4 = inicio
	MOVE.W inicio, t4
	; i = t4
	MOVE.W t4, i
	; t5 = fin
	MOVE.W fin, t5
	; limite = t5
	MOVE.W t5, limite
e0:
	; t6 = i
	MOVE.W i, t6
	; t7 = limite
	MOVE.W limite, t7
	; t8 = t6 < t7
	MOVE.W #0, t8
	MOVE.W t6, D0
	CMP.W t7, D0
	BLT t8_true
	JMP t8_false
t8_true:
	MOVE.W #1, t8
t8_false:
	; if !(t8) goto e1
	MOVE.W t8, D0
	CMP.W #0, D0
	BEQ e1
	; t9 = i
	MOVE.W i, t9
	; t10 = 0
	MOVE.W #0, t10
	; t11 = t9 != t10
	MOVE.W #0, t11
	MOVE.W t9, D0
	CMP.W t10, D0
	BNE t11_true
	JMP t11_false
t11_true:
	MOVE.W #1, t11
t11_false:
	; if !(t11) goto e2
	MOVE.W t11, D0
	CMP.W #0, D0
	BEQ e2
	; t12 = i
	MOVE.W i, t12
	; t13 = 2
	MOVE.W #2, t13
	; t14 = t12 % t13
	MOVE.W t12, D0
	MOVE.W t13, D1
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
	; t15 = residuo
	MOVE.W residuo, t15
	; t16 = 0
	MOVE.W #0, t16
	; t17 = t15 == t16
	MOVE.W #0, t17
	MOVE.W t15, D0
	CMP.W t16, D0
	BEQ t17_true
	JMP t17_false
t17_true:
	MOVE.W #1, t17
t17_false:
	; if !(t17) goto e4
	MOVE.W t17, D0
	CMP.W #0, D0
	BEQ e4
	; contador = contador + 1
	MOVE.W contador, D0
	ADD.W #1, D0
	MOVE.W D0, contador
	; goto e5
	JMP e5
e4:
e5:
	; goto e3
	JMP e3
e2:
e3:
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e0
	JMP e0
e1:
	; t18 = contador
	MOVE.W contador, t18
	; return t18
	MOVE.W t18, D0
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
	; t19 = 10
	MOVE.W #10, t19
	; x = t19
	MOVE.W t19, x
	; t20 = 5
	MOVE.W #5, t20
	; y = t20
	MOVE.W t20, y
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
	; t22 = x
	MOVE.W x, t22
	; t23 = y
	MOVE.W y, t23
	; t24 = t22 > t23
	MOVE.W #0, t24
	MOVE.W t22, D0
	CMP.W t23, D0
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
	; goto e7
	JMP e7
e6:
e7:
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
	; t25 = 1
	MOVE.W #1, t25
	; c = t25
	MOVE.W t25, c
e8:
	; t26 = c
	MOVE.W c, t26
	; t27 = 3
	MOVE.W #3, t27
	; t28 = t26 <= t27
	MOVE.W #0, t28
	MOVE.W t26, D0
	CMP.W t27, D0
	BLE t28_true
	JMP t28_false
t28_true:
	MOVE.W #1, t28
t28_false:
	; if !(t28) goto e9
	MOVE.W t28, D0
	CMP.W #0, D0
	BEQ e9
	; t29 = c
	MOVE.W c, t29
	; output t29
	MOVE.W t29, D1
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
	; t30 = true
	MOVE.W #1, t30
	; a = t30
	MOVE.W t30, a
	; t31 = false
	MOVE.W #0, t31
	; b = t31
	MOVE.W t31, b
	; t32 = a
	MOVE.W a, t32
	; t33 = a
	MOVE.W a, t33
	; t34 = t32 && t33
	MOVE.W #0, t34
	MOVE.W t32, D0
	CMP.W #0, D0
	BEQ t34_false
	MOVE.W t33, D0
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
	; goto e11
	JMP e11
e10:
e11:
	; t35 = a
	MOVE.W a, t35
	; t36 = b
	MOVE.W b, t36
	; t37 = t35 || t36
	MOVE.W #0, t37
	MOVE.W t35, D0
	CMP.W #0, D0
	BNE t37_true
	MOVE.W t36, D0
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
	; goto e13
	JMP e13
e12:
e13:
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
	; goto e15
	JMP e15
e14:
e15:
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
	; t39 = 1
	MOVE.W #1, t39
	; t40 = 11
	MOVE.W #11, t40
	; param_s t39  
	; param_s t40  
	; t41 = call contarPares
	MOVE.W t39, inicio
	MOVE.W t40, fin
	JSR contarPares
	MOVE.W D0, t41
	; pares = t41
	MOVE.W t41, pares
	; t42 = pares
	MOVE.W pares, t42
	; output t42
	MOVE.W t42, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "FIN"
	LEA str12, A1
	MOVE.B #14, D0
	TRAP #15
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
n1:	DS.W 1
n2:	DS.W 1
inicio:	DS.W 1
fin:	DS.W 1
str7:	DC.B 'TEST 4: Logica',0
str8:	DC.B 'AND: SI',0
t10:	DS.W 1
str5:	DC.B 'TEST 3: While (1 a 3)',0
str6:	DC.B ' ',0
t12:	DS.W 1
str3:	DC.B 'TEST 2: Condicionales',0
t11:	DS.W 1
str4:	DC.B '10>5: SI',0
t14:	DS.W 1
str1:	DC.B 'TEST 1: Variables',0
t13:	DS.W 1
str2:	DC.B 'x+y= ',0
t16:	DS.W 1
str12:	DC.B 'FIN',0
t15:	DS.W 1
t18:	DS.W 1
str10:	DC.B 'NOT: SI',0
t17:	DS.W 1
str11:	DC.B 'TEST 5: Pares(1-11)= ',0
t19:	DS.W 1
str9:	DC.B 'OR: SI',0
str0:	DC.B 'PRUEBA COMPLETA',0
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.W 1
t24:	DS.W 1
t27:	DS.W 1
true:	DS.W 1
t26:	DS.W 1
t29:	DS.W 1
t28:	DS.W 1
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
limite:	DS.W 1
t30:	DS.W 1
t32:	DS.W 1
t31:	DS.W 1
t34:	DS.W 1
contador:	DS.W 1
t33:	DS.W 1
t36:	DS.W 1
t35:	DS.W 1
pares:	DS.W 1
t38:	DS.W 1
t37:	DS.W 1
t39:	DS.W 1
a:	DS.W 1
b:	DS.W 1
c:	DS.W 1
false:	DS.W 1
i:	DS.W 1
residuo:	DS.W 1
t41:	DS.W 1
t40:	DS.W 1
t42:	DS.W 1
x:	DS.W 1
y:	DS.W 1

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
