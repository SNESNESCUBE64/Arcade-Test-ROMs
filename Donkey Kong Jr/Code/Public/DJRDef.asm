;Constants
work_ram_size equ $0400
work_ram_bank_count equ $03
video_ram_size equ $0400
video_ram_bank_count equ $01

work_ram_start_addr equ $6000
sprite_ram_start_addr equ $7000
video_ram_start_addr equ $7400
default_stack_pointer equ $6400
rom0_checksum_addr equ $3FC7
version_end_addr equ $3FFF
build_date_end_addr equ $3FF8

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
ram_3l_fail_mask equ $40
ram_3h_fail_mask equ $80
ram_3_fail_mask equ $0040
ram_4l_fail_mask equ $01
ram_4h_fail_mask equ $02
ram_4_fail_mask equ $0100
ram_bank_fail_mask equ $04
nmi_pass_mask equ $08
dma_fail_mask equ $10

sprite_test_mask equ $80

menu_max_opt equ $08
menu_max_palette equ $04
menu_max_monitor equ $03
menu_max_sound equ $08
menu_max_music equ $10

menu_constants: DB menu_max_palette, menu_max_monitor, menu_max_sound, menu_max_music


;Discrete Sounds
walk_sound_addr equ $7D00
jump_sound_addr equ $7D01
boom_sound_addr equ $7D02
;Digital Sounds
spring_sound_addr equ $7D03
fall_sound_addr equ $7D04
prize_sound_addr equ $7D05
dead_sound_addr equ $7D80

;DK System Addresses
screen_invert_addr equ $7D82
palette_bit_0_addr equ $7D86
palette_bit_1_addr equ $7D87
int_enable_addr equ $7D84
music_addr equ $7C00
watchdog_addr equ $7D00

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


;String Print Addresses
tkg_header_address equ $74E1
build_date_addr equ $74E2

ram_test_header_address equ $7684
ram_test_line_address equ $7605
ram0l_print_address equ $7626
ram3l_print_address equ $7466
ram_bank_test_address equ $746B
rom_test_header_address equ $760D
rom_test_line_address equ $760E
rom0_print_address equ $764F
rom0_if_print_address equ $746F
system_header_print_address equ $7634
system_line_print_address equ $7615
dma_result_print_address equ $7696
nmi_result_print_address equ $7697
audio_header_address equ $7659
audio_line_address equ $761A
triggered_sound_test_addr equ $76DB
music_sound_test_addr equ $76DC
startup_fail_print_addr equ $74CD

error_code_print_addr equ $75D2

controls_test_header_address equ $7604
controls_test_line_address equ $7605

p1_controls_start_address equ $7766
p1_controls_down_addr equ $76A6
p1_controls_addr equ $7626
p2_controls_start_address equ $75A6
p2_controls_down_addr equ $74E6
p2_controls_addr equ $7466
coin_print_addr equ $772C
coin_state_addr equ $762C

dip_switch_info_addr equ  $76B1
dip_sw_header_addr equ $764E
dip_sw_line_addr equ $760F

menu_header_print_addr equ $7614
menu_line_print_addr equ $7615
menu_palette_print_addr equ $75F6
menu_invert_print_addr equ $7617
menu_monitor_print_addr equ $75F8
menu_sound_print_addr equ $76D9
menu_music_print_addr equ $76DA
menu_bg_print_addr equ $759B
menu_sprite_print_addr equ $761C
menu_reset_print_addr equ $76DD
menu_value_print_addr equ $74F6
menu_reset_ip_print_addr equ $750F
menu_reset_pw_print_addr equ $7571

test_menu_print_addr equ $74DC

;Strings
string_rom:           DB $1D, $1F, $22, $3F
string_rom0_if:       DB $1C, $19, $11, $16, $10, $29, $24, $19, $22, $17, $15, $24, $1E, $19, $3F
string_ram:           DB $1D, $11, $22, $3F
string_sound:         DB $14, $1E, $25, $1F, $23, $3F
string_music:         DB $13, $19, $23, $25, $1D, $3F
string_done:          DB $14, $1E, $1F, $14, $3F
string_rom_checksums: DB $23, $1D, $25, $23, $1B, $13, $15, $18, $13, $10, $1D, $1F, $22, $3F
string_ram_test:      DB $23, $24, $23, $15, $24, $10, $1D, $11, $22, $3F
string_ram_bank:      DB $24, $23, $15, $24, $2B, $12, $3F
string_good:          DB $23, $23, $11, $20, $3F
string_bad:           DB $1C, $19, $11, $16, $3F
string_na:            DB $2B, $11, $2B, $1E, $3F
string_audio_test:    DB $23, $24, $23, $15, $24, $10, $1F, $19, $14, $25, $11, $3F
string_line:          DB $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $3F
string_system_test:   DB $23, $24, $23, $15, $24, $10, $1D, $15, $24, $23, $29, $23, $3F
string_nmi:           DB $19, $1D, $1E, $3F
string_dma:           DB $11, $1D, $14, $3F
string_tkg_startup:   DB $23, $24, $23, $15, $24, $10, $20, $25, $2C, $24, $22, $11, $24, $23, $10, $22, $1A, $14, $3F
string_tkg_runtime:   DB $23, $24, $23, $15, $24, $10, $15, $1D, $19, $24, $2C, $1E, $25, $22, $10, $22, $1A, $14, $3F
string_p1:            DB $01, $20, $3F
string_p2:            DB $02, $20, $3F
string_down:          DB $10, $1E, $27, $1F, $14, $3F
string_up:            DB $10, $10, $10, $20, $25, $3F
string_left:          DB $10, $24, $16, $15, $1C, $3F
string_right:         DB $24, $18, $17, $19, $22, $3F
string_start:         DB $24, $22, $11, $24, $23, $3F
string_jump:          DB $10, $20, $1D, $25, $1A, $3F
string_coin:          DB $1E, $19, $1F, $13, $3F
string_controls_test: DB $24, $23, $15, $24, $10, $23, $1C, $1F, $22, $24, $1E, $1F, $13, $3F
string_dip_sw_test:   DB $24, $23, $15, $24, $10, $27, $23, $10, $20, $19, $14, $3F
string_on:            DB $10, $1E, $1F, $3F
string_off:           DB $16, $16, $1F, $3F
string_test_select:   DB $24, $23, $15, $24, $10, $11, $10, $24, $13, $15, $1C, $15, $23, $3F
string_palette_test:  DB $24, $23, $15, $24, $10, $15, $24, $24, $15, $1C, $11, $20, $3F
string_invert_test:   DB $20, $19, $1C, $16, $10, $1E, $15, $15, $22, $13, $23, $3F
string_monitor_test:  DB $24, $23, $15, $24, $10, $22, $1F, $24, $19, $1E, $1F, $1D, $3F
string_sound_set:     DB $14, $1E, $25, $1F, $23, $3F
string_music_set:     DB $13, $19, $23, $25, $1D, $3F
string_bg_test:       DB $24, $23, $15, $24, $10, $14, $1E, $25, $1F, $22, $17, $1B, $13, $11, $12, $3F
string_sprite_test:   DB $24, $23, $15, $24, $10, $15, $24, $19, $22, $20, $23, $3F
string_reset:         DB $24, $15, $23, $15, $22, $3F
string_reset_ip:      DB $23, $23, $15, $22, $17, $1F, $22, $20, $10, $1E, $19, $10, $24, $15, $23, $15, $22, $3F
string_reset_pw:      DB $24, $19, $11, $27, $10, $15, $23, $11, $15, $1C, $20, $3F
string_return:        DB $1E, $22, $25, $24, $15, $22, $10, $1F, $24, $10, $20, $1D, $25, $1A, $10, $23, $23, $15, $22, $20, $3F
string_p1_mes:        DB $15, $24, $24, $15, $1C, $11, $20, $10, $15, $17, $1E, $11, $18, $13, $10, $1F, $24, $10, $01, $20, $10, $23, $23, $15, $22, $20, $3F
string_p2_mes:        DB $15, $24, $19, $22, $20, $23, $10, $15, $17, $1E, $11, $18, $13, $10, $1F, $24, $10, $02, $20, $10, $23, $23, $15, $22, $20, $3F
string_version:       DB $2E, $1E, $1F, $19, $23, $22, $15, $26, $3F
string_bdate:         DB $2E, $15, $24, $11, $14, $10, $14, $1C, $19, $25, $12, $3F
string_startup_fail:  DB $15, $22, $25, $1C, $19, $11, $16, $10, $24, $23, $15, $24, $10, $20, $25, $2C, $24, $22, $11, $24, $23, $3F


align $1FC0
DB "CHKSUM:", $FF, $FF, " PAD:", $00, $00
DB "DJR TEST 5E     SNESNESCUBE64   03SEP2026  V0.02"

ds $2000 - $
