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

3. Use this script to modify the stock ```boot.img```, both Sony Xperia's ```.sin``` and regular ```.img``` files supported:
    ```
    # Linux (WSL2 also tested)
    ./run.sh path_to_boot_img_file
    ```
    ```bat
    # Windows (Experimentally, not Suggested)
    .\run.bat path_to_boot_img_file
    ```
    Outs: ```image-new.img```
    - Fix: If the error is shown as **Unrecognized format** on Windows, replace the line endings of the following file by ```LF```:
        ```
        Android-Image-Kitchen\android_win_tools\androidbootimg.magic
        Android-Image-Kitchen\android_win_tools\magic
        ```

4. Flash Magisk:
    - Method 1: Use Magisk Manager to patch ```image-new.img```, copy the patched image to the computer, then reboot your phone to the ```bootloader```, and use ```fastboot``` to flash the patched image into the ```boot``` partition. Reboot.
    - Method 2: Reboot your phone to the ```bootloader```, use ```fastboot``` to flash ```image-new.img``` into the ```boot``` partition, then reboot your phone to ```recovery```, flash the ```magisk.zip``` file. Reboot.
