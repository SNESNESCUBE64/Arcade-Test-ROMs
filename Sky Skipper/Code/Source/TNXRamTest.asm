;TNX Hardware Test ROM
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
    ld hl, work_ram_start_addr
    exx
    ld c, ram_0l_fail_mask
    exx
    jp ram_bit_check_readback
bit_test1_bank2_check:
    ld iy, bit_test1_bank3_check
    exx
    ld c, ram_1l_fail_mask
    exx
    jp ram_bit_check_readback
bit_test1_bank3_check:
    ld iy, bit_test_count_check
    ld hl, work_ram_start_addr + (work_ram_size * 3)
    exx
    ld c, ram_2l_fail_mask
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
    ld bc, work_ram_start_addr
    ld de, ram_0_fail_mask
    exx
    jp pattern_test
pattern_test_2:
    ld iy, pattern_test_3
    exx
    ld bc, work_ram_start_addr + work_ram_size
    ld de, ram_1_fail_mask
    exx
    jp pattern_test
pattern_test_3:
    ld iy, bank_test_fill
    exx
    ld bc, work_ram_start_addr + (work_ram_size * 3)
    ld de, ram_2_fail_mask
    exx
    jp pattern_test
bank_test_fill:
;     ld iy, bank_test_compare
;     jp ram_bank_fill_all
; bank_test_compare:
;     ld iy, ram_test_erase
;     jp ram_bank_compare_all
; ram_test_erase:
;     ld iy, ram_test_return
;     jp ram_erase
ram_test_return:
    jp main


ram_erase:
    xor a
    ld b, $10
ram_fill:
    ld hl, work_ram_start_addr
    ld de, $1000
work_ram_erase:
    ld (hl), a
    inc hl
    dec e
    jr nz, work_ram_erase
    dec d
    jr nz, work_ram_erase
    jp (iy)

ram_bank_fill_all:
    ld a, $11
    ld bc, $1103
    ld hl, work_ram_start_addr
ram_bank_fill_all_loop1:
    ld ix, ram_fill_return1
    jp ram_bank_fill
ram_fill_return1:
    add b
    dec c
    jr nz, ram_bank_fill_all_loop1
    jp (iy)

; hl is the start address
; a is the fill value
ram_bank_fill:
    ld de, $0400
ram_bank_fill_loop:
    ld (hl), a
    inc hl
    dec e
    jr nz, ram_bank_fill_loop
    dec d
    jr nz, ram_bank_fill_loop
    jp (ix)

ram_bank_compare_all:
    ld a, $11
    ld bc, $1103
    ld hl, work_ram_start_addr
ram_bank_compare_all_loop1:
    ld ix, ram_compare_return1
    jp ram_bank_compare
ram_compare_return1:
    add b
    dec c
    jr nz, ram_bank_compare_all_loop1
    jp (iy)

; hl is the start address
; a is the fill value
ram_bank_compare:
    ld de, $0400
ram_bank_compare_loop:
    cp (hl)
    jr nz, ram_bank_fail
    inc hl
    dec e
    jr nz, ram_bank_compare_loop
    dec d
    jr nz, ram_bank_compare_loop
    jp (ix)
ram_bank_fail:
    exx
    ld a, h
    or ram_bank_fail_mask
    ld h, a
    exx
    jp (iy);why bother doing the rest, if one is bad there are A LOT of problems

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
    ld a,c
    and $f0
    ld b, a
    ld a, h
    and $f0
    cp b
    jr z, next_pattern_byte_error
    exx
    ;shift the error bit to the high error
    ld a, d
    rlca
    ld d, a
    ld a, e
    rlca
    ld e, a
    ;Set the error
    ld a, h
    or d
    ld h, a
    ld a, l
    or e
    ld l, a
    ;Shift the error bit back
    ld a, d
    rrca
    ld d, a
    ld a, e
    rrca
    ld e, a
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
    ld de, string_ram_header_print_addr
    ld hl, string_ram_test
    rst $20
    ld de, string_ram_header_print_addr+$20
    ld hl, string_line
    rst $20

    call rearrange_ram_error_bits

    xor a
    ld de, string_ram_0_print_addr
print_ram_loop_info:
    push af
    cp $02
    jr z, next_ram_ic
    cp $06
    jr z, next_ram_ic
    ld hl, string_ram
    push de
    rst $20
    or a
    ld de, $0400
    sbc hl, de
    add $0A
    ld (hl), a
    inc hl
    inc hl
    inc hl
    ex de, hl
    ld hl, string_nok
    exx
    ld a, l
    rrca
    ld l, a
    exx
    jr c, increment_ram_counter
    ld hl, string_ok
increment_ram_counter:
    rst $20
    ex de, hl
    add hl, de
    ex de, hl
    pop de
    ex de, hl
    ld bc, $0020
    add hl, bc
    ex de, hl
next_ram_ic:
    pop af
    inc a
    cp $08
    jr nz, print_ram_loop_info

    ret

rearrange_ram_error_bits:
    xor a
    exx
    bit 0, l
    jr z, rearrange_bit_1
    set 0, a
rearrange_bit_1:
    bit 2, l
    jr z, rearrange_bit_2
    set 1, a
rearrange_bit_2:
    bit 4, l
    jr z, rearrange_bit_3
    set 2, a
rearrange_bit_3:
    bit 1, l
    jr z, rearrange_bit_4
    set 3, a
rearrange_bit_4:
    bit 3, l
    jr z, rearrange_bit_5
    set 4, a
rearrange_bit_5:
    bit 5, l
    jr z, rearrange_done
    set 5, a
rearrange_done:
    ld l, a
    exx

    ret

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
    ld b, $03
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
    ld sp, work_ram_start_addr + work_ram_size
    jr alt_sp_return
alt_sp_check2:
    ld a,b 
    and $0C
    jr nz, alt_sp_check3
    ld sp, work_ram_start_addr + (work_ram_size * 2)
    jr alt_sp_return
alt_sp_check3:
    ld a,b 
    and $30
    jp nz, dead_loop
    ld sp, work_ram_start_addr + (work_ram_size * 4)
    jr alt_sp_return
alt_sp_return:

    jp (ix)

;DE - length
;HL - start address
;A - write value
mass_write:
    ld (hl), a
    inc hl
    dec e
    jr nz, mass_write
    dec d
    jr nz, mass_write
    ret

