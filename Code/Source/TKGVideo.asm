;TKG Hardware Test ROM
;(C) SNESNESCUBE64

video_all_character:
    ld a, $02
    call menu_select_palette+3

    call clear_screen
    
    ld a, ($7D00)
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

;Wrote this for the monitor test, might as well reuse
    jp monitor_test_return