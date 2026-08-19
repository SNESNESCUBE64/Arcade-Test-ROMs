;TKG Hardware Test ROM
;(C) SNESNESCUBE64

monitor_test_main:
    ld a, (menu_monitor_test_opt)
    and a
    jp z, monitor_checkerboard_test
    dec a
    jp z, monitor_grid_test
    dec a
    jp z, monitor_block_test
    ret

monitor_block_test:
    ld hl, $7400
    ld d, $4D
    ld bc, $0400
monitor_block_test_print:    
    ld a, ($7D00)
    ld (hl), d
    inc hl
    dec c
    jr nz, monitor_block_test_print
    dec b
    jr nz, monitor_block_test_print
    jp monitor_test_return

monitor_checkerboard_test:
    ld a, $01
    call menu_select_palette+3
    ld hl, $7400
    ld e,  $40
checkerboard_blanking:
    ld (hl), $10
    inc hl
    dec e
    jr nz, checkerboard_blanking

    ld b, $04
checkerboard_draw_start:
    ld c, $10
checkerboard_draw:
    ld de, $0404
checkerboard_odd1:
    ld (hl), $10
    inc hl
    dec d
    jr nz, checkerboard_odd1
checkerboard_even1:
    ld (hl), $4D
    inc hl
    dec e
    jr nz, checkerboard_even1
    dec c
    jr nz, checkerboard_draw
    ld c, $10
    dec b
    jr z, checkerboard_footer
checkerboard_draw2:   
    ld de, $0404
checkerboard_odd2:
    ld (hl), $4D
    inc hl
    dec d
    jr nz, checkerboard_odd2
checkerboard_even2:
    ld (hl), $10
    inc hl
    dec e
    jr nz, checkerboard_even2
    dec c
    jr nz, checkerboard_draw2

    jr checkerboard_draw_start

checkerboard_footer:
    ld e,  $40
checkerboard_blanking2:
    ld (hl), $10
    inc hl
    dec e
    jr nz, checkerboard_blanking2

    jp monitor_test_return

monitor_grid_test:
    ld a, $01
    call menu_select_palette+3
    ld hl, $7400  
    ld de, $3F3E
    ld bc, $4140
monitor_grid_test_print1:
    ld a, ($7D00)
    ld a, $20 
monitor_grid_test_loop1:
    ld (hl), d
    inc hl
    ld (hl), e
    inc hl
    sub $02
    jr nz, monitor_grid_test_loop1:
monitor_grid_test_print2:
    ld a, $20
monitor_grid_test_loop2: 
    ld (hl), b
    inc hl
    ld (hl), c
    inc hl
    sub $02
    jr nz, monitor_grid_test_loop2:
    ld a, $78
    cp h
    jr nz, monitor_grid_test_print1  

monitor_test_return:
    ld a, ($7D00)
    nop
    ld a, (in0_addr)
    and $10
    jr nz, monitor_test_return

monitor_test_cont_read:
    ld a, ($7D00)
    ld a, (in0_addr)
    and $10
    jr z, monitor_test_cont_read
    call menu_select_palette
    ld sp, $6C00
    jp TKGRuntime_Main