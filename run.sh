#!/usr/bin/bash
#作者: entr0pia (风沐白)
#文件: run.sh
#描述: 移除Android固件(如Sony Xpeira 5II)的boot.img中的system_ext分区, 修复patch magisk后的bootloop问题
#版本: v3.3

img=$1
workspace=$(pwd)

git fetch
git pull -f

user=$(whoami)
if [ "$user" != "root" ]; then
    echo -e "\033[37;41m root permission required. \033[0m"
    echo -e "\033[37;41m 需要 root 权限. \033[0m"
    exit
fi

function rmSysExt() {
    cd "$workspace/Android-Image-Kitchen"
    ./unpackimg.sh
    find . -name "fstab.*" | xargs sed -i 's/^system_ext/#system_ext/g'
    ./repackimg.sh
    mv image-new.img ..
    git clean -xdf
}

function patchMagisk() {
    cd "$workspace"
    echo
    echo -e "\033[37;41m Please connect your Android device with adb enabled. \033[0m"
    echo -e "\033[37;41m 请连接你的安卓设备, 并开启adb调试. \033[0m"
    adb wait-for-device
    adb push magisk_patch /data/local/tmp
    adb push image-new.img /data/local/tmp/magisk_patch
    adb shell "sh /data/local/tmp/magisk_patch/boot_patch.sh /data/local/tmp/magisk_patch/image-new.img"
    adb pull /data/local/tmp/magisk_patch/new-boot.img image-new.img
}

function disableModlues() {
    cd "$workspace"
    echo
    echo -e "\033[37;41m Whether to disable all modules? [y]es or [n]o \033[0m"
    read -p "是否停用所有模块? [y]es 或 [n]o: " Dis
    if [ "${Dis:0:1}" == "y" ]; then 
    echo "Disable all modules..."
    adb push disable.sh /data/local/tmp
    adb shell "su -c sh /data/local/tmp/disable.sh"
    fi
}

if [ "${img##*\.}" = "sin" ]; then
    result=$(./unsin $1 | grep "img")
    if [ -z "$result" ]; then
        exit
    fi
    img="$(dirname "$img")/$(basename "$result")"
fi

if [ "${img##*\.}" != "img" ]; then
    exit
fi

git submodule foreach 'git clean -xdf'
git submodule set-branch -b iNux Android-Image-Kitchen
git submodule update --remote -f
mv "$img" "$workspace/Android-Image-Kitchen/boot.img"
rmSysExt

cd "$workspace"
if [ ! -d "magisk_patch" ]; then
    git clone https://github.com/entr0pia/magisk_patch.git
fi
cd "magisk_patch"
git fetch
git pull -f

patchMagisk
disableModlues
echo "Done"
