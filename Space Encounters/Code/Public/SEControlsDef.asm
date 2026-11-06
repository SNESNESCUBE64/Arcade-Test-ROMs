
;Variable Address Locations
horiz_string_addr equ $2000
horiz_raw_addr equ horiz_string_addr + $03
horiz_rel_string_addr equ horiz_raw_addr + $01
horiz_rel_addr equ horiz_rel_string_addr + $03
vert_string_addr equ horiz_rel_addr + $01
vert_raw_addr equ vert_string_addr + $03
vert_rel_string_addr equ vert_raw_addr + $01
vert_rel_addr equ vert_rel_string_addr + $03
cursor_pos equ vert_rel_addr + $01
previous_cursor_pos equ cursor_pos + $02
vblank_counter equ previous_cursor_pos + $02

;Constants
vram_start equ $2400
encoder_max equ $3F
vert_cursor_offset equ $08

;Locations
space_encounters_print_addr equ $2508
controls_test_print_addr equ $2609

encoder_h_print_addr equ $2946
encoder_h_rel_print_addr equ $2A46
encoder_v_print_addr equ $2DC6
encoder_v_rel_print_addr equ $2DC6

data_header_print_addr equ $2802

;sentences
string_space_encounters: DB $10, $1C, $19, $0A, $0C, $0E, $28, $0E, $17, $0C, $18, $1E, $17, $1D, $0E, $1B, $1C
string_controls_test:    DB $0E, $0C, $18, $17, $1D, $1B, $18, $15, $1C, $28, $28, $1D, $0E, $1C, $1D
string_horiz:            DB $05, $11, $18, $1B, $12, $23
string_vert:             DB $04, $1F, $0E, $1B, $1D
string_abs:              DB $04, $0A, $0B, $1C, $26
string_rel:              DB $04, $1B, $0E, $15, $26
string_cursor:           DB $01, $21
string_blank:            DB $01, $28


; Font bytes
align $0678
;$00
char_0:     DB $00, $1C, $22, $32, $2A, $26, $22, $1C
char_1:     DB $00, $08, $0C, $08, $08, $08, $08, $1C
char_2:     DB $00, $1C, $22, $20, $10, $08, $04, $3E
char_3:     DB $00, $1C, $22, $20, $18, $20, $22, $1C
char_4:     DB $00, $10, $18, $14, $12, $3E, $10, $10
char_5:     DB $00, $3E, $02, $1E, $20, $20, $22, $1C
char_6:     DB $00, $18, $04, $02, $1E, $22, $22, $1C
char_7:     DB $00, $3E, $20, $10, $08, $04, $04, $04
char_8:     DB $00, $1C, $22, $22, $1C, $22, $22, $1C
char_9:     DB $00, $1C, $22, $22, $3C, $20, $10, $0C
char_a:     DB $00, $1C, $22, $22, $22, $3E, $22, $22
char_b:     DB $00, $1E, $22, $22, $1E, $22, $22, $1E
char_c:     DB $00, $1C, $22, $02, $02, $02, $22, $1C
char_d:     DB $00, $0E, $12, $22, $22, $22, $12, $0E
char_e:     DB $00, $3E, $02, $02, $1E, $02, $02, $3E
char_f:     DB $00, $3E, $02, $02, $1E, $02, $02, $02
;$10
char_g:     DB $00, $1C, $22, $02, $3A, $22, $22, $3C
char_h:     DB $00, $22, $22, $22, $3E, $22, $22, $22
char_i:     DB $00, $1C, $08, $08, $08, $08, $08, $1C
char_j:     DB $00, $20, $20, $20, $20, $20, $22, $1C
char_k:     DB $00, $22, $12, $0A, $06, $0A, $12, $22
char_l:     DB $00, $02, $02, $02, $02, $02, $02, $3E
char_m:     DB $00, $22, $36, $2A, $2A, $22, $22, $22
char_n:     DB $00, $22, $22, $26, $2A, $32, $22, $22
char_o:     DB $00, $1C, $22, $22, $22, $22, $22, $1C
char_p:     DB $00, $1E, $22, $22, $1E, $02, $02, $02
char_q:     DB $00, $1C, $22, $22, $22, $2A, $12, $2C
char_r:     DB $00, $1E, $22, $22, $1E, $0A, $12, $22
char_s:     DB $00, $3C, $02, $02, $1C, $20, $20, $1E
char_t:     DB $00, $3E, $08, $08, $08, $08, $08, $08
char_u:     DB $00, $22, $22, $22, $22, $22, $22, $1C
char_v:     DB $00, $22, $22, $22, $22, $22, $14, $08
;$20
char_w:     DB $00, $22, $22, $22, $2A, $2A, $36, $22
char_x:     DB $00, $22, $22, $14, $08, $14, $22, $22
char_y:     DB $00, $22, $22, $22, $14, $08, $08, $08
char_z:     DB $00, $3E, $20, $10, $08, $04, $02, $3E
char_lp:    DB $00, $10, $08, $04, $04, $04, $08, $10
char_rp:    DB $00, $04, $08, $10, $10, $10, $08, $04
char_colon: DB $00, $00, $02, $00, $00, $02, $00, $00
char_dash:  DB $00, $00, $00, $00, $1E, $00, $00, $00
char_space: DB $00, $00, $00, $00, $00, $00, $00, $00

; Footer
align $07C0
DB "CHKSUM:", $FF, $FF, " PAD:", $00, $00
DB "SE Controls 1H  SNESNESCUBE64   05NOV2026  V0.03"

ds $800 - $
