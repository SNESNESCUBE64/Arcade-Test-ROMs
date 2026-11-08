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
    call calculate_hbar
    ;enable interrupts, all the drawings 
    ei
    ;call print_data_labels
    ;call print_title_header
main_loop:
    call process_encoders
    call process_abs_all
    call calculate_cursor_print_addr
    call calculate_hbar
    ;pet the watchdog
    xra a
    out $02
    jp main_loop

print_title_header:
    lxi h, space_encounters_print_addr
    lxi d, string_space_encounters
    call print_string
    lxi h, controls_test_print_addr
    lxi d, string_controls_test
    call print_string
    ret

print_data_labels:
    lxi h, data_header_print_addr
    lxi d, string_horiz
    call print_string
    lxi h, data_header_print_addr + $140
    lxi d, string_abs
    call print_string
    lxi h, data_header_print_addr + $240
    lxi d, string_rel
    call print_string
    lxi h, data_header_print_addr + $480
    lxi d, string_vert
    call print_string
    lxi h, data_header_print_addr + $5C0
    lxi d, string_abs
    call print_string
    lxi h, data_header_print_addr + $6C0
    lxi d, string_rel
    call print_string
    ret

print_bars:
    nop
    nop
    nop
    nop
    nop
    nop
    push psw
    lxi h, hbar_print_addr
    lxi d, hbar_string_addr
    call print_string
    pop psw
    ret

print_data:
    ;Print the addresses
    lxi d, horiz_string_addr
    lxi h, encoder_h_print_addr
    call print_string
    lxi d, horiz_rel_string_addr
    lxi h, encoder_h_print_addr+$100
    call print_string
    lxi d, vert_string_addr
    lxi h, encoder_v_print_addr
    call print_string
    lxi d, vert_rel_string_addr
    lxi h, encoder_v_print_addr+$100
    call print_string
    ret

isr_halfbeam_handler:
    push psw
    push b
    push d
    push h
    lda vblank_counter
    cpi $00
    cz print_title_header
    cpi $08
    cz print_data_labels
    inr a
    cpi $10
    jc half_beam_return
    xra a
half_beam_return:
    sta vblank_counter
    pop h
    pop d
    pop b
    pop psw
    ei
    ret

isr_vblank_handler:
    push psw
    push b
    push d
    push h

    lda vblank_counter
    cpi $02
    cz print_bars
    inr a
    cpi $10
    jc vblank_return
    xra a
vblank_return:
    sta vblank_counter
    call print_data
    ;print cursor
    lhld previous_cursor_pos
    lxi d, string_blank
    call print_string
    lhld cursor_pos
    shld previous_cursor_pos
    lxi d, string_cursor
    call print_string
    pop h
    pop d
    pop b
    pop psw
    ei
    ret

include "SEControlsRAM.asm"
include "SEControlsEncoder.asm"
include "SEControlsVideo.asm"
include "SEControlsDef.asm"