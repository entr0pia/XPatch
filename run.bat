@echo off
::作者: entr0pia (风沐白)
::文件: run.sh
::描述: 移除Android固件(如Sony Xpeira 5II)的boot.img中的system_ext分区, 修复patch magisk后的bootloop问题
::版本: v3.1

set img=%1
set workspace=%cd%
if "%img:~-3%" == "img" goto swicth
if not "%img:~-3%" == "sin" goto end
.\unsin.exe %img%
set img=%img:sin=img%
if not exist %img% goto end

:swicth
git submodule foreach "git clean -xdf"
git submodule set-branch -b iWin Android-Image-Kitchen
git submodule update --remote -f

move %img% Android-Image-Kitchen\boot.img
cd Android-Image-Kitchen
call unpackimg.bat

:sed
setlocal enabledelayedexpansion
set fstab_tmp=%workspace%\fstab.tmp
if exist %fstab_tmp% del %fstab_tmp%
for /R "." %%f in (fstab.*) do (
for /f "delims=" %%i in (%%f) do (
    set str=%%i
    set "str=!str:system_ext=#system_ext!"
    echo !str!>>%fstab_tmp%
)
copy %fstab_tmp% %%f
)

:repack
call repackimg.bat
move .\image-new.img ..
git clean -xdf

:patch
cd %workspace%
if not exist magisk_patch git clone https://github.com/entr0pia/magisk_patch.git
cd magisk_patch
git fetch
git pull -f
cd %workspace%

echo Please connect your Android device with adb enabled.
echo 请连接你的安卓设备, 并开启adb调试.
adb wait-for-device
adb push magisk_patch /data/local/tmp
adb push image-new.img /data/local/tmp/magisk_patch
adb shell "sh /data/local/tmp/magisk_patch/boot_patch.sh /data/local/tmp/magisk_patch/image-new.img"
adb pull /data/local/tmp/magisk_patch/new-boot.img image-new.img
:end