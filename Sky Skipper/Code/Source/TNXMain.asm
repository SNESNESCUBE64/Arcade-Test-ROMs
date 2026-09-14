;TNX Hardware Test ROM
;(C) SNESNESCUBE64

org $0000
init:
    ld sp, default_stack_pointer
    ;Clear the registers
    xor a
    ;ld (int_enable_addr), a  
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

include "TNXPrint.asm"

align $66
;NMI shouldn't do anything other than pet the watchdog
nmi_routine:
    push af
    push bc
    push de
    push hl
    ; call interrupt_disable
    ; ld a, (watchdog_addr)
    ; exx
    ; ld a, h
    ; or nmi_pass_mask
    ; ld h, a
    ; exx
    ; and sprite_test_mask
    ; call nz, sprite_handler
    ; call interrupt_enable
    pop hl
    pop de
    pop bc
    pop af
    ret

main:
;See if any RAM errors are present
;If RAM errors are present, we need to set an alt stack pointer
;and perform sound codes
    
;This doesnt't work yet, assume RAM is ok
;     exx
;     ld a, l;Load the lower results
;     or h ;load the upper results, we don't care which RAM failed yet
;     exx
;     and a
;     jr z, post_ram_test;if ANY test failed, we will have to figure out which one, otherwise all is good

;     ld ix, check_sp:
;     jp check_ram_results
; check_sp:
;     nop
;     nop
;     nop
;     nop
;     nop
;     ld ix, post_ram_test:
;     jp find_alt_sp

post_ram_test:
    call ay_init
test_loop:
    call clear_screen
    ld a, $08
    call delay
    ld hl, string_text_test
    ld de, string_text_test_addr
    rst $20
    call text_test
    ;call screen_test
    ld a, $08
    call delay
    call clear_screen
    ld a, $08
    call delay
    call background_test
    
    ; ld a, $08
    ; call delay
    ; call clear_screen
    ld a, $08
    call delay
    call sprite_test
    ld a, $08
    call delay
    ;call background_test_3
    ;call background_test2
    ; call clear_screen
    ; ld a, $08
    ; call delay
    
    ; ld a, $08
    ; call delay


   ; ld de, tkg_header_address
    ;ld hl, string_tkg_startup
    ;rst $20

    ;call print_version_info

    xor a
    ;call process_ram_results
    ;call rom_check_main

    ;print the header
    ;ld de, system_header_print_address
    ;ld hl, string_system_test
    ;rst $20

    ;ld de, system_line_print_address
    ;ld hl, string_line
    ;rst $20

    jp test_loop


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

startup_fail:
    exx
;gracefully reset
    ; call clear_screen

    ; ld de, menu_reset_ip_print_addr
    ; ld hl, string_reset_ip
    ; rst $20

    ; ld de, startup_fail_print_addr
    ; ld hl, string_startup_fail
    ; rst $20

;Attempt to print an error code
    ; call interrupt_disable
    ; exx
    ; ld a, l
    ; exx
    ; ld hl, error_code_print_addr
    ; call print_two_digit
    ; exx
    ; ld a, h
    ; exx
    ; call print_two_digit

dead_loop:
    ;We are dead at this point. Try waiting for the watchdog, otherwise just jump back to start
    xor a
    ;ld (int_enable_addr), a   
    ld iy, $0000
    ld a, $03
    jp delay_no_ram


include "TNXSystem.asm"
;include "TNXRomTest.asm"
include "TNXRamTest.asm"
include "TNXScreen.asm"
include "TNXDef.asm"