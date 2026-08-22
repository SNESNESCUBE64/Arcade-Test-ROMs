;TKG Hardware Test ROM
;(C) SNESNESCUBE64

sprite_test_main:
    call clear_screen

    ld de, test_menu_print_addr-$02
    ld hl, string_return
    rst $20
   
    ld de, test_menu_print_addr-$61
    ld hl, string_p1_mes
    rst $20
   
    ld de, test_menu_print_addr-$40
    ld hl, string_p2_mes
    rst $20

    call sprite_color_palette

    exx
    ld a, h
    or sprite_test_mask
    ld h, a
    exx
    ld hl, $7000
    ld a, $80
    ld (hl), a
    inc l
    xor a
    ld (hl), a
    inc l
    ;ld a, $02
    ld (hl), a
    inc l
    ld a, $80
    ld (hl), $80

sprite_wait_for_button_release:
    ld a, (watchdog_addr)
    nop
    ld a, (in0_addr)
    and $10
    jr nz, sprite_wait_for_button_release
    ld a, $0F
    ld (int_enable_addr), a
sprite_loop:
    ld a, (watchdog_addr)
    jr sprite_loop

sprite_handler:
    ld bc, $0020
    ld hl, $7721
    ld a, ($7000)
    call print_two_digit
    ld (hl), $2E
    add hl, bc
    ld (hl), $28
    ld hl, $7722
    ld a, ($7003)
    call print_two_digit
    ld (hl), $2E
    add hl, bc
    ld (hl), $29
    ld hl, $7723
    ld a, ($7001)
    call print_two_digit
    ld (hl), $2E
    add hl, bc
    ld (hl), $23
    ld hl, $7724
    ld a, ($7002)
    call print_two_digit
    ld (hl), $2E
    add hl, bc
    ld (hl), $20

    ld a, (in0_addr)
    rrca
    jr c, sprite_right
    rrca
    jr c, sprite_left
    rrca
    jr c, sprite_up
    rrca
    jr c, sprite_down
    rrca
    jr c, sprite_runtime_return

    ld a, (in2_addr)
    ld hl, sprite_last_controls
    cp (hl)
    ret z
    ld (hl), a
    rrca
    rrca
    rrca
    jr c, sprite_sprite_inc
    rrca
    jr c, sprite_palette_inc

    ret

sprite_up:
    ld hl, $7003
    dec (hl)
    ret
sprite_down:
    ld hl, $7003
    inc (hl)
    ret
sprite_left:
    ld hl, $7000
    dec (hl)
    ret
sprite_right:
    ld hl, $7000
    inc (hl)
    ret

sprite_runtime_return:
    xor a
    ld (int_enable_addr), a
    exx
    ld a, h
    xor $80
    ld h, a
    exx
    ld a, $0F
    ld (int_enable_addr), a
    ld sp, $6C00
    jp TKGRuntime_Main

sprite_palette_inc:
    ld hl, $7002
    inc (hl)
    ld a, (hl)
    cp $10
    ret nz
    xor a
    ld (hl), a
    ret

sprite_sprite_inc:
    ld hl, $7001
    inc (hl)
    ret

sprite_color_palette:
    xor a
    ld de, $1000
    ld hl, $10F0
    ld ix, $7004
sprite_color_palette_loop:
    ld (ix+0), h
    add hl, de
    inc ix
    ld (ix+0), $BA
    inc ix
    ld (ix+0), a
    inc ix
    ld (ix+0), l
    inc ix
    inc a
    cp $10
    jr nz, sprite_color_palette_loop
    ret
