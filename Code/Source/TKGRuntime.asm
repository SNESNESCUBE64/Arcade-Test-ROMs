;TKG Hardware Test ROM
;(C) SNESNESCUBE64

TKGRuntime_Main:
;temporary until the menu can be written out.
    ;call audio_test_main
    ld de, tkg_header_address
    ld hl, string_tkg_runtime
    call print
runtime_loop:    
    call runtime_controls_main
    call menu_handler
    jr runtime_loop

menu_handler:
    ld a, (in0_addr)
    ld b, a
    ld a, (last_controls)
    cp b
    ret z ;return if they are exactly the same
    ld a, b 
    ld (last_controls), a
    and a
    ret z;return if nothing is pressed
    and $0C
    call nz, change_menu_item
    ld a, b
    and $03
    call nz, change_menu_option
    ld a, b
    and $10
    call nz, menu_select

;Add debounce delay

    ret

change_menu_item:
    rrca
    rrca
    rrca
    jr nc, move_opt_down
    ld a, (menu_selected_opt)
    inc a
    cp menu_max_opt
    jr nz, change_menu_item_return
    xor a
    jr change_menu_item_return
move_opt_down:
    ld a, (menu_selected_opt)
    dec a
    cp $ff
    jr nz, change_menu_item_return
    ld a, menu_max_opt - 1
change_menu_item_return:
    ld (menu_selected_opt), a
    ret

change_menu_option:
    ret

menu_select:
    ret

include "TKGControls.asm"