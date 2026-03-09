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
	; x = 2.0
	MOVE.W #200, x
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t4 = x + 3.0
	MOVE.W x, D0
	ADD.W #300, D0
	MOVE.W D0, t4
	; x = t4
	MOVE.W t4, x
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t8 = x - 2.0
	MOVE.W x, D0
	SUB.W #200, D0
	MOVE.W D0, t8
	; x = t8
	MOVE.W t8, x
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t12 = x * 4.0
	MOVE.W x, D0
	MOVE.W #400, D1
	MULS D1, D0
	MOVE.W #100, D2
	DIVS D2, D0
	MOVE.W D0, t12
	; x = t12
	MOVE.W t12, x
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t16 = x / 3.0
	MOVE.W x, D0
	MOVE.W #300, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	MOVE.W #100, D2
	MULS D2, D0
	DIVS D1, D0
	MOVE.W D0, t16
	; x = t16
	MOVE.W t16, x
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; x = x - 1.0
	MOVE.W x, D0
	SUB.W #100, D0
	MOVE.W D0, x
	; t20 = x % 2.0
	MOVE.W x, D0
	MOVE.W #200, D1
	TST.W D1
	BEQ DIV_ZERO_ERROR
	EXT.L D0
	MOVE.L D0, D2
	DIVS D1, D0
	CLR.L D3
	MOVE.W D0, D3
	MULS D1, D3
	SUB.L D3, D2
	MOVE.W D2, t20
	; x = t20
	MOVE.W t20, x
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; x = 1.0
	MOVE.W #100, x
	; output "x es: "
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "x es: "
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; x = x + 1.0
	MOVE.W x, D0
	ADD.W #100, D0
	MOVE.W D0, x
	; t27 = 5.0 - x
	MOVE.W #500, D0
	SUB.W x, D0
	MOVE.W D0, t27
	; t29 = t27 + 2.0
	MOVE.W t27, D0
	ADD.W #200, D0
	MOVE.W D0, t29
	; x = x - 1.0
	MOVE.W x, D0
	SUB.W #100, D0
	MOVE.W D0, x
	; t31 = t29 + x
	MOVE.W t29, D0
	ADD.W x, D0
	MOVE.W D0, t31
	; t33 = t31 + 1.0
	MOVE.W t31, D0
	ADD.W #100, D0
	MOVE.W D0, t33
	; x = x + 1.0
	MOVE.W x, D0
	ADD.W #100, D0
	MOVE.W D0, x
	; t34 = t33 - x
	MOVE.W t33, D0
	SUB.W x, D0
	MOVE.W D0, t34
	; t35 = x + t34
	MOVE.W x, D0
	ADD.W t34, D0
	MOVE.W D0, t35
	; x = t35
	MOVE.W t35, x
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "BUCLES:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; i = 1.0
	MOVE.W #100, i
e0:
	; t40 = i <= 5.0
	MOVE.W #0, t40
	MOVE.W i, D0
	CMP.W #500, D0
	BLE t40_true
	JMP t40_false
t40_true:
	MOVE.W #1, t40
t40_false:
	; if !(t40) goto e1
	MOVE.W t40, D0
	CMP.W #0, D0
	BEQ e1
	; output "ITERAMOS"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output x
	CLR.L D1
	MOVE.W x, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output i
	CLR.L D1
	MOVE.W i, D1
	EXT.L D1
	JSR PRINT_DECIMAL_2
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t45 = i + 1.0
	MOVE.W i, D0
	ADD.W #100, D0
	MOVE.W D0, t45
	; i = t45
	MOVE.W t45, i
	; t48 = i + 0.5
	MOVE.W i, D0
	ADD.W #50, D0
	MOVE.W D0, t48
	; x = t48
	MOVE.W t48, x
	; goto e0
	JMP e0
e1:
	; output "hola"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; i = 1.0
	MOVE.W #100, i
e2:
	; t52 = i <= 5
	MOVE.W #0, t52
	MOVE.W i, D0
	CMP.W #5, D0
	BLE t52_true
	JMP t52_false
t52_true:
	MOVE.W #1, t52
t52_false:
	; if !(t52) goto e3
	MOVE.W t52, D0
	CMP.W #0, D0
	BEQ e3
	; output "otro bucle"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t55 = i + 1.0
	MOVE.W i, D0
	ADD.W #100, D0
	MOVE.W D0, t55
	; i = t55
	MOVE.W t55, i
	; goto e2
	JMP e2
e3:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
DECIMAL_POINT:	DC.B '.',0
ZERO_CHAR:	DC.B '0',0
DIV_ZERO_MSG:	DC.B 'ERROR: Division entre cero',13,10,0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t8:	DS.W 1
str0:	DC.B 'x es: ',0
i:	DS.W 1
t52:	DS.W 1
t40:	DS.W 1
t20:	DS.W 1
t31:	DS.W 1
t12:	DS.W 1
t34:	DS.W 1
t45:	DS.W 1
str3:	DC.B 'hola',0
t33:	DS.W 1
str4:	DC.B 'otro bucle',0
t55:	DS.W 1
str1:	DC.B 'BUCLES:',0
t35:	DS.W 1
str2:	DC.B 'ITERAMOS',0
x:	DS.W 1
t16:	DS.W 1
t27:	DS.W 1
t48:	DS.W 1
t29:	DS.W 1

; ===== MANEJADOR DE ERROR DE DIVISION ENTRE CERO =====
DIV_ZERO_ERROR:
	LEA DIV_ZERO_MSG, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
