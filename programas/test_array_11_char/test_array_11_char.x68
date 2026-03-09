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


ARRAY_INDEX_OUT_OF_BOUNDS:
	; Indice fuera de rango - mostrar mensaje y detener la simulacion
	LEA ERROR_INDEX_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	SIMHALT

ALLOC_SIZE_INVALID:
	; Tamaño de array inválido en tiempo de ejecución - mostrar mensaje y detener
	LEA ERROR_ALLOC_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	SIMHALT
main:
	; output "=== TEST: Arrays de char ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t0 = 5
	MOVE.W #5, t0
	; t1 = 2
	MOVE.W #2, t1
	; t2 = t0 * t1
	MOVE.W t0, D0
	MULS t1, D0
	MOVE.W D0, t2
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, vocales
	CLR.L D1
	MOVE.W t2, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t2, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	; t3 = 97
	MOVE.W #97, t3
	; t4 = 0
	MOVE.W #0, t4
	; t5 = 2
	MOVE.W #2, t5
	; t6 = t4 * t5
	MOVE.W t4, D0
	MULS t5, D0
	MOVE.W D0, t6
	; vocales[t6] = t3
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t6, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t3, D1
	MOVE.W D1, 0(A0, D0.L)
	; t7 = 101
	MOVE.W #101, t7
	; t8 = 1
	MOVE.W #1, t8
	; t9 = 2
	MOVE.W #2, t9
	; t10 = t8 * t9
	MOVE.W t8, D0
	MULS t9, D0
	MOVE.W D0, t10
	; vocales[t10] = t7
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t10, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t7, D1
	MOVE.W D1, 0(A0, D0.L)
	; t11 = 105
	MOVE.W #105, t11
	; t12 = 2
	MOVE.W #2, t12
	; t13 = 2
	MOVE.W #2, t13
	; t14 = t12 * t13
	MOVE.W t12, D0
	MULS t13, D0
	MOVE.W D0, t14
	; vocales[t14] = t11
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t14, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t11, D1
	MOVE.W D1, 0(A0, D0.L)
	; t15 = 111
	MOVE.W #111, t15
	; t16 = 3
	MOVE.W #3, t16
	; t17 = 2
	MOVE.W #2, t17
	; t18 = t16 * t17
	MOVE.W t16, D0
	MULS t17, D0
	MOVE.W D0, t18
	; vocales[t18] = t15
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t18, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t15, D1
	MOVE.W D1, 0(A0, D0.L)
	; t19 = 117
	MOVE.W #117, t19
	; t20 = 4
	MOVE.W #4, t20
	; t21 = 2
	MOVE.W #2, t21
	; t22 = t20 * t21
	MOVE.W t20, D0
	MULS t21, D0
	MOVE.W D0, t22
	; vocales[t22] = t19
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t22, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t19, D1
	MOVE.W D1, 0(A0, D0.L)
	; output "Mostrando vocales:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t23 = 0
	MOVE.W #0, t23
	; t24 = 2
	MOVE.W #2, t24
	; t25 = t23 * t24
	MOVE.W t23, D0
	MULS t24, D0
	MOVE.W D0, t25
	; t27 = 5
	MOVE.W #5, t27
	; t26 = t27
	MOVE.W t27, t26
	; t28 = vocales[t25]
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t25, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t26, D2
	EXT.L D2
	MOVE.W #2, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t28
	; primera = t28
	MOVE.B t28, primera
	; t29 = primera
	MOVE.B primera, t29
	; output t29
	MOVE.B t29, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t30 = 2
	MOVE.W #2, t30
	; t31 = 2
	MOVE.W #2, t31
	; t32 = t30 * t31
	MOVE.W t30, D0
	MULS t31, D0
	MOVE.W D0, t32
	; t34 = 5
	MOVE.W #5, t34
	; t33 = t34
	MOVE.W t34, t33
	; t35 = vocales[t32]
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t32, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t33, D2
	EXT.L D2
	MOVE.W #2, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t35
	; tercera = t35
	MOVE.B t35, tercera
	; t36 = tercera
	MOVE.B tercera, t36
	; output t36
	MOVE.B t36, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Modificando posicion 1:"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t37 = 1
	MOVE.W #1, t37
	; t38 = 2
	MOVE.W #2, t38
	; t39 = t37 * t38
	MOVE.W t37, D0
	MULS t38, D0
	MOVE.W D0, t39
	; t40 = 69
	MOVE.W #69, t40
	; vocales[t39] = t40
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t39, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t40, D1
	MOVE.W D1, 0(A0, D0.L)
	; t41 = 1
	MOVE.W #1, t41
	; t42 = 2
	MOVE.W #2, t42
	; t43 = t41 * t42
	MOVE.W t41, D0
	MULS t42, D0
	MOVE.W D0, t43
	; t45 = 5
	MOVE.W #5, t45
	; t44 = t45
	MOVE.W t45, t44
	; t46 = vocales[t43]
	MOVEA.L vocales, A0
	CLR.L D0
	MOVE.W t43, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t44, D2
	EXT.L D2
	MOVE.W #2, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W 0(A0, D0.L), D1
	EXT.L D1
	MOVE.W D1, t46
	; nueva = t46
	MOVE.B t46, nueva
	; t47 = nueva
	MOVE.B nueva, t47
	; output t47
	MOVE.B t47, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Test completado"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t10:	DS.W 1
tercera:	DS.B 1
t12:	DS.W 1
str3:	DC.B 'Test completado',0
t11:	DS.W 1
t14:	DS.W 1
str1:	DC.B 'Mostrando vocales:',0
t13:	DS.W 1
str2:	DC.B 'Modificando posicion 1:',0
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
str0:	DC.B '=== TEST: Arrays de char ===',0
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.W 1
t24:	DS.W 1
t27:	DS.W 1
t26:	DS.W 1
t29:	DS.B 1
t28:	DS.B 1
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
vocales:	DS.L 1
t30:	DS.W 1
t32:	DS.W 1
primera:	DS.B 1
t31:	DS.W 1
t34:	DS.W 1
t33:	DS.W 1
t36:	DS.B 1
t35:	DS.B 1
t38:	DS.W 1
t37:	DS.W 1
t39:	DS.W 1
nueva:	DS.B 1
t41:	DS.W 1
t40:	DS.W 1
t43:	DS.W 1
t42:	DS.W 1
t45:	DS.W 1
t44:	DS.W 1
t47:	DS.B 1
t46:	DS.B 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
