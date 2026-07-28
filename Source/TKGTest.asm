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
    call analog_sound_test
    jr loop


invert_screen:
    push af
    ld a, $f0
    ld ($7d82), a
    pop af
    ret

uninvert_screen:
    push af
    ld a, $0f
    ld ($7d82), a
    pop af
    ret

delay_1s:
    push de
    push hl

    ld hl, $ffff
    ld de, $0001

delay_1s_loop:
    dec l
    jr nz, delay_1s_loop
    dec h
    jr nz, delay_1s_loop
    dec e
    jr nz, delay_1s_loop


    pop hl
    pop de
    
    ret

set_digital_sound:
    ld ($7C00), a
    ret

clear_analog_sounds:
    ret

toggle_walk_sound:
    push af

    ld a, $0f
    ld ($7D00), a
    call delay_1s
    ld a, $f0
    ld ($7D00), a

    pop af
    ret

toggle_jump_sound:
    push af

    ld a, $0f
    ld ($7D01), a
    call delay_1s
    ld a, $f0
    ld ($7D01), a

    pop af
    ret

toggle_boom_sound:
    push af

    ld a, $0f
    ld ($7D02), a
    call delay_1s
    ld a, $f0
    ld ($7D02), a

    pop af
    ret

analog_sound_test:
    call toggle_walk_sound
    ld a, $02
wait_analog_sound1:
    call delay_1s
    dec a
    jr nz, wait_analog_sound1
    call toggle_jump_sound
    ld a, $02
wait_analog_sound2:
    call delay_1s
    dec a
    jr nz, wait_analog_sound2
    call toggle_boom_sound
    ld a, $02
wait_analog_sound3:
    call delay_1s
    dec a
    jr nz, wait_analog_sound3
    ret
    
align $0FD0
DB "TKG Test ROM    SNESNESCUBE64   27 July 2026   ",$20


ds $1000 - $