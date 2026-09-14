;TKG Hardware Test ROM
;(C) SNESNESCUBE64

align $20
;hl is the string address
;de is the destination address
;prints both color and text
print:
    push af
    push bc
    push de
    ld b, $00
    ld c, (hl)
    push bc
    inc hl
    ld a, (hl)
    inc hl
    ldir
    pop de
    pop hl
    ld bc, $0400
    ld d, $01
    add hl, bc
    call mass_write;color the text
    pop bc
    pop af
    ret

;prints a two digit character from a
;assumes hl is the print address
;assumes b is the color
;assumes a is what is being printed
print_two_digit:
    push af
    and $0F
    ld c, a
    pop af
    and $F0
    ld de, hl
    inc h
    inc h
    inc h
    inc h
    ld (hl), b
    inc hl
    ld (hl), b
    ld (de), a
    inc de
    ld (de), a
    ret