@echo off
cd ..\..\
rmdir /S /Q .\Build
z80asm -I=Code\Source -I=Code\Public -mz80 -b -O=.\Build TNXMain.asm -o=TNXTestRom.bin -f=$c7
python ".\Tools\Checksum Patch Utility\ChecksumPatchUtility.py" ".\Build\TNXTestRom.bin"
python ".\Tools\Tnx Encryption Utility\TnxEncrypt.py" ".\Build\TNXTestRom.bin"
move .\Build\Code\Source\* .\Build\Code > nul
rmdir .\Build\Code\Source
move .\Build\Code .\Build\ObjectFiles > nul

pause