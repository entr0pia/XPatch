# XPatch

[English](https://github.com/entr0pia/XPatch#readme) | [中文](https://github.com/entr0pia/XPatch/blob/master/readme_zh.md)

移除 Android (如 Sony Xpeira 5II) 固件的 ```boot.img``` 中的 ```system_ext``` 分区.

## 使用场景

如果你的 Android (特别是 Android 11) 在刷入 ```magisk``` 后无限重启, 如 [Issue #3752 · topjohnwu/Magisk](https://github.com/topjohnwu/Magisk/issues/3752) 所描述的那样, 可能是由 ```boot.img``` 中的 ```system_ext``` 分区导致的. 尝试使用此脚本来修复问题.

## 使用方法

1. 克隆此仓库, 使用 [GitHub Proxy 代理加速 - 镜像站](https://ghproxy.com/) 代理:
    ```shell
    git clone --recurse-submodules https://ghproxy.com/https://github.com/entr0pia/XPatch.git
    ```

2. 从任何你能获取到 ```boot.img``` 的地方获取 ```boot.img``` 文件. 对于Sony Xperia的固件, 它可能的名字是 ```boot_X-FLASH-ALL-xxxx.sin```.

3. 请连接安卓设备, 并开启adb调试.

4. 使用此脚本修改原厂 ```boot.img```, 支持Sony Xperia的 ```.sin``` 和常规的 ```.img``` 文件:
    - Linux
    ```shell
    # Linux
    ./run.sh path_to_boot_img_file
    ```

    - Windows
    ```
    .\run.bat path_to_boot_img_file
    ```
    
    - 输出: ```image-new.img```

   

5. 刷入 ```magisk```:

    重启手机到 ```bootloader```, 用 ```fastboot``` 将 ```image-new.img``` 刷入 ```boot``` 分区, 然后重启.
    > 修复: 某些情况下, 您必须在刷入 ```image-new.img``` 之前用原厂 ```boot.img``` 正常启动一次系统. 如果刷入 ```image-new.img``` 后依旧无限重启, 请强行进入安全模式以停用所有 Magisk 模块.

