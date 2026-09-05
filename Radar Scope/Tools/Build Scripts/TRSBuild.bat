@echo off
cd ..\..\
z80asm -I=Code\Source -I=Code\Public -mz80 -b -O=.\Build TRSMain.asm -o=TRSTestRom.bin -f=$c7
python ".\Tools\Checksum Patch Utility\ChecksumPatchUtility.py" ".\Build\TRSTestRom.bin"
move .\Build\Code\Source\* .\Build\Code > nul
rmdir .\Build\Code\Source
move .\Build\Code .\Build\ObjectFiles > nul
pause