; Space Encounter Controls Test ROM
; SNESNESCUBE64

;Assume DE is the string address
;Assume HL is the print location
print_string:
    ;Grab the amount of characters to print
    ldax d
    mov b, a
    inx d
print_string_loop:
    push d
    call get_character_address
    ;de is now the character that is getting printed
    call print_character
    pop d
    inx d
    dcr b
    jnz print_string_loop
    ret

get_character_address:
    ldax d
    ;See if we have to decrement at all
    ana a
    jnz calculate_character_offset
    ;If we do not need to increment, just load the first character
    lxi d, char_0
    ret

calculate_character_offset:
    push b
    push h
    
    lxi b, $0000; c is down counter
    lxi d, $0000; d is offset
    lxi h, char_0
    mov c, a
    xra a
character_address_loop:
    adi $08
    jnc next_char_address
    inr d
next_char_address:
    dcr c
    jnz character_address_loop

    mov e, a
    dad d
    push h;transfer back to de
    pop d
    pop h;reset
    pop b
    ret

;Assume DE is the character data
;Assume HL is the print address
print_character:
    push h
    push b
    lxi b, $0820
    mvi a, $08
print_character_loop:
    ldax d
    inx d
    mov m, a
    mov a, b
    mvi b, $00
    dad b
    mov b, a
    dcr b
    jnz print_character_loop
print_character_return:
    pop b
    pop h
    inx h
    ret

calculate_cursor_print_addr:
    lxi h, vram_start
    lxi d, $00C0
    
    lda vert_rel_addr
    mov b, a
    mvi a, encoder_max - vert_cursor_offset
    sub b
    inr a

vpos_cursor_loop:
    dcr a
    jz vpos_cursor_end
    dad d
    jp vpos_cursor_loop
vpos_cursor_end:

;Calculate horizontal cursor
lda horiz_rel_addr
cpi se_encoder_center
jz horiz_pos_center
jc horiz_pos_right
horiz_pos_left:
    sub se_encoder_center
    mov c, a
    cma
    ani $01
    sta cursor_carry
    mov a, c
    rar ;divide by 2
    mov b, a
    mvi a, screen_center
    sub b
    mov e, a
    mvi d, $00
    jp horiz_pos_finish
horiz_pos_right:
    ;ora a ;clear the carry flag
    mov b, a
    mvi a, se_encoder_center
    sub b
    mov c, a
    ani $01
    sta cursor_carry
    mov a, c
    rar ;divide by 2
    adi screen_center
    mov e, a
    mvi d, $00
    jp horiz_pos_finish
horiz_pos_center:
    ;Load the center value 
    lxi d, screen_center_word
    xra a
    sta cursor_carry
horiz_pos_finish:
    dad d
    shld cursor_pos
    ret

    shld cursor_pos
    ret

calculate_hbar:
    mvi a, $08
    lxi h, hbar_string_addr
    mov m, a
    inx h
    mov b, a
    mov c, a
    lda horiz_rel_addr
    mov c, a
    mvi a, encoder_max
    sub c;This is now how far we have to print
    mvi c, $08

calculate_hbar_loop:
    cpi $08
    jc hbar_nonzero
    mvi m, horiz_bar_char_full
    sub b
    jp hbar_next
hbar_nonzero:
    ana a
    jz hbar_zero
    mov b, a
    mvi a, $08
    sub b
    mov b, a
    mvi a, horiz_bar_char_full
    sub b
    mov m, a
    sub a
    jp hbar_next
hbar_zero:
    mvi m, horiz_bar_char_empty
hbar_next:    
    inx h
    dcr c
    jnz calculate_hbar_loop
    ret

print_vbar:
    lxi h, vbar_print_addr
    lxi d, $0020
    lda vert_rel_addr
    mov c, a
    mvi a, $40
    sub c
    mov b, a
    xra a

print_vbar_loop1:
    ana a
    jnz print_vbar_loop1_7
    mvi m, $C3
    inr a
    jp print_vbar_loop1_next
print_vbar_loop1_7:
    cpi $07
    jnz print_vbar_loop1_else
    mvi m, $C3
    xra a
    jp print_vbar_loop1_next
print_vbar_loop1_else:
    mvi m, $81
    inr a
print_vbar_loop1_next:
    dad d
    dcr b
    jnz print_vbar_loop1

    mvi a, $FF
print_vbar_loop2:
    mov m, a
    dad d
    dcr c
    jnz print_vbar_loop2

    ret

