; Space Encounter Controls Test ROM
; SNESNESCUBE64

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
    lxi h, data_header_print_addr + $580
    lxi d, string_vert
    call print_string
    lxi h, data_header_print_addr + $6C0
    lxi d, string_abs
    call print_string
    lxi h, data_header_print_addr + $7C0
    lxi d, string_rel
    call print_string
    ret

print_bars:
    lxi h, hbar_print_addr
    lxi d, hbar_string_addr
    call print_string
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

print_cursor:
    lhld cursor_pos
    mov d, h
    mov e, l
    lhld previous_cursor_pos
    mov a, h
    sub d
    jnz start_cursor_print
    mov a, l
    sub e
    jnz start_cursor_print 
    lda previous_cursor_carry
    mov b, a
    lda cursor_carry
    cmp b
    rz ;We have the same address if zero, don't bother printing
start_cursor_print:
    lda cursor_carry
    ana a
    jnz print_half_cursor
    lhld previous_cursor_pos
    lxi d, string_blank
    call print_string
    lhld cursor_pos
    shld previous_cursor_pos
    lxi d, string_cursor
    call print_string
    xra a
    sta previous_cursor_carry
    ret
print_half_cursor:
    lhld previous_cursor_pos
    lxi d, string_blank
    call print_string
    lhld cursor_pos
    shld previous_cursor_pos
    lxi d, string_cursor_half
    call print_string
    mvi a, $01
    sta previous_cursor_carry
    ret