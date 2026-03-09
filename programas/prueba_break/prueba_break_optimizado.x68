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

main:
	; i = 1
	MOVE.W #1, i
e0:
	; t3 = i <= 5
	MOVE.W #0, t3
	MOVE.W i, D0
	CMP.W #5, D0
	BLE t3_true
	JMP t3_false
t3_true:
	MOVE.W #1, t3
t3_false:
	; if !(t3) goto e1
	MOVE.W t3, D0
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
	; t6 = i > 2
	MOVE.W #0, t6
	MOVE.W i, D0
	CMP.W #2, D0
	BGT t6_true
	JMP t6_false
t6_true:
	MOVE.W #1, t6
t6_false:
	; if !(t6) goto e2
	MOVE.W t6, D0
	CMP.W #0, D0
	BEQ e2
	; goto e1
	JMP e1
e2:
	; t9 = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, t9
	; i = t9
	MOVE.W t9, i
	; goto e0
	JMP e0
e1:
	; output "hola"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; i = 1
	MOVE.W #1, i
e4:
	; t13 = i <= 5
	MOVE.W #0, t13
	MOVE.W i, D0
	CMP.W #5, D0
	BLE t13_true
	JMP t13_false
t13_true:
	MOVE.W #1, t13
t13_false:
	; if !(t13) goto e5
	MOVE.W t13, D0
	CMP.W #0, D0
	BEQ e5
	; output "otro bucle"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
	; output " "
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e5
	JMP e5
	; t16 = i + 1
	MOVE.W i, D0
	ADD.W #1, D0
	MOVE.W D0, t16
	; i = t16
	MOVE.W t16, i
	; goto e4
	JMP e4
e5:
	; t19 = 1 == 1
	MOVE.W #0, t19
	MOVE.W #1, D0
	CMP.W #1, D0
	BEQ t19_true
	JMP t19_false
t19_true:
	MOVE.W #1, t19
t19_false:
	; if !(t19) goto e6
	MOVE.W t19, D0
	CMP.W #0, D0
	BEQ e6
	; goto end
	JMP end
e6:
	; output "adios"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
t6:	DS.W 1
str3:	DC.B ' ',0
t9:	DS.W 1
str4:	DC.B 'adios',0
str1:	DC.B 'hola',0
t13:	DS.W 1
str2:	DC.B 'otro bucle',0
t16:	DS.W 1
i:	DS.W 1
str0:	DC.B 'ITERAMOS',0
t19:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
