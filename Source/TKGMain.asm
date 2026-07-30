;TKG Hardware Test ROM
;(C) SNESNESCUBE64

org $0000
init: 
    ld sp, $6BFF
    jp code_start

align $66
nmi_routine:
    push af
    push bc
    push de
    push hl
    push ix
    push iy   
    ld a, ($7D00)
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    ret


align $100
code_start:
;Clear all of RAM
    ld hl, $6000
    ld de, $0C00
    xor a
work_ram_erase:
    ld (hl), a
    inc hl
    dec e
    jr nz, work_ram_erase
    dec d
    jr nz, work_ram_erase
    ld hl, $7000
    ld de, $0400
sprite_ram_erase:
    ld (hl), a
    inc hl
    dec e
    jr nz, sprite_ram_erase
    dec d
    jr nz, sprite_ram_erase
    ld hl, $7400
    ld de, $0400
    or $10
video_ram_erase:
    ld (hl), a
    inc hl
    dec e
    jr nz, video_ram_erase
    dec d
    jr nz, video_ram_erase
    
    call uninvert_screen
    xor a

;This is just a test routine. No real work is being done at this point. This should be replaced later.
loop:
    call rom_check_main
    call audio_test_main
    jr loop


invert_screen:
    push af
    ld a, $f0
    ld (screen_invert_addr), a
    pop af
    ret

uninvert_screen:
    push af
    ld a, $0f
    ld (screen_invert_addr), a
    pop af
    ret

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

include "TKGRomTest.asm"
include "TKGAudioTest.asm"
include "TKGPrint.asm"
include "TKG_Def.asm"