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
	; output "=== PRUEBA DE SWITCH-CASE ==="
	LEA str0, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; opcion = 1
	MOVE.W #1, opcion
	; output "Opcion = 1:"
	LEA str1, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t1 = opcion
	MOVE.W opcion, t1
	; t2 = 1
	MOVE.W #1, t2
	; if t1 != t2 goto e1
	MOVE.W t1, D0
	CMP.W t2, D0
	BNE e1
	; output "Seleccionaste 1"
	LEA str2, A1
	MOVE.B #14, D0
	TRAP #15
e1:
	; t3 = 2
	MOVE.W #2, t3
	; if t1 != t3 goto e2
	MOVE.W t1, D0
	CMP.W t3, D0
	BNE e2
	; output "Seleccionaste 2"
	LEA str3, A1
	MOVE.B #14, D0
	TRAP #15
e2:
	; t4 = 3
	MOVE.W #3, t4
	; if t1 != t4 goto e0
	MOVE.W t1, D0
	CMP.W t4, D0
	BNE e0
	; output "Seleccionaste 3"
	LEA str4, A1
	MOVE.B #14, D0
	TRAP #15
e0:
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; opcion2 = 2
	MOVE.W #2, opcion2
	; output "Opcion = 2:"
	LEA str5, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t6 = opcion2
	MOVE.W opcion2, t6
	; t7 = 1
	MOVE.W #1, t7
	; if t6 != t7 goto e4
	MOVE.W t6, D0
	CMP.W t7, D0
	BNE e4
	; output "Opcion 1"
	LEA str6, A1
	MOVE.B #14, D0
	TRAP #15
e4:
	; t8 = 2
	MOVE.W #2, t8
	; if t6 != t8 goto e5
	MOVE.W t6, D0
	CMP.W t8, D0
	BNE e5
	; output "Opcion 2"
	LEA str7, A1
	MOVE.B #14, D0
	TRAP #15
e5:
	; t9 = 3
	MOVE.W #3, t9
	; if t6 != t9 goto e3
	MOVE.W t6, D0
	CMP.W t9, D0
	BNE e3
	; output "Opcion 3"
	LEA str8, A1
	MOVE.B #14, D0
	TRAP #15
e3:
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; opcion3 = 5
	MOVE.W #5, opcion3
	; output "Opcion = 5 (no existe):"
	LEA str9, A1
	MOVE.B #14, D0
	TRAP #15
	; output "\n"
	LEA NEWLINE, A1
	MOVE.B #14, D0
	TRAP #15
	; t11 = opcion3
	MOVE.W opcion3, t11
	; t12 = 1
	MOVE.W #1, t12
	; if t11 != t12 goto e7
	MOVE.W t11, D0
	CMP.W t12, D0
	BNE e7
	; output "Uno"
	LEA str10, A1
	MOVE.B #14, D0
	TRAP #15
e7:
	; t13 = 2
	MOVE.W #2, t13
	; if t11 != t13 goto e8
	MOVE.W t11, D0
	CMP.W t13, D0
	BNE e8
	; output "Dos"
	LEA str11, A1
	MOVE.B #14, D0
	TRAP #15
e8:
	; t14 = 3
	MOVE.W #3, t14
	; if t11 != t14 goto e6
	MOVE.W t11, D0
	CMP.W t14, D0
	BNE e6
	; output "Tres"
	LEA str12, A1
	MOVE.B #14, D0
	TRAP #15
e6:
	; output "FIN"
	LEA str13, A1
	MOVE.B #14, D0
	TRAP #15
	BRA HALT

	; DATA SECTION
NEWLINE:	DC.B 13,10,0
MINUS_SIGN:	DC.B '-',0
HEAP_PTR:	DC.L $8000
t4:	DS.W 1
t6:	DS.W 1
t7:	DS.W 1
t8:	DS.W 1
t9:	DS.W 1
str7:	DC.B 'Opcion 2',0
str8:	DC.B 'Opcion 3',0
str5:	DC.B 'Opcion = 2:',0
str6:	DC.B 'Opcion 1',0
str3:	DC.B 'Seleccionaste 2',0
t12:	DS.W 1
str4:	DC.B 'Seleccionaste 3',0
t11:	DS.W 1
str1:	DC.B 'Opcion = 1:',0
t14:	DS.W 1
str2:	DC.B 'Seleccionaste 1',0
t13:	DS.W 1
str12:	DC.B 'Tres',0
str13:	DC.B 'FIN',0
opcion2:	DS.W 1
str10:	DC.B 'Uno',0
opcion3:	DS.W 1
str11:	DC.B 'Dos',0
str9:	DC.B 'Opcion = 5 (no existe):',0
opcion:	DS.W 1
str0:	DC.B '=== PRUEBA DE SWITCH-CASE ===',0
t1:	DS.W 1
t2:	DS.W 1
t3:	DS.W 1

HALT:
	SIMHALT

	ORG $5000
STACKPTR:
	END START
