;Constants
discrete_sound_test_addr equ $75A2
screen_invert_addr equ $7d82
walk_sound_addr equ $7D00
jump_sound_addr equ $7D01
boom_sound_addr equ $7D02

;Strings
string_sound_test: DB $14, $1E, $25, $1F, $23, $10, $15, $24, $15, $22, $13, $23, $19, $14, $3F

align $0FD0
DB "TKG Test ROM    SNESNESCUBE64   28 July 2026   ",$20

ds $1000 - $