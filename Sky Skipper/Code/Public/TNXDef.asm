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
sprite_ram_size equ $27C



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


;Strings - string followed by print addr
string_text_test: DB $09, $02, $1D, $0E, $21, $1D, $FF, $1D, $0E, $1C, $1D
string_text_test_addr equ $A06C


align $0FC0
DB "CHKSUM:", $FF, $FF, " PAD:", $00, $00
DB "TNX TEST 2A     SNESNESCUBE64   12SEP2026  V0.01"

ds $1000 - $
