;TKG Hardware Test ROM
;(C) SNESNESCUBE64

TKGRuntime_Main:
;temporary until the menu can be written out.
    ;call audio_test_main
    ld de, tkg_header_address
    ld hl, string_tkg_runtime
    call print
runtime_loop:    
    call runtime_controls_main
    jr runtime_loop

include "TKGControls.asm"