;TNX Hardware Test ROM
;(C) SNESNESCUBE64

clear_screen:
    call clear_video
    call clear_color
    call clear_background
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
    ret

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
    ld hl, background_ram_start_addr
    ld de, background_ram_size
    xor a

background_test_loop:
    ld (hl), a
    inc hl
    inc a
    dec e
    jr nz, background_test_loop
    dec d
    jr nz, background_test_loop
    ret

background_print_command: DB $0F, $0F, $0F, $0F, $0F, $0F, $09, $0F, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                          DB $0F, $09, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
background_test2:
    ld hl, background_print_command
    ld de, $8F92
    ld c, $20
    call background_command_1
    ld b, $05
    call background_command_2

background_command_1:
    ld a, (hl)
    ld (de), a
    inc hl
    inc de
    dec c
    jr nz, background_command_1
    ret

background_command_2:
    ex de, hl
    ld l, $91
    ld (hl), c
    dec l
    ld (hl), b
background_command_2_loop:
    ld a, (hl)
    and a
    jr nz, background_command_2_loop
    ex de, hl
    ret

background_test_3:
    ld hl, $8800
    ld de, background_ram_size
    xor a

background_test_loop3:
    ld (hl), a
    inc hl
    inc a
    dec e
    jr nz, background_test_loop3
    dec d
    jr nz, background_test_loop3
    ret

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