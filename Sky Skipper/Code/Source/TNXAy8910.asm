;TNX Hardware Test ROM
;(C) SNESNESCUBE64

ay_init_command: DB $07, $BF, $08, $00, $09, $00, $0A, $0F, $0C, $02
ay_low_tone_command:       DB $1A, $00, $FF, $01, $01, $02, $FF, $03, $01, $04, $FF, $05, $01, $06, $00, $07, $B8, $08, $0F, $09, $0F, $0A, $0F, $0B, $0F, $0C, $0F
ay_high_tone_command:      DB $1A, $00, $DE, $01, $00, $02, $DE, $03, $00, $04, $DE, $05, $00, $06, $00, $07, $B8, $08, $0F, $09, $0F, $0A, $0F, $0B, $0F, $0C, $0F
ay_turn_off_sound_command: DB $1A, $00, $00, $01, $00, $02, $00, $03, $00, $04, $00, $05, $00, $06, $00, $07, $BF, $08, $00, $00, $00, $0A, $00, $0B, $00, $0C, $00


ay_init:
    ld hl, ay_init_command
    ld b, $0A
    ld c, $01
ay_init_loop:    
    dec c
    outi
    inc c
    outi
    jr nz, ay_init_loop:
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
