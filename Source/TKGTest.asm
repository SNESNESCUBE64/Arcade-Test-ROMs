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

set_digital_sound:
    ld ($7C00), a
    ret

clear_analog_sounds:
    ret

toggle_walk_sound:
    push af

    ld a, $0f
    ld (walk_sound_addr), a
    call delay_1s
    ld a, $f0
    ld (walk_sound_addr), a

    pop af
    ret

toggle_jump_sound:
    push af

    ld a, $0f
    ld (jump_sound_addr), a
    call delay_1s
    ld a, $f0
    ld (jump_sound_addr), a

    pop af
    ret

toggle_boom_sound:
    push af

    ld a, $0f
    ld (boom_sound_addr), a
    call delay_1s
    ld a, $f0
    ld (boom_sound_addr), a

    pop af
    ret

analog_sound_test:
    ld bc, $0040
    ld a, $1
    ld ix, discrete_sound_test_addr
    ld (ix+0), a
    add ix, bc
    ld hl, string_sound_test
    call print_by_address_and_length
    ;Test walk sound
    call toggle_walk_sound
    ld a, $02
    call delay
    ld a, $2
    ld ix, discrete_sound_test_addr
    ld (ix+0), a
    ;Test Jump Sound
    call toggle_jump_sound
    ld a, $02
    call delay
    ld a, $3
    ld ix, discrete_sound_test_addr
    ld (ix+0), a
    ;Test Boom Sound
    call toggle_boom_sound
    ld a, $02
    call delay
    ret

;Assume that IX is our print location
;Assume that HL has our string
;Assume that '$3F' is our end character
print_by_address_and_length:
    push bc
    ld bc, $0020
load_character_by_addr:    
    ld a, (hl)
    cp $3F
    jr z, print_return
    ld (ix+0), a
    add ix, bc
    inc hl
    jr load_character_by_addr
print_return:
    pop bc
    ret

;Constants
discrete_sound_test_addr equ $75A2
screen_invert_addr equ $7d82
walk_sound_addr equ $7D00
jump_sound_addr equ $7D01
boom_sound_addr equ $7D02

;Strings
string_sound_test: DB $14, $1E, $25, $1F, $23, $10, $15, $24, $15, $22, $13, $23, $19, $14, $3F

align $0FD0
DB "TKG Test ROM    SNESNESCUBE64   28 July 2026   ",$20


ds $1000 - $