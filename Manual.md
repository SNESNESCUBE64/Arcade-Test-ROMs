# TKG/TRS Test ROM Manual
Last Revised: 03 August 2026
Written by: SNESNESCUBE64

## Table of Contents
1. Overview
2. Startup Tests
3. Runtime Test Menu
4. RAM Tests
    1. TRS RAM
    2. TRS2, TKG2, and TKG3 RAM
    3. TKG4 RAM
5. ROM Checks
6. Audio Tests
    1. TRS Audio
    2. TKG Audio
7. Controls Tests
8. DIP Switch Print
9. Monitor Adjustment Patterns
10. Miscellaneous Tests
    1. Screen Flip
    2. Color Palette Test
    3. DMA Test
    4. NMI Test
    5. Grid (TRS/TRS2 only)

## Chapter 1: Overview
The purpose of this manual is to ensure that the user of the test ROM has all of the information required to use and interpret the test ROM data. This test ROM targets the following hardware:
- TRS / I80
- TRS2
- TKG
- TKG2
- TKG3
- TKG4

There are several test ROMs available. They can be split into one of two categories:
- Standalone, Complete Test Suite
- Test socket, Test Menu Only

The standalone ROM replaces ROM0 and contains all tests for an appropriate game. TRS and TKG test ROMs have some different tests as the hardware is slightly different.
## Chapter 4: RAM Tests
### Section 1: TRS RAM
#### RAM Info Table
| **Name** |  **Designation** | **Type** | **Start Address** | **Size** | **High Bit Location** | **Low Bit Location** |
|:--------:|:----------------:|:--------:|:-----------------:|:--------:|:---------------------:|:--------------------:|
| RAM0     | Work RAM         | 2114     | 0x6000            | 1k x 4   | C-6L                  | C-6H                 |
| RAM1     | Work RAM         | 2114     | 0x6400            | 1k x 4   | C-6M                  | C-6J                 |
| RAM2     | Work RAM         | 2114     | 0x6800            | 1k x 4   | C-6N                  | C-6K                 |
| RAM3     | Sprite           | 2148     | 0x7000            | 1k x 4   | V-5J                  | V-4J                 |
| RAM4     | Video/Background | 2114     | 0x7400            | 1k x 4   | V-3H                  | V-3J                 |

### Section 2: TRS2, TKG2 RAM
TRS2 was the final revision 
#### RAM Info Table
| **Name** |  **Designation** | **Type** | **Start Address** | **Size** | **High Bit Location** | **Low Bit Location** |
|:--------:|:----------------:|:--------:|:-----------------:|:--------:|:---------------------:|:--------------------:|
| RAM0     | Work RAM         | 2114     | 0x6000            | 1k x 4   | C-6L                  | C-6H                 |
| RAM1     | Work RAM         | 2114     | 0x6400            | 1k x 4   | C-6M                  | C-6J                 |
| RAM2     | Work RAM         | 2114     | 0x6800            | 1k x 4   | C-6N                  | C-6K                 |
| RAM3     | Sprite           | 2148     | 0x7000            | 1k x 4   | V-5J                  | V-5K                 |
| RAM4     | Video/Background | 2114     | 0x7400            | 1k x 4   | V-3K                  | V-3J                 |

### Section 2:TKG3 RAM
TKG3 was the first significant revision of the hardware. Many features specific to the TRS game were removed in this revision
#### RAM Info Table
| **Name** |  **Designation** | **Type** | **Start Address** | **Size** | **High Bit Location** | **Low Bit Location** |
|:--------:|:----------------:|:--------:|:-----------------:|:--------:|:---------------------:|:--------------------:|
| RAM0     | Work RAM         | 2114     | 0x6000            | 1k x 4   | C-6L                  | C-6H                 |
| RAM1     | Work RAM         | 2114     | 0x6400            | 1k x 4   | C-6M                  | C-6J                 |
| RAM2     | Work RAM         | 2114     | 0x6800            | 1k x 4   | C-6N                  | C-6K                 |
| RAM3     | Sprite           | 2148     | 0x7000            | 1k x 4   | V-2L                  | V-2M                 |
| RAM4     | Video/Background | 2114     | 0x7400            | 1k x 4   | V-5L                  | V-5M                 |

### Section 3: TKG4 RAM
TKG4 was the final major revision of the TKG hardware. With this revision, the PCB count was reduced from four to two boardsets. As such, locations for the RAM have changed.
#### RAM Info Table
| **Name** |  **Designation** | **Type** | **Start Address** | **Size** | **High Bit Location** | **Low Bit Location** |
|:--------:|:----------------:|:--------:|:-----------------:|:--------:|:---------------------:|:--------------------:|
| RAM0     | Work RAM         | 2114     | 0x6000            | 1k x 4   | C-4C                  | C-3C                 |
| RAM1     | Work RAM         | 2114     | 0x6400            | 1k x 4   | C-4B                  | C-3B                 |
| RAM2     | Work RAM         | 2114     | 0x6800            | 1k x 4   | C-4A                  | C-3A                 |
| RAM3     | Sprite           | 2148     | 0x7000            | 1k x 4   | V-6R                  | V-6P                 |
| RAM4     | Video/Background | 2114     | 0x7400            | 1k x 4   | V-2R                  | V-2P                 |

## Chapter 5: ROM Checks
#### ROM Info Table
| **Designation** | **Type** | **Start Address** | **Size** | **TRS/TRS2/TKG2/TKG3 Location** | **TKG4 Location** |
|:---------------:|:--------:|:-----------------:|:--------:|:-------------------------------:|:-----------------:|
| ROM0            | 2532     | 0x0000            |    4k    |                5F               |         5E        |
| ROM1            | 2532     | 0x1000            |    4k    |                5G               |         5C        |
| ROM2            | 2532     | 0x2000            |    4k    |                5H               |         5B        |
| ROM3            | 2532     | 0x3000            |    4k    |                5K               |         5A        |

## Chapter 10: Miscellaneous
### Section 1: Screen Flip
The flipping of the screen is handled through hardware. By default, the screen is flipped upside down and has to be flipped. You accomplish this by writing to address 0x7D82. To invert the screen, you can accomplish such by writing 0xF0. To uninvert the screen you can write 0x0F.

The test program by default un-inverts the screen after the RAM test. An option to invert/uninvert the screen is provided in the runtime test menu. You can flip the screen by just tapping the "jump" button.

### Section 2: Color Palette Test

### Section 3: DMA Test
TRS/TKG hardware relies heavily on DMA to transfer sprite information so that the CPU can be free to do other activites. On TKG software, it transfers sprites from 0x6900-0x6A80 to 0x7000-0x7180. As part of the startup tests, this functionality is peformed by doing 3 transfers:
- Transfer all 0xAA
- Transfer all 0x55
- Transfer all 0x00

It initiates the transfer and then waits one second. After it compares the results to verify that it was written properly. If any bytes did not transfer properly, then it will report a failure. *If the sprite RAM (reported as RAM3) is not functional, the DMA test will not pass.* Results are reported under "System Tests" during the startup tests. The actual test performs immediately after the RAM test.

### Section 4: NMI Test
TRS/TKG also relies heavily on NMI to trigger various routines including screen actions. The reason it does such is that NMI, when enabled, triggers during VBlank. In original TKG software, this is where the watchdog is refreshed and DMA is kicked off. By default, NMI is not enabled on TKG hardware and must be enabled every single time it needs to be used. It can be both manually enabled and disabled. To enable it in software, you can write 0x0F to 0x7D84. To disable it, you can write 0xF0 to 0x7D84. The enable is a physical enable 74LS74 that lives between the NMI pin and VBlank.

The NMI test occurs after the DMA test gets reported. The way it works is NMI is enabled, from there when VBlank triggers it goes to the NMI routine at 0x0066. During this routine, the test ROM writes to the $40 of the H result register. When NMI is enabled, it enters a one second delay. This is ample time for NMI to trigger. If the delay finishes and no NMI is read from the result register, the test ROM assumes that NMI is not functional and will report a failure.

### Section 5: Grid Test
This test is unavailble in the TKG version of the test ROM. The grid is a TRS exclusive feature. This test would provide means of enabling and disabling the grid and changing the color of it.