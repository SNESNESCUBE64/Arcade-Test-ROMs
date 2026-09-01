@echo off
cd ..\..\
z80asm -I=Code\Source -I=Code\Public -mz80 -b -O=.\Build TKGMain.asm -o=TKGTestRom.bin -f=$c7
python ".\Tools\Checksum Patch Utility\ChecksumPatchUtility.py" ".\Build\TKGTestRom.bin"
move .\Build\Code\Source\* .\Build\Code > nul
rmdir .\Build\Code\Source
move .\Build\Code .\Build\ObjectFiles > nul
pause