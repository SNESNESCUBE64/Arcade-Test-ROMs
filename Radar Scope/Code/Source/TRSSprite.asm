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

    xor a
    call system_select_palette

    call sprite_color_palette

    exx
    ld a, h
    or sprite_test_mask
    ld h, a
    exx
    ld hl, sprite_ram_start_addr
    ld a, $80
    ld (hl), a
    inc l
    xor a
    ld (hl), a
    inc l
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
    call interrupt_enable
sprite_loop:
    ld a, (watchdog_addr)
    jr sprite_loop

sprite_handler:
    ld bc, $0020
    ld hl, $7721
    ld a, (sprite_ram_start_addr)
    call print_two_digit
    ld (hl), $2E
    add hl, bc
    ld (hl), $28
    ld hl, $7722
    ld a, (sprite_ram_start_addr+3)
    call print_two_digit
    ld (hl), $2E
    add hl, bc
    ld (hl), $29
    ld hl, $7723
    ld a, (sprite_ram_start_addr+1)
    call print_two_digit
    ld (hl), $2E
    add hl, bc
    ld (hl), $23
    ld hl, $7724
    ld a, (sprite_ram_start_addr+2)
    call print_two_digit
    ld (hl), $2E
    add hl, bc
    ld (hl), $20

    call sprite_down
    ld a, (in0_addr)
    rrca
    jr c, sprite_right
    rrca
    jr c, sprite_left
    rrca
    rrca
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

sprite_down:
    ld hl, sprite_ram_start_addr+3
    inc (hl)
    ret
sprite_left:
    ld hl, sprite_ram_start_addr
    dec (hl)
    ret
sprite_right:
    ld hl, sprite_ram_start_addr
    inc (hl)
    ret

sprite_runtime_return:
    call interrupt_disable
    exx
    ld a, h
    xor $80
    ld h, a
    exx
    call interrupt_enable
    ld a, (menu_palette_opt)
    call system_select_palette
    ld sp, default_stack_pointer
    jp TKGRuntime_Main

sprite_palette_inc:
    ld hl, sprite_ram_start_addr+2
    inc (hl)
    ld a, (hl)
    cp $10
    ret nz
    xor a
    ld (hl), a
    ret

sprite_sprite_inc:
    ld hl, sprite_ram_start_addr+1
    inc (hl)
    ret

sprite_color_palette:
    xor a
    ld de, $1000
    ld hl, $10F0
    ld ix, sprite_ram_start_addr+4
sprite_color_palette_loop:
    ld (ix+0), h
    add hl, de
    inc ix
    ld (ix+0), $0E
    inc ix
    ld (ix+0), a
    inc ix
    ld (ix+0), l
    inc ix
    inc a
    cp $10
    jr nz, sprite_color_palette_loop
    ret
