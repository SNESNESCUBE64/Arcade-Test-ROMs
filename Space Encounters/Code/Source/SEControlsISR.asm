; Space Encounter Controls Test ROM
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
    push psw
    cpi $00
    cz print_bars
    cpi $01
    cz print_vbar
    cpi $02
    cz print_title_header
    cpi $03
    cz print_data_labels
    pop psw
    inr a
    cpi $04
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