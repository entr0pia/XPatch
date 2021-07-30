#!/usr/bin/bash
#作者: entr0pia (风沐白)
#文件: run.sh
#描述: 移除Android固件(如Sony Xpeira 5II)的boot.img中的system_ext分区, 修复patch magisk后的bootloop问题
#版本: v2.0

img=$1
workspace=$(pwd)

function rmSysExt(){
    cd "$workspace/Android-Image-Kitchen"
    ./unpackimg.sh
    find . -name "fstab.*" | xargs sed -i 's/^system_ext/#system_ext/g'
    ./repackimg.sh
    mv image-new.img ..
    ./cleanup.sh
    git clean -xdf
}

function patchMagisk(){
    cd "$workspace/magisk_patch"
    mv ../image-new.img .
    git fetch --all && git reset --hard origin/master
    ./boot_patch.sh image-new.img
    mv new-boot.img ../image-new.img
    git clean -xdf
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
if [ ! -d "magisk_patch" ]; then
    git clone https://github.com/entr0pia/magisk_patch.git
fi

mv "$img" "$workspace/Android-Image-Kitchen/boot.img"
rmSysExt
patchMagisk
