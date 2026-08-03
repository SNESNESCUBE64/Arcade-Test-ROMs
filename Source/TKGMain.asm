;TKG Hardware Test ROM
;(C) SNESNESCUBE64

org $0000
init: 
    ld sp, $6C00
    ld ix, main ;Load the jump address into iy, RAM stuff is all inline
    ;Clear the result buffer
    xor a
    exx
    ld b, a
    ld c, a
    ld d, a
    ld e, a
    ld h, a
    ld l, a
    exx
    ;start the tests
    jp ram_test_main

align $66
nmi_routine:
    exx
    ld b, a
    ld a, ($7D00)
    ld a, $01
    ld h, a
    ;ld a, $0f
    ;ld (interrupt_enable), a
    ld a, b
    exx
    ret


align $A0

main:
    ld ix, post_ram_test
post_ram_test:
    call uninvert_screen
    call set_background_palette_2
    xor a
    call process_ram_results
;This is just a test routine. No real work is being done at this point. This should be replaced later.
loop:
    call rom_check_main
    call audio_test_main
    ;call interrupt_enable ;currently causes a crash during the sound test
    jr loop


delay_1s:
    ld a, $01
;assume a is the coundown so long as a is greater than one.
delay:
    push hl

    ld hl, $ffff

delay_loop:
    dec l
    jr nz, delay_loop
    dec h
    jr nz, delay_loop
    dec a
    jr nz, delay_loop

    pop hl
    ret

;this will toggle something like an analog sound or screen flip depending on what is required
;assumes hl is the address
;works with walk, jump, and boom sounds
toggle_discrete_feature:
    push af

    ld a, $0f
    ld (hl), a
    call delay_1s
    ld a, $f0
    ld (hl), a

    pop af
    ret

include "TKGSystem.asm"
include "TKGRomTest.asm"
include "TKGRamTest.asm"
include "TKGAudioTest.asm"
include "TKGPrint.asm"
include "TKG_Def.asm"