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
    dec b
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
