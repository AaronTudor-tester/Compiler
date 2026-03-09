	ORG $1000
START:
	LEA STACKPTR, A7
	; t0 = 0
	MOVE.W #0, t0
	; contador = t0
	MOVE.W t0, contador
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
	; t1 = a
	MOVE.W a, t1
	; t2 = b
	MOVE.W b, t2
	; t3 = t1 + t2
	MOVE.W t1, D0
	ADD.W t2, D0
	MOVE.W D0, t3
	; resultado = t3
	MOVE.W t3, resultado
	; t4 = resultado
	MOVE.W resultado, t4
	; return t4
	MOVE.W t4, D0
	RTS
prueba:
	; ; param a : INT
	; ; param b : INT
	; ; param c : INT
	; t5 = a
	MOVE.W a, t5
	; t6 = 20
	MOVE.W #20, t6
	; t7 = t5 < t6
	MOVE.W #0, t7
	MOVE.W t5, D0
	CMP.W t6, D0
	BLT t7_true
	JMP t7_false
t7_true:
	MOVE.W #1, t7
t7_false:
	; if !(t7) goto e0
	MOVE.W t7, D0
	CMP.W #0, D0
	BEQ e0
	; t8 = a
	MOVE.W a, t8
	; output t8
	MOVE.W t8, D1
	JSR PRINT_SIGNED
	; t9 = a
	MOVE.W a, t9
	; t10 = 2
	MOVE.W #2, t10
	; t11 = t9 + t10
	MOVE.W t9, D0
	ADD.W t10, D0
	MOVE.W D0, t11
	; param_s t11  
	; param_s b  
	; param_s c  
	; t12 = call prueba
	MOVE.W t11, a
	MOVE.W b, b
	MOVE.W c, c
	JSR prueba
	MOVE.W D0, t12
	; return t12
	MOVE.W t12, D0
	RTS
	; goto e1
	JMP e1
e0:
e1:
	; output "fin"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; t13 = 555
	MOVE.W #555, t13
	; return t13
	MOVE.W t13, D0
	RTS
main:
	; t14 = 15
	MOVE.W #15, t14
	; t15 = NEG t14
	MOVE.W t14, D0
	NEG.W D0
	MOVE.W D0, t15
	; x = t15
	MOVE.W t15, x
	; t16 = NEG x
	MOVE.W x, D0
	NEG.W D0
	MOVE.W D0, t16
	; z = t16
	MOVE.W t16, z
	; t17 = 20
	MOVE.W #20, t17
	; y = t17
	MOVE.W t17, y
	; t18 = 5
	MOVE.W #5, t18
	; t19 = z
	MOVE.W z, t19
	; t20 = 10
	MOVE.W #10, t20
	; t21 = t19 - t20
	MOVE.W t19, D0
	SUB.W t20, D0
	MOVE.W D0, t21
	; t22 = t18 + t21
	MOVE.W t18, D0
	ADD.W t21, D0
	MOVE.W D0, t22
	; l = t22
	MOVE.W t22, l
	; t23 = true
	MOVE.W #1, t23
	; llueve = t23
	MOVE.W t23, llueve
	; t24 = ! llueve
	MOVE.W llueve, D0
	CMP.W #0, D0
	BEQ t24_not_true
	MOVE.W #0, t24
	JMP t24_not_end
t24_not_true:
	MOVE.W #1, t24
t24_not_end:
	; noLlueve = t24
	MOVE.W t24, noLlueve
	; t25 = 5
	MOVE.W #5, t25
	; t26 = 16
	MOVE.W #16, t26
	; t27 = t25 + t26
	MOVE.W t25, D0
	ADD.W t26, D0
	MOVE.W D0, t27
	; t28 = NEG t27
	MOVE.W t27, D0
	NEG.W D0
	MOVE.W D0, t28
	; l = t28
	MOVE.W t28, l
	; param_s x  
	; param_s y  
	; t29 = call suma
	MOVE.W x, a
	MOVE.W y, b
	JSR suma
	MOVE.W D0, t29
	; total = t29
	MOVE.W t29, total
	; t30 = 7
	MOVE.W #7, t30
	; t31 = 3
	MOVE.W #3, t31
	; t32 = 1
	MOVE.W #1, t32
	; t33 = t31 + t32
	MOVE.W t31, D0
	ADD.W t32, D0
	MOVE.W D0, t33
	; param_s t30  
	; param_s t33  
	; t34 = call suma
	MOVE.W t30, a
	MOVE.W t33, b
	JSR suma
	MOVE.W D0, t34
	; total2 = t34
	MOVE.W t34, total2
	; t35 = 2
	MOVE.W #2, t35
	; t36 = 3
	MOVE.W #3, t36
	; param_s t35  
	; param_s t36  
	; t37 = call suma
	MOVE.W t35, a
	MOVE.W t36, b
	JSR suma
	MOVE.W D0, t37
	; t38 = total
	MOVE.W total, t38
	; output t38
	MOVE.W t38, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t39 = total
	MOVE.W total, t39
	; t40 = 25
	MOVE.W #25, t40
	; t41 = t39 > t40
	MOVE.W #0, t41
	MOVE.W t39, D0
	CMP.W t40, D0
	BGT t41_true
	JMP t41_false
t41_true:
	MOVE.W #1, t41
t41_false:
	; if !(t41) goto e2
	MOVE.W t41, D0
	CMP.W #0, D0
	BEQ e2
	; output "El numero es grande"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e3
	JMP e3
e2:
	; output "El numero es pequeno"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e3:
e4:
	; t42 = contador
	MOVE.W contador, t42
	; t43 = 3
	MOVE.W #3, t43
	; t44 = t42 < t43
	MOVE.W #0, t44
	MOVE.W t42, D0
	CMP.W t43, D0
	BLT t44_true
	JMP t44_false
t44_true:
	MOVE.W #1, t44
t44_false:
	; if !(t44) goto e5
	MOVE.W t44, D0
	CMP.W #0, D0
	BEQ e5
	; contador = contador + 1
	MOVE.W contador, D0
	ADD.W #1, D0
	MOVE.W D0, contador
	; output "Contando..."
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t45 = contador
	MOVE.W contador, t45
	; t46 = 2
	MOVE.W #2, t46
	; t47 = t45 > t46
	MOVE.W #0, t47
	MOVE.W t45, D0
	CMP.W t46, D0
	BGT t47_true
	JMP t47_false
t47_true:
	MOVE.W #1, t47
t47_false:
	; if !(t47) goto e6
	MOVE.W t47, D0
	CMP.W #0, D0
	BEQ e6
	; t48 = contador
	MOVE.W contador, t48
	; t49 = 2
	MOVE.W #2, t49
	; t50 = t48 == t49
	MOVE.W #0, t50
	MOVE.W t48, D0
	CMP.W t49, D0
	BEQ t50_true
	JMP t50_false
t50_true:
	MOVE.W #1, t50
t50_false:
	; if !(t50) goto e8
	MOVE.W t50, D0
	CMP.W #0, D0
	BEQ e8
	; t51 = contador
	MOVE.W contador, t51
	; pruebaBlques = t51
	MOVE.W t51, pruebaBlques
	; goto e9
	JMP e9
e8:
e9:
	; goto e7
	JMP e7
e6:
e7:
	; goto e4
	JMP e4
e5:
	; t52 = 1
	MOVE.W #1, t52
	; t53 = 2
	MOVE.W #2, t53
	; t54 = 3
	MOVE.W #3, t54
	; param_s t52  
	; param_s t53  
	; param_s t54  
	; t55 = call prueba
	MOVE.W t52, a
	MOVE.W t53, b
	MOVE.W t54, c
	JSR prueba
	MOVE.W D0, t55
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
noLlueve:	DS.W 1
t50:	DS.W 1
t52:	DS.W 1
t51:	DS.W 1
t10:	DS.W 1
t54:	DS.W 1
t53:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'Contando...',0
t11:	DS.W 1
t55:	DS.W 1
t14:	DS.W 1
str1:	DC.B 'El numero es grande',0
t13:	DS.W 1
str2:	DC.B 'El numero es pequeno',0
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
pruebaBlques:	DS.W 1
t19:	DS.W 1
str0:	DC.B 'fin',0
total2:	DS.W 1
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.W 1
t24:	DS.W 1
true:	DS.W 1
t27:	DS.W 1
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
llueve:	DS.W 1
t30:	DS.W 1
total:	DS.W 1
t32:	DS.W 1
t31:	DS.W 1
t34:	DS.W 1
contador:	DS.W 1
t33:	DS.W 1
t36:	DS.W 1
t35:	DS.W 1
t38:	DS.W 1
t37:	DS.W 1
t39:	DS.W 1
a:	DS.W 1
b:	DS.W 1
c:	DS.W 1
resultado:	DS.W 1
l:	DS.W 1
t41:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t42:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1
t47:	DS.W 1
t46:	DS.W 1
x:	DS.W 1
t49:	DS.W 1
y:	DS.W 1
t48:	DS.W 1
z:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
