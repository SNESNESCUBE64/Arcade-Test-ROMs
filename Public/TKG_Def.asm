;Constants
rom_test_header_address equ $75C2
rom_test_line_address equ $75C3
audio_header_address equ $760B
audio_line_address equ $75CC
rom0_print_address equ $7604
triggered_sound_test_addr equ $768D
music_sound_test_addr equ $768E
screen_invert_addr equ $7d82
;Discrete Sounds
walk_sound_addr equ $7D00
jump_sound_addr equ $7D01
boom_sound_addr equ $7D02
;Digital Sounds
spring_sound_addr equ $7D03
fall_sound_addr equ $7D04
prize_sound_addr equ $7D05

music_addr equ $7C00

;Strings
string_rom:           DB $1D, $1F, $22, $3F
string_sound:         DB $14, $1E, $25, $1F, $23, $3F
string_music:         DB $13, $19, $23, $25, $1D, $3F
string_done:          DB $14, $1E, $1F, $14, $3F
string_rom_checksums: DB $23, $1D, $25, $23, $1B, $13, $15, $18, $13, $10, $1D, $1F, $22, $3F
string_audio_test:    DB $23, $24, $23, $15, $24, $10, $1F, $19, $14, $25, $11, $3F
string_line:          DB $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $3F


align $0FD0
DB "TKG Test ROM?   SNESNESCUBE64?  29 July 2026?  ",$20

ds $1000 - $