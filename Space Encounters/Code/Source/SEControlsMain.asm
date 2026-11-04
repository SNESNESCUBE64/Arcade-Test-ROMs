; Space Encounter Controls Test ROM
; SNESNESCUBE64

org $0000

lxi sp, $2400
call clear_ram
jp main
init:

align $66
nmi_routine:
    jp main

align $100
main:
    lxi h, space_encounters_print_addr
    lxi d, string_space_encounters
    call print_string
    lxi h, controls_test_print_addr
    lxi d, string_controls_test
    call print_string
    lxi h, encoder_h_print_addr - $02
    lxi d, string_h
    call print_string
    lxi h, encoder_v_print_addr - $02
    lxi d, string_v
    call print_string
main_loop:
    ;read encoders
    mvi a, $02
    sta $2000
    sta $2003
    in $00
    mov b, a
    ani $0F
    sta $2002
    mov a, b
    ani $30
    rrc
    rrc
    rrc
    rrc
    sta $2001
    in $01
    mov b, a
    ani $0F
    sta $2005
    mov a, b
    ani $30
    rrc
    rrc
    rrc
    rrc
    sta $2004

    ;Print the addresses
    lxi d, $2000
    lxi h, encoder_h_print_addr
    call print_string
    lxi d, $2003
    lxi h, encoder_v_print_addr
    call print_string

    ;pet the watchdog
    xra a
    out $02
    jp main_loop

include "SEControlsRAM.asm"
include "SEControlsVideo.asm"
include "SEControlsDef.asm"