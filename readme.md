# XPatch

[English](https://github.com/entr0pia/XPatch#readme) | [中文](https://github.com/entr0pia/XPatch/blob/master/readme_zh.md)

Remove the ```system_ext``` partition in ```boot.img``` of Android (such as Sony Xpeira 5II) firmware.

## Scenes
If your Android (especially Android 11) bootloop after patched ```magisk```, as described in [Issue #3752 · topjohnwu/Magisk](https://github.com/topjohnwu/Magisk/issues/3752), it may be caused by the ```system_ext``` partition in ```boot.img```. Try the script to fix bootloop.

## Instructions
1. Clone this repo:
    ```shell
    git clone --recurse-submodules https://github.com/entr0pia/XPatch.git
    ```

2. Get the ```boot.img``` file from wherever you can get ```boot.img```. For Sony Xperia firmware, it's possibly named as ```boot_X-FLASH-ALL-xxxx.sin```.

3. Connect Android device with adb enabled.

4. Use this script to modify the stock ```boot.img```, both Sony Xperia's ```.sin``` and regular ```.img``` files supported:
    - Linux
    ```shell
    # Linux
    ./run.sh path_to_boot_img_file
    ```
    

    - Windows
    ```cmd
    .\run.bat path_to_boot_img_file
    ```

    - Outs: ```image-new.img```

5. Diasble all Magisk modules --  *Optional but recommended*

6. Flash Magisk:
    
    Reboot your phone to the ```bootloader```, use ```fastboot``` to flash the ```image-new.img``` into the ```boot``` partition, then reboot.
    > Fix: Sometimes, you must use the stock ```boot.img``` to boot system regularly before flashing the ```image-new.img```.
