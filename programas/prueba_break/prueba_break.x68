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
	; t0 = 1
	MOVE.W #1, t0
	; i = t0
	MOVE.W t0, i
e0:
	; t1 = i
	MOVE.W i, t1
	; t2 = 5
	MOVE.W #5, t2
	; t3 = t1 <= t2
	MOVE.W #0, t3
	MOVE.W t1, D0
	CMP.W t2, D0
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
	; t4 = i
	MOVE.W i, t4
	; t5 = 2
	MOVE.W #2, t5
	; t6 = t4 > t5
	MOVE.W #0, t6
	MOVE.W t4, D0
	CMP.W t5, D0
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
	; goto e3
	JMP e3
e2:
e3:
	; t7 = i
	MOVE.W i, t7
	; t8 = 1
	MOVE.W #1, t8
	; t9 = t7 + t8
	MOVE.W t7, D0
	ADD.W t8, D0
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
	; t10 = 1
	MOVE.W #1, t10
	; i = t10
	MOVE.W t10, i
e4:
	; t11 = i
	MOVE.W i, t11
	; t12 = 5
	MOVE.W #5, t12
	; t13 = t11 <= t12
	MOVE.W #0, t13
	MOVE.W t11, D0
	CMP.W t12, D0
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
	; t14 = i
	MOVE.W i, t14
	; t15 = 1
	MOVE.W #1, t15
	; t16 = t14 + t15
	MOVE.W t14, D0
	ADD.W t15, D0
	MOVE.W D0, t16
	; i = t16
	MOVE.W t16, i
	; goto e4
	JMP e4
e5:
	; t17 = 1
	MOVE.W #1, t17
	; t18 = 1
	MOVE.W #1, t18
	; t19 = t17 == t18
	MOVE.W #0, t19
	MOVE.W t17, D0
	CMP.W t18, D0
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
	; goto e7
	JMP e7
e6:
e7:
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
t4:	DS.W 1
t5:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
t10:	DS.W 1
t12:	DS.W 1
str3:	DC.B ' ',0
t11:	DS.W 1
str4:	DC.B 'adios',0
str1:	DC.B 'hola',0
t14:	DS.W 1
t13:	DS.W 1
str2:	DC.B 'otro bucle',0
t16:	DS.W 1
t15:	DS.W 1
t18:	DS.W 1
t17:	DS.W 1
t19:	DS.W 1
i:	DS.W 1
str0:	DC.B 'ITERAMOS',0
t0:	DS.W 1
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
