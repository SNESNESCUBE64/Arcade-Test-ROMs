; Space Encounters Encoders Test ROM
; SNESNESCUBE64

trench_string_1: DB $02, $06, $02, $06, $02, $06, $02, $06, $02, $06, $02, $06, $02, $06, $02, $06

trench1:
	mvi a, $20
	out $07
	out $07
	mvi a, $20 ;lda 2043
	out $00
	lxi h, trench_string_1
	mov a, m
	out $03
	inx h
	mov a, m
	out $0B
	inx h
	mov a, m
	out $13
	inx h
	mov a, m
	out $1B
	inx h
	mov a, m
	out $43
	inx h
	mov a, m
	out $4B
	inx h
	mov a, m
	out $53
	inx h
	mov a, m
	out $5B
	inx h
	mov a, m
	out $83
	inx h
	mov a, m
	out $8B
	inx h
	mov a, m
	out $93
	inx h
	mov a, m
	out $9B
	inx h
	mov a, m
	out $C3
	inx h
	mov a, m
	out $CB
	inx h
	mov a, m
	out $D3
	inx h
	mov a, m
	out $DB
	mvi a, $0E
	out $00
	ret

trench2:
