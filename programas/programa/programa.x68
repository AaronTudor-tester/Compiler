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

PRINT_DECIMAL_2:
	MOVE.L D1, D3
	TST.L D3
	BPL .PD2_POSITIVE
	MOVE.B #14, D0
	LEA MINUS_SIGN, A1
	TRAP #15
	NEG.L D3
.PD2_POSITIVE:
	MOVE.L D3, D2
	MOVE.W #100, D4
	DIVS D4, D2
	MOVE.L D2, D5
	MOVE.W #100, D4
	MOVE.L D5, D6
	CLR.L D0
	MOVE.W D4, D0
	MULS D0, D6
	SUB.L D6, D3
	CLR.L D1
	MOVE.W D2, D1
	MOVE.B #3, D0
	TRAP #15
	LEA DECIMAL_POINT, A1
	MOVE.B #14, D0
	TRAP #15
	CLR.L D0
	MOVE.W D3, D0
	CMP.W #10, D0
	BGE .PD2_SKIP_ZERO
	LEA ZERO_CHAR, A1
	MOVE.B #14, D0
	TRAP #15
.PD2_SKIP_ZERO:
	CLR.L D1
	MOVE.W D3, D1
	MOVE.B #3, D0
	TRAP #15
	RTS

READ_NUM_VALID:
.RNV_RETRY:
	LEA INPUT_BUFFER, A1
	MOVE.B #2, D0
	TRAP #15
	LEA INPUT_BUFFER, A1
	CLR.W D2
	CLR.L D3
	CLR.L D4
	MOVE.B (A1), D5
	CMP.B #0, D5
	BEQ .RNV_ERR
	CMP.B #'-', D5
	BNE .RNV_CHK
	MOVE.W #1, D2
	ADDA.L #1, A1
.RNV_CHK:
.RNV_LOOP:
	MOVE.B (A1)+, D5
	CMP.B #0, D5
	BEQ .RNV_VALID
	CMP.B #10, D5
	BEQ .RNV_VALID
	CMP.B #13, D5
	BEQ .RNV_VALID
	CMP.B #'0', D5
	BLT .RNV_ERR
	CMP.B #'9', D5
	BGT .RNV_ERR
	ADD.L #1, D4
	SUB.B #'0', D5
	MOVE.L D3, D6
	MULS #10, D3
	EXT.W D5
	EXT.L D5
	ADD.L D5, D3
	BRA .RNV_LOOP
.RNV_VALID:
	TST.L D4
	BEQ .RNV_ERR
	MOVE.W D3, D1
	TST.W D2
	BEQ .RNV_END
	NEG.W D1
.RNV_END:
	RTS
.RNV_ERR:
	LEA ERROR_INPUT_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	BRA .RNV_RETRY

main:
	; t0 = 10.0
	MOVE.W #1000, t0
	; x = t0
	MOVE.W t0, x
	; t1 = 20
	MOVE.W #20, t1
	; y = t1
	MOVE.W t1, y
	; t2 = 5.5
	MOVE.W #550, t2
	; z = t2
	MOVE.W t2, z
	; t3 = 1
	MOVE.W #1, t3
	; i = t3
	MOVE.W t3, i
e0:
	; t4 = i
	MOVE.W i, t4
	; t5 = 5
	MOVE.W #5, t5
	; t6 = t4 <= t5
	MOVE.W #0, t6
	MOVE.W t4, D0
	CMP.W t5, D0
	BLE t6_true
	JMP t6_false
t6_true:
	MOVE.W #1, t6
t6_false:
	; if !(t6) goto e1
	MOVE.W t6, D0
	CMP.W #0, D0
	BEQ e1
	; output "ITERAMOS"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t7 = i
	MOVE.W i, t7
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e0
	JMP e0
e1:
	; t8 = 0
	MOVE.W #0, t8
	; crement = t8
	MOVE.W t8, crement
	; t9 = 1
	MOVE.W #1, t9
	; incr = t9
	MOVE.W t9, incr
	; incr = incr + 1
	MOVE.W incr, D0
	ADD.W #1, D0
	MOVE.W D0, incr
	; crement = incr
	MOVE.W incr, crement
	; t10 = incr
	MOVE.W incr, t10
	; incr = incr + 1
	MOVE.W incr, D0
	ADD.W #1, D0
	MOVE.W D0, incr
	; crement = t10
	MOVE.W t10, crement
	; t11 = crement
	MOVE.W crement, t11
	; output t11
	MOVE.W t11, D1
	JSR PRINT_SIGNED
	; t12 = x
	MOVE.W x, t12
	; x = x + 1.0
	MOVE.W x, D0
	ADD.W #100, D0
	MOVE.W D0, x
	; t13 = 5.0
	MOVE.W #500, t13
	; t14 = t12 + t13
	MOVE.W t12, D0
	ADD.W t13, D0
	MOVE.W D0, t14
	; asignaIncremento = t14
	MOVE.W t14, asignaIncremento
	; t15 = asignaIncremento
	MOVE.W asignaIncremento, t15
	; t16 = 0.5
	MOVE.W #50, t16
	; t17 = t15 + t16
	MOVE.W t15, D0
	ADD.W t16, D0
	MOVE.W D0, t17
	; asignaIncremento = asignaIncremento + 1.0
	MOVE.W asignaIncremento, D0
	ADD.W #100, D0
	MOVE.W D0, asignaIncremento
	; t18 = t17 < asignaIncremento
	MOVE.W #0, t18
	MOVE.W t17, D0
	CMP.W asignaIncremento, D0
	BLT t18_true
	JMP t18_false
t18_true:
	MOVE.W #1, t18
t18_false:
	; if !(t18) goto e2
	MOVE.W t18, D0
	CMP.W #0, D0
	BEQ e2
	; output "incrementado"
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
e3:
	; t19 = 3
	MOVE.W #3, t19
	; t20 = 10
	MOVE.W #10, t20
	; t21 = t19 + t20
	MOVE.W t19, D0
	ADD.W t20, D0
	MOVE.W D0, t21
	; t22 = y
	MOVE.W y, t22
	; t23 = t21 - t22
	MOVE.W t21, D0
	SUB.W t22, D0
	MOVE.W D0, t23
	; a = t23
	MOVE.W t23, a
	; t24 = a
	MOVE.W a, t24
	; output t24
	MOVE.W t24, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t25 = 10
	MOVE.W #10, t25
	; t26 = y
	MOVE.W y, t26
	; t27 = t25 * t26
	MOVE.W t25, D0
	MULS t26, D0
	MOVE.W D0, t27
	; w = t27
	MOVE.W t27, w
	; t28 = z
	MOVE.W z, t28
	; t29 = 1.5
	MOVE.W #150, t29
	; t30 = t28 + t29
	MOVE.W t28, D0
	ADD.W t29, D0
	MOVE.W D0, t30
	; output t30
	CLR.L D1
	MOVE.W t30, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; hola2 = "Hola mundo"
	LEA str2, A0
	MOVE.L A0, hola2
	; t31 = hola2
	MOVE.L hola2, t31
	; output t31
	MOVEA.L t31, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; input edad
	JSR READ_NUM_VALID
	MOVE.W D1, edad
	; t32 = edad
	MOVE.W edad, t32
	; t33 = 17
	MOVE.W #17, t33
	; t34 = t32 > t33
	MOVE.W #0, t34
	MOVE.W t32, D0
	CMP.W t33, D0
	BGT t34_true
	JMP t34_false
t34_true:
	MOVE.W #1, t34
t34_false:
	; if !(t34) goto e4
	MOVE.W t34, D0
	CMP.W #0, D0
	BEQ e4
	; output "Eres mayor de edad"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e5
	JMP e5
e4:
	; output "Eres menor de edad"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e5:
	; t35 = 0
	MOVE.W #0, t35
	; j = t35
	MOVE.W t35, j
e6:
	; t36 = j
	MOVE.W j, t36
	; t37 = 5
	MOVE.W #5, t37
	; t38 = t36 <= t37
	MOVE.W #0, t38
	MOVE.W t36, D0
	CMP.W t37, D0
	BLE t38_true
	JMP t38_false
t38_true:
	MOVE.W #1, t38
t38_false:
	; if !(t38) goto e7
	MOVE.W t38, D0
	CMP.W #0, D0
	BEQ e7
	; t39 = j
	MOVE.W j, t39
	; output t39
	MOVE.W t39, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; j = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, j
	; goto e6
	JMP e6
e7:
	; t40 = 5
	MOVE.W #5, t40
	; n = t40
	MOVE.W t40, n
e8:
	; t41 = n
	MOVE.W n, t41
	; output t41
	MOVE.W t41, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; n = n - 1
	MOVE.W n, D0
	SUB.W #1, D0
	MOVE.W D0, n
	; t42 = n
	MOVE.W n, t42
	; t43 = 0
	MOVE.W #0, t43
	; t44 = t42 != t43
	MOVE.W #0, t44
	MOVE.W t42, D0
	CMP.W t43, D0
	BNE t44_true
	JMP t44_false
t44_true:
	MOVE.W #1, t44
t44_false:
	; if t44 goto e8
	MOVE.W t44, D0
	CMP.W #0, D0
	BNE e8
e9:
	; t45 = 2
	MOVE.W #2, t45
	; opcion = t45
	MOVE.W t45, opcion
	; t46 = opcion
	MOVE.W opcion, t46
	; t47 = 1
	MOVE.W #1, t47
	; if t46 != t47 goto e11
	MOVE.W t46, D0
	CMP.W t47, D0
	BNE e11
	; output "uno"
	LEA str5, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e10
	JMP e10
e11:
	; t48 = 2
	MOVE.W #2, t48
	; if t46 != t48 goto e12
	MOVE.W t46, D0
	CMP.W t48, D0
	BNE e12
	; output "dos"
	LEA str6, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e10
	JMP e10
e12:
	; t49 = 3
	MOVE.W #3, t49
	; if t46 != t49 goto e13
	MOVE.W t46, D0
	CMP.W t49, D0
	BNE e13
	; output "tres"
	LEA str7, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e10
	JMP e10
e13:
	; output "Opción no válida"
	LEA str8, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e10:
	; t50 = 0
	MOVE.W #0, t50
	; i = t50
	MOVE.W t50, i
e14:
	; t51 = i
	MOVE.W i, t51
	; t52 = 5
	MOVE.W #5, t52
	; t53 = t51 < t52
	MOVE.W #0, t53
	MOVE.W t51, D0
	CMP.W t52, D0
	BLT t53_true
	JMP t53_false
t53_true:
	MOVE.W #1, t53
t53_false:
	; if !(t53) goto e15
	MOVE.W t53, D0
	CMP.W #0, D0
	BEQ e15
	; t54 = 1
	MOVE.W #1, t54
	; pruebaaaa = t54
	MOVE.W t54, pruebaaaa
	; t55 = i
	MOVE.W i, t55
	; i = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, i
	; goto e14
	JMP e14
e15:
	; t56 = true
	MOVE.W #1, t56
	; llueve = t56
	MOVE.W t56, llueve
	; t57 = false
	MOVE.W #0, t57
	; paraguas = t57
	MOVE.W t57, paraguas
	; t58 = llueve
	MOVE.W llueve, t58
	; t59 = ! paraguas
	MOVE.W paraguas, D0
	CMP.W #0, D0
	BEQ t59_not_true
	MOVE.W #0, t59
	JMP t59_not_end
t59_not_true:
	MOVE.W #1, t59
t59_not_end:
	; t60 = t58 && t59
	MOVE.W #0, t60
	MOVE.W t58, D0
	CMP.W #0, D0
	BEQ t60_false
	MOVE.W t59, D0
	CMP.W #0, D0
	BEQ t60_false
	MOVE.W #1, t60
t60_false:
	; if !(t60) goto e16
	MOVE.W t60, D0
	CMP.W #0, D0
	BEQ e16
	; output "Me voy a mojar"
	LEA str9, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e17
	JMP e17
e16:
	; output "Todo bien"
	LEA str10, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
e17:
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
ERROR_INPUT_MSG:	DC.B 'ERROR: Entrada invalida. Ingrese un numero valido: ',0
INPUT_BUFFER:	DS.B 80
HEAP_PTR:	DC.L $8000
pruebaaaa:	DS.W 1
t50:	DS.W 1
str7:	DC.B 'tres',0
t52:	DS.W 1
str8:	DC.B 'Opción no válida',0
t51:	DS.W 1
t10:	DS.W 1
str5:	DC.B 'uno',0
t54:	DS.W 1
str6:	DC.B 'dos',0
t53:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'Eres mayor de edad',0
t56:	DS.W 1
t11:	DS.W 1
str4:	DC.B 'Eres menor de edad',0
t55:	DS.W 1
t14:	DS.W 1
str1:	DC.B 'incrementado',0
t58:	DS.W 1
t13:	DS.W 1
str2:	DC.B 'Hola mundo',0
t57:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t59:	DS.W 1
t18:	DS.W 1
str10:	DC.B 'Todo bien',0
t17:	DS.W 1
hola2:	DS.L 1
t19:	DS.W 1
str9:	DC.B 'Me voy a mojar',0
str0:	DC.B 'ITERAMOS',0
edad:	DS.W 1
t60:	DS.W 1
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
asignaIncremento:	DS.W 1
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
paraguas:	DS.W 1
t32:	DS.W 1
t31:	DS.L 1
t34:	DS.W 1
t33:	DS.W 1
t36:	DS.W 1
t35:	DS.W 1
t38:	DS.W 1
t37:	DS.W 1
t39:	DS.W 1
a:	DS.W 1
opcion:	DS.W 1
incr:	DS.W 1
crement:	DS.W 1
false:	DS.W 1
i:	DS.W 1
j:	DS.W 1
n:	DS.W 1
t41:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t42:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1
t47:	DS.W 1
w:	DS.W 1
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
