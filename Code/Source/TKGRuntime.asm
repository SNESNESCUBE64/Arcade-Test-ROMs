;TKG Hardware Test ROM
;(C) SNESNESCUBE64

TKGRuntime:
;temporary until the menu can be written out.
    call audio_test_main
    jr TKGRuntime