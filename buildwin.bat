@echo off
echo Build script for Windows
echo.

echo Assembling bootloader...
cd source\bootload
nasm -O0 -f bin -o bootload.bin bootload.asm
cd ..

echo Assembling MikeOS kernel...
nasm -O0 -f bin -o kernel.bin kernel.asm

echo Assembling programs...
cd ..\programs
 for %%i in (*.asm) do nasm -O0 -f bin %%i
 for %%i in (*.run) do del %%i
 for %%i in (*.) do ren %%i %%i.run
cd ..

echo Mounting disk image...
imdisk -a -f disk_images\interdos.flp -s 1440K -m B:

echo Deleting All files in disk image...
del b:\*

echo Copying kernel, applications, and content file to disk image...
copy source\kernel.bin b:\
copy programs\*.run b:\
copy programs\*.bas b:\
copy content\* b:\

echo Dismounting disk image...
imdisk -D -m B:

echo Copying...
cd disk_images
copy interdos.flp ..
cd ..

echo Done!

pause