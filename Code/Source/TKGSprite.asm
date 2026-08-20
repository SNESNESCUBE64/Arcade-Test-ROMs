;TKG Hardware Test ROM
;(C) SNESNESCUBE64

sprite_test_main:
    call clear_screen
    exx
    ld a, h
    or $80
    ld h, a
    exx
    ld hl, $7000
    ld a, $80
    ld (hl), a
    inc l
    xor a
    ld (hl), a
    inc l
    ld a, $02
    ld (hl), a
    inc l
    ld a, $80
    ld (hl), $80

sprite_wait_for_button_release:
    ld a, ($7D00)
    nop
    ld a, (in0_addr)
    and $10
    jr nz, sprite_wait_for_button_release
    ld a, $0F
    ld ($7D84), a
sprite_loop:
    ld a, ($7D00)
    jr sprite_loop

sprite_handler:
    ld hl, $7741
    ld a, ($7000)
    call print_two_digit
    ld hl, $7742
    ld a, ($7003)
    call print_two_digit

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
    ld ($7D84), a
    exx
    ld a, h
    xor $80
    ld h, a
    exx
    ld a, $0F
    ld ($7D84), a
    ld sp, $6C00
    jp TKGRuntime_Main