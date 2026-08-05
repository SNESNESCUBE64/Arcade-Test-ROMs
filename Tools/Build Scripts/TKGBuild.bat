@echo off
cd ..\..\
z80asm -I=Source -I=Public -mz80 -b -O=.\Build TKGMain.asm -o=TKGTestRom.bin
python ".\Tools\Checksum Patch Utility\ChecksumPatchUtility.py" ".\Build\TKGTestRom.bin"
move .\Build\Source\* .\Build > nul
rmdir .\Build\Source