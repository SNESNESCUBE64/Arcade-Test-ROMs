;TKG Hardware Test ROM
;(C) SNESNESCUBE64

org $0000
init:
    ;If we are at 0, it should read back 0, if we are at 0x4000, we will read something non-zero
    nop
    ld a, ($0000)
    and a
    jp nz, test_socket_main
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
    exx
    ld b, a
    xor a
    ld ($7D84), a
    ld a, ($7D00)
    ld a, h
    or $01
    ld h, a
    ld a, $0f
    ld ($7D84), a
    ;ld a, b
    exx
    pop hl
    pop de
    pop bc
    pop af
    ret

main:
;This delay might not be necessary after all RAM tests are implemented
    ld hl, $FFFF
    ld a, $03
main_delay_loop1:
    dec l
    jr nz, main_delay_loop1
    dec h
    jr nz, main_delay_loop1
    dec a
    jr nz, main_delay_loop1

;See if any RAM errors are present
;If RAM errors are present, we need to set an alt stack pointer
;and perform sound codes
    exx
    ld a, l
    exx
    and a
    jr z, post_ram_test

    ld ix, check_sp:
    jp check_ram_results
check_sp:
    ld ix, post_ram_test:
    jp find_alt_sp

post_ram_test:
    call uninvert_screen
    call set_background_palette_2
    xor a
    ld de, tkg_header_address
    ld hl, string_tkg_startup
    call print
    xor a
    call process_ram_results
    call rom_check_main
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
    ;print the header
    ld de, nmi_header_print_address
    ld hl, string_nmi_test
    call print

    ld de, nmi_line_print_address
    ld hl, string_line
    call print
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
    and $01
    ld de, nmi_result_print_address
    ld hl, string_bad
    jr z, bad_nmi
    ld hl, string_good
bad_nmi:
    call print
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
include "TKG_Def.asm"