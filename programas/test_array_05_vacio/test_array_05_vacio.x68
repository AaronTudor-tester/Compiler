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
	; output "=== TEST: Array vacio ==="
	LEA str0, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t0 = 1
	MOVE.W #1, t0
	; t1 = 3
	MOVE.W #3, t1
	; t2 = t0 * t1
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t0, D0
	MULS t1, D0
	MOVE.W D0, t2
	; t3 = 4
	MOVE.W #4, t3
	; t4 = t2 * t3
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t2, D0
	MULS t3, D0
	MOVE.W D0, t4
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, vector
	CLR.L D1
	MOVE.W t4, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	; t5 = 0
	MOVE.W #0, t5
	; t6 = 4
	MOVE.W #4, t6
	; t7 = t5 * t6
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t5, D0
	MULS t6, D0
	MOVE.W D0, t7
	; t8 = 100
	MOVE.W #100, t8
	; vector[t7] = t8
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t7, D0
	CLR.L D1
	MOVE.W t8, D1
	MOVE.L D1, 0(A0, D0.L)
	; t9 = 1
	MOVE.W #1, t9
	; t10 = 4
	MOVE.W #4, t10
	; t11 = t9 * t10
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t9, D0
	MULS t10, D0
	MOVE.W D0, t11
	; t12 = 200
	MOVE.W #200, t12
	; vector[t11] = t12
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t11, D0
	CLR.L D1
	MOVE.W t12, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Leyendo posicion 0: "
	LEA str1, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t13 = 0
	MOVE.W #0, t13
	; t14 = 4
	MOVE.W #4, t14
	; t15 = t13 * t14
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t13, D0
	MULS t14, D0
	MOVE.W D0, t15
	; t16 = vector[t15]
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t15, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t16
	; output t16
	MOVE.W t16, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "Leyendo posicion 1: "
	LEA str2, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t17 = 1
	MOVE.W #1, t17
	; t18 = 4
	MOVE.W #4, t18
	; t19 = t17 * t18
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t17, D0
	MULS t18, D0
	MOVE.W D0, t19
	; t20 = vector[t19]
	MOVEA.L vector, A0
	CLR.L D0
	MOVE.W t19, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t20
	; output t20
	MOVE.W t20, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "Test completado"
	LEA str3, A1
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
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t10:	DS.W 1
t12:	DS.W 1
str3:	DC.B 'Test completado',0
t11:	DS.W 1
str1:	DC.B 'Leyendo posicion 0: ',0
t14:	DS.W 1
t13:	DS.W 1
str2:	DC.B 'Leyendo posicion 1: ',0
t16:	DS.W 1
t15:	DS.W 1
vector:	DS.L 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B '=== TEST: Array vacio ===',0
t20:	DS.W 1
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
