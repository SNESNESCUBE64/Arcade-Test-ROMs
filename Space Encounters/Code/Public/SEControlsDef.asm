
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
cursor_carry equ cursor_pos + $02
previous_cursor_pos equ cursor_carry + $01
previous_cursor_carry equ previous_cursor_pos + $02
vblank_counter equ previous_cursor_carry + $01
hbar_string_addr equ vblank_counter + $01
h_bin_string_addr equ hbar_string_addr + $09
v_bin_string_addr equ h_bin_string_addr + $07
print_start_addr equ v_bin_string_addr + $07

;Constants
vram_start equ $2400
encoder_max equ $3F
vert_cursor_offset equ $08
se_encoder_center equ $1D
screen_center equ $0F
screen_center_word equ $000F
horiz_bar_char_full equ $29
horiz_bar_char_empty equ horiz_bar_char_full - $08

;Locations
space_encounters_print_addr equ $2508
controls_test_print_addr equ $2609
data_header_print_addr equ $2802

encoder_h_print_addr equ $2946
encoder_v_print_addr equ $2EC6

hbar_print_addr equ $3A0B
vbar_print_addr equ $2E1A

;sentences
align $0600
string_space_encounters: DB $10, $17, $15, $0A, $0C, $0E, $1D, $0E, $13, $0C, $14, $19, $13, $18, $0E, $16, $17
string_controls_test:    DB $0E, $0E, $13, $0C, $14, $0D, $0E, $16, $17, $1D, $1D, $18, $0E, $17, $18
string_horiz:            DB $05, $10, $14, $16, $11, $1B
string_vert:             DB $04, $1A, $0E, $16, $18
string_abs:              DB $04, $0A, $0B, $17, $1C
string_rel:              DB $04, $16, $0E, $12, $1C
string_cursor:           DB $01, $1E
string_cursor_half:      DB $02, $1F, $20
string_blank:            DB $02, $1D, $1D

; Font bytes
char_0: DB $00, $1C, $22, $32, $2A, $26, $22, $1C
char_1: DB $00, $08, $0C, $08, $08, $08, $08, $1C
char_2: DB $00, $1C, $22, $20, $10, $08, $04, $3E
char_3: DB $00, $1C, $22, $20, $18, $20, $22, $1C
char_4: DB $00, $10, $18, $14, $12, $3E, $10, $10
char_5: DB $00, $3E, $02, $1E, $20, $20, $22, $1C
char_6: DB $00, $18, $04, $02, $1E, $22, $22, $1C
char_7: DB $00, $3E, $20, $10, $08, $04, $04, $04
char_8: DB $00, $1C, $22, $22, $1C, $22, $22, $1C
char_9: DB $00, $1C, $22, $22, $3C, $20, $10, $0C
char_a: DB $00, $1C, $22, $22, $22, $3E, $22, $22
char_b: DB $00, $1E, $22, $22, $1E, $22, $22, $1E
char_c: DB $00, $1C, $22, $02, $02, $02, $22, $1C
char_d: DB $00, $0E, $12, $22, $22, $22, $12, $0E
char_e: DB $00, $3E, $02, $02, $1E, $02, $02, $3E
char_f: DB $00, $3E, $02, $02, $1E, $02, $02, $02
char_h: DB $00, $22, $22, $22, $3E, $22, $22, $22
char_i: DB $00, $1C, $08, $08, $08, $08, $08, $1C
char_l: DB $00, $02, $02, $02, $02, $02, $02, $3E
char_n: DB $00, $22, $22, $26, $2A, $32, $22, $22
char_o: DB $00, $1C, $22, $22, $22, $22, $22, $1C
char_p: DB $00, $1E, $22, $22, $1E, $02, $02, $02
char_r: DB $00, $1E, $22, $22, $1E, $0A, $12, $22
char_s: DB $00, $3C, $02, $02, $1C, $20, $20, $1E
char_t: DB $00, $3E, $08, $08, $08, $08, $08, $08
char_u: DB $00, $22, $22, $22, $22, $22, $22, $1C
char_v: DB $00, $22, $22, $22, $22, $22, $14, $08
char_z: DB $00, $3E, $20, $10, $08, $04, $02, $3E
char_colon: DB $00, $00, $02, $00, $00, $02, $00, $00
char_space: DB $00, $00, $00, $00, $00, $00, $00, $00
char_crosshair: DB $18, $18, $18, $E7, $E7, $18, $18, $18
char_crosshair_right: DB $80, $80, $80, $70, $70, $80, $80, $80
char_crosshair_left: DB $01, $01, $01, $0E, $0E, $01, $01, $01
char_hbar0: DB $FF, $81, $00, $00, $00, $00, $81, $FF
char_hbar1: DB $FF, $81, $01, $01, $01, $01, $81, $FF
char_hbar2: DB $FF, $83, $03, $03, $03, $03, $83, $FF
char_hbar3: DB $FF, $87, $07, $07, $07, $07, $87, $FF
char_hbar4: DB $FF, $8F, $0F, $0F, $0F, $0F, $8F, $FF
char_hbar5: DB $FF, $9F, $1F, $1F, $1F, $1F, $9F, $FF
char_hbar6: DB $FF, $BF, $3F, $3F, $3F, $3F, $BF, $FF
char_hbar7: DB $FF, $FF, $7F, $7F, $7F, $7F, $FF, $FF
char_hbar8: DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; Footer
align $07C0
DB "CHKSUM:", $FF, $FF, " PAD:", $00, $00
DB "SE Controls 1H  SNESNESCUBE64   10NOV2026  V0.05"

ds $800 - $
