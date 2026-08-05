#Checksum Patch Utility - SNESNESCUBE64

import os
import sys

#Function to calculate the 8 bit checksum used by ROM 104
def CalculateChecksum16(file):
    checksum = 0
    with open(file,"rb") as openedFile:
        while (byte := openedFile.read(1)):
            checksum += int.from_bytes(byte)
            #We only care about the last byte
            if checksum > 65535:
                checksum = checksum - 65536
        openedFile.close()

    return checksum

def CalculateChecksum16FromBuffer(buffer):
    checksum = 0
    for byte in buffer:
        checksum += byte
        #We only care about the last byte
        if checksum > 65535:
            checksum = checksum - 65536

    return checksum

def PatchChecksum(file, checksum):
    buffer = [0xFF] * 4096
    counter = 0
    with open(file,"rb") as openedFile:
        while (byte := openedFile.read(1)):
            buffer[counter] = int.from_bytes(byte)
            counter += 1
        openedFile.close()

#patch the checksum
    buffer[0xFC7] = (checksum & 0xFF00) >> 8
    buffer[0xFC8] = checksum & 0x00FF

#Add the padding
    padding = checksum - CalculateChecksum16FromBuffer(buffer)
    if padding > 255:
        buffer[0xFCE] = 255
        padding -= 255
        buffer[0xFCF] = padding
    else:
        buffer[0xFCE] = 0
        buffer[0xFCF] = padding

    with open(file,"wb") as openedFile:
        for byte in buffer:
            openedFile.write(byte .to_bytes(1, 'little', signed=False))

print("Patching Checksum")

checksum = 65535

if len(sys.argv) > 1:
    if os.path.isfile(sys.argv[1]):
        checksum = CalculateChecksum16(sys.argv[1])
        PatchChecksum(sys.argv[1], checksum)
        print("Done")
    else:
        print("Error: Not a path")
else:
    print("Error: Invalid Arguement")