echo "ro.unica.version=$ROM_VERSION" >> "$WORK_DIR/system/system/build.prop"
echo "ro.unica.codename=$ROM_CODENAME" >> "$WORK_DIR/system/system/build.prop"
echo "ro.unica.timestamp=$ROM_BUILD_TIMESTAMP" >> "$WORK_DIR/system/system/build.prop"

if ! grep -q "choidujour" "$WORK_DIR/configs/file_context-system"; then
    {
        echo "/system/etc/default-permissions/default-permissions-io\.mesalabs\.choidujour\.xml u:object_r:system_file:s0"
        echo "/system/etc/permissions/privapp-permissions-io\.mesalabs\.choidujour\.xml u:object_r:system_file:s0"
        echo "/system/priv-app/ChoiDujour u:object_r:system_file:s0"
        echo "/system/priv-app/ChoiDujour/ChoiDujour\.apk u:object_r:system_file:s0"
    } >> "$WORK_DIR/configs/file_context-system"
fi
if ! grep -q "choidujour" "$WORK_DIR/configs/fs_config-system"; then
    {
        echo "system/etc/default-permissions/default-permissions-io.mesalabs.choidujour.xml 0 0 644 capabilities=0x0"
        echo "system/etc/permissions/privapp-permissions-io.mesalabs.choidujour.xml 0 0 644 capabilities=0x0"
        echo "system/priv-app/ChoiDujour 0 0 755 capabilities=0x0"
        echo "system/priv-app/ChoiDujour/ChoiDujour.apk 0 0 644 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-system"
fi

CERT_NAME="aosp_testkey"
$ROM_IS_OFFICIAL && [ -f "$SRC_DIR/unica/security/unica_ota.x509.pem" ] && CERT_NAME="unica_ota"

rm "$WORK_DIR/system/system/etc/security/otacerts.zip"
cd "$SRC_DIR" ; zip -q "$WORK_DIR/system/system/etc/security/otacerts.zip" "./unica/security/$CERT_NAME.x509.pem" ; cd - &> /dev/null