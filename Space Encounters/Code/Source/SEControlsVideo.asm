; Space Encounter Controls Test ROM
; SNESNESCUBE64

;Assume DE is the string address
;Assume HL is the print location
print_string:
    ;Grab the amount of characters to print
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldax d
    mov b, a
    inx d
print_string_loop:
    push d
    call get_character_address
    ;de is now the character that is getting printed
print_character_loop:
    
    pop d
    inx d
    dec b
    jnz print_string_loop
    ret

get_character_address:
    ldax d
    ;See if we have to decrement at all
    ana a
    jnz calculate_character_offset
    ;If we do not need to increment, just load the first character
    lxi d, char_a
    ret

calculate_character_offset:
    push b
    push h
    
    lxi b, $0000; c is down counter
    lxi d, $0000; d is offset
    lxi h, char_a
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
    ret
