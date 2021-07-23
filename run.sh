#!/usr/bin/bash
#作者: entr0pia (风沐白)
#文件: run.sh
#描述: 移除Android固件(如Sony Xpeira 5II)的boot.img中的system_ext分区, 修复patch magisk后的bootloop问题
#版本: v1.0

img=$1
exname=${img##*\.}
if [ "$exname" = "sin" ]; then
    result=$(./unsin $1 | grep img)
    if [ -z "$result" ]; then
        exit
    fi
    img=${result##*/}
fi

git submodule foreach 'git clean -xdf'
git submodule set-branch -b iNux Android-Image-Kitchen
git submodule update --remote -f

mv $img Android-Image-Kitchen
cd Android-Image-Kitchen
./unpackimg.sh
sed -i 's/^system_ext/#system_ext/g' ramdisk/fstab.qcom
./repackimg.sh
mv image-new.img ..
git clean -xdf