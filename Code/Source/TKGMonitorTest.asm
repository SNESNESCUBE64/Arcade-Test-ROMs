;TKG Hardware Test ROM
;(C) SNESNESCUBE64

monitor_test_main:
    ld a, (menu_monitor_test_opt)
    and a
    jp z, monitor_block_test
    dec a
    jp z, monitor_grid_test
    ret

monitor_block_test:
    ld hl, $7400
    ld d, $4E
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

monitor_grid_test:
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

    ld sp, $6C00
    jp TKGRuntime_Main