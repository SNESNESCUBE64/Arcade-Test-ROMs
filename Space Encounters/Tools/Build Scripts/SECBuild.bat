@echo off
cd ..\..\
z80asm -I=Code\Source -I=Code\Public -m8080 -b -O=.\Build SEControlsMain.asm -o=SEControlsTestRom.1H -f=$c7
python ".\Tools\Checksum Patch Utility\ChecksumPatchUtility.py" ".\Build\SEControlsTestRom.1H"
move .\Build\Code\Source\* .\Build\Code > nul
rmdir .\Build\Code\Source
move .\Build\Code .\Build\ObjectFiles > nul
pause