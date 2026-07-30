;TKG Hardware Test ROM
;(C) SNESNESCUBE64

;Assume that IX is our print location
;Assume that HL has our string
;Assume that '$3F' is our end character
print_by_address_and_length:
    push af
    push bc
    ld bc, $0020
load_character_by_addr:    
    ld a, (hl)
    cp $3F
    jr z, print_return
    ld (ix+0), a
    add ix, bc
    inc hl
    jr load_character_by_addr
print_return:
    pop bc
    pop af
    ret

;prints a two digit character from a
;assumes hl is the print address
;assumes a is what is being printed
print_two_digit:
    push bc
    push de
    ld de, $0020

    ld b, a
    and a, $0F
    cp a, $0A
    jr c, skip_first_letter
    add a, $07
skip_first_letter:
    ld (hl), a
    add hl, de
    ld a, b
    and a, $F0
    rra
    rra
    rra
    rra
    cp a, $0A
    jr c, skip_second_letter
    add a, $07
skip_second_letter:
    ld (hl), a
    add hl, de
    pop de
    pop bc
    ret