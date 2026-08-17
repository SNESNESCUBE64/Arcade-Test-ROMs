;TKG Hardware Test ROM
;(C) SNESNESCUBE64

runtime_controls_labels:
    ld de, controls_test_header_address
    ld hl, string_controls_test
    rst $20

    ld de, controls_test_line_address
    ld hl, string_line
    rst $20

    ld de, dip_sw_header_addr
    ld hl, string_dip_sw_test
    rst $20

    ld de, dip_sw_line_addr
    ld hl, string_line
    rst $20
    
    call print_controls_labels

runtime_controls_main:
    call print_controls_state
    call print_dip_switches
    ret

print_controls_labels:
    ld iy, after_controls_stack_routine
    jp load_controls_strings
after_controls_stack_routine:
    
    ld de, p1_controls_start_address
    ld a, $06   
p1_print_loop:
    ld hl, string_p1
    rst $20
    inc e
    dec a
    jr nz, p1_print_loop
    
    ld a, $06
    ld de, p1_controls_down_addr 
p1_labels_print:
    pop hl
    rst $20
    inc e
    dec a
    jr nz, p1_labels_print

    ld de, p2_controls_start_address
    ld b, $06   
p2_print_loop:
    ld hl, string_p2
    rst $20
    inc e
    dec b
    jr nz, p2_print_loop

    ld b, $06
    ld de, p2_controls_down_addr
p2_labels_print:
    pop hl
    rst $20
    inc e
    dec b
    jr nz, p2_labels_print

    ld de, coin_print_addr
    ld hl, string_coin
    rst $20

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
    rst $20
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
    rst $20
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
    rst $20
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
    rst $20
    inc e
    dec b
    jr nz, p2_controls_loop

    ld a,c
    rrca
    ld hl, string_off
    jr nc, p2_start_state_print:
    ld hl, string_on
p2_start_state_print:
    rst $20
    ld c,a

    ret

print_dip_switches:
    ld a, (dpsw_addr)
    ld bc, $1808
    ld de, $0020
    ld hl, dip_switch_info_addr
dip_info_print_loop:
    ld (hl), b
    dec l
    rlca
    jr nc, dip_print_0:
    ld (hl), $01
    jr dip_next_sw
dip_print_0:
    ld (hl), $00
dip_next_sw:
    inc l
    dec b
    dec c
    add hl, de
    jr nz, dip_info_print_loop

    ret