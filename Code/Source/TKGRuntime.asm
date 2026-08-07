;TKG Hardware Test ROM
;(C) SNESNESCUBE64

TKGRuntime_Main:
;temporary until the menu can be written out.
    ;call audio_test_main
    call runtime_controls_main
    jr TKGRuntime_Main

include "TKGControls.asm"