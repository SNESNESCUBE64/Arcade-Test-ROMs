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

audio_test_main:
    ld ix, $0000
    ld de, audio_header_address
    add ix, de
    ld hl, string_audio_test
    call print_by_address_and_length

    ld ix, $0000
    ld de, audio_line_address
    add ix, de
    ld hl, string_line
    call print_by_address_and_length

    call triggered_sound_test
    call music_sound_test
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
    ld b, a
    cp a, $0A
    jr c, music_not_letter
    add a, $07
music_not_letter:
    ld (ix+0), a
    ld (hl), b
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
    ld ix, $0000
    ld de, rom_test_header_address
    add ix, de
    ld hl, string_rom_checksums
    call print_by_address_and_length

    ld ix, $0000
    ld de, rom_test_line_address
    add ix, de
    ld hl, string_line
    call print_by_address_and_length

    ld a, $04
    ld hl, $0000 ;starting address
checksum_loop:
    call rom_checksum_calculation
    push bc
    dec a
    jr nz, checksum_loop
    ld a, $04
print_loop:
    ld hl, rom0_print_address
    dec a
    ld b, 00
    ld c, a
    add hl, bc
    pop bc
    inc a
    push af
    ld a, c
    call print_two_digit
    ld a, b
    call print_two_digit
    pop af
    dec a
    ld de, $0040
    add hl, de
    ld (hl), a
    add hl, de 
    ld ix, $0000
    ld de, hl
    add ix, de
    ld hl, string_rom
    call print_by_address_and_length
    jr nz, print_loop
    ret


; Assume that HL is the start address
rom_checksum_calculation:
    push af
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
    jr z, checksum_finish
    ld a,c
    jr rom_add
checksum_finish:
    pop af
    ret



;Assume that IX is our print location
;Assume that HL has our string
;Assume that '$3F' is our end character
print_by_address_and_length:
    push af
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
    pop af
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