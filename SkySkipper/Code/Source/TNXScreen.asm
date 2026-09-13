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

background_test2:
    ld hl, $8800
    ld de, background_ram_size
    xor a

background_test_loop2:
    ld (hl), a
    inc hl
    inc a
    dec e
    jr nz, background_test_loop2
    dec d
    jr nz, background_test_loop2
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