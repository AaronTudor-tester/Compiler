	ORG $1000
START:
	LEA STACKPTR, A7
	; contador = 0
	MOVE.W #0, contador
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
	; t3 = a + b
	MOVE.W a, D0
	ADD.W b, D0
	MOVE.W D0, t3
	; resultado = t3
	MOVE.W t3, resultado
	; return resultado
	MOVE.W resultado, D0
	RTS
prueba:
	; ; param a : INT
	; ; param b : INT
	; ; param c : INT
	; t7 = a < 20
	MOVE.W #0, t7
	MOVE.W a, D0
	CMP.W #20, D0
	BLT t7_true
	JMP t7_false
t7_true:
	MOVE.W #1, t7
t7_false:
	; if !(t7) goto e0
	MOVE.W t7, D0
	CMP.W #0, D0
	BEQ e0
	; output a
	MOVE.W a, D1
	JSR PRINT_SIGNED
	; t11 = a + 2
	MOVE.W a, D0
	ADD.W #2, D0
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
e0:
	; output "fin"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; return 555
	MOVE.W #555, D0
	RTS
main:
	; t15 = NEG 15
	MOVE.W #15, D0
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
	; y = 20
	MOVE.W #20, y
	; t21 = z - 10
	MOVE.W z, D0
	SUB.W #10, D0
	MOVE.W D0, t21
	; t22 = 5 + t21
	MOVE.W #5, D0
	ADD.W t21, D0
	MOVE.W D0, t22
	; llueve = true
	MOVE.W #1, llueve
	; t24 = ! llueve
	MOVE.W llueve, D0
	CMP.W #0, D0
	BEQ t24_not_true
	MOVE.W #0, t24
	JMP t24_not_end
t24_not_true:
	MOVE.W #1, t24
t24_not_end:
	; t28 = NEG 21
	MOVE.W #21, D0
	NEG.W D0
	MOVE.W D0, t28
	; param_s x  
	; param_s y  
	; t29 = call suma
	MOVE.W x, a
	MOVE.W y, b
	JSR suma
	MOVE.W D0, t29
	; total = t29
	MOVE.W t29, total
	; param_s 7  
	; param_s 4  
	; param_s 2  
	; param_s 3  
	; output total
	MOVE.W total, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t41 = total > 25
	MOVE.W #0, t41
	MOVE.W total, D0
	CMP.W #25, D0
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
	; t44 = contador < 3
	MOVE.W #0, t44
	MOVE.W contador, D0
	CMP.W #3, D0
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
	; t47 = contador > 2
	MOVE.W #0, t47
	MOVE.W contador, D0
	CMP.W #2, D0
	BGT t47_true
	JMP t47_false
t47_true:
	MOVE.W #1, t47
t47_false:
	; if !(t47) goto e4
	MOVE.W t47, D0
	CMP.W #0, D0
	BEQ e4
	; t50 = contador == 2
	MOVE.W #0, t50
	MOVE.W contador, D0
	CMP.W #2, D0
	BEQ t50_true
	JMP t50_false
t50_true:
	MOVE.W #1, t50
t50_false:
	; goto e4
	JMP e4
e5:
	; param_s 1  
	; param_s 2  
	; param_s 3  
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
t7:	DS.W 1
llueve:	DS.W 1
t50:	DS.W 1
total:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'Contando...',0
contador:	DS.W 1
t11:	DS.W 1
str1:	DC.B 'El numero es grande',0
str2:	DC.B 'El numero es pequeno',0
t16:	DS.W 1
t15:	DS.W 1
a:	DS.W 1
b:	DS.W 1
c:	DS.W 1
resultado:	DS.W 1
str0:	DC.B 'fin',0
t41:	DS.W 1
t21:	DS.W 1
t22:	DS.W 1
t44:	DS.W 1
t47:	DS.W 1
t24:	DS.W 1
x:	DS.W 1
true:	DS.W 1
y:	DS.W 1
z:	DS.W 1
t29:	DS.W 1
t28:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
