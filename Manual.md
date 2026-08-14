# TKG/TRS Test ROM Manual
Last Revised: 03 August 2026
Written by: SNESNESCUBE64

## Table of Contents
1. Overview
2. Startup Tests
4. Runtime Test Menu
5. RAM Tests
    1. TRS RAM
    2. TRS2, TKG2, and TKG3 RAM
    3. TKG4 RAM
6. ROM Checks
7. Audio Tests
    1. TRS Audio
    2. TKG Audio
8. Controls Tests
9. DIP Switch Print
10. Monitor Adjustment Patterns
11. Miscellaneous Tests
    1. Screen Flip
    2. NMI Test
    3. DMA Test
    4. Color Palette Test
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
### Section 2: TRS2, TKG2, and TKG3 RAM
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
