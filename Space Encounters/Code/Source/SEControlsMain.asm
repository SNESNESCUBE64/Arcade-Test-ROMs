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
main_loop:
    ;read encoders
    in $00
    ani $3F
    sta $2000
    in $01
    ani $3F
    sta $2001

    ;pet the watchdog
    xra a
    out $02
    jp main_loop

include "SEControlsRAM.asm"
include "SEControlsDef.asm"