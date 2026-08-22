;TKG Hardware Test ROM
;(C) SNESNESCUBE64

org $0000
init:
    ld sp, $6C00
    ;Clear the registers
    xor a
    ld (int_enable_addr), a  
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
    jp ram_test_main

include "TKGPrint.asm"

align $66
;NMI shouldn't do anything other than pet the watchdog
nmi_routine:
    push af
    push bc
    push de
    push hl
    xor a
    ld (int_enable_addr), a
    ld a, (watchdog_addr)
    exx
    ld a, h
    or nmi_pass_mask
    ld h, a
    exx
    and sprite_test_mask
    call nz, sprite_handler
    ld a, $0f
    ld (int_enable_addr), a
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
    ld a, $01
    call system_select_palette

    ld de, tkg_header_address
    ld hl, string_tkg_startup
    rst $20

    call print_version_info

    xor a
    call process_ram_results
    call rom_check_main

    ;print the header
    ld de, system_header_print_address
    ld hl, string_system_test
    rst $20

    ld de, system_line_print_address
    ld hl, string_line
    rst $20

    call check_dma
    call check_nmi
    call audio_test_main
check_startup_results:
    xor a
    ld (int_enable_addr), a
    exx
    ld a, h
    and $04
    jp z, startup_fail
    ld a, h
    and $03
    jp nz, startup_fail
    ld a, l
    and a
    jp nz, startup_fail
    exx
    ld a, $0f
    ld (int_enable_addr), a
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
    ld (int_enable_addr), a
    call delay_1s
    xor a
    ld (int_enable_addr), a
    exx
    ld a, h
    exx
    ld b, a
    ld a, $0f
    ld (int_enable_addr), a
    ld a, b
    and nmi_pass_mask
    ld de, nmi_result_print_address
    ld hl, string_bad
    jr z, bad_nmi
    ld hl, string_good
bad_nmi:
    rst $20
    ld hl, string_nmi
    ld de, $0040
    add ix, de
    rst $28
    ret

check_dma:
    exx
    ld a, h
    ld b, a
    or sprite_test_mask
    xor sprite_test_mask ;This bit needs to be cleared because sprite test uses this bit
    ld h, a
    ld a, b
    exx
    ld de, dma_result_print_address
    and dma_fail_mask
    ld hl, string_bad
    jr nz, bad_dma
    ld hl, string_good
bad_dma:
    rst $20
    ld hl, string_dma
    ld de, $0040
    add ix, de
    rst $28
    ret

startup_fail:
    exx
    ;print failure

    ;disable interrupts
    
dead_loop:
    ;We are dead at this point. Try waiting for the watchdog, otherwise just jump back to start
    xor a
    ld (int_enable_addr), a   
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
include "TKGRuntime.asm"
include "TKGDma.asm"
include "TKG_Def.asm"