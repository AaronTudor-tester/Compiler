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
	; output "=== TEST: Array 2D completo ==="
	LEA str0, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t0 = 1
	MOVE.W #1, t0
	; t1 = 2
	MOVE.W #2, t1
	; t2 = t0 * t1
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t0, D0
	MULS t1, D0
	MOVE.W D0, t2
	; t3 = 2
	MOVE.W #2, t3
	; t4 = t2 * t3
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t2, D0
	MULS t3, D0
	MOVE.W D0, t4
	; t5 = 4
	MOVE.W #4, t5
	; t6 = t4 * t5
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t4, D0
	MULS t5, D0
	MOVE.W D0, t6
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, matriz
	CLR.L D1
	MOVE.W t6, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	; output "Inicializando matriz 2x2:"
	LEA str1, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t7 = 0
	MOVE.W #0, t7
	; t8 = 0
	MOVE.W #0, t8
	; t9 = 2
	MOVE.W #2, t9
	; t10 = t7 * t9
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t7, D0
	MULS t9, D0
	MOVE.W D0, t10
	; t11 = t10 + t8
	MOVE.W t10, D0
	ADD.W t8, D0
	MOVE.W D0, t11
	; t12 = 4
	MOVE.W #4, t12
	; t13 = t11 * t12
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t11, D0
	MULS t12, D0
	MOVE.W D0, t13
	; t14 = 1
	MOVE.W #1, t14
	; matriz[t13] = t14
	MOVEA.L matriz, A0
	CLR.L D0
	MOVE.W t13, D0
	CLR.L D1
	MOVE.W t14, D1
	MOVE.L D1, 0(A0, D0.L)
	; t15 = 0
	MOVE.W #0, t15
	; t16 = 1
	MOVE.W #1, t16
	; t17 = 2
	MOVE.W #2, t17
	; t18 = t15 * t17
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t15, D0
	MULS t17, D0
	MOVE.W D0, t18
	; t19 = t18 + t16
	MOVE.W t18, D0
	ADD.W t16, D0
	MOVE.W D0, t19
	; t20 = 4
	MOVE.W #4, t20
	; t21 = t19 * t20
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t19, D0
	MULS t20, D0
	MOVE.W D0, t21
	; t22 = 2
	MOVE.W #2, t22
	; matriz[t21] = t22
	MOVEA.L matriz, A0
	CLR.L D0
	MOVE.W t21, D0
	CLR.L D1
	MOVE.W t22, D1
	MOVE.L D1, 0(A0, D0.L)
	; t23 = 1
	MOVE.W #1, t23
	; t24 = 0
	MOVE.W #0, t24
	; t25 = 2
	MOVE.W #2, t25
	; t26 = t23 * t25
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t23, D0
	MULS t25, D0
	MOVE.W D0, t26
	; t27 = t26 + t24
	MOVE.W t26, D0
	ADD.W t24, D0
	MOVE.W D0, t27
	; t28 = 4
	MOVE.W #4, t28
	; t29 = t27 * t28
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t27, D0
	MULS t28, D0
	MOVE.W D0, t29
	; t30 = 3
	MOVE.W #3, t30
	; matriz[t29] = t30
	MOVEA.L matriz, A0
	CLR.L D0
	MOVE.W t29, D0
	CLR.L D1
	MOVE.W t30, D1
	MOVE.L D1, 0(A0, D0.L)
	; t31 = 1
	MOVE.W #1, t31
	; t32 = 1
	MOVE.W #1, t32
	; t33 = 2
	MOVE.W #2, t33
	; t34 = t31 * t33
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t31, D0
	MULS t33, D0
	MOVE.W D0, t34
	; t35 = t34 + t32
	MOVE.W t34, D0
	ADD.W t32, D0
	MOVE.W D0, t35
	; t36 = 4
	MOVE.W #4, t36
	; t37 = t35 * t36
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t35, D0
	MULS t36, D0
	MOVE.W D0, t37
	; t38 = 4
	MOVE.W #4, t38
	; matriz[t37] = t38
	MOVEA.L matriz, A0
	CLR.L D0
	MOVE.W t37, D0
	CLR.L D1
	MOVE.W t38, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Leyendo matriz con bucle:"
	LEA str2, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t39 = 0
	MOVE.W #0, t39
	; i = t39
	MOVE.W t39, i
e0:
	; t40 = i
	MOVE.W i, t40
	; t41 = 2
	MOVE.W #2, t41
	; t42 = t40 < t41
	MOVE.W #0, t42
	MOVE.W t40, D0
	CMP.W t41, D0
	BLT t42_true
	JMP t42_false
t42_true:
	MOVE.W #1, t42
t42_false:
	; if !(t42) goto e1
	MOVE.W t42, D0
	CMP.W #0, D0
	BEQ e1
	; t43 = 0
	MOVE.W #0, t43
	; j = t43
	MOVE.W t43, j
e2:
	; t44 = j
	MOVE.W j, t44
	; t45 = 2
	MOVE.W #2, t45
	; t46 = t44 < t45
	MOVE.W #0, t46
	MOVE.W t44, D0
	CMP.W t45, D0
	BLT t46_true
	JMP t46_false
t46_true:
	MOVE.W #1, t46
t46_false:
	; if !(t46) goto e3
	MOVE.W t46, D0
	CMP.W #0, D0
	BEQ e3
	; t47 = i
	MOVE.W i, t47
	; t48 = j
	MOVE.W j, t48
	; t49 = 2
	MOVE.W #2, t49
	; t50 = t47 * t49
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t47, D0
	MULS t49, D0
	MOVE.W D0, t50
	; t51 = t50 + t48
	MOVE.W t50, D0
	ADD.W t48, D0
	MOVE.W D0, t51
	; t52 = 4
	MOVE.W #4, t52
	; t53 = t51 * t52
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t51, D0
	MULS t52, D0
	MOVE.W D0, t53
	; t54 = matriz[t53]
	MOVEA.L matriz, A0
	CLR.L D0
	MOVE.W t53, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t54
	; valor = t54
	MOVE.W t54, valor
	; t55 = valor
	MOVE.W valor, t55
	; output t55
	MOVE.W t55, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t56 = j
	MOVE.W j, t56
	; t57 = 1
	MOVE.W #1, t57
	; t58 = t56 + t57
	MOVE.W t56, D0
	ADD.W t57, D0
	MOVE.W D0, t58
	; j = t58
	MOVE.W t58, j
	; goto e2
	JMP e2
e3:
	; t59 = i
	MOVE.W i, t59
	; t60 = 1
	MOVE.W #1, t60
	; t61 = t59 + t60
	MOVE.W t59, D0
	ADD.W t60, D0
	MOVE.W D0, t61
	; i = t61
	MOVE.W t61, i
	; goto e0
	JMP e0
e1:
	; output "Operacion: matriz[0,0] + matriz[1,1]:"
	LEA str3, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t62 = 0
	MOVE.W #0, t62
	; t63 = 0
	MOVE.W #0, t63
	; t64 = 2
	MOVE.W #2, t64
	; t65 = t62 * t64
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t62, D0
	MULS t64, D0
	MOVE.W D0, t65
	; t66 = t65 + t63
	MOVE.W t65, D0
	ADD.W t63, D0
	MOVE.W D0, t66
	; t67 = 4
	MOVE.W #4, t67
	; t68 = t66 * t67
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t66, D0
	MULS t67, D0
	MOVE.W D0, t68
	; t69 = matriz[t68]
	MOVEA.L matriz, A0
	CLR.L D0
	MOVE.W t68, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t69
	; a = t69
	MOVE.W t69, a
	; t70 = 1
	MOVE.W #1, t70
	; t71 = 1
	MOVE.W #1, t71
	; t72 = 2
	MOVE.W #2, t72
	; t73 = t70 * t72
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t70, D0
	MULS t72, D0
	MOVE.W D0, t73
	; t74 = t73 + t71
	MOVE.W t73, D0
	ADD.W t71, D0
	MOVE.W D0, t74
	; t75 = 4
	MOVE.W #4, t75
	; t76 = t74 * t75
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t74, D0
	MULS t75, D0
	MOVE.W D0, t76
	; t77 = matriz[t76]
	MOVEA.L matriz, A0
	CLR.L D0
	MOVE.W t76, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t77
	; b = t77
	MOVE.W t77, b
	; t78 = a
	MOVE.W a, t78
	; t79 = b
	MOVE.W b, t79
	; t80 = t78 + t79
	MOVE.W t78, D0
	ADD.W t79, D0
	MOVE.W D0, t80
	; suma = t80
	MOVE.W t80, suma
	; t81 = suma
	MOVE.W suma, t81
	; output t81
	MOVE.W t81, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "Test completado"
	LEA str4, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
end:
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
t50:	DS.W 1
t52:	DS.W 1
t51:	DS.W 1
t10:	DS.W 1
t54:	DS.W 1
t53:	DS.W 1
t12:	DS.W 1
t56:	DS.W 1
str3:	DC.B 'Operacion: matriz[0,0] + matriz[1,1]:',0
t11:	DS.W 1
t55:	DS.W 1
str4:	DC.B 'Test completado',0
str1:	DC.B 'Inicializando matriz 2x2:',0
t14:	DS.W 1
t58:	DS.W 1
t13:	DS.W 1
str2:	DC.B 'Leyendo matriz con bucle:',0
t57:	DS.W 1
t16:	DS.W 1
t15:	DS.W 1
t59:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B '=== TEST: Array 2D completo ===',0
t61:	DS.W 1
t60:	DS.W 1
t63:	DS.W 1
t62:	DS.W 1
t21:	DS.W 1
t65:	DS.W 1
t20:	DS.W 1
t64:	DS.W 1
t23:	DS.W 1
t67:	DS.W 1
t22:	DS.W 1
t66:	DS.W 1
t25:	DS.W 1
t69:	DS.W 1
t24:	DS.W 1
t68:	DS.W 1
t27:	DS.W 1
t26:	DS.W 1
t29:	DS.W 1
t28:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1
t4:	DS.W 1
suma:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t70:	DS.W 1
matriz:	DS.L 1
t72:	DS.W 1
t71:	DS.W 1
t30:	DS.W 1
t74:	DS.W 1
t73:	DS.W 1
t32:	DS.W 1
t76:	DS.W 1
t31:	DS.W 1
t75:	DS.W 1
t34:	DS.W 1
t78:	DS.W 1
t33:	DS.W 1
t77:	DS.W 1
t36:	DS.W 1
t35:	DS.W 1
t79:	DS.W 1
t38:	DS.W 1
t37:	DS.W 1
t39:	DS.W 1
a:	DS.W 1
b:	DS.W 1
valor:	DS.W 1
i:	DS.W 1
j:	DS.W 1
t81:	DS.W 1
t80:	DS.W 1
t41:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t42:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1
t47:	DS.W 1
t46:	DS.W 1
t49:	DS.W 1
t48:	DS.W 1

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
