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

UNINITIALIZED_ACCESS:
	; Acceso a posicion no inicializada - mostrar mensaje y detener la simulacion
	LEA ERROR_UNINIT_MSG, A1
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
	; output "=== TEST: Arrays de frase ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t0 = 3
	MOVE.W #3, t0
	; t1 = 4
	MOVE.W #4, t1
	; t2 = t0 * t1
	MOVE.W t0, D0
	MULS t1, D0
	MOVE.W D0, t2
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, nombres
	CLR.L D1
	MOVE.W t2, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	CLR.L D1
	MOVE.W t2, D1
	ADD.L D1, D0
	MOVE.L D0, HEAP_PTR
	TST.L D1
	BEQ INIT_nombres_LOOP_END
	MOVE.L nombres, A0
INIT_nombres_LOOP:
	MOVE.L #-1, D4
	MOVE.L D4, (A0)+
	SUBQ.L #4, D1
	BGT INIT_nombres_LOOP
INIT_nombres_LOOP_END:
	; t3 = 0
	MOVE.W #0, t3
	; t4 = 4
	MOVE.W #4, t4
	; t5 = t3 * t4
	MOVE.W t3, D0
	MULS t4, D0
	MOVE.W D0, t5
	; nombres[t5] = "Ana"
	MOVEA.L nombres, A0
	CLR.L D0
	MOVE.W t5, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	LEA str1, A1
	MOVE.L A1, 0(A0, D0.L)
	; t6 = 1
	MOVE.W #1, t6
	; t7 = 4
	MOVE.W #4, t7
	; t8 = t6 * t7
	MOVE.W t6, D0
	MULS t7, D0
	MOVE.W D0, t8
	; nombres[t8] = "Luis"
	MOVEA.L nombres, A0
	CLR.L D0
	MOVE.W t8, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	LEA str2, A1
	MOVE.L A1, 0(A0, D0.L)
	; t9 = 2
	MOVE.W #2, t9
	; t10 = 4
	MOVE.W #4, t10
	; t11 = t9 * t10
	MOVE.W t9, D0
	MULS t10, D0
	MOVE.W D0, t11
	; nombres[t11] = "Maria"
	MOVEA.L nombres, A0
	CLR.L D0
	MOVE.W t11, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	LEA str3, A1
	MOVE.L A1, 0(A0, D0.L)
	; output "Mostrando nombres:"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t12 = 0
	MOVE.W #0, t12
	; t13 = 4
	MOVE.W #4, t13
	; t14 = t12 * t13
	MOVE.W t12, D0
	MULS t13, D0
	MOVE.W D0, t14
	; t16 = 3
	MOVE.W #3, t16
	; t15 = t16
	MOVE.W t16, t15
	; t17 = nombres[t14]
	MOVEA.L nombres, A0
	CLR.L D0
	MOVE.W t14, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t15, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.L D1, t17
	; nombre1 = t17
	MOVE.L t17, nombre1
	; t18 = nombre1
	MOVE.L nombre1, t18
	; output t18
	MOVEA.L t18, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t19 = 1
	MOVE.W #1, t19
	; t20 = 4
	MOVE.W #4, t20
	; t21 = t19 * t20
	MOVE.W t19, D0
	MULS t20, D0
	MOVE.W D0, t21
	; t23 = 3
	MOVE.W #3, t23
	; t22 = t23
	MOVE.W t23, t22
	; t24 = nombres[t21]
	MOVEA.L nombres, A0
	CLR.L D0
	MOVE.W t21, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t22, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.L D1, t24
	; nombre2 = t24
	MOVE.L t24, nombre2
	; t25 = nombre2
	MOVE.L nombre2, t25
	; output t25
	MOVEA.L t25, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Modificando posicion 2:"
	LEA str5, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t26 = 2
	MOVE.W #2, t26
	; t27 = 4
	MOVE.W #4, t27
	; t28 = t26 * t27
	MOVE.W t26, D0
	MULS t27, D0
	MOVE.W D0, t28
	; nombres[t28] = "Pedro"
	MOVEA.L nombres, A0
	CLR.L D0
	MOVE.W t28, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	LEA str6, A1
	MOVE.L A1, 0(A0, D0.L)
	; t29 = 2
	MOVE.W #2, t29
	; t30 = 4
	MOVE.W #4, t30
	; t31 = t29 * t30
	MOVE.W t29, D0
	MULS t30, D0
	MOVE.W D0, t31
	; t33 = 3
	MOVE.W #3, t33
	; t32 = t33
	MOVE.W t33, t32
	; t34 = nombres[t31]
	MOVEA.L nombres, A0
	CLR.L D0
	MOVE.W t31, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.W t32, D2
	EXT.L D2
	MOVE.W #4, D3
	MULS D3, D2
	CMP.L D2, D0
	BGE ARRAY_INDEX_OUT_OF_BOUNDS
	MOVE.L 0(A0, D0.L), D1
	CMP.L #-1, D1
	BEQ UNINITIALIZED_ACCESS
	MOVE.L D1, t34
	; nombre3 = t34
	MOVE.L t34, nombre3
	; t35 = nombre3
	MOVE.L nombre3, t35
	; output t35
	MOVEA.L t35, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Test completado"
	LEA str7, A1
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
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
nombre2:	DS.B 80
nombre1:	DS.B 80
nombres:	DS.L 1
nombre3:	DS.B 80
t30:	DS.W 1
str7:	DC.B 'Test completado',0
t10:	DS.W 1
str5:	DC.B 'Modificando posicion 2:',0
t32:	DS.W 1
str6:	DC.B 'Pedro',0
t31:	DS.W 1
str3:	DC.B 'Maria',0
t12:	DS.W 1
t34:	DS.B 80
t11:	DS.W 1
str4:	DC.B 'Mostrando nombres:',0
t33:	DS.W 1
str1:	DC.B 'Ana',0
t14:	DS.W 1
str2:	DC.B 'Luis',0
t13:	DS.W 1
t35:	DS.B 80
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.B 80
t17:	DS.B 80
t19:	DS.W 1
str0:	DC.B '=== TEST: Arrays de frase ===',0
t21:	DS.W 1
t20:	DS.W 1
t23:	DS.W 1
t22:	DS.W 1
t25:	DS.B 80
t24:	DS.B 80
t27:	DS.W 1
t26:	DS.W 1
t29:	DS.W 1
t28:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
