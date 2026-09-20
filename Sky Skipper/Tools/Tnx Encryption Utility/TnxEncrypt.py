# This is a stripped down version of the TNX/TPP encryption utility
# https://github.com/SNESNESCUBE64/ArcadeROMUtilities/tree/main/Sky%20Skipper%20Popeye%20Encryption%20Utility

import os
import sys

TNX_ROM_MASK = 0xFC
TNX_BUFFER_SIZE = 0x1000

#Sub Functions
#############################################
# TNX hardware obfuscated the address lines so they need to be "unencrypted" in order to made unencrypted ROMs.
# This was accomplished by changing the address bit order and then XOR by a MASK, for this case "ROM_MASK".
# bitorder = (15, 14, 13, 12, 11, 10, 8, 7, 0, 1, 2, 4, 5, 9, 3, 6) ^ 0xfc
# data can be re-encrypted by doing this operatiuons backwards.
def TNXEncryptAddress(oldAddress):
    newAddress = 0xFFFF
    oldAddress = oldAddress ^ TNX_ROM_MASK #undo the mask
    
    newAddress = oldAddress & 0xFC10 #these bits are unchanged

    newAddress = newAddress | ((oldAddress & 0x0001) << 6) | \
                 ((oldAddress & 0x0002) << 2) | ((oldAddress & 0x0004) << 7)  | \
                 ((oldAddress & 0x0008) << 2) | ((oldAddress & 0x0020) >> 3)  | \
                 ((oldAddress & 0x0040) >> 5) | ((oldAddress & 0x0080) >> 7)  | \
                 ((oldAddress & 0x0100) >> 1) | ((oldAddress & 0x0200) >> 1) 
    
    return newAddress

# TPP hardware also "encrypted" ROM data by shifting bits around.
# bitorder = (3, 4, 2, 5, 1, 6, 0, 7)
# data can be re-encrypted by doing this operatiuons backwards.
def encryptROMData(data):
    newData = 0xff
    
    newData = ((data & 0x01) << 7) | ((data & 0x02) >> 1) | \
              ((data & 0x04) << 4) | ((data & 0x08) >> 2) | \
              ((data & 0x10) << 1) | ((data & 0x20) >> 3) | \
              ((data & 0x40) >> 2) | ((data & 0x80) >> 4)

    return newData

#This returns a encrypted ROM buffer that aligns both addresses and data as the eproms are supposed to be read.
#With an encrypted ROM buffer, a ROM can be burnt for use on the game board.
def getEncryptedBuffer(filename, buffer_size):
    buffer = [0xFF] * buffer_size
    obfuscatedBuffer = [0xFF] * buffer_size
    obfuscatedAddress = 0xFFFF

    with open(filename,"rb") as openedFile:
        for addressCounter in range(buffer_size):
            buffer[addressCounter] = int.from_bytes(openedFile.read(1))

    for addressCounter in range(buffer_size):
        obfuscatedAddress = TNXEncryptAddress(addressCounter)
        obfuscatedBuffer[addressCounter] = encryptROMData(buffer[obfuscatedAddress])

    return obfuscatedBuffer

#Writes a given buffer to a filepath.
def writeROMData(path, buffer):
    with open(path,"wb") as openedFile:
        for byte in buffer:
            openedFile.write(byte .to_bytes(1, 'little', signed=False))

#Main program
#############################################
if len(sys.argv) > 1:
        print("Encrypting ROM")
        obfuscatedBuffer = getEncryptedBuffer(sys.argv[1],TNX_BUFFER_SIZE)
        writeROMData((sys.argv[1].replace(".bin", "_Encrypted.bin")), obfuscatedBuffer)
        print("Done")
else:
    print("Error: Invalid Arguements")
