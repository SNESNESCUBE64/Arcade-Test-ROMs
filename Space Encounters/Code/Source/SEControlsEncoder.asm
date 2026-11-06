; Space Encounter Controls Test ROM
; SNESNESCUBE64

encoder_table: DB $3F, $3E, $3C, $3D, $39, $38, $3A, $3B ;7
               DB $33, $32, $30, $31, $35, $34, $36, $37 ;15
	       DB $27, $26, $24, $25, $21, $20, $22, $23 ;23
	       DB $2B, $2A, $28, $29, $2D, $2C, $2E, $2F ;31
	       DB $0F, $0E, $0C, $0D, $09, $08, $0A, $0B ;39
	       DB $03, $02, $00, $01, $05, $04, $06, $07 ;47
	       DB $17, $16, $14, $15, $11, $10, $12, $13 ;56
	       DB $1B, $1A, $18, $19, $1D, $1C, $1E, $1F ;63


process_encoders:
    in $00
    ani $3F
    sta horiz_raw_addr
    lxi h, horiz_string_addr
    call create_encoder_string
    in $01
    ani $3F
    sta vert_raw_addr
    lxi h, vert_string_addr
    call create_encoder_string
    ret


process_abs_all:
    lda horiz_raw_addr
    mov b, a
    call process_abs
    sta horiz_rel_addr
    lxi h, horiz_rel_string_addr
    call create_encoder_string
    lda vert_raw_addr
    mov b, a
    call process_abs
    sta vert_rel_addr
    lxi h, vert_rel_string_addr
    call create_encoder_string
    ret

;assume B is processing value
process_abs:
    lxi h, encoder_table
    mvi c, $00
    mvi d, $40
process_abs_loop:
    mov a, m
    cmp b
    jz process_abs_done
    inx h
    inr c
    ;Convert to base 10
;     mov a, c
;     ani $0F
;     cpi $0A
;     jnz process_abs_next
;     inr c
;     inr c
;     inr c
;     inr c
;     inr c
;     inr c
; process_abs_next:
    dcr d
    jnz process_abs_loop
    ;We did not find what we needed, give a default value
    mvi a, $FF
    ret
process_abs_done:
    mov a, c
    ret

;Assume A is the print value
;Assume HL is the start address
create_encoder_string:	    
    mov b, a
    mvi a, $02
    mov m, a
    inx h
    mov a, b
    ani $30
    rrc
    rrc
    rrc
    rrc
    mov m, a
    inx h
    mov a, b
    ani $0F
    mov m, a
    ret

