#!/system/bin/sh

modules=$(ls -d /data/adb/modules/*)

for module in $modules; do
    touch "$module/disable"
done
