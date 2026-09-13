;TNX Hardware Test ROM
;(C) SNESNESCUBE64

ay_init_command: DB $07, $BF, $08, $00, $09, $00, $0A, $0F, $0C, $02
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