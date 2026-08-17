;TKG Hardware Test ROM
;(C) SNESNESCUBE64

rom_check_main:
    ld de, rom_test_header_address
    ld hl, string_rom_checksums
    rst $20

    ld de, rom_test_line_address
    ld hl, string_line
    rst $20

    ld a, $04
    ld hl, $0000 ;starting address
checksum_loop:
    call rom_checksum_calculation
    push bc
    dec a
    jr nz, checksum_loop
    ld a, $04
print_loop:
    ld hl, rom0_print_address
    dec a
    ld b, 00
    ld c, a
    add hl, bc
    pop bc
    inc a
    push af
    ld a, c
    call print_two_digit
    ld a, b
    call print_two_digit
    pop af
    dec a
    ld de, $0040
    add hl, de
    ld (hl), a
    add hl, de 
    ld de, hl
    ld hl, string_rom
    call print
    jr nz, print_loop
    ret


; Assume that HL is the start address
rom_checksum_calculation:
    push af
    ld a, $00
    ld bc, $0000 ;result
    ld de, $1000 ;counter

rom_add:
    add a, (hl)
    inc hl
    jr nc, rom_no_carry
    inc b
rom_no_carry:   
    ld c, a
    dec de
    ld a, d
    or a, e
    jr z, checksum_finish
    ld a,c
    jr rom_add
checksum_finish:
    pop af
    ret
