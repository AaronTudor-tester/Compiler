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
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, matriz
	ADD.L #16, D0
	MOVE.L D0, HEAP_PTR
	; output "Inicializando matriz 2x2:"
	LEA str1, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; matriz[0] = 1
	MOVEA.L matriz, A0
	MOVE.L #0, D0
	MOVE.L #1, D1
	MOVE.L D1, 0(A0, D0.L)
	; matriz[4] = 2
	MOVEA.L matriz, A0
	MOVE.L #4, D0
	MOVE.L #2, D1
	MOVE.L D1, 0(A0, D0.L)
	; matriz[8] = 3
	MOVEA.L matriz, A0
	MOVE.L #8, D0
	MOVE.L #3, D1
	MOVE.L D1, 0(A0, D0.L)
	; matriz[12] = 4
	MOVEA.L matriz, A0
	MOVE.L #12, D0
	MOVE.L #4, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Leyendo matriz con bucle:"
	LEA str2, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; i = 0
	MOVE.W #0, i
e0:
	; t42 = i < 2
	MOVE.W #0, t42
	MOVE.W i, D0
	CMP.W #2, D0
	BLT t42_true
	JMP t42_false
t42_true:
	MOVE.W #1, t42
t42_false:
	; if !(t42) goto e1
	MOVE.W t42, D0
	CMP.W #0, D0
	BEQ e1
	; j = 0
	MOVE.W #0, j
e2:
	; t46 = j < 2
	MOVE.W #0, t46
	MOVE.W j, D0
	CMP.W #2, D0
	BLT t46_true
	JMP t46_false
t46_true:
	MOVE.W #1, t46
t46_false:
	; if !(t46) goto e3
	MOVE.W t46, D0
	CMP.W #0, D0
	BEQ e3
	; t50 = i * 2
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W i, D0
	MULS #2, D0
	MOVE.W D0, t50
	; t51 = t50 + j
	MOVE.W t50, D0
	ADD.W j, D0
	MOVE.W D0, t51
	; t53 = t51 * 4
	; MULT ENTERA: D0 = op1 * op2
	MOVE.W t51, D0
	MULS #4, D0
	MOVE.W D0, t53
	; t55 = matriz[t53]
	MOVEA.L matriz, A0
	CLR.L D0
	MOVE.W t53, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t55
	; output t55
	MOVE.W t55, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0	; Task 14 = Display string
	TRAP #15
	; t58 = j + 1
	MOVE.W j, D0
	ADD.W #1, D0
	MOVE.W D0, t58
	; j = t58
	MOVE.W t58, j
	; goto e2
	JMP e2
e3:
	; t61 = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
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
	; a = matriz[0]
	MOVEA.L matriz, A0
	MOVE.L #0, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, a
	; b = matriz[12]
	MOVEA.L matriz, A0
	MOVE.L #12, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, b
	; t80 = a + b
	MOVE.W a, D0
	ADD.W b, D0
	MOVE.W D0, t80
	; suma = t80
	MOVE.W t80, suma
	; output suma
	MOVE.W suma, D1
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
suma:	DS.W 1
a:	DS.W 1
b:	DS.W 1
str0:	DC.B '=== TEST: Array 2D completo ===',0
i:	DS.W 1
j:	DS.W 1
t80:	DS.W 1
matriz:	DS.L 1
t50:	DS.W 1
t61:	DS.W 1
t51:	DS.W 1
t42:	DS.W 1
t53:	DS.W 1
str3:	DC.B 'Operacion: matriz[0,0] + matriz[1,1]:',0
t55:	DS.W 1
str4:	DC.B 'Test completado',0
str1:	DC.B 'Inicializando matriz 2x2:',0
t58:	DS.W 1
str2:	DC.B 'Leyendo matriz con bucle:',0
t46:	DS.W 1

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
