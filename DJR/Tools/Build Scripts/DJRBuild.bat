@echo off
cd ..\..\
z80asm -I=Code\Source -I=Code\Public -mz80 -b -O=.\Build DJRMain.asm -o=DJRTestRom.bin -f=$c7
python ".\Tools\Checksum Patch Utility\ChecksumPatchUtility.py" ".\Build\DJRTestRom.bin"
move .\Build\Code\Source\* .\Build\Code > nul
rmdir .\Build\Code\Source
move .\Build\Code .\Build\ObjectFiles > nul
pause