;TNX Hardware Test ROM
;(C) SNESNESCUBE64

controls_wait_for_any_button:
    in $00
    and a
    ret nz
    in $01
    and a
    ret nz
    in $02
    and a
    ret nz
    jr controls_wait_for_any_button