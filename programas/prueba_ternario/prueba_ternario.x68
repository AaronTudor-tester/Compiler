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

PRINT_BOOL:
	TST.W D1
	BEQ .PRINT_MENTIRA
	LEA STR_CIERTO, A1
	BRA .PRINT_BOOL_STR
.PRINT_MENTIRA:
	LEA STR_MENTIRA, A1
.PRINT_BOOL_STR:
	MOVE.B #14, D0
	TRAP #15
	RTS

main:
	; t0 = 2
	MOVE.W #2, t0
	; x = t0
	MOVE.W t0, x
	; t2 = x
	MOVE.W x, t2
	; t3 = 4
	MOVE.W #4, t3
	; t4 = t2 + t3
	MOVE.W t2, D0
	ADD.W t3, D0
	MOVE.W D0, t4
	; t5 = 5
	MOVE.W #5, t5
	; t6 = t4 > t5
	MOVE.W #0, t6
	MOVE.W t4, D0
	CMP.W t5, D0
	BGT t6_true
	JMP t6_false
t6_true:
	MOVE.W #1, t6
t6_false:
	; if !(t6) goto e0
	MOVE.W t6, D0
	CMP.W #0, D0
	BEQ e0
	; t7 = true
	MOVE.W #1, t7
	; t1 = t7
	MOVE.W t7, t1
	; goto e1
	JMP e1
e0:
	; t8 = false
	MOVE.W #0, t8
	; t1 = t8
	MOVE.W t8, t1
e1:
	; a = t1
	MOVE.W t1, a
	; t9 = x
	MOVE.W x, t9
	; output t9
	MOVE.W t9, D1
	JSR PRINT_SIGNED
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t10 = a
	MOVE.W a, t10
	; output t10
	MOVE.W t10, D1
	JSR PRINT_BOOL
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t11 = a
	MOVE.W a, t11
	; if !(t11) goto e2
	MOVE.W t11, D0
	CMP.W #0, D0
	BEQ e2
	; output "hola"
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; goto e3
	JMP e3
e2:
e3:
end:
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
STR_CIERTO:	DC.B 'cierto',0
STR_MENTIRA:	DC.B 'mentira',0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t5:	DS.W 1
a:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
false:	DS.W 1
str0:	DC.B 'hola',0
t10:	DS.W 1
t11:	DS.W 1
x:	DS.W 1
true:	DS.W 1
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
