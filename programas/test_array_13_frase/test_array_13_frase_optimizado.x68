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
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, nombres
	MOVE.L #12, D1
	CMP.L #1, D1
	BLT ALLOC_SIZE_INVALID
	ADD.L #12, D0
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
	; nombres[0] = "Ana"
	MOVEA.L nombres, A0
	MOVE.L #0, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	LEA str1, A1
	MOVE.L A1, 0(A0, D0.L)
	; nombres[4] = "Luis"
	MOVEA.L nombres, A0
	MOVE.L #4, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	LEA str2, A1
	MOVE.L A1, 0(A0, D0.L)
	; nombres[8] = "Maria"
	MOVEA.L nombres, A0
	MOVE.L #8, D0
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
	; t15 = 3
	MOVE.W #3, t15
	; t17 = nombres[0]
	MOVEA.L nombres, A0
	MOVE.L #0, D0
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
	; output nombre1
	MOVEA.L nombre1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t22 = 3
	MOVE.W #3, t22
	; t24 = nombres[4]
	MOVEA.L nombres, A0
	MOVE.L #4, D0
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
	; output nombre2
	MOVEA.L nombre2, A1
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
	; nombres[8] = "Pedro"
	MOVEA.L nombres, A0
	MOVE.L #8, D0
	TST.L D0
	BMI ARRAY_INDEX_OUT_OF_BOUNDS
	LEA str6, A1
	MOVE.L A1, 0(A0, D0.L)
	; t32 = 3
	MOVE.W #3, t32
	; t34 = nombres[8]
	MOVEA.L nombres, A0
	MOVE.L #8, D0
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
	; output nombre3
	MOVEA.L nombre3, A1
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
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
ERROR_INDEX_MSG:	DC.B 'ERROR: Indice fuera de rango',13,10,0
ERROR_UNINIT_MSG:	DC.B 'ERROR: Acceso a posicion no inicializada',13,10,0
ERROR_ALLOC_MSG:	DC.B 'ERROR: Tamaño de array inválido (<= 0)',13,10,0
HEAP_PTR:	DC.L $8000
str0:	DC.B '=== TEST: Arrays de frase ===',0
nombre2:	DS.B 80
nombre1:	DS.B 80
nombres:	DS.L 1
nombre3:	DS.B 80
str7:	DC.B 'Test completado',0
str5:	DC.B 'Modificando posicion 2:',0
t32:	DS.W 1
str6:	DC.B 'Pedro',0
str3:	DC.B 'Maria',0
t34:	DS.B 80
str4:	DC.B 'Mostrando nombres:',0
t22:	DS.W 1
str1:	DC.B 'Ana',0
str2:	DC.B 'Luis',0
t24:	DS.B 80
t15:	DS.W 1
t17:	DS.B 80

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
