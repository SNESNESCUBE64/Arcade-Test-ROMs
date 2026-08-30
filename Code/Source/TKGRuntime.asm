;TKG Hardware Test ROM
;(C) SNESNESCUBE64

TKGRuntime_Main:
    ;Disable NMI, we don't want it running anymore
    call interrupt_disable
    call clear_screen

    ld de, tkg_header_address
    ld hl, string_tkg_runtime
    rst $20

    call print_version_info

    call runtime_controls_labels
    call print_menu
    
runtime_loop:
    ;refresh the watchdog
    ld a, (watchdog_addr)
    ;attempt to clear the dead sound if applicatble
    xor a
    ld (dead_sound_addr), a
    ;main runtime functions 
    call runtime_controls_main
    call print_menu_selection
    call print_menu_values
    call menu_handler
    jr runtime_loop

print_menu:
    ld de, menu_header_print_addr
    ld hl, string_test_select
    rst $20

    ld de, menu_line_print_addr
    ld hl, string_line
    rst $20

    ld de, string_reset
    push de
    ld de, menu_reset_print_addr
    push de
    ld de, string_sprite_test
    push de
    ld de, menu_sprite_print_addr
    push de
    ld de, string_bg_test
    push de
    ld de, menu_bg_print_addr
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
    rst $20
    inc a
    cp menu_max_opt
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
    cp menu_max_opt
    jr nz, menu_print_loop2
    ret

print_menu_values:
    ld b, $05
    ld hl, menu_value_print_addr
    ld de, menu_palette_opt
menu_print_value_loop:
    ld a, (de)
    call print_hex
    inc e
    inc l
    dec b
    jr nz, menu_print_value_loop
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
    ld a, (last_controls)
    and $0C
    call nz, change_menu_item
    ld a, (last_controls)
    and $03
    call nz, change_menu_option
    ld a, (last_controls)
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
    ld de, menu_palette_opt
    ld hl, menu_constants
    and a
    jp z, menu_change_option_value
    inc e
    inc e
    inc hl
    cp $02
    jp z, menu_change_option_value
    inc e
    inc hl
    cp $03
    jp z, menu_change_option_value
    inc e
    inc hl
    cp $04
    jp z, menu_change_option_value
    ret

menu_change_option_value:
    ld a, (hl)
    ld b, a
    ld a, c
    rrca
    jr nc, move_option_value_down
    ld a, (de)
    inc a
    cp b
    jr nz, change_option_value_return
    xor a
    jr change_option_value_return
move_option_value_down:
    ld a, (de)
    dec a
    cp $ff
    jr nz, change_option_value_return
    dec b
    ld a, b
change_option_value_return:
    ld (de), a
    ret

menu_select:
    ld a, (menu_selected_opt)
    and a
    jp z, menu_select_palette
    dec a
    jp z, menu_invert_screen
    dec a
    jp z, monitor_test_main
    dec a
    jp z, menu_select_sound
    dec a
    jp z, menu_select_music
    dec a
    jp z, video_all_character
    dec a
    jp z, sprite_test_main
    dec a
    jp z, menu_reset_select
    ret

menu_select_palette:
    ld a, (menu_palette_opt)
    call system_select_palette
    ret

menu_invert_screen:
    ld a, (menu_invert_opt)
    xor $01
    ld (menu_invert_opt), a
    jp z, uninvert_screen
    jp invert_screen

menu_select_sound:
    ld a, (menu_sound_opt)
    cp $06
    jr z, menu_play_dead_sound
    ld hl, walk_sound_addr
    add a, l
    ld l, a
    ld a, $0F
    ld (hl), a
    ld b, $FF
    ld c, $20
menu_sound_play_delay:
    dec b
    jr nz, menu_sound_play_delay
    dec c
    jr nz, menu_sound_play_delay
    ld a, $F0
    ld (hl), a
    ret
menu_play_dead_sound:    
    ld a, $01
    ld (dead_sound_addr), a
    ret

menu_select_music:
    ld a, (menu_music_opt)
    ld (music_addr), a
    ret

menu_reset_select:
    call clear_screen

    ld de, menu_reset_pw_print_addr
    ld hl, string_reset_pw
    rst $20   

    ld de, menu_reset_ip_print_addr
    ld hl, string_reset_ip
    rst $20

    ld hl, $0FEC
    ld de, build_date_addr+$60
    ld c, $0D
    call print_utf8

    jp dead_loop


include "TKGControls.asm"
include "TKGMonitorTest.asm"
include "TKGVideo.asm"
include "TKGSprite.asm"
