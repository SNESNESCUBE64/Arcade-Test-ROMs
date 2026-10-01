# Donkey Kong Test ROM Quick Start Guide
## Required Parts
- 2532 (or equivalent) 4k EPROM

## Required Tools
- EPROM Programmer (for programming test ROM)
- UV EPROM Eraser

## Burning the EPROM
This process varies from programmer to programmer suite. The overall process is as follows:
1. Plug in programmer and open software
2. Assuming connection is successful, select device type and find your 2532 EPROM keeping in mind the manufacturer of the ROM matters
    - Sometimes it is not obvious, however each manufacturer typically has a marking. You can find out who made the chip by searching online for "IC manufactuer symbols"
3. After chip is selected, verify that the ROM is blank
    - if the ROM is not blank use the UV eraser if it is a UV EPROM
4. Load the test ROM file TKGTestRom_V1_02.5e5f
    - CRC32: 70ca99f0
    - SHA-1: d147a0ee241b183c2b179b6724254efd7c2f75ac
5. Program the device
6. Validate that the device was programmed correctly

## Using the Test ROM
We are going to be looking at the CPU board only. It is not inherently necessary to remove the board from the machine but be careful when swapping out the ROMs.
1. **Ensure the machine is powered off and no power is going to the board**
2. Carefully remove the origianl EPROM at 5E for TKG4 hardware or 5F on TKG2 and TKG3 hardware on the CPU board
    - Save this for later as when you are done you will just put the original ROM back.
3. Insert the test ROM into the now empty socket at 5E for TKG4 hardware or 5F on TKG2 and TKG3 hardware
    - Note the pin 1 notch, the EPROM can only operate one way
    - Inspect for any bent pins or mistakes before proceeding
4. Turn machine on and begin diagnostics