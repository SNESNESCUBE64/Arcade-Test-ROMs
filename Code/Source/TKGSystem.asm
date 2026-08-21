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
