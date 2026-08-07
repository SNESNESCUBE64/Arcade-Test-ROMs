;TKG Hardware Test ROM
;(C) SNESNESCUBE64

ram_test_main:
    ;bit test
    ld iy, bit_test1_fill_return
    ld a, $a5
    ld b, $00
    jp ram_fill
bit_test1_fill_return:
    ld iy, bit_test1_bank2_check
    ld c, a
    ld hl, $6000
    exx
    ld c, $01
    exx
    jp ram_bit_check_readback
bit_test1_bank2_check:
    ld iy, bit_test1_bank3_check
    exx
    ld c, $04
    exx
    jp ram_bit_check_readback
bit_test1_bank3_check:
    ld iy, bit_test1_bank4_check
    exx
    ld c, $10
    exx
    jp ram_bit_check_readback
bit_test1_bank4_check:
    ld iy, bit_test2_fill_start
    ld hl, $7400
    exx
    ld c, $40
    exx
    jp ram_bit_check_readback

bit_test2_fill_start:
    ld iy, bit_test2_fill_return
    ld a, $5a
    jp ram_fill
bit_test2_fill_return:
    ld iy, bit_test2_bank2_check
    ld c, a
    ld hl, $6000
    exx
    ld c, $01
    exx
    jp ram_bit_check_readback
bit_test2_bank2_check:
    ld iy, bit_test2_bank3_check
    exx
    ld c, $04
    exx
    jp ram_bit_check_readback
bit_test2_bank3_check:
    ld iy, bit_test2_bank4_check
    exx
    ld c, $10
    exx
    jp ram_bit_check_readback
bit_test2_bank4_check:
    ld iy, ram_test_erase
    ld hl, $7400
    exx
    ld c, $40
    exx
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


ram_bit_check_readback:
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
    ld a, c
    or a, l
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
    ld a, c
    rlca
    or a, l
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

check_ram_results:
    ld iy, next_ram_validate_bit
    ld b, $08
ram_validate_loop:    
    rra
    jp c, bad_ram_result
    jp good_ram_result
next_ram_validate_bit:
    dec b
    jr nz, ram_validate_loop 
 check_ram_results_return:   
    jp (ix)

bad_ram_result:
    ld hl, $FFFF
    ld c, a
    ld a, $0f
    ld ($7D02), a
bad_delay_loop1:
    dec l
    jr nz, bad_delay_loop1
    dec h
    jr nz, bad_delay_loop1
    xor a
    ld ($7D02), a
    ld hl, $FFFF
    ld a, $02
bad_delay_loop2:
    dec l
    jr nz, bad_delay_loop2
    dec h
    jr nz, bad_delay_loop2
    dec a
    jr nz, bad_delay_loop2
    ld a, c
    jp (iy)

good_ram_result:
    ld hl, $FFFF
    ld c, a
    ld a, $0f
    ld ($7D01), a
good_delay_loop1:
    dec l
    jr nz, good_delay_loop1
    dec h
    jr nz, good_delay_loop1
    xor a
    ld ($7D01), a
    ld hl, $FFFF
    ld a, $02
good_delay_loop2:
    dec l
    jr nz, good_delay_loop2
    dec h
    jr nz, good_delay_loop2
    dec a
    jr nz, good_delay_loop2

    ld a, c
    jp (iy)

find_alt_sp:
    exx
    ld a, l
    exx
    ld b, a
    and $03
    jr nz, alt_sp_check2
    ld sp, $6400
    jr alt_sp_return
alt_sp_check2:
    ld a,b 
    and $0C
    jr nz, alt_sp_check3
    ld sp, $6800
    jr alt_sp_return
alt_sp_check3:
    ld a,b 
    and $30
    jr nz, alt_sp_check4
    ld sp, $6C00
    jr alt_sp_return
;This is in video RAM, it should be good enough for printing results...
alt_sp_check4:
    ld a,b 
    and $C0
    jp nz, dead_loop;No RAM is good, do NOT proceed
    ld sp, $7800
    jr alt_sp_return
alt_sp_return:

    jp (ix)
