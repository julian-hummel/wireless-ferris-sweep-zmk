#!/bin/bash

include_settings_reset=false

for arg in "$@"; do
  case "$arg" in
    --with-settings)
      include_settings_reset=true
      ;;
    -h|--help)
      echo "Usage: $0 [--with-settings]"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--with-settings]"
      exit 1
      ;;
  esac
done

source venv/bin/activate

# Ensure dependencies are updated
#west update

# Set Zephyr paths for CMake
export ZEPHYR_BASE="/Users/jhummel2/wireless-ferris-sweep-zmk/zephyr"
export CMAKE_PREFIX_PATH="${ZEPHYR_BASE}/share/zephyr-package/cmake"

cd zmk/app

west build -p -d build/left -b nice_nano -- \
  -DSHIELD=sleeky_left \
  -DZMK_CONFIG="/Users/jhummel2/wireless-ferris-sweep-zmk/config" \
  -DBOARD_ROOT="/Users/jhummel2/wireless-ferris-sweep-zmk"

west build -p -d build/right -b nice_nano -- \
  -DSHIELD=sleeky_right \
  -DZMK_CONFIG="/Users/jhummel2/wireless-ferris-sweep-zmk/config" \
  -DBOARD_ROOT="/Users/jhummel2/wireless-ferris-sweep-zmk"

if [ "$include_settings_reset" = true ]; then
  west build -p -d build/settings_reset -b nice_nano -- \
    -DSHIELD=settings_reset \
    -DZMK_CONFIG="/Users/jhummel2/wireless-ferris-sweep-zmk/config" \
    -DBOARD_ROOT="/Users/jhummel2/wireless-ferris-sweep-zmk"
fi

# Copy firmware files to convenient location
cd ../..
mkdir -p build
cp zmk/app/build/left/zephyr/zmk.uf2 build/left.uf2
cp zmk/app/build/right/zephyr/zmk.uf2 build/right.uf2
if [ "$include_settings_reset" = true ]; then
  cp zmk/app/build/settings_reset/zephyr/zmk.uf2 build/settings_reset.uf2
fi

echo ""
echo "Build complete!"
echo "Left firmware: build/left.uf2"
echo "Right firmware: build/right.uf2"
if [ "$include_settings_reset" = true ]; then
  echo "Settings reset firmware: build/settings_reset.uf2"
fi