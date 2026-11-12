; Space Encounters Encoders Test ROM
; SNESNESCUBE64

isr_halfbeam_handler:
    ei
    ret

isr_vblank_handler:
    push psw
    push b
    push d
    push h

    lda vblank_counter
    cpi $00
    cz print_bars
    cpi $01
    cz print_vbar
    ;cpi $02
    ;cz print_title_header
    cpi $02
    cz print_data_labels
    cpi $03
    cz print_bar_ticks
    inr a
    cpi $04
    jc vblank_return
    xra a
vblank_return:
    sta vblank_counter
    call print_data
    ;print cursor
    call print_cursor
    lxi h, data_header_print_addr + $0340
    lxi d, h_bin_string_addr
    call print_string
    lxi h, data_header_print_addr + $08C0
    lxi d, v_bin_string_addr
    call print_string
    pop h
    pop d
    pop b
    pop psw
    ei
    ret