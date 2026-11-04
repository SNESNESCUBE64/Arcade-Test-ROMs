import pyperclip
import os

FONT_PATH = "..\\..\\Code\\Public\\font_raw.hx"
CHAR_LIST = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "lp", "rp", "colon", "dash"]

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