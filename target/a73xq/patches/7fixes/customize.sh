echo "Adding lux kernel"
cp -rf prebuilts/lux/boot.img out/work_dir/kernel/boot.img
cp -rf prebuilts/lux/dtbo.img out/work_dir/kernel/dtbo.img
cp -rf prebuilts/lux/vendor_boot.img out/work_dir/kernel/vendor_boot.img

echo "Adding camera/floating xml mods"
cat prebuilts/lux/camera-feature.xml > out/work_dir/system/system/cameradata/camera-feature.xml
cat prebuilts/lux/floating_feature.xml > out/work_dir/system/system/etc/floating_feature.xml

echo "Adding CTS and AI Wallpaper"
BLOB_LIST_R+=$(find prebuilts/samsung/r11sxxx/product -type f -print0 | xargs -0 -I {} echo "{} " | sed 's|prebuilts/samsung/r11sxxx/product/||g')
for blob in $BLOB_LIST_R
do
    DELETE_FROM_WORK_DIR "product" "$blob" &>/dev/null
    ADD_TO_WORK_DIR "r11sxxx" "product" "$blob"
    if [[ "$blob" == *.apk ]]; then
        oatfolder="out/work_dir/product/$(dirname "$blob")/oat"
        [[ -d "$oatfolder" ]] && DELETE_FROM_WORK_DIR "product" "${oatfolder#out/work_dir/product/}" &>/dev/null
    fi
done

echo "Replacing Camera App"
DELETE_FROM_WORK_DIR "system" "system/priv-app/SamsungCamera" &>/dev/null
ADD_TO_WORK_DIR "r12sksx" "system" "system/priv-app/SamsungCamera/SamsungCamera.apk"

echo "Replacing Gallery"
DELETE_FROM_WORK_DIR "system" "system/priv-app/PhotoEditor_Full" &>/dev/null
ADD_TO_WORK_DIR "r11sxxx" "system" "system/priv-app/PhotoEditor_AIFull/PhotoEditor_AIFull.apk"
DELETE_FROM_WORK_DIR "system" "system/app/SketchBook" &>/dev/null
ADD_TO_WORK_DIR "r11sxxx" "system" "system/app/SketchBook/SketchBook.apk"

echo "Adding Smart Select"
ADD_TO_WORK_DIR "r11sxxx" "system" "system/lib64/libLttEngine.camera.samsung.so"

echo "Adding Now Brief & More AI & Photo Ambient Wallpaper"
BLOB_LIST_S+=$(find prebuilts/samsung/pa3qxxx/system -type f -print0 | xargs -0 -I {} echo "{} " | sed 's|prebuilts/samsung/pa3qxxx/||g')
for blob in $BLOB_LIST_S
do
    DELETE_FROM_WORK_DIR "system" "$blob" &>/dev/null
    ADD_TO_WORK_DIR "pa3qxxx" "system" "$blob"
    if [[ "$blob" == *.apk ]]; then
        oatfolder="out/work_dir/system/$(dirname "$blob")/oat"
        [[ -d "$oatfolder" ]] && DELETE_FROM_WORK_DIR "system" "${oatfolder#out/work_dir/system/}" &>/dev/null
    fi
done

#echo "NOT Adding live blur yet..."
#DELETE_FROM_WORK_DIR "system" "system/bin/surfaceflinger"
#ADD_TO_WORK_DIR "r9qxxx" "system" "system/bin/surfaceflinger" 0 2000 755 "u:object_r:surfaceflinger_exec:s0"
#DELETE_FROM_WORK_DIR "system" "system/lib/libgui.so"
#ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib/libgui.so" 0 0 644 "u:object_r:system_lib_file:s0"
#DELETE_FROM_WORK_DIR "system" "system/lib/libui.so"
#ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib/libui.so" 0 0 644 "u:object_r:system_lib_file:s0"
#DELETE_FROM_WORK_DIR "system" "system/lib64/libgui.so"
#ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib64/libgui.so" 0 0 644 "u:object_r:system_lib_file:s0"
#DELETE_FROM_WORK_DIR "system" "system/lib64/libui.so"
#ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib64/libui.so" 0 0 644 "u:object_r:system_lib_file:s0"

echo "Add from tweaks module."
LINE="$(sed -n '/\/dev\/cpuset\/background\/cpus/=' "$WORK_DIR/vendor/bin/init.kernel.post_boot-yupik.sh")"
sed -i \
    "$LINE cecho 0-1 > /dev/cpuset/background/cpus\necho 0-3 > /dev/cpuset/restricted/cpus" \
    "$WORK_DIR/vendor/bin/init.kernel.post_boot-yupik.sh"
