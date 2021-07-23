@echo off
::作者: entr0pia (风沐白)
::文件: run.sh
::描述: 移除Android固件(如Sony Xpeira 5II)的boot.img中的system_ext分区, 修复patch magisk后的bootloop问题
::版本: v1.0

set img=%1
if "%img:~-3%" == "img" goto swicth

if not "%img:~-3%" == "sin" goto end
.\unsin.exe %img%
set img=%img:sin=img%

if not exist %img% goto end

:swicth
git submodule foreach "git clean -xdf"
git submodule set-branch -b iWin Android-Image-Kitchen
git submodule update --remote -f

move %img% Android-Image-Kitchen
cd Android-Image-Kitchen
call unpackimg.bat

:sed
setlocal enabledelayedexpansion
set fstab=.\ramdisk\fstab.qcom
set fstab_tmp=.\fstab.tmp

for /f "delims=" %%i in (%fstab%) do (
    set str=%%i
    set "str=!str:system_ext=#system_ext!"
    echo !str!>>%fstab_tmp%
)
move %fstab_tmp% %fstab%

call repackimg.bat
move .\image-new.img ..
git clean -xdf
cd ..

:end