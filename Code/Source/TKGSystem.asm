;TKG Hardware Test ROM
;(C) SNESNESCUBE64

invert_screen:
    push af
    ld a, $f0
    ld (screen_invert_addr), a
    pop af
    ret

uninvert_screen:
    push af
    ld a, $0f
    ld (screen_invert_addr), a
    pop af
    ret

interrupt_enable:
    push af
    ld a, $0f
    ld ($7D84), a
    pop af
    ret

set_background_palette_0:
    push af
    xor a
    ld (palette_bit_0_addr), a
    ld (palette_bit_1_addr), a
    pop af
    ret

set_background_palette_1:
    push af
    xor a
    ld (palette_bit_0_addr), a
    inc a
    ld (palette_bit_1_addr), a
    pop af
    ret

set_background_palette_2:
    push af
    xor a
    ld (palette_bit_1_addr), a
    inc a
    ld (palette_bit_0_addr), a
    pop af
    ret

set_background_palette_3:
    push af
    ld a, $01
    ld (palette_bit_0_addr), a
    ld (palette_bit_1_addr), a
    pop af
    ret

clear_screen:
    ld iy, clear_screen_return
    xor a
    ld b, $10
    jp screen_ram_erase_start
clear_screen_return:
    ret
