;TNX Hardware Test ROM
;(C) SNESNESCUBE64

rom_check_main:
    ld de, string_rom_header_print_addr
    ld hl, string_rom_test
    rst $20
    ld de, string_rom_header_print_addr+$20
    ld hl, string_line
    rst $20

    ld a, $07
    ld de, $8000;start address for temp storage of the checksums
    ld hl, $0000
rom_check_loop:
    call rom_checksum_calculation
    ex de, hl
    ld (hl), b
    inc hl
    ld (hl), c
    inc hl
    ex de, hl
    dec a
    jr nz, rom_check_loop

    call process_rom_results

    ret


; Assume that HL is the start address
rom_checksum_calculation:
    push af
    push de
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
    pop de
    pop af
    ret

process_rom_results:
;print the headers
    xor a
    ld de, string_rom_0_print_addr
print_rom_loop_info:
    push af
    ld hl, string_rom
    push de
    call print
    or a
    ld de, $0400
    sbc hl, de
    add $0A
    ld (hl), a
    add hl, de
    ex de, hl
    pop de
    ex de, hl
    ld bc, $0020
    add hl, bc
    ex de, hl
    pop af
    inc a
    cp $07
    jr nz, print_rom_loop_info

;Verify the ROMs
    xor a
    ld hl, rom_known_checksums
    ld de, $8000
    ld ix, string_rom_0_print_addr + 8
rom_compare_loop:
    ;load the compare values
    ld b, (hl)
    inc hl
    ld c, (hl)
    inc hl
    push hl
    ex de, hl
    ld d, (hl)
    inc hl
    ld e, (hl)
    inc hl
    push hl
    ;compare the values
    ex de, hl
    or a
    sbc hl, bc
    jr nz, rom_compare_nok
    ld hl, string_ok
    jr rom_compare_result_print
rom_compare_nok:
    ld hl, string_nok
rom_compare_result_print:
    push ix
    pop de
    call print
    ld de, $20
    add ix, de
    pop de
    pop hl
    inc a
    cp $07
    jr nz, rom_compare_loop

    ret