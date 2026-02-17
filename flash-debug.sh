#!/bin/bash

echo "========================================="
echo "KEYBOARD DEBUG FLASH PROCEDURE"
echo "========================================="
echo ""
echo "Current firmware files:"
ls -lh build/left.uf2 build/right.uf2
echo ""
echo "Build timestamp: $(date -r build/left.uf2 '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "USB Logging status in build:"
grep "CONFIG_ZMK_USB_LOGGING" zmk/app/build/left/zephyr/.config
echo ""
echo "========================================="
echo "FLASHING INSTRUCTIONS:"
echo "========================================="
echo ""
echo "1. Disconnect your keyboard"
echo "2. Put Nice Nano into BOOTLOADER mode:"
echo "   - Double-tap the RESET button quickly"
echo "   - You should see a drive called 'NICENANO' appear"
echo ""
echo "3. Copy the firmware:"
echo "   cp build/left.uf2 /Volumes/NICENANO/"
echo ""
echo "4. Wait for it to reboot (drive will disappear)"
echo ""
echo "5. Reconnect via USB and check for device:"
echo "   ls /dev/tty.usbmodem*"
echo ""
echo "6. Monitor logs:"
echo "   ./monitor-keyboard.sh"
echo ""
echo "Press Enter to continue and check for NICENANO drive..."
read

if [ -d "/Volumes/NICENANO" ]; then
    echo "✓ NICENANO drive detected!"
    echo ""
    echo "Copy firmware? (y/n)"
    read answer
    if [ "$answer" = "y" ]; then
        cp -v build/left.uf2 /Volumes/NICENANO/
        echo ""
        echo "Firmware copied! Waiting for reboot..."
        sleep 3
        echo "Checking for USB device..."
        sleep 2
        ls -l /dev/tty.usbmodem* 2>/dev/null || echo "No device found yet - wait a moment"
    fi
else
    echo "✗ NICENANO drive not found."
    echo "   Make sure you double-tapped the RESET button"
fi
