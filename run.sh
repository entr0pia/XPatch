#!/usr/bin/bash

result=$(./unsin $1 | grep img)
if [ -z "$result" ]; then
    exit
fi
img=${result##*/}

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
