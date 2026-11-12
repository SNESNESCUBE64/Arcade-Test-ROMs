; Space Encounters Encoders Test ROM
; SNESNESCUBE64

clear_ram:
    lxi h, $2000
    lxi d, $2000
    xra a
    pop b
    jp clear_ram_loop

clear_work_ram:
    lxi h, $2000
    lxi d, $0400
    xra a
    pop b
    jp clear_ram_loop

clear_video_ram:
    lxi h, $2400
    lxi d, $1C00
    xra a
    pop b
    jp clear_ram_loop

clear_ram_loop:
    mov m, a
    inx h
    dcr e
    jnz clear_ram_loop
    dcr d
    jnz clear_ram_loop
    push b
    ret