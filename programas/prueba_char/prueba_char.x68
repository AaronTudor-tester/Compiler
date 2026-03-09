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
	; t0 = 122
	MOVE.B #122, t0
	; x = t0
	MOVE.B t0, x
	; t1 = 55
	MOVE.B #55, t1
	; y = t1
	MOVE.B t1, y
	; t2 = x
	MOVE.B x, t2
	; output t2
	MOVE.B t2, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t3 = y
	MOVE.B y, t3
	; output t3
	MOVE.B t3, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t4 = 120
	MOVE.B #120, t4
	; a = t4
	MOVE.B t4, a
	; t5 = 121
	MOVE.B #121, t5
	; b = t5
	MOVE.B t5, b
	; t6 = 53
	MOVE.B #53, t6
	; c = t6
	MOVE.B t6, c
	; t7 = a
	MOVE.B a, t7
	; output t7
	MOVE.B t7, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t8 = b
	MOVE.B b, t8
	; output t8
	MOVE.B t8, D1
	MOVE.B #6, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t9 = c
	MOVE.B c, t9
	; output t9
	MOVE.B t9, D1
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
	; t10 = aa
	MOVE.L aa, t10
	; output t10
	MOVEA.L t10, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t11 = ab
	MOVE.L ab, t11
	; output t11
	MOVEA.L t11, A1
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
HEAP_PTR:	DC.L $8000
t4:	DS.B 1
aa:	DS.L 1
a:	DS.B 1
t5:	DS.B 1
ab:	DS.L 1
b:	DS.B 1
t6:	DS.B 1
c:	DS.B 1
t7:	DS.B 1
t8:	DS.B 1
t9:	DS.B 1
str0:	DC.B 'asd',0
t10:	DS.L 1
t11:	DS.L 1
str1:	DC.B 'aasd asd',0
str2:	DC.B 'ggg wwww',0
x:	DS.B 1
y:	DS.B 1
t0:	DS.B 1
t1:	DS.B 1
t2:	DS.B 1
t3:	DS.B 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
