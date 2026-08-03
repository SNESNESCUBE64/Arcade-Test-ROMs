# TKG/TRS Test ROM Manual

The purpose of this manual is to ensure that the user of the test ROM has all of the information required to use and interpret the test ROM data. This test ROM targets the following hardware:
- TRS / I80
- TRS2
- TKG
- TKG2
- TKG3
- TKG4

## Table of Contents
1. Overview
2. Startup Tests
3. Test Menu
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
9. TRS Specific Tests
   1. Grid Test
10. Monitor Adjustment Patterns

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
| RAM3     | Video/Background | 2114     | 0x7400            | 1k x 4   | V-2R                  | V-2P                 |
