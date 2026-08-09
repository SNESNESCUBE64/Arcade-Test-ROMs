;TKG Hardware Test ROM
;(C) SNESNESCUBE64

TKGRuntime_Main:
;temporary until the menu can be written out.
    ;call audio_test_main
    ld de, tkg_header_address
    ld hl, string_tkg_runtime
    call print

    call runtime_controls_labels
    call print_menu
runtime_loop:    
    call runtime_controls_main
    call print_menu_selection
    call menu_handler
    jr runtime_loop

print_menu:
    ld de, menu_header_print_addr
    ld hl, string_test_select
    call print

    ld de, menu_line_print_addr
    ld hl, string_line
    call print

    ld de, string_reset
    push de
    ld de, menu_reset_print_addr
    push de
    ld de, string_music_set
    push de
    ld de, menu_music_print_addr
    push de
    ld de, string_sound_set
    push de
    ld de, menu_sound_print_addr
    push de
    ld de, string_monitor_test
    push de
    ld de, menu_monitor_print_addr
    push de
    ld de, string_invert_test
    push de
    ld de, menu_invert_print_addr
    push de
    ld de, string_palette_test
    push de
    ld de, menu_palette_print_addr
    push de

    ld a, (menu_selected_opt)
    ld b, a
    ld a, $00
menu_print_loop:
    pop de
    pop hl
    call print
    ;cp b
    ;jr nz, clear_selector
    ;ld (ix+$0), $FB
    ;jr next_menu_item
;clear_selector:
    ;ld (ix+$0), $10
;next_menu_item:
    inc a
    cp $06
    jr nz, menu_print_loop
    ret

print_menu_selection:
    ld a, (menu_selected_opt)
    ld b, a
    ld a, $00
    ld hl, $7796
    menu_print_loop2:
    cp b
    jr nz, clear_selector2
    ld (hl), $FB
    jr next_menu_item2
clear_selector2:
    ld (hl), $10
next_menu_item2:
    inc a
    inc l
    cp $06
    jr nz, menu_print_loop2
    ret

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
    jr c, move_opt_down
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
    ld c, a
    ld a, (menu_selected_opt)
    and a
    jp z, menu_change_palette
    ret

menu_change_palette:
    ld a, c
    rrca
    jr nc, move_palette_down
    ld a, (menu_palette_opt)
    inc a
    cp menu_max_palette
    jr nz, change_palette_return
    xor a
    jr change_palette_return
move_palette_down:
    ld a, (menu_palette_opt)
    dec a
    cp $ff
    jr nz, change_palette_return
    ld a, menu_max_palette - 1
change_palette_return:
    ld (menu_palette_opt), a
    ret


menu_select:
    ld a, (menu_selected_opt)
    and a
    jp z, menu_select_palette
    cp $01
    jp z, menu_invert_screen
    cp $05
    jp z, menu_reset_select
    ret

menu_select_palette:
    ld a, (menu_palette_opt)
    ld b, a
    and $01
    ld (palette_bit_0_addr), a
    ld a, b
    and $02
    rra
    ld (palette_bit_1_addr), a
    ret

menu_invert_screen:
    ld a, (menu_invert_opt)
    xor $01
    ld (menu_invert_opt), a
    jp z, uninvert_screen
    jp invert_screen


menu_reset_select:
    jp dead_loop


include "TKGControls.asm"