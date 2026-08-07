;TKG Hardware Test ROM
;(C) SNESNESCUBE64

runtime_controls_main:
    call print_controls_labels
    ret

print_controls_labels:
    ld de, p1_controls_start_address
    ld b, $06   
p1_print_loop:
    ld hl, string_p1
    call print
    inc e
    dec b
    jr nz, p1_print_loop
    
    ld iy, after_controls_stack_routine
    jp load_controls_strings
after_controls_stack_routine:
    ld b, $06
    ld de, p1_controls_down_addr
p1_labels_print:
    pop hl
    call print
    inc e
    dec b
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

    ret
    
load_controls_strings:
    ld a, $02
load_controls_strings_loop:
    ld de, string_start
    push de
    ld de, string_jump
    push de
    ld de, string_right
    push de
    ld de, string_left
    push de
    ld de, string_up
    push de
    ld de, string_down
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
