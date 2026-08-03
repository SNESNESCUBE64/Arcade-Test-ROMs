;TKG Hardware Test ROM
;(C) SNESNESCUBE64

ram_test_main:
    ;bit test
    ld iy, bit_test1_fill_return
    ld a, $a5
    ld b, $00
    jp ram_fill
bit_test1_fill_return:
    ld iy, bit_test2_fill_start
    ld c, a
    jp ram_bit_check_readback
bit_test2_fill_start:
    ld iy, bit_test2_fill_return
    ld a, $5a
    jp ram_fill
bit_test2_fill_return:
    ld iy, ram_test_erase
    ld c, a
    jp ram_bit_check_readback
ram_test_erase:
    ld iy, ram_test_return
    jp ram_erase
ram_test_return:
    jp (ix)

ram_erase:
    xor a
    ld b, $10
ram_fill:
    ld hl, $6000
    ld de, $0C00
work_ram_erase:
    ld (hl), a
    inc hl
    dec e
    jr nz, work_ram_erase
    dec d
    jr nz, work_ram_erase
    ld hl, $7000
    ld de, $0400
sprite_ram_erase:
    ld (hl), a
    inc hl
    dec e
    jr nz, sprite_ram_erase
    dec d
    jr nz, sprite_ram_erase
    ld hl, $7400
    ld de, $0400
    or b
video_ram_erase:
    ld (hl), a
    inc hl
    dec e
    jr nz, video_ram_erase
    dec d
    jr nz, video_ram_erase
    jp (iy)

;to do, clean this up to make more re-usable. Very long hard coded routines here
ram_bit_check_readback:
    ld hl, $6000
    ld de, $0400
ram_bit_check_loop1:
    ld a, (hl)
    xor a, c
    jr z, ram_bit_check_bit_pass1
;RAM Failure Detected, find out if high or low
    ld b, $04
loop1_low_bit_test:
    rrca
    jr nc, loop1_next_bit1
    exx
    ld b, a
    ld a, l
    or a, $01
    ld l, a
    ld a, b
    exx
loop1_next_bit1:
    dec b
    jr nz, loop1_low_bit_test

    ld b, $04
loop1_high_bit_test:
    rrca
    jr nc, loop1_next_bit2
    exx
    ld b, a
    ld a, l
    or a, $02
    ld l, a
    ld a, b
    exx
loop1_next_bit2:
    dec b
    jr nz, loop1_high_bit_test


ram_bit_check_bit_pass1:
    inc hl
    dec e
    jr nz, ram_bit_check_loop1
    dec d
    jr nz, ram_bit_check_loop1

    ld de, $0400
ram_bit_check_loop2:
    ld a, (hl)
    xor a, c
    jr z, ram_bit_check_bit_pass2
;RAM Failure Detected, find out if high or low
    ld b, $04
loop2_low_bit_test:
    rrca
    jr nc, loop2_next_bit1
    exx
    ld b, a
    ld a, l
    or a, $04
    ld l, a
    ld a, b
    exx
loop2_next_bit1:
    dec b
    jr nz, loop2_low_bit_test

    ld b, $04
loop2_high_bit_test:
    rrca
    jr nc, loop2_next_bit2
    exx
    ld b, a
    ld a, l
    or a, $08
    ld l, a
    ld a, b
    exx
loop2_next_bit2:
    dec b
    jr nz, loop2_high_bit_test

ram_bit_check_bit_pass2:
    inc hl
    dec e
    jr nz, ram_bit_check_loop2
    dec d
    jr nz, ram_bit_check_loop2

    ld de, $0400
ram_bit_check_loop3:
    ld a, (hl)
    xor a, c
    jr z, ram_bit_check_bit_pass3
;RAM Failure Detected, find out if high or low
    ld b, $04
loop3_low_bit_test:
    rrca
    jr nc, loop3_next_bit1
    exx
    ld b, a
    ld a, l
    or a, $10
    ld l, a
    ld a, b
    exx
loop3_next_bit1:
    dec b
    jr nz, loop3_low_bit_test

    ld b, $04
loop3_high_bit_test:
    rrca
    jr nc, loop3_next_bit2
    exx
    ld b, a
    ld a, l
    or a, $20
    ld l, a
    ld a, b
    exx
loop3_next_bit2:
    dec b
    jr nz, loop3_high_bit_test

ram_bit_check_bit_pass3:
    inc hl
    dec e
    jr nz, ram_bit_check_loop3
    dec d
    jr nz, ram_bit_check_loop3

    ld hl, $7400
    ld de, $0400
ram_bit_check_loop4:
    ld a, (hl)
    xor a, c
    jr z, ram_bit_check_bit_pass4
;RAM Failure Detected, find out if high or low
    ld b, $04
loop4_low_bit_test:
    rrca
    jr nc, loop4_next_bit1
    exx
    ld b, a
    ld a, l
    or a, $40
    ld l, a
    ld a, b
    exx
loop4_next_bit1:
    dec b
    jr nz, loop4_low_bit_test

    ld b, $04
loop4_high_bit_test:
    rrca
    jr nc, loop4_next_bit2
    exx
    ld b, a
    ld a, l
    or a, $80
    ld l, a
    ld a, b
    exx
loop4_next_bit2:
    dec b
    jr nz, loop4_high_bit_test
ram_bit_check_bit_pass4:
    inc hl
    dec e
    jr nz, ram_bit_check_loop4
    dec d
    jr nz, ram_bit_check_loop4
    
    jp (iy)


process_ram_results:
    ;print the header
    ld de, ram_test_header_address
    ld hl, string_ram_test
    call print

    ld de, ram_test_line_address
    ld hl, string_line
    call print

    ;Copy the results to preserve original test
    exx
    ld d, h
    ld e, l
    exx

    ld bc, $0000
print_ram_results_loop:
    ld de, ram0l_print_address
    ld ix, $0000
    add ix, de
    add ix, bc
    ld d, $00
    ld e, $C0
    ;See if RAM test passed
    exx
    ld a, e
    rra
    ld e, a
    exx
    ld hl, string_good
    jr nc, print_ram_test_result
    ld hl, string_bad
print_ram_test_result:
    call print_by_address_and_length
    ld de, $0040
    add ix, de
    ld (ix+$00), $1C
    ld a, c
    and $01
    jr z, print_ram_id:
    ld (ix+$00), $18
print_ram_id:
    ld a, c
    rra 
    and $03   
    ld (ix+$20), a
    ld e, $60
    add ix, de
    ld hl, string_ram
    call print_by_address_and_length
    inc c
    ld a, $08
    cp c
    ret z
    jr print_ram_results_loop
