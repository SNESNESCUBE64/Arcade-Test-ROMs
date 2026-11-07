import pyperclip
import os

FONT_PATH = ".\\font_raw.hx"
CHAR_LIST = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "h", "i", "l", "n", "o", "p", "r", "s", "t", "u", "v", "z", "colon", "space", "crosshair", "h_bar_right", "h_bar_center", "h_bar_left", "v_bar_low", "v_bar_center", "v_bar_high"]

charCounter = 0
byteCount = 0
byteCountMax = os.path.getsize(FONT_PATH)
with open(FONT_PATH, "rb") as f:
    while byteCount < byteCountMax:
        line = ""
        line = "char_" + CHAR_LIST[charCounter] + ": DB "
        for index in range(0,8):
            line += "$" + format(int.from_bytes(f.read(1)), '02X')
            byteCount += 1
            if index < 7:
                line += ", "

        print(line)
        charCounter += 1