;TKG Hardware Test ROM
;(C) SNESNESCUBE64

;                       1         2         3         4         5         6         7         8         9         A         B         C         D         E         F
music_delay_timings: DB $01, $01, $01, $01, $01, $01, $08, $01, $06, $01, $06, $01, $06, $01, $08, $01, $06, $01, $06, $01, $06, $01, $08, $01, $06, $01, $06, $01, $06, $01

audio_test_main:
    ld de, audio_header_address
    ld hl, string_audio_test
    rst $20

    ld de, audio_line_address
    ld hl, string_line
    rst $20

    call triggered_sound_test
    call music_sound_test
    ret

triggered_sound_test:
    ld a, $01
    ld ($7D06), a
    ld bc, $0040
    ld ix, triggered_sound_test_addr
    add ix, bc
    ld hl, string_sound
    rst $28
    ld ix, triggered_sound_test_addr
    ld hl, walk_sound_addr
    ld a, $0
triggered_sound_loop:
    ld (ix+0), a
    ld b, a
    cp $3
    jr z, alarm_sound_toggle
    call toggle_discrete_feature
post_toggle:
    ld a, $02
    call delay
    ld a, b
    inc l
    inc a
    cp $6
    jr nz, triggered_sound_loop
    ret

alarm_sound_toggle:
    push hl
    ld hl, $7D07
    call toggle_discrete_feature
    pop hl
    jr post_toggle

music_sound_test:
    ld iy, music_delay_timings
    ld bc, $0040
    ld ix, music_sound_test_addr
    add ix, bc
    ld hl, string_music
    rst $28
    ld ix, music_sound_test_addr
    ld hl, music_addr
    ld a, $1
music_sound_loop:
    ld b, a
    cp a, $0A
    jr c, music_not_letter
    add a, $07
music_not_letter:
    ld (ix+0), a
    ld (hl), b
    ld a, (iy+0)
    inc iy
    call delay
    xor a
    ld (hl), a
    ld a, (iy+0)
    inc iy
    call delay
    ld a, b
    inc a
    cp $10
    jr nz, music_sound_loop
    xor a
    ld (hl), a
    ret

toggle_dead_sound:
    ret