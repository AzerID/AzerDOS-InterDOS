@echo off
echo Running InterDOS...
"C:\Program Files\qemu\qemu-system-x86_64.exe" "interdos.flp" -soundhw all -rtc base=localtime

echo Done!