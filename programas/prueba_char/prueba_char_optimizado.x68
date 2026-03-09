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
	; x = 122
	MOVE.B #122, x
	; y = 55
	MOVE.B #55, y
	; output x
	MOVE.B x, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output y
	MOVE.B y, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; a = 120
	MOVE.B #120, a
	; b = 121
	MOVE.B #121, b
	; c = 53
	MOVE.B #53, c
	; output a
	MOVE.B a, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output b
	MOVE.B b, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output c
	MOVE.B c, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output "asd"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; aa = "aasd asd"
	LEA str1, A0
	MOVE.L A0, aa
	; ab = "ggg wwww"
	LEA str2, A0
	MOVE.L A0, ab
	; output aa
	MOVEA.L aa, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; output ab
	MOVEA.L ab, A1
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
HEAP_PTR:	DC.L $8000
aa:	DS.L 1
a:	DS.B 1
ab:	DS.L 1
b:	DS.B 1
c:	DS.B 1
str1:	DC.B 'aasd asd',0
str2:	DC.B 'ggg wwww',0
x:	DS.B 1
y:	DS.B 1
str0:	DC.B 'asd',0

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
