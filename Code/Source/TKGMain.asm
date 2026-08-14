;TKG Hardware Test ROM
;(C) SNESNESCUBE64

org $0000
init:
    ld sp, $6C00
    ;Clear the registers
    xor a
    ld ($7D84), a  
    ld b, a
    ld c, a
    ld d, a
    ld e, a
    ld h, a
    ld l, a
    exx
    ld b, a
    ld c, a
    ld d, a
    ld e, a
    ld h, a
    ld l, a
    ld iy, $0000
    ;start the tests
    ld ix, main ;Load the jump address into iy, RAM stuff is all inline
    jp ram_test_main

align $66
;NMI shouldn't do anything other than pet the watchdog
nmi_routine:
    push af
    push bc
    push de
    push hl
    xor a
    ld ($7D84), a
    ld a, ($7D00)
    exx
    ld a, h
    or $04
    ld h, a
    exx
    and $80
    call nz, sprite_handler
    ld a, $0f
    ld ($7D84), a
    pop hl
    pop de
    pop bc
    pop af
    ret

main:
;See if any RAM errors are present
;If RAM errors are present, we need to set an alt stack pointer
;and perform sound codes
    
    exx
    ld a, l;Load the lower results
    or h ;load the upper results, we don't care which RAM failed yet
    exx
    and a
    jr z, post_ram_test;if ANY test failed, we will have to figure out which one, otherwise all is good

    ld ix, check_sp:
    jp check_ram_results
check_sp:
    ld ix, post_ram_test:
    jp find_alt_sp

post_ram_test:
    call dma_test_main
    call uninvert_screen
    call set_background_palette_2
    xor a
    ld de, tkg_header_address
    ld hl, string_tkg_startup
    call print
    xor a
    call process_ram_results
    call rom_check_main

    ;print the header
    ld de, system_header_print_address
    ld hl, string_system_test
    call print

    ld de, system_line_print_address
    ld hl, string_line
    call print

    call check_dma
    call check_nmi
    call audio_test_main
    ;Check to see if there were any startup failures. 
    xor a
    ld ($7D84), a
    exx
    ld a, l
    and a
    jp nz, startup_fail
    ld a, h
    and a
    jp z, startup_fail
    exx
    ld a, $0f
    ld ($7D84), a
    ld a, $01
    ld (menu_palette_opt), a
    jp TKGRuntime_Main


delay_1s:
    ld a, $01
;assume a is the coundown so long as a is greater than one.
delay:
    push hl
    ld hl, $ffff

delay_loop:
    dec l
    jr nz, delay_loop
    dec h
    jr nz, delay_loop
    dec a
    jr nz, delay_loop

    pop hl
    ret

delay_1s_no_ram:
    ld a, $01
;assume a is the coundown so long as a is greater than one.
delay_no_ram:
    ld hl, $ffff

delay_no_ram_loop:
    dec l
    jr nz, delay_no_ram_loop
    dec h
    jr nz, delay_no_ram_loop
    dec a
    jr nz, delay_no_ram_loop

    jp (iy)

;this will toggle something like an analog sound or screen flip depending on what is required
;assumes hl is the address
;works with walk, jump, and boom sounds
toggle_discrete_feature:
    push af

    ld a, $0f
    ld (hl), a
    call delay_1s
    ld a, $f0
    ld (hl), a

    pop af
    ret

check_nmi:
    ;enable interrupts
    ld a, $0f
    ld ($7D84), a
    call delay_1s
    xor a
    ld ($7D84), a
    exx
    ld a, h
    exx
    ld b, a
    ld a, $0f
    ld ($7D84), a
    ld a, b
    and $04
    ld de, nmi_result_print_address
    ld hl, string_bad
    jr z, bad_nmi
    ld hl, string_good
bad_nmi:
    call print
    ld hl, string_nmi
    ld de, $0040
    add ix, de
    call print_by_address_and_length
    ret

check_dma:
    exx
    ld a, h
    ld b, a
    or $80
    xor $80 ;This bit needs to be cleared because sprite test uses this bit
    ld h, a
    ld a, b
    exx
    ld de, dma_result_print_address
    and $80
    ld hl, string_bad
    jr nz, bad_dma
    ld hl, string_good
bad_dma:
    call print
    ld hl, string_dma
    ld de, $0040
    add ix, de
    call print_by_address_and_length
    ret

startup_fail:
    exx
    ;print failure

    ;disable interrupts
    
dead_loop:
    ;We are dead at this point. Try waiting for the watchdog, otherwise just jump back to start
    xor a
    ld ($7D84), a   
    ld iy, $0000
    ld a, $03
    jp delay_no_ram

;main if the ROM lives in 0x4000
test_socket_main:
    jr test_socket_main

include "TKGSystem.asm"
include "TKGRomTest.asm"
include "TKGRamTest.asm"
include "TKGAudioTest.asm"
include "TKGPrint.asm"
include "TKGRuntime.asm"
include "TKGDma.asm"
include "TKG_Def.asm"