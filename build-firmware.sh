#!/bin/bash

source venv/bin/activate

# Ensure dependencies are updated
#west update

# Set Zephyr paths for CMake
export ZEPHYR_BASE="/Users/jhummel2/wireless-ferris-sweep-zmk/zephyr"
export CMAKE_PREFIX_PATH="${ZEPHYR_BASE}/share/zephyr-package/cmake"

cd zmk/app

west build -p -d build/left -b nice_nano -- \
  -DSHIELD=cradio_left \
  -DZMK_CONFIG="/Users/jhummel2/wireless-ferris-sweep-zmk/config"

west build -p -d build/right -b nice_nano -- \
  -DSHIELD=cradio_right \
  -DZMK_CONFIG="/Users/jhummel2/wireless-ferris-sweep-zmk/config"

# Copy firmware files to convenient location
cd ../..
mkdir -p build
cp zmk/app/build/left/zephyr/zmk.uf2 build/left.uf2
cp zmk/app/build/right/zephyr/zmk.uf2 build/right.uf2

echo ""
echo "Build complete!"
echo "Left firmware: build/left.uf2"
echo "Right firmware: build/right.uf2"