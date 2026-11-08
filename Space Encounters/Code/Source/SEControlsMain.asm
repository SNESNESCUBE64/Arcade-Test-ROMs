; Space Encounter Controls Test ROM
; SNESNESCUBE64

org $0000

lxi sp, $2400
jp main
init:

align $08
isr_halfbeam:
    jp isr_halfbeam_handler

align $10
isr_vblank:
    jp isr_vblank_handler

align $70
main:
    call clear_ram
    call process_encoders
    call process_abs_all
    call calculate_cursor_print_addr
    call calculate_hbar
    ;enable interrupts, all the drawings 
    ei
    
main_loop:
    call process_encoders
    call process_abs_all
    call calculate_cursor_print_addr
    call calculate_hbar
    ;pet the watchdog
    xra a
    out $02
    jp main_loop
include "SEControlsISR.asm"
include "SEControlsRAM.asm"
include "SEControlsEncoder.asm"
include "SEControlsVideo.asm"
include "SEControlsPrintWrappers.asm"
include "SEControlsDef.asm"