;TKG Hardware Test ROM
;(C) SNESNESCUBE64

video_all_character:
    ld a, $02
    call menu_select_palette+3

    call clear_screen
    
    ld a, (watchdog_addr)
    ld hl, $74E8
    ld de, $0010
    ld bc, $1010
    ld a, $0F
character_print_loop:
    ld (hl), a
    inc hl
    add $10
    dec c
    jr nz, character_print_loop
    ld c, $10
    add hl, de
    dec a
    dec b
    jr nz, character_print_loop

    ld hl, $74C7
    ld de, $0020
    ld bc, $13F0
character_grid_top:
    ld (hl), c
    add hl, de
    dec b
    jr nz, character_grid_top

    ld hl, $76E6
    ld a, $F0
    ld b, $13
character_grid_side:
    ld (hl), a
    inc l
    dec b
    jr nz, character_grid_side

    ld a, $0F
    ld hl, $74E6
    ld de, $0020
    ld bc, $100F
character_grid_top_id:
    call print_hex
    dec c
    ld a, c
    add hl, de
    dec b
    jr nz, character_grid_top_id

    ld hl, $7708
    ld a, $00
    ld bc, $1000
character_grid_side_id:
    call print_hex
    inc c
    ld a, c
    inc l
    dec b
    jr nz, character_grid_side_id

    ld de, test_menu_print_addr
    ld hl, string_return
    rst $20

    ld de, test_menu_print_addr-$3F
    ld hl, string_background_p1
    rst $20

background_test_return:
    ld a, (watchdog_addr)
    nop
    ld a, (in0_addr)
    and $10
    jr nz, background_test_return

background_test_cont_read:
    ld a, (watchdog_addr)
    and $04
    call nz, background_bank_select
    ld a, (in0_addr)
    and $10
    jr z, background_test_cont_read
    call menu_select_palette
    ld sp, default_stack_pointer
    jp djr_runtime_main

background_bank_select:
    ld a, (background_current_bank)
    xor $01
    ld (background_current_bank), a
    ld (background_bank_addr), a
background_bank_select_return:
    ld a, (watchdog_addr)
    and $04
    jr nz, background_bank_select_return
    ret
