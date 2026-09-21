;TNX Hardware Test ROM
;(C) SNESNESCUBE64

ay_init_command:           DB $0A, $07, $BF, $08, $00, $09, $00, $0A, $0F, $0C, $02
ay_low_tone_command:       DB $1A, $00, $FF, $01, $01, $02, $FF, $03, $01, $04, $FF, $05, $01, $06, $00, $07, $B8, $08, $0F, $09, $0F, $0A, $0F, $0B, $0F, $0C, $0F
ay_high_tone_command:      DB $1A, $00, $DE, $01, $00, $02, $DE, $03, $00, $04, $DE, $05, $00, $06, $00, $07, $B8, $08, $0F, $09, $0F, $0A, $0F, $0B, $0F, $0C, $0F
ay_turn_off_sound_command: DB $1A, $00, $00, $01, $00, $02, $00, $03, $00, $04, $00, $05, $00, $06, $00, $07, $BF, $08, $0F, $09, $0F, $0A, $00, $0B, $00, $0C, $00


ay_init:
    ld hl, ay_init_command
    jp ay_execute_command


ay_channel_test:
    ld hl, string_sound_test
    ld de, string_sound_test_print_addr
    rst $20
    ld hl, string_line
    ld de, string_sound_test_print_addr+$20
    rst $20
    ld hl, string_channel
    ld de, string_sound_test_print_addr+$40
    rst $20
    ld de, $03FF
    or a
    sbc hl, de
    ld (hl), $0A
    ld hl, string_channel
    ld de, string_sound_test_print_addr+$60
    rst $20
    ld de, $03FF
    or a
    sbc hl, de
    ld (hl), $0B
    ld hl, string_channel
    ld de, string_sound_test_print_addr+$80
    rst $20
    ld de, $03FF
    or a
    sbc hl, de
    ld (hl), $0C

    ;Copy the off command to memory, we are going to modify that as our way 
    ld bc, $001B
    ld de, $8010
    ld hl, ay_turn_off_sound_command
    ldir

    ld ix, $8010
    call print_channel_status

    ld a, $0F
    ld (ix+$16), a
    ld (ix+$18), a
    ld (ix+$1A), a

    ld (ix+$10), $BE
    ld a, $20
channel_a_loop:
    push af
    ld (ix+2), a
    call print_channel_status
    push ix
    pop hl
    call ay_execute_command
    ld a, $02
    call delay
    pop af
    rlca
    jr nc, channel_a_loop
    ld a, (ix+4)
    and a
    jr nz, next_channel_a_byte
    inc (ix+4)
    ld a, $10
    jr channel_a_loop
next_channel_a_byte:
    rlca
    ld (ix+4), a
    cp $10
    ld a, $10
    jr nz, channel_a_loop

    xor a
    ld (ix+2), a
    ld (ix+4), a
    ld (ix+$10), $BD
    ld a, $20
channel_b_loop:
    push af
    ld (ix+6), a
    call print_channel_status
    push ix
    pop hl
    call ay_execute_command
    ld a, $02
    call delay
    pop af
    rlca
    jr nc, channel_b_loop
    ld a, (ix+8)
    and a
    jr nz, next_channel_b_byte
    inc (ix+8)
    ld a, $10
    jr channel_b_loop
next_channel_b_byte:
    rlca
    ld (ix+8), a
    cp $10
    ld a, $10
    jr nz, channel_b_loop

    xor a
    ld (ix+$06), a
    ld (ix+$08), a
    ld (ix+$10), $BB
    ld a, $20
channel_c_loop:
    push af
    ld (ix+$0A), a
    call print_channel_status
    push ix
    pop hl
    call ay_execute_command
    ld a, $02
    call delay
    pop af
    rlca
    jr nc, channel_c_loop
    ld a, (ix+$0C)
    and a
    jr nz, next_channel_c_byte
    inc (ix+$0C)
    ld a, $10
    jr channel_c_loop
next_channel_c_byte:
    rlca
    ld (ix+$0C), a
    cp $10
    ld a, $10
    jr nz, channel_c_loop

    xor a
    ld (ix+$0A), a
    ld (ix+$0C), a
    call print_channel_status
    
    call ay_turn_off_sound

    ret

print_channel_status:
    push af
    push de
    push hl
    ld b, $00

    ld hl, channel_location_print_addr
    ld a, (ix+$04)
    call print_two_digit
    ex de, hl
    ld a, (ix+$02)
    inc l
    call print_two_digit

    ld hl, channel_location_print_addr+$20
    ld a, (ix+$08)
    call print_two_digit
    ex de, hl
    ld a, (ix+$06)
    inc l
    call print_two_digit

    ld hl, channel_location_print_addr+$40
    ld a, (ix+$0C)
    call print_two_digit
    ld a, (ix+$0A)
    ex de, hl
    inc l
    call print_two_digit

    pop hl
    pop de
    pop af

    ret


ay_play_high_tone:
    ld hl, ay_high_tone_command
    jr ay_execute_command

ay_play_low_tone:
    ld hl, ay_low_tone_command
    jr ay_execute_command

ay_turn_off_sound:
    ld hl, ay_turn_off_sound_command
;hl should be the command
;first byte should be the length
ay_execute_command:
    ld b, (hl)
    inc hl
    ld c, $01
ay_execute_loop:    
    dec c
    outi
    inc c
    outi
    jr nz, ay_execute_loop:

    ret


ay_execute_command_ram_test:
    ld b, (hl)
    inc hl
    ld c, $01
ay_execute_loop_no_ram:    
    dec c
    outi
    inc c
    outi
    jr nz, ay_execute_loop_no_ram:


    ld hl, $ffff
    ld a, $03
delay_no_ram_loop:
    dec l
    jr nz, delay_no_ram_loop
    dec h
    jr nz, delay_no_ram_loop
    dec a
    jr nz, delay_no_ram_loop

    ld hl, ay_turn_off_sound_command
    ld b, (hl)
    inc hl
    ld c, $01
ay_execute_loop_no_ram2:    
    dec c
    outi
    inc c
    outi
    jr nz, ay_execute_loop_no_ram2:

    ld hl, $ffff
    ld a, $03
delay_no_ram_loop2:
    dec l
    jr nz, delay_no_ram_loop2
    dec h
    jr nz, delay_no_ram_loop2
    dec a
    jr nz, delay_no_ram_loop2

    jp (iy)
