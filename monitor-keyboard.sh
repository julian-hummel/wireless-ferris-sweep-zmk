#!/bin/bash

echo "=== Keyboard Debugging Guide ==="
echo ""
echo "USB Device Found: /dev/tty.usbmodem1101"
echo ""
echo "USB Logging Status:"
grep "CONFIG_ZMK_USB_LOGGING" zmk/app/build/left/zephyr/.config 2>/dev/null || echo "Build not found"
echo ""
echo "Now monitoring keyboard logs..."
echo "TRY THESE STEPS:"
echo "  1. Press keys on your keyboard - you should see kscan events"
echo "  2. Press the RESET button once - you should see boot messages"
echo "  3. If you see kscan events but no keystrokes work, it's a keymap issue"
echo "  4. Press Ctrl+C to exit this view"
echo ""
echo "--- LOG OUTPUT BELOW ---"
echo ""

cat /dev/tty.usbmodem1101
