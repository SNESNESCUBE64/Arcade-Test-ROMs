;TNX Hardware Test ROM
;(C) SNESNESCUBE64

;Constants
work_ram_size equ $0400
work_ram_bank_count equ $03
work_ram_start_addr equ $8000
default_stack_pointer equ $8400

video_ram_start_addr equ $A000
video_ram_size equ $0400
color_ram_start_addr equ $A400
color_ram_size equ $0400
background_ram_start_addr equ $C000
background_ram_size equ $1000
sprite_ram_start_addr equ $8C04
sprite_ram_size equ $0400



rom0_checksum_addr equ $0FC7
version_end_addr equ $0FFF
build_date_end_addr equ $0FF8

;Failure Masks
ram_0l_fail_mask equ $01
ram_0h_fail_mask equ $02
ram_0_fail_mask equ $0001
ram_1l_fail_mask equ $04
ram_1h_fail_mask equ $08
ram_1_fail_mask equ $0004
ram_2l_fail_mask equ $10
ram_2h_fail_mask equ $20
ram_2_fail_mask equ $0010

ram_bank_fail_mask equ $04
nmi_pass_mask equ $08
dma_fail_mask equ $10

sprite_test_mask equ $80

;Controls
in0_addr equ $7C00 ;p1 controls
in1_addr equ $7C80 ;p2 controls
in2_addr equ $7D00
dpsw_addr equ $7D80

;Variables
last_controls equ $6000
menu_palette_opt equ $6001
menu_invert_opt equ $6002
menu_monitor_test_opt equ $6003
menu_sound_opt equ $6004
menu_music_opt equ $6005
menu_selected_opt equ $6006
sprite_last_controls equ $6007

entire_background_layer_addr equ $8C03



;String Print Addresses
tkg_header_address equ $74E1
build_date_addr equ $74E2


;Strings - string followed by print addr if applicable
;String format - # of printable characters, text color, letters[n]
string_test_su_header:      DB $12, $06, $1D, $17, $21, $FF, $1C, $1D, $0A, $1B, $1D, $58, $1E, $19, $FF, $1D, $0E, $1C, $1D, $1C
string_test_header_addr equ $A067
string_any_button:          DB $1C, $08, $19, $1B, $0E, $1C, $1C, $FF, $0A, $17, $22, $FF, $0B, $1E, $1D, $1D, $18, $17, $FF, $1D, $18, $FF, $0C, $18, $17, $1D, $12, $17, $1E, $0E
string_any_button_addr equ $A362
string_text_test:           DB $09, $02, $1D, $0E, $21, $1D, $FF, $1D, $0E, $1C, $1D
string_text_test_addr equ $A06C
string_rom:                 DB $05, $00, $1B, $18, $16, $FF, $02
string_rom_0_print_addr equ $A131
string_ok:                  DB $02, $00, $18, $14
string_nok:                 DB $03, $00, $17, $18, $14
string_rom_test:            DB $08, $00, $1B, $18, $16, $FF, $1D, $0E, $1C, $1D
string_line:                DB $0D, $00, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66
string_rom_header_print_addr equ $A0F1

string_ram_test:            DB $08, $00, $1B, $0A, $16, $FF, $1D, $0E, $1C, $1D
string_ram:                 DB $05, $00, $1B, $0A, $16, $FF, $01
string_ram_0_print_addr equ $A121
string_ram_header_print_addr equ $A0E1

string_sound_test:          DB $0a, $00, $1C, $18, $1E, $17, $0D, $FF, $1D, $0E, $1C, $1D
string_sound_test_print_addr equ $A261
string_channel:             DB $07, $00, $0C, $11, $0A, $17, $17, $0E, $15
channel_location_print_addr equ $A2AC

align $0FC0
;                        2A     2B     2C     2D     2E     2F     2G     Pad
rom_known_checksums: DW $FFFF, $6B43, $9658, $6587, $DC0B, $F1C2, $5E5F, $0000
DB "TNX TEST 2A     SNESNESCUBE64   19SEP2026  V0.06"

ds $1000 - $
