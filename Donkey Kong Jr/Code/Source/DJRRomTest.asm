;TKG Hardware Test ROM
;(C) SNESNESCUBE64

djr_rom_addrs: DB $00, $08, $30, $38, $20, $48, $10, $58, $40, $28, $50, $18, $80, $88, $FF

rom_check_main:
    ld de, rom_test_header_address
    ld hl, string_rom_checksums
    rst $20

    ld de, rom_test_line_address
    ld hl, string_line
    rst $20

nop
nop
nop
nop
nop
nop

    ld a, $04
    ld hl, djr_rom_addrs
    exx
    ld bc, $0000 ;result
    ld d, $04 ;banks remaining
    exx

checksum_loop:
    call rom_checksum_calculation
    exx
    push bc
    ld bc, $0000 ;result
    ld d, $04 ;banks remaining
    exx
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
    call rom_0_integrity_check
    ret


;hl - bank addr
;bc' - result
;d' banks remaining
rom_checksum_calculation:
    push af
    ld a, $00
    ld bc, $0000 ;current address
    ;ld de, $0800 ;counter
    ;hl - bank addr
    
rom_checksum_bank_start:
    ld b, (hl)
    ld c, $00 ; might not be necessary
    ld ix, $0000
    add ix, bc
    ld de, $0800
rom_checksum_bank_loop:
    add a, (ix+0)
    jr nc, next_checksum_byte
    exx
    inc b
    exx
next_checksum_byte:
    inc ix
    dec e
    jr nz, rom_checksum_bank_loop
    dec d
    jr nz, rom_checksum_bank_loop

    inc hl

    exx
    dec d ; decrement bank counter
    jr z, checksum_finish
    exx
    push af
    ld a, (hl)
    cp $FF
    jr z, checksum_finish_early
    pop af
    jr rom_checksum_bank_start
checksum_finish_early:
    pop af
    exx
checksum_finish:
    ld c, a
    exx

    pop af
    ret

rom_0_integrity_check:
    ld hl, rom0_checksum_addr
    
    ld a, b
    cp (hl)
    jr nz, rom_0_integrity_fail
    inc hl
    ld a, c
    cp (hl)
    jr nz, rom_0_integrity_fail

    ret
rom_0_integrity_fail:
    ld de, rom0_if_print_address
    ld hl, string_rom0_if
    rst $20
    ret