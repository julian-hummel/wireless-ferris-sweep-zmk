#!/bin/bash

echo "Monitoring ALL USB serial devices..."
echo "Press RESET on keyboard or press some keys"
echo "Press Ctrl+C to exit"
echo ""

# Monitor all usbmodem devices
for dev in /dev/tty.usbmodem*; do
    if [ -e "$dev" ]; then
        echo "Starting monitor on $dev"
        cat "$dev" &
    fi
done

wait
