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

main:
	; output "=== TEST: Array con while ==="
	LEA str0, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t0 = 5
	MOVE.W #5, t0
	; t1 = 4
	MOVE.W #4, t1
	; t2 = t0 * t1
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t0, D0
	MULS t1, D0
	MOVE.W D0, t2
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, vector
	ADD.L t2, D0
	MOVE.L D0, HEAP_PTR
	; t3 = 5
	MOVE.W #5, t3
	; t4 = 0
	MOVE.W #0, t4
	; t5 = 4
	MOVE.W #4, t5
	; t6 = t4 * t5
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t4, D0
	MULS t5, D0
	MOVE.W D0, t6
	; vector[t6] = t3
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t6, D0
	CLR.L D1
	MOVE.W t3, D1
	MOVE.L D1, 0(A0, D0.L)
	; t7 = 10
	MOVE.W #10, t7
	; t8 = 1
	MOVE.W #1, t8
	; t9 = 4
	MOVE.W #4, t9
	; t10 = t8 * t9
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t8, D0
	MULS t9, D0
	MOVE.W D0, t10
	; vector[t10] = t7
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t10, D0
	CLR.L D1
	MOVE.W t7, D1
	MOVE.L D1, 0(A0, D0.L)
	; t11 = 15
	MOVE.W #15, t11
	; t12 = 2
	MOVE.W #2, t12
	; t13 = 4
	MOVE.W #4, t13
	; t14 = t12 * t13
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t12, D0
	MULS t13, D0
	MOVE.W D0, t14
	; vector[t14] = t11
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t14, D0
	CLR.L D1
	MOVE.W t11, D1
	MOVE.L D1, 0(A0, D0.L)
	; t15 = 20
	MOVE.W #20, t15
	; t16 = 3
	MOVE.W #3, t16
	; t17 = 4
	MOVE.W #4, t17
	; t18 = t16 * t17
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t16, D0
	MULS t17, D0
	MOVE.W D0, t18
	; vector[t18] = t15
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t18, D0
	CLR.L D1
	MOVE.W t15, D1
	MOVE.L D1, 0(A0, D0.L)
	; t19 = 25
	MOVE.W #25, t19
	; t20 = 4
	MOVE.W #4, t20
	; t21 = 4
	MOVE.W #4, t21
	; t22 = t20 * t21
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t20, D0
	MULS t21, D0
	MOVE.W D0, t22
	; vector[t22] = t19
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t22, D0
	CLR.L D1
	MOVE.W t19, D1
	MOVE.L D1, 0(A0, D0.L)
	; t23 = 0
	MOVE.W #0, t23
	; i = t23
	MOVE.W t23, i
	; output "Recorriendo array con while:"
	LEA str1, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
e0:
	; t24 = i
	MOVE.W i, t24
	; t25 = 5
	MOVE.W #5, t25
	; t26 = t24 < t25
	MOVE.W #0, t26
	MOVE.W t24, D0
	CMP.W t25, D0
	BLT t26_true
	JMP t26_false
t26_true:
	MOVE.W #1, t26
t26_false:
	; if !(t26) goto e1
	MOVE.W t26, D0
	CMP.W #0, D0
	BEQ e1
	; t27 = i
	MOVE.W i, t27
	; t28 = 4
	MOVE.W #4, t28
	; t29 = t27 * t28
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t27, D0
	MULS t28, D0
	MOVE.W D0, t29
	; t30 = vector[t29]
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t29, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t30
	; valor = t30
	MOVE.W t30, valor
	; t31 = valor
	MOVE.W valor, t31
	; output t31
	MOVE.W t31, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t32 = i
	MOVE.W i, t32
	; t33 = 1
	MOVE.W #1, t33
	; t34 = t32 + t33
	MOVE.W t32, D0
	ADD.W t33, D0
	MOVE.W D0, t34
	; i = t34
	MOVE.W t34, i
	; goto e0
	JMP e0
e1:
	; output "Test completado"
	LEA str2, A1
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
HEAP_PTR:	DC.L $8000	; Inicio del heap para arrays
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t30:	DS.W 1
t10:	DS.W 1
t32:	DS.W 1
t31:	DS.W 1
t12:	DS.W 1
t34:	DS.W 1
t11:	DS.W 1
t33:	DS.W 1
t14:	DS.W 1
str1:	DC.B 'Recorriendo array con while:',0
t13:	DS.W 1
str2:	DC.B 'Test completado',0
t16:	DS.W 1
t15:	DS.W 1
vector:	DS.L 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
valor:	DS.W 1
str0:	DC.B '=== TEST: Array con while ===',0
i:	DS.W 1
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.W 1
t24:	DS.W 1
t27:	DS.W 1
t26:	DS.W 1
t29:	DS.W 1
t28:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

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
