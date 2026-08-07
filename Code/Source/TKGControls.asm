;TKG Hardware Test ROM
;(C) SNESNESCUBE64

runtime_controls_main:
    ld de, controls_test_header_address
    ld hl, string_controls_test
    call print

    ld de, controls_test_line_address
    ld hl, string_line
    call print

    call print_controls_labels
    call print_controls_state
    ret

print_controls_labels:
    ld iy, after_controls_stack_routine
    jp load_controls_strings
after_controls_stack_routine:
    
    ld de, p1_controls_start_address
    ld a, $06   
p1_print_loop:
    ld hl, string_p1
    call print
    inc e
    dec a
    jr nz, p1_print_loop
    
    ld a, $06
    ld de, p1_controls_down_addr 
p1_labels_print:
    pop hl
    call print
    inc e
    dec a
    jr nz, p1_labels_print

    ld de, p2_controls_start_address
    ld b, $06   
p2_print_loop:
    ld hl, string_p2
    call print
    inc e
    dec b
    jr nz, p2_print_loop

    ld b, $06
    ld de, p2_controls_down_addr
p2_labels_print:
    pop hl
    call print
    inc e
    dec b
    jr nz, p2_labels_print

    ld de, coin_print_addr
    ld hl, string_coin
    call print

    ret
    
load_controls_strings:
    ld a, $02
load_controls_strings_loop:
    ld de, string_start
    push de
    ld de, string_jump
    push de
    ld de, string_down
    push de
    ld de, string_up
    push de
    ld de, string_left
    push de
    ld de, string_right
    push de
    dec a
    jr nz, load_controls_strings_loop
    jp (iy)

; load_controls_strings:
;     ld a, $0C
;     ld de, $0006
;     ld hl, string_down
; load_controls_strings_loop:
;     add hl, de
;     push hl
;     dec a
;     jr nz, load_controls_strings_loop
;     jp (iy)

print_controls_state:
    ld a, (in2_addr)
    rlca
    ld hl, string_off
    ld de, coin_state_addr
    jr nc, coin_state_print:
    ld hl, string_on
coin_state_print:
    call print
    rrca
    ld c, a

    ld de, p1_controls_addr
    ld b, $05  
    ld a, (in0_addr)
p1_controls_loop:
    ld hl, string_off
    rra
    jr nc, p1_controls_state_print:
    ld hl, string_on
p1_controls_state_print:
    call print
    inc e
    dec b
    jr nz, p1_controls_loop

    ld a,c
    rrca
    rrca
    rrca
    ld hl, string_off
    jr nc, p1_start_state_print:
    ld hl, string_on
p1_start_state_print:
    call print
    ld c,a

    ld de, p2_controls_addr
    ld b, $05  
    ld a, (in1_addr)
p2_controls_loop:
    ld hl, string_off
    rra
    jr nc, p2_controls_state_print:
    ld hl, string_on
p2_controls_state_print:
    call print
    inc e
    dec b
    jr nz, p2_controls_loop

    ld a,c
    rrca
    ld hl, string_off
    jr nc, p2_start_state_print:
    ld hl, string_on
p2_start_state_print:
    call print
    ld c,a

    ret
