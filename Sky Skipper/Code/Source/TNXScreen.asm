;TNX Hardware Test ROM
;(C) SNESNESCUBE64

clear_screen:
    call clear_video
    call clear_color
    call clear_background
    call clear_sprites
    ret

clear_video:
    ld de, video_ram_size
    ld hl, video_ram_start_addr
    ld a, $FF
    call mass_write
    ret

clear_color:
    ld de, color_ram_size
    ld hl, color_ram_start_addr
    xor a
    call mass_write
    ret

clear_background:
    ld de, background_ram_size
    ld hl, background_ram_start_addr
    xor a
    call mass_write
    ld de, background_ram_size
    ld hl, background_ram_start_addr
    ld a, $F0
    call mass_write
    ret

clear_sprites:
    xor a
    ld de, sprite_ram_size
    ld hl, sprite_ram_start_addr
    call mass_write

flip_screen:
    push af
    ld a, $01
    out $01
    pop af
    ret

unflip_screen:
    push af
    ld a, $01
    out $01
    pop af
    ret

screen_test:
    ld bc, video_ram_size-$80
    ;ld bc, $F000
    ld de, color_ram_start_addr+$40
    ld hl, video_ram_start_addr+$40
    exx
    ld bc, $0000
    exx
    xor a
    
screen_test_print_loop:
    ld (hl), a
    
    exx
    ld c, a
    ld a, b
    exx
    
    ld (de), a
    
    exx
    ld a, c
    exx

    inc a
    inc hl
    inc de
    dec c
    jr nz, screen_test_print_loop
    
    exx
    inc b
    exx

    dec b
    jr nz, screen_test_print_loop
    ret

text_test:

    ld b, $00 ; current color palette
    ld c, $10
text_test_init:
    call print_text_test_header
    xor a
    ld hl, $1010
    ld de, $0010
    ld ix, $A108
    ld iy, $A508
text_test_loop:
    ld (ix+0), a
    ld (iy+0), b
    inc ix
    inc iy
    inc a
    dec l
    jr nz, text_test_loop
    ld l, $10
    add ix, de
    add iy, de
    dec h
    jr nz, text_test_loop
    inc b
    ld a, $04
    call delay
    dec c
    jr nz, text_test_init
    ret

print_text_test_header:
    push bc

    inc b
    xor a
    ld c, $10
    ld de, $0010
    ld ix, $A0C8
    ld iy, $A4C8
print_text_test_header_loop1:
    ld (ix+0), a
    ld (iy+0), b
    inc a
    inc ix
    inc iy
    dec c
    jr nz, print_text_test_header_loop1
    ld a, $FE
    add ix, de
    add iy, de
    dec ix
    dec ix
    dec iy
    dec iy
    ld c, $14
print_text_test_header_loop2:
    ld (ix+0), a
    ld (iy+0), b
    inc ix
    inc iy
    dec c
    jr nz, print_text_test_header_loop2

    ld hl, $00FE
    ld a, l
    ld ($A0C7), a
    ld a, b
    ld ($A4C7), a
    ld c, $10
    ld de, $0020
    ld ix, $A106
    ld iy, $A506
print_text_test_header_loop3:
    ld (ix+0), h
    ld (ix+1), l
    ld (iy+0), b
    ld (iy+1), b
    inc h
    add ix, de
    add iy, de
    dec c
    jr nz, print_text_test_header_loop3


    pop bc
    ret

background_test:
    xor a
background_loop:
    and $0F
    push af
    ld b, $02
    ld hl, $A088
    call print_two_digit
    pop af
    ld de, $1000
    ld hl, $C000
    call mass_write
    or $80
    ld de, $1000
    ld hl, $C000
    call mass_write
    ld b, a
    ld a, $08
    call delay
    ld a, b
    or $F0
    inc a
    jr nz, background_loop

sprite_test:
    ld hl, $9000
    ld de, background_ram_size
    xor a

sprite_test_loop:
    ld (hl), a
    inc hl
    inc a
    dec e
    jr nz, sprite_test_loop
    dec d
    jr nz, sprite_test_loop
    ret

blue_background_set:
    xor a
    ld (entire_background_layer_addr), a

black_background_set:
    ld a, $08
    ld (entire_background_layer_addr), a

;bc - XY coordinates
;d - sprite 1
;e - sprite 2
;hl - draw address
draw_sprite:
    ld (hl), b
    inc hl
    ld a, c
    cpl
    ld (hl), a
    inc hl
    ld (hl), d
    inc hl
    ld (hl), e
    ret
