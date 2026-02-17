#!/bin/bash

echo "Looking for USB serial devices..."
DEVICE=$(ls /dev/tty.usbmodem* 2>/dev/null | head -n 1)

if [ -z "$DEVICE" ]; then
    echo "No USB serial device found!"
    echo "Make sure your keyboard is connected via USB."
    exit 1
fi

echo "Found device: $DEVICE"
echo "Starting log viewer..."
echo "Press Ctrl+A then K to exit, or Ctrl+C"
echo ""

# Use cat for simple, scrolling output
cat "$DEVICE"
