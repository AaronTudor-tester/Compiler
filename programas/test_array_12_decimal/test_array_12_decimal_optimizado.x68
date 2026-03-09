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

main:
	; output "=== TEST: Arrays de decimal ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; 
	MOVE.L HEAP_PTR, D0
	MOVE.L D0, precios
	ADD.L #12, D0
	MOVE.L D0, HEAP_PTR
	; precios[0] = 10.5
	MOVEA.L precios, A0
	MOVE.L #0, D0
	MOVE.L #1050, D1
	MOVE.L D1, 0(A0, D0.L)
	; precios[4] = 20.99
	MOVEA.L precios, A0
	MOVE.L #4, D0
	MOVE.L #2099, D1
	MOVE.L D1, 0(A0, D0.L)
	; precios[8] = 15.75
	MOVEA.L precios, A0
	MOVE.L #8, D0
	MOVE.L #1575, D1
	MOVE.L D1, 0(A0, D0.L)
	; output "Mostrando precios:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t21 = precios[0]
	MOVEA.L precios, A0
	MOVE.L #0, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t21
	; output t21
	CLR.L D1
	MOVE.W t21, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t28 = precios[4]
	MOVEA.L precios, A0
	MOVE.L #4, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, t28
	; output t28
	CLR.L D1
	MOVE.W t28, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "Suma de precios[0] + precios[2]:"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; p3 = precios[8]
	MOVEA.L precios, A0
	MOVE.L #8, D0
	MOVE.L 0(A0, D0.L), D1
	MOVE.W D1, p3
	; t37 = p1 + p3
	MOVE.W p1, D0
	ADD.W p3, D0
	MOVE.W D0, t37
	; output t37
	CLR.L D1
	MOVE.W t37, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
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
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
HEAP_PTR:	DC.L $8000
p1:	DS.W 1
t21:	DS.W 1
p3:	DS.W 1
str3:	DC.B 'Test completado',0
str1:	DC.B 'Mostrando precios:',0
str2:	DC.B 'Suma de precios[0] + precios[2]:',0
str0:	DC.B '=== TEST: Arrays de decimal ===',0
t37:	DS.W 1
t28:	DS.W 1
precios:	DS.L 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
