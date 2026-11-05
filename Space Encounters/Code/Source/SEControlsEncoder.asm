; Space Encounter Controls Test ROM
; SNESNESCUBE64

encoder_table: DB $3F, $3E, $3C, $3D, $39, $38, $3A, $3B
               DB $33, $32, $30, $31, $35, $34, $36, $37
	       DB $27, $26, $24, $25, $21, $20, $22, $23
	       DB $2B, $2A, $28, $29, $2D, $2C, $2E, $2F
	       DB $0F, $0E, $0C, $0D, $09, $08, $0A, $0B
	       DB $03, $02, $00, $01, $05, $04, $06, $07
	       DB $17, $16, $14, $15, $11, $10, $12, $13
	       DB $1B, $1A, $18, $19, $1D, $1C, $1E, $1F


process_encoders:
    ;read encoders
    mvi a, $02
    sta horiz_string_addr
    sta vert_string_addr
    in $00
    ani $3F
    sta horiz_raw_addr
    mov b, a
    ani $0F
    sta horiz_string_addr + $02
    mov a, b
    ani $30
    rrc
    rrc
    rrc
    rrc
    sta horiz_string_addr + $01
    in $01
    ani $3F
    sta vert_raw_addr
    mov b, a
    ani $0F
    sta vert_string_addr + $02
    mov a, b
    ani $30
    rrc
    rrc
    rrc
    rrc
    sta vert_string_addr + $01
    ret


process_abs_all:
    lda horiz_raw_addr
    mov b, a
    call process_abs
    sta horiz_rel_addr
    lda vert_raw_addr
    mov b, a
    call process_abs
    sta vert_rel_addr
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
    mov a, c
    ani $0F
    cpi $0A
    jnz process_abs_next
    inr c
    inr c
    inr c
    inr c
    inr c
    inr c
process_abs_next:
    dcr d
    jnz process_abs_loop
    ;We did not find what we needed, give a default value
    mvi a, $FF
    ret
process_abs_done:
    mov a, c
    ret


