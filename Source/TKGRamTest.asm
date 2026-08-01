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

ram_bit_check_readback:
    nop
    nop
    nop
    nop
    nop
    ld hl, $6000
    ld de, $0400
ram_bit_check_loop1:
    ld a, (hl)
    cp a, c
    jr z, ram_bit_check_bit_pass1
    exx
    ld a, l
    or a, $01
    ld l, a
    exx
ram_bit_check_bit_pass1:
    inc hl
    dec e
    jr nz, ram_bit_check_loop1
    dec d
    jr nz, ram_bit_check_loop1

    ld de, $0400
ram_bit_check_loop2:
    ld a, (hl)
    cp a, c
    jr z, ram_bit_check_bit_pass2
    exx
    ld a, l
    or a, $02
    ld l, a
    exx
ram_bit_check_bit_pass2:
    inc hl
    dec e
    jr nz, ram_bit_check_loop2
    dec d
    jr nz, ram_bit_check_loop2

    ld de, $0400
ram_bit_check_loop3:
    ld a, (hl)
    cp a, c
    jr z, ram_bit_check_bit_pass3
    exx
    ld a, l
    or a, $04
    ld l, a
    exx
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
    cp a, c
    jr z, ram_bit_check_bit_pass4
    exx
    ld a, l
    or a, $08
    ld l, a
    exx
ram_bit_check_bit_pass4:
    inc hl
    dec e
    jr nz, ram_bit_check_loop4
    dec d
    jr nz, ram_bit_check_loop4
    
    jp (iy)


process_ram_results:
    ld de, ram_test_header_address
    ld hl, string_ram_test
    call print

    ld de, ram_test_line_address
    ld hl, string_line
    call print

    ret
