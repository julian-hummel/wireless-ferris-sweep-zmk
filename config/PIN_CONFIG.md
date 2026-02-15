# Custom Pin Configuration for Ferris Sweep

This configuration allows you to define individual pins for each side (left and right) of your Ferris Sweep keyboard.

## Files

- `cradio_left.overlay` - Pin definitions for the LEFT side
- `cradio_right.overlay` - Pin definitions for the RIGHT side
- `cradio.keymap` - Your keymap (shared between both sides)
- `cradio.conf` - Configuration settings

## Modifying Pin Assignments

### Current Setup: Matrix Scanning

The current configuration uses **matrix scanning** with rows and columns. This uses fewer pins than direct GPIO scanning.

**Matrix Layout:** 4 rows × 5 columns per side

### Left Side (`cradio_left.overlay`)

Edit the row and column pin arrays to match your wiring:

```c
// Row pins (4 rows)
row-gpios
    = <&pro_micro 21 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>  // Row 0
    , <&pro_micro 20 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>  // Row 1
    , <&pro_micro 19 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>  // Row 2
    , <&pro_micro 18 (GPIO_ACTIVE_HIGH | GPIO_PULL_DOWN)>  // Row 3
    ;

// Column pins (5 columns)
col-gpios
    = <&pro_micro 4 GPIO_ACTIVE_HIGH>  // Col 0
    , <&pro_micro 5 GPIO_ACTIVE_HIGH>  // Col 1
    , <&pro_micro 6 GPIO_ACTIVE_HIGH>  // Col 2
    , <&pro_micro 7 GPIO_ACTIVE_HIGH>  // Col 3
    , <&pro_micro 8 GPIO_ACTIVE_HIGH>  // Col 4
    ;
```

### Right Side (`cradio_right.overlay`)

Similarly, edit the row and column pins for your right side wiring.

### Diode Direction

Set `diode-direction` based on how your diodes are oriented:
- `"col2row"` - Diodes point from columns to rows (cathode on row)
- `"row2col"` - Diodes point from rows to columns (cathode on column)

## Key Positions

The keys are organized in a 4×5 matrix per side:

```
Left Side:                    Right Side:
Row 0:  0   1   2   3   4            17  18  19  20  21
Row 1:  5   6   7   8   9            22  23  24  25  26
Row 2: 10  11  12  13  14            27  28  29  30  31
Row 3:              15  16            32  33
```

Matrix positions:
- Row 0, Col 0-4: Keys 0-4
- Row 1, Col 0-4: Keys 5-9
- Row 2, Col 0-4: Keys 10-14
- Row 3, Col 3-4: Keys 15-16 (thumb keys)

## Pin Numbering Reference

The `&pro_micro` pins refer to the Pro Micro compatible controller (nice!nano) pin numbers:
- Standard pins: 0-21
- Some pins may not be available depending on your specific controller

## Alternative: Direct GPIO Scanning

If you want to use direct GPIO scanning instead (one pin per key, no matrix), you would need to:

1. Change `compatible = "zmk,kscan-gpio-matrix"` to `compatible = "zmk,kscan-gpio-direct"`
2. Remove `diode-direction`
3. Replace `row-gpios` and `col-gpios` with a single `input-gpios` array

Example direct GPIO configuration:

```c
kscan0: kscan {
    compatible = "zmk,kscan-gpio-direct";
    wakeup-source;
    
    input-gpios
        = <&pro_micro  7 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)> // Key 0
        , <&pro_micro 18 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)> // Key 1
        , <&pro_micro 19 (GPIO_ACTIVE_LOW | GPIO_PULL_UP)> // Key 2
        // ... one pin per key (17 pins total)
        ;
};
```

And update the matrix transform:

```c
default_transform: keymap_transform_0 {
    compatible = "zmk,matrix-transform";
    columns = <34>;  // Total keys across both sides
    rows = <1>;      // Single virtual row
    map = <
    RC(0,0)  RC(0,1)  RC(0,2)  RC(0,3)  RC(0,4)    RC(0,21) RC(0,20) RC(0,19) RC(0,18) RC(0,17)
    RC(0,5)  RC(0,6)  RC(0,7)  RC(0,8)  RC(0,9)    RC(0,26) RC(0,25) RC(0,24) RC(0,23) RC(0,22)
    RC(0,10) RC(0,11) RC(0,12) RC(0,13) RC(0,14)   RC(0,31) RC(0,30) RC(0,29) RC(0,28) RC(0,27)
                                RC(0,15) RC(0,16)   RC(0,33) RC(0,32)
    >;
};
```

## Building the Firmware

After modifying the pin definitions, rebuild your firmware:

```bash
./build-firmware.sh
```

The firmware will be output to:
- `build/left.uf2` - Flash to the LEFT side
- `build/right.uf2` - Flash to the RIGHT side

## Notes

- Each side is configured independently
- Make sure the pin numbers match your physical wiring
- The pin comments indicate which key position they correspond to
- Test thoroughly after changing pin assignments
