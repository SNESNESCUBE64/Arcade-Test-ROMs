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
    call triggered_sound_test
    call music_sound_test
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

triggered_sound_test:
    ld bc, $0040
    ld ix, triggered_sound_test_addr
    add ix, bc
    ld hl, string_sound
    call print_by_address_and_length
    ld ix, triggered_sound_test_addr
    ld hl, walk_sound_addr
    ld a, $1
triggered_sound_loop:
    ld (ix+0), a
    ld b, a
    call toggle_discrete_feature
    ld a, $02
    call delay
    ld a, b
    inc l
    inc a
    cp $7
    jr nz, triggered_sound_loop
    ret

music_sound_test:
    ld bc, $0040
    ld ix, music_sound_test_addr
    add ix, bc
    ld hl, string_music
    call print_by_address_and_length
    ld ix, music_sound_test_addr
    ld hl, music_addr
    ld a, $1
music_sound_loop:
    ld (ix+0), a
    ld b, a
    ld (hl), a
    ld a, $05
    call delay
    xor a
    ld (hl), a
    ld a, $0A
    call delay
    ld a, b
    inc a
    cp $10
    jr nz, music_sound_loop
    xor a
    ld (hl), a
    ret

rom_check_main:
    ld hl, $0000 ;current address
    call rom_checksum_calculation
    ld hl, rom0_print_address
    ld a, c
    call print_two_digit
    ld a, b
    call print_two_digit
    ld de, $0040
    add hl, de
    ld (hl), $00
    add hl, de 
    ld ix, $0000
    ld de, hl
    add ix, de
    ld hl, string_rom
    call print_by_address_and_length
    
    ld hl, $1000 ;current address
    call rom_checksum_calculation
    ld hl, rom0_print_address
    inc hl
    ld a, c
    call print_two_digit
    ld a, b
    call print_two_digit
    ld de, $0040
    add hl, de
    ld (hl), $01
    add hl, de 
    ld ix, $0000
    ld de, hl
    add ix, de
    ld hl, string_rom
    call print_by_address_and_length

    ld hl, $1000 ;current address
    call rom_checksum_calculation
    ld hl, rom0_print_address
    inc hl
    ld a, c
    call print_two_digit
    ld a, b
    call print_two_digit
    ld de, $0040
    add hl, de
    ld (hl), $01
    add hl, de 
    ld ix, $0000
    ld de, hl
    add ix, de
    ld hl, string_rom
    call print_by_address_and_length

    ld hl, $2000 ;current address
    call rom_checksum_calculation
    ld hl, rom0_print_address
    inc hl
    inc hl
    ld a, c
    call print_two_digit
    ld a, b
    call print_two_digit
    ld de, $0040
    add hl, de
    ld (hl), $02
    add hl, de 
    ld ix, $0000
    ld de, hl
    add ix, de
    ld hl, string_rom
    call print_by_address_and_length

    ld hl, $3000 ;current address
    call rom_checksum_calculation
    ld hl, rom0_print_address
    inc hl
    inc hl
    inc hl
    ld a, c
    call print_two_digit
    ld a, b
    call print_two_digit
    ld de, $0040
    add hl, de
    ld (hl), $03
    add hl, de 
    ld ix, $0000
    ld de, hl
    add ix, de
    ld hl, string_rom
    call print_by_address_and_length

    ret

; Assume that HL is the start address
rom_checksum_calculation:
    ld a, $00
    ld bc, $0000 ;result
    ld de, $1000 ;counter

rom_add:
    add a, (hl)
    inc hl
    jr nc, rom_no_carry
    inc b
rom_no_carry:   
    ld c, a
    dec de
    ld a, d
    or a, e
    ret z
    ld a,c
    jr rom_add



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

;prints a two digit character from a
;assumes hl is the print address
;assumes a is what is being printed
print_two_digit:
    push bc
    push de
    ld de, $0020

    ld b, a
    and a, $0F
    cp a, $0A
    jr c, skip_first_letter
    add a, $07
skip_first_letter:
    ld (hl), a
    add hl, de
    ld a, b
    and a, $F0
    rra
    rra
    rra
    rra
    cp a, $0A
    jr c, skip_second_letter
    add a, $07
skip_second_letter:
    ld (hl), a
    add hl, de
    pop de
    pop bc
    ret


include "TKG_Def.asm"