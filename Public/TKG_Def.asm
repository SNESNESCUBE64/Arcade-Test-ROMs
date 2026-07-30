;Constants
rom0_print_address equ $7602
triggered_sound_test_addr equ $7687
music_sound_test_addr equ $7688
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
string_rom:   DB $1D, $1F, $22, $3F
string_sound: DB $14, $1E, $25, $1F, $23, $3F
string_music: DB $13, $19, $23, $25, $1D, $3F
string_done:  DB $14, $1E, $1F, $14, $3F


align $0FD0
DB "TKG Test ROM    SNESNESCUBE64   28 July 2026   ",$20

ds $1000 - $