;TKG Hardware Test ROM
;(C) SNESNESCUBE64

ram_test_main:
    ;bit test
    ld a, $00;Start pattern
    exx
    ld d, $10;number of increments
    exx
bit_test_start:
    ld iy, bit_test1_fill_return
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
    ld iy, bit_test1_bank5_check
    ld hl, $7000
    exx
    ld c, $40
    exx
    jp ram_bit_check_readback
bit_test1_bank5_check:
    ld iy, bit_test_count_check
    ld hl, $7400
    exx
    ld c, h
    ld h, l
    ld l, c
    ld c, $01
    exx
    jp ram_bit_check_readback
bit_test_count_check:
    exx
    ld c, h
    ld h, l
    ld l, c
    ld a, e
    add $11
    ld e, a
    dec d
    exx
    jp nz, bit_test_start
    ;jp ram_test_erase
pattern_test_1:
    ld iy, pattern_test_2
    exx
    ld bc, $6000
    ld de, $0001
    exx
    jp pattern_test
pattern_test_2:
    ld iy, pattern_test_3
    exx
    ld bc, $6400
    ld de, $0004
    exx
    jp pattern_test
pattern_test_3:
    ld iy, pattern_test_4
    exx
    ld bc, $6800
    ld de, $0010
    exx
    jp pattern_test
pattern_test_4:
    ld iy, pattern_test_5
    exx
    ld bc, $7000
    ld de, $0040
    exx
    jp pattern_test
pattern_test_5:
    ld iy, ram_test_erase
    exx
    ld bc, $7400
    ld de, $0100
    exx
    jp pattern_test
ram_test_erase:
    ld iy, ram_test_return
    jp ram_erase
ram_test_return:
    jp main


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
screen_ram_erase_start:
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

;Assume IX is the start address
;Assume DE' is the Fail Mask
;Assume HL' is the results
pattern_test:
    ld a, $11;Byte Start
    ld l, $10;How many times we are gonna run this
pattern_specified_start_fill:
    ld de, $0400
    ld ix, $0000
    exx
    add ix, bc
    exx
pattern_byte_loop:
    ld (ix+0), a
    nop;Wait for a proper write
    nop
    nop
    nop
    ld h, (ix+0)
    cp h
    jr z, next_pattern_byte
    ;Byte Failure
    ld c, a;This will not work. We need to figure out which RAM failed
    and $0f
    ld b, a
    ld a, h
    and $0f
    cp b
    jr z, pattern_high_nibble
    exx
    ld a, h
    or d
    ld h, a
    ld a, l
    or e
    ld l, a
    exx
pattern_high_nibble:
    exx
    ld a, d
    rlca
    ld d, a
    ld a, e
    rlca
    ld e, a
    exx
    ld a,c
    and $f0
    ld b, a
    ld a, h
    and $f0
    cp b
    jr z, next_pattern_byte_error
    exx
    ld a, h
    or d
    ld h, a
    ld a, l
    or e
    ld l, a
    exx
next_pattern_byte_error:
    ld a, c
next_pattern_byte:
    add $11
    jr nc, pattern_fill_prep_next
    ld a, $11
pattern_fill_prep_next:
    inc ix
    dec e
    jr nz, pattern_byte_loop
    dec d
    jr nz, pattern_byte_loop
    dec l
    jr nz, pattern_specified_start_fill

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
    rst $20

    ld de, ram_test_line_address
    ld hl, string_line
    rst $20

    ;Copy the results to preserve original test
    exx
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
    rst $28
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
    rst $28
    inc c
    ld a, $06;The number of RAM results
    cp c
    jr z, print_ram_results_2_main
    jr print_ram_results_loop

print_ram_results_2_main:
    ;Copy the results to preserve original test
    exx
    ld a, l
    and $C0
    ld b, a
    ld a, h
    or $80
    xor $80
    or b
    rlca
    rlca
    ld e, a
    exx

    ld bc, $0000
print_ram_results_loop2:
    ld de, ram3l_print_address
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
    jr nc, print_ram_test_result2
    ld hl, string_bad
print_ram_test_result2:
    rst $28
    ld de, $0040
    add ix, de
    ld (ix+$00), $1C
    ld a, c
    and $01
    jr z, print_ram_id2:
    ld (ix+$00), $18
print_ram_id2:
    ld a, c
    rra 
    and $03 
    add $03  
    ld (ix+$20), a
    sub $03
    ld e, $60
    add ix, de
    ld hl, string_ram
    rst $28
    inc c
    ld a, $04;The number of RAM results
    cp c
    ret z
    jr print_ram_results_loop2

check_ram_results:
    exx 
    ld a, l
    exx
    ld iy, next_lower_ram_validate_bit
    ld b, $08
lower_ram_validate_loop:    
    rra
    jp c, bad_ram_result
    jp good_ram_result
next_lower_ram_validate_bit:
    dec b
    jr nz, lower_ram_validate_loop

    exx 
    ld a, h
    exx
    ld iy, next_upper_ram_validate_bit
    ld b, $02
upper_ram_validate_loop:    
    rra
    jp c, bad_ram_result
    jp good_ram_result
next_upper_ram_validate_bit:
    dec b
    jr nz, upper_ram_validate_loop

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
;This is in sprite RAM, it should be good enough for printing results...
alt_sp_check4:
    ld a,b 
    and $C0
    jp nz, alt_sp_check5;
    ld sp, $7400
    jr alt_sp_return
;This is in video RAM, it should be good enough for printing results...
alt_sp_check5:
    exx
    ld a, h
    exx
    and $03
    jp nz, dead_loop;No RAM is good, do NOT proceed
    ld sp, $7800
    jr alt_sp_return
alt_sp_return:

    jp (ix)
