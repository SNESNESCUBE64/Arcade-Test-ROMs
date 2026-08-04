;Constants
work_ram_size equ $0400
work_ram_bank_count equ $03
video_ram_size equ $0400
video_ram_bank_count equ $01

work_ram_start_addr equ $6000
video_ram_start_addr equ $7400


;Discrete Sounds
walk_sound_addr equ $7D00
jump_sound_addr equ $7D01
boom_sound_addr equ $7D02
;Digital Sounds
spring_sound_addr equ $7D03
fall_sound_addr equ $7D04
prize_sound_addr equ $7D05

;DK System Addresses
screen_invert_addr equ $7d82
palette_bit_0_addr equ $7D86
palette_bit_1_addr equ $7D87
int_enable_addr equ $7D84
music_addr equ $7C00

;String Print Addresses
tkg_header_address equ $74E2

ram_test_header_address equ $7645
ram_test_line_address equ $75C6
ram0l_print_address equ $75E7
rom_test_header_address equ $75D0
rom_test_line_address equ $75D1
rom0_print_address equ $7612
nmi_test_print_address equ $75B8
audio_header_address equ $761A
audio_line_address equ $75DB
triggered_sound_test_addr equ $769C
music_sound_test_addr equ $769D


;Strings
string_rom:           DB $1D, $1F, $22, $3F
string_ram:           DB $1D, $11, $22, $3F
string_sound:         DB $14, $1E, $25, $1F, $23, $3F
string_music:         DB $13, $19, $23, $25, $1D, $3F
string_done:          DB $14, $1E, $1F, $14, $3F
string_rom_checksums: DB $23, $1D, $25, $23, $1B, $13, $15, $18, $13, $10, $1D, $1F, $22, $3F
string_ram_test:      DB $23, $24, $23, $15, $24, $10, $1D, $11, $22, $3F
string_good:          DB $14, $1F, $1F, $17, $3F
string_bad:           DB $10, $14, $11, $12, $3F
string_audio_test:    DB $23, $24, $23, $15, $24, $10, $1F, $19, $14, $25, $11, $3F
string_line:          DB $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $3F
string_nmi_test:      DB $24, $23, $15, $24, $10, $19, $1D, $1E, $3F
string_tkg_startup:   DB $23, $24, $23, $15, $24, $10, $20, $25, $2C, $24, $22, $11, $24, $23, $10, $17, $1B, $24, $3F


align $0FD0
DB "TKG Test ROM    SNESNESCUBE64   01 Aug 2026    ",$20

ds $1000 - $