#!/bin/bash

source venv/bin/activate

# Set Zephyr paths for CMake
export ZEPHYR_BASE="/Users/jhummel2/wireless-ferris-sweep-zmk/zephyr"
export CMAKE_PREFIX_PATH="${ZEPHYR_BASE}/share/zephyr-package/cmake"

cd zmk/app

echo "Building LEFT half with debug logging..."
west build -p -d build/left -b nice_nano -- \
  -DSHIELD=sleeky_left \
  -DZMK_CONFIG="/Users/jhummel2/wireless-ferris-sweep-zmk/config" \
  -DBOARD_ROOT="/Users/jhummel2/wireless-ferris-sweep-zmk" \
  -DEXTRA_CONF_FILE="../../../config/sleeky_debug.conf"

# Copy firmware files to convenient location
cd ../..
mkdir -p build
cp zmk/app/build/left/zephyr/zmk.uf2 build/left_debug.uf2

echo ""
echo "Debug build complete!"
echo "Left firmware: build/left_debug.uf2"
echo ""
echo "To view logs after flashing:"
echo "  macOS/Linux: screen /dev/tty.usbmodem* 115200"
echo "  Or use: cat /dev/tty.usbmodem*"
echo ""
echo "To find your device:"
echo "  ls /dev/tty.usbmodem*"
