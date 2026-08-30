;TKG Hardware Test ROM
;(C) SNESNESCUBE64

invert_screen:
    xor a
    ld (screen_invert_addr), a
    ret

uninvert_screen:
    ld a, $01
    ld (screen_invert_addr), a
    ret

interrupt_enable:
    push af
    ld a, $01
    ld (int_enable_addr), a
    pop af
    ret

interrupt_disable:
    push af
    xor a
    ld (int_enable_addr), a
    pop af
    ret

system_select_palette:
    ld b, a
    and $01
    ld (palette_bit_0_addr), a
    ld a, b
    and $02
    rra
    ld (palette_bit_1_addr), a
    ret

clear_screen:
    ld iy, clear_screen_return
    xor a
    ld b, $10
    jp screen_ram_erase_start
clear_screen_return:
    ret

;c - length
;de - destination addr
;hl - source addr

print_utf8:
    ld ix, de
    ld de, $0020
print_utf8_loop:
    ld a, (hl)  
    sub $30
    cp a, $FE
    jr c, skip_letter_8
    ld a, $2B
skip_letter_8:
    ld (ix), a
    add ix, de
    dec hl
    dec c
    jr nz, print_utf8_loop
    ret

print_version_info:
    ld hl, build_date_end_addr
    ld de, build_date_addr
    ld c, $04
    call print_utf8
    add ix, de
    ld c, $03
    call print_utf8_loop
    add ix, de
    ld c, $02
    call print_utf8_loop
    add ix, de
    add ix, de
    ld hl, version_end_addr
    ld c, $05
    call print_utf8_loop
    ret