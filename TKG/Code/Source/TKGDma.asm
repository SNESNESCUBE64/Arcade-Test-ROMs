;TKG Hardware Test ROM
;(C) SNESNESCUBE64

;Copy $6900 - 6A80 to $7000 - $7180
dma_parameters: DB $53, $00, $69, $80, $41, $00, $70, $80, $81

execute_dma:
    ld hl, dma_parameters
    xor a
    ld ($7D85), a
    ld a, (hl)
    ld ($7808), a
    inc hl
    ld a, (hl)
    ld ($7800), a
    inc hl
    ld a, (hl)
    ld ($7800), a
    inc hl
    ld a, (hl)
    ld ($7801), a
    inc hl
    ld a, (hl)
    ld ($7801), a
    inc hl
    ld a, (hl)
    ld ($7802), a
    inc hl
    ld a, (hl)
    ld ($7802), a
    inc hl
    ld a, (hl)
    ld ($7803), a
    inc hl
    ld a, (hl)
    ld ($7803), a
    ld a, $01
    ld ($7D85), a
    xor a
    ld ($7D85), a
    ret

dma_test_main:
    ;fill sprite RAM:
    ld a, $AA
    call dma_test
    ld a, $55
    call dma_test
    ld a, $00
    call dma_test
    ret

dma_test:
    ld hl, $6900
    ld de, $0280
dma_fill_loop:
    ld (hl), a
    inc hl
    dec e
    jr nz, dma_fill_loop
    dec d
    jr nz, dma_fill_loop

    call execute_dma
    call delay_1s

dma_compare:
    ld hl, $6900
    ld ix, $7000
    ld de, $0280
dma_comp_loop:
    ld a, (ix)
    ld b, (hl)
    cp b
    jr z, dma_pass
    exx
    ld a, h
    or dma_fail_mask
    ld h, a
    exx
dma_pass:
    inc hl
    inc ix
    dec e
    jr nz, dma_comp_loop
    dec d
    jr nz, dma_comp_loop
    ret

