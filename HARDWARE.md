# RG34XXSP Hardware Specifications

## Overview

The ANBERNIC RG34XXSP is a GBA SP-inspired clamshell handheld gaming device featuring a 3.4-inch display, dual analog sticks, and comprehensive connectivity options. This document provides complete hardware specifications for Armbian development.

## Main Hardware Components

### System-on-Chip (SoC)
- **Chipset**: Allwinner H700 (sun50iw9 family)
- **Architecture**: ARM Cortex-A53 quad-core @ 1.5GHz
- **Process**: 28nm
- **GPU**: Mali-G31 MP2 dual-core @ 850MHz
- **Memory**: 2GB LPDDR4 RAM
- **Storage**: 64GB eMMC (expandable via microSD to 512GB)

### Display System
- **Screen**: 3.4-inch full-fit IPS LCD
- **Resolution**: 720×480 pixels (3:2 aspect ratio)
- **Touch**: No touchscreen support
- **Backlight**: PWM-controlled LED backlight
- **Panel Type**: MIPI-DPI-SPI compatible
- **Color Depth**: 24-bit RGB888

### Audio System
- **Codec**: Built-in sun8i-codec (Allwinner internal)
- **Output**: Dual speakers + 3.5mm headphone jack
- **Amplifier**: 74HC4052D analog multiplexer
- **Microphone**: Built-in microphone with bias control
- **Headphone Detection**: Automatic switching via GPIO
- **Formats**: "flac", "mp3", "wav", "ape", "aif", "aiff", "ogg", "wma", "aac", "m4a", "m4r"

### Input Controls

#### D-Pad and Action Buttons
- **D-Pad**: PA6 (Up), PA8 (Left), PE0 (Down), PA9 (Right)
- **Action Buttons**: PA0 (A), PA1 (B), PA3 (X), PA2 (Y)
- **Shoulder Buttons**: PA10 (L1), PA11 (L2), PA12 (R1), PA7 (R2)
- **System Buttons**: PA5 (Select), PA4 (Start), PE3 (Menu)
- **Volume Controls**: PE1 (Up), PE2 (Down)

#### Analog Controls
- **Left Stick**: ADC-based analog joystick
- **Right Stick**: ADC-based analog joystick
- **Stick Configuration**: Sunken dual joystick design
- **Calibration**: Hardware-based dead zone compensation

### Wireless Connectivity

#### WiFi
- **Chipset**: Realtek RTL8821CS
- **Interface**: SDIO (Secure Digital Input/Output)
- **Standards**: IEEE 802.11 a/b/g/n/ac
- **Bands**: 2.4GHz and 5GHz dual-band
- **Antenna**: Internal PCB antenna
- **GPIO Control**: Power sequencing via dedicated GPIO

#### Bluetooth
- **Chipset**: RTL8821CS-BT (integrated with WiFi)
- **Version**: Bluetooth 4.2
- **Interface**: UART1 with RTS/CTS flow control
- **GPIO Control**: Enable/disable and wake signals
- **Profiles**: A2DP, HID, HFP support

### Power Management

#### Battery System
- **Capacity**: 3,300mAh lithium-ion battery
- **Type**: Replaceable battery pack
- **Charging**: USB-C PD (Power Delivery)
- **Voltage**: 3.7V nominal
- **Runtime**: 4-6 hours typical gaming

#### Power Management IC (PMIC)
- **Controller**: AXP717 (Allwinner standard)
- **Features**: Battery charging, voltage regulation, power sequencing
- **Regulators**: Multiple voltage rails for SoC, memory, peripherals
- **GPIO Control**: Power button, LED indicators

#### LED Indicators
- **Power LED**: PI12 (Power status)
- **Status LED**: PI11 (Activity/charging status)
- **Colors**: Red/Green/Blue multicolor support

### Storage and Expansion

#### Internal Storage
- **Primary**: 64GB eMMC 5.1
- **Boot**: Dedicated boot partition
- **User**: Available for OS and games

#### External Storage
- **Slot 1**: microSD card slot (up to 512GB)
- **Slot 2**: Second microSD card slot (up to 512GB)
- **Format**: FAT32, exFAT, ext4 support
- **Hot-swap**: Supported with proper unmounting

### Connectivity Ports

#### USB-C Port
- **Function**: Charging and data transfer
- **Standard**: USB 2.0 with PD support
- **OTG**: USB On-The-Go capable
- **Data Rate**: 480 Mbps

#### HDMI Output
- **Type**: Mini HDMI 1.4
- **Resolution**: Up to 1080p @ 60Hz
- **Audio**: Digital audio output support
- **CEC**: Consumer Electronics Control support

#### Audio Jack
- **Type**: 3.5mm TRRS (Tip-Ring-Ring-Sleeve)
- **Function**: Headphone output + microphone input
- **Impedance**: 16-32 ohm headphone support
- **Detection**: Automatic insertion detection

### Physical Specifications

#### Form Factor
- **Design**: Clamshell (GBA SP style)
- **Dimensions**: 152mm × 89mm × 24mm (closed)
- **Weight**: 280g (approximate)
- **Colors**: Yellow, Gray, Black, Indigo

#### Build Quality
- **Materials**: ABS plastic shell
- **Hinges**: Dual-axis hinge mechanism
- **Buttons**: Tactile membrane switches
- **Sticks**: Hall effect analog sensors
- **Durability**: Consumer-grade construction

## GPIO Pin Mapping

### SoC Pin Assignments
```
Port A (PA):
PA0  - Button A
PA1  - Button B
PA2  - Button Y
PA3  - Button X
PA4  - Button Start
PA5  - Button Select
PA6  - D-Pad Up
PA7  - Button R2
PA8  - D-Pad Left
PA9  - D-Pad Right
PA10 - Button L1
PA11 - Button L2
PA12 - Button R1

Port E (PE):
PE0  - D-Pad Down
PE1  - Volume Up
PE2  - Volume Down
PE3  - Menu Button

Port I (PI):
PI3  - Headphone Detect
PI5  - Speaker Amp Enable
PI11 - Status LED
PI12 - Power LED
```

### Power Management
```
AXP717 PMIC:
- DCDC1: 3.3V (System)
- DCDC2: 1.1V (CPU Core)
- DCDC3: 1.5V (DDR)
- LDO1: 3.3V (IO)
- LDO2: 1.8V (Internal)
- LDO3: 2.8V (WiFi)
```

## Device Tree Configuration

### Base Device Tree
- **File**: `sun50i-h700-anbernic-rg34xx-sp.dts`
- **Parent**: `sun50i-h700.dtsi`
- **Compatible**: `anbernic,rg34xx-sp`, `allwinner,sun50i-h700`

### Critical Device Tree Nodes
```dts
/ {
    model = "Anbernic RG34XX-SP";
    compatible = "anbernic,rg34xx-sp", "allwinner,sun50i-h700";
    
    gpio-keys {
        compatible = "gpio-keys";
        // Button definitions
    };
    
    gpio-leds {
        compatible = "gpio-leds";
        // LED definitions
    };
    
    sound {
        compatible = "simple-audio-card";
        // Audio routing
    };
};
```

## Driver Requirements

### Essential Drivers
- **Display**: `panel-mipi-dpi-spi` (gaming panel support)
- **Audio**: `sun8i-codec` (internal codec)
- **WiFi**: `rtl8821cs` (SDIO interface)
- **Bluetooth**: `rtl8821cs-bt` (UART interface)
- **GPIO**: `sun50i-h616-pinctrl` (pin control)
- **Power**: `axp717-pmic` (power management)
- **Input**: `gpio-keys` (button input)
- **Joystick**: Custom ADC-based driver

### Gaming-Specific Drivers
- **Joypad**: ROCKNIX custom gaming joypad driver
- **Panel**: Gaming device-specific panel driver
- **Audio Routing**: Gaming-optimized audio paths
- **Power Management**: Gaming-optimized governors

## Performance Characteristics

### CPU Performance
- **Single-core**: ~1,200 PassMark points
- **Multi-core**: ~4,800 PassMark points
- **Architecture**: ARMv8-A instruction set
- **Cache**: 32KB L1I + 32KB L1D per core, 512KB shared L2

### GPU Performance
- **Compute Units**: 2 execution engines
- **Memory**: Shared system memory
- **API Support**: OpenGL ES 3.2, Vulkan 1.0
- **Performance**: ~40 GFLOPS theoretical

### Memory Bandwidth
- **LPDDR4**: ~12.8 GB/s theoretical
- **eMMC**: ~200 MB/s read, ~100 MB/s write
- **microSD**: Class 10 minimum (10 MB/s)

## Thermal Management

### Thermal Zones
- **CPU**: Active cooling via case ventilation
- **GPU**: Integrated thermal throttling
- **Battery**: Temperature monitoring via PMIC
- **Ambient**: Passive cooling design

### Operating Temperatures
- **Operating**: 0°C to 40°C
- **Storage**: -20°C to 60°C
- **Charging**: 0°C to 35°C

## Compatibility Notes

### Armbian Support Level
- **SoC**: Full H700 support in sun50iw9 family
- **WiFi/BT**: Requires RTL8821CS driver patches
- **Display**: Requires gaming panel driver port
- **Audio**: Requires gaming audio routing
- **Input**: Requires gaming joypad driver

### Kernel Requirements
- **Minimum**: Linux 6.12+ (H700 support)
- **Recommended**: Linux 6.15+ (full gaming support)
- **Patches**: ROCKNIX gaming patches required

### Bootloader Support
- **U-Boot**: sun50i-h616 configuration
- **ATF**: ARM Trusted Firmware bl31.bin
- **SPL**: Secondary Program Loader support

## Development Notes

### Known Issues
- **Bluetooth**: Limited profile support in mainline
- **HDMI**: Requires additional patches for full support
- **Battery**: Calibration needed for accurate reporting
- **Sleep**: Lid-close sleep function needs implementation

### Future Enhancements
- **Display**: Higher refresh rate support
- **Audio**: DSP audio processing
- **Performance**: CPU/GPU overclocking options
- **Power**: Advanced power saving modes

## Distribution-Specific Hardware Handling

### Alpine H700 Implementation

**Approach**: Extracts components from stock firmware for hardware support.

**Hardware Handling**:
- **Kernel**: Uses stock H700 kernel from factory image
- **Drivers**: Relies on stock driver binaries
- **Firmware**: Extracts all firmware blobs from factory.img
- **Device Tree**: Uses stock device tree configuration
- **Display**: Stock display driver with original calibration
- **Audio**: Stock audio codec configuration
- **WiFi/BT**: Stock RTL8821CS drivers
- **Input**: Stock input driver configuration

**Limitations**:
- No customization of hardware drivers
- Limited to stock firmware capabilities
- Cannot optimize for specific use cases
- Dependent on factory image quality

### Knulli Distribution Implementation

**Approach**: Buildroot-based system with H700-specific board configuration.

**Hardware Handling**:
- **Kernel**: Linux 4.9.170 from orangepi-xunlong repository
- **Architecture**: ARM64 (aarch64) Cortex-A53 with NEON FPU
- **GPU**: Mali-G31 with fbdev driver (libmali-g31-fbdev)
- **Display**: Custom gaming panel support
- **Audio**: sun8i-codec with gaming optimizations
- **WiFi/BT**: RTL8821CS with custom power management
- **Input**: Custom SDL1/SDL2 input mapping for gaming

**Board Configuration** (`knulli-h700.board`):
```
BR2_aarch64=y
BR2_cortex_a53=y
BR2_ARM_FPU_NEON_FP_ARMV8=y
BR2_PACKAGE_BATOCERA_TARGET_H700=y
BR2_LINUX_KERNEL_CUSTOM_REPO_URL="https://github.com/orangepi-xunlong/linux-orangepi.git"
BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION="orange-pi-4.9-sun50iw9"
```

**Gaming-Specific Features**:
- SDL1/SDL2 with fbdev backend
- Custom audio routing for gaming
- ADB support for debugging
- Optimized for gaming performance

### ROCKNIX Distribution Implementation

**Approach**: Extensive patching system for comprehensive H700 gaming support.

**Hardware Handling**:
- **Kernel**: Heavily patched mainline with gaming optimizations
- **Display**: Display Engine 3.3 (DE33) support with LCD timing controller
- **Audio**: sun4i-codec with headphone detection for Anbernic RG35XX devices
- **GPU**: Mali-G31 with GPU OPP (Operating Performance Points)
- **Backlight**: PWM backlight control
- **Input**: Custom ROCKNIX joypad driver
- **USB**: USB OTG support
- **LEDs**: RGB LED support
- **HDMI**: HDMI audio and video output

**Key Patches Applied**:
- `0001-v8_20250310_ryan_drm_sun4i_add_display_engine_3_3_de33_support.patch`
- `0003-20250216_ryan_arm64_dts_allwinner_h616_add_lcd_timing_controller.patch`
- `0004-v3_20250215_ryan_asoc_sun4i_codec_add_headphone_detection.patch`
- `0005-v2_20250416_andre_przywara_arm64_sunxi_h616_enable_mali_gpu.patch`
- `0140-rg35xx-2024-use-rocknix-joypad-driver.patch`
- `0145-Create-sun50i-h700-anbernic-rg34xx.dts.patch`
- `0146-Create-sun50i-h700-anbernic-rg34xx-sp.dts.patch`

**RG34XXSP Specific Device Tree**:
```dts
// sun50i-h700-anbernic-rg34xx-sp.dts
/ {
    model = "Anbernic RG34XX-SP";
    compatible = "anbernic,rg34xx-sp", "allwinner,sun50i-h700";
    
    gpio-keys {
        compatible = "gpio-keys";
        pinctrl-names = "default";
        pinctrl-0 = <&gpio_keys_pins>;
        
        button-a { /* GPIO button definitions */ };
        button-b { /* GPIO button definitions */ };
        /* ... more buttons */
    };
    
    gpio-leds {
        compatible = "gpio-leds";
        pinctrl-names = "default";
        pinctrl-0 = <&gpio_leds_pins>;
        
        led-1 { /* LED definitions */ };
        led-2 { /* LED definitions */ };
    };
    
    sound {
        compatible = "simple-audio-card";
        /* Audio routing for gaming */
    };
};
```

**Hardware Optimizations**:
- GPU overclocking support in `400-set_gpu_overclock`
- Force feedback support
- Panel variants for different screen types
- Gaming-specific power management

### Armbian Integration Requirements

**Based on Distribution Analysis**:

**Essential Components for RG34XXSP**:
1. **Device Tree**: Port ROCKNIX `sun50i-h700-anbernic-rg34xx-sp.dts`
2. **Kernel Config**: Adapt Knulli H700 configuration for mainline
3. **Display Driver**: Port panel-mipi-dpi-spi driver
4. **Audio Driver**: Port sun8i-codec with headphone detection
5. **WiFi/BT**: Port RTL8821CS drivers with power management
6. **Input Driver**: Port ROCKNIX joypad driver
7. **GPU Driver**: Mali-G31 with OPP support
8. **Power Management**: AXP717 PMIC integration

**Hardware Support Priority**:
1. **Phase 1**: Basic boot, display, serial console
2. **Phase 2**: WiFi, SSH, storage access
3. **Phase 3**: Audio, input controls, LEDs
4. **Phase 4**: GPU, HDMI, power management
5. **Phase 5**: Gaming optimizations, overclocking

**Key Differences from Stock Distributions**:
- Armbian uses mainline kernel (6.12+) vs legacy 4.9.170
- Armbian follows Debian package management vs custom builds
- Armbian requires upstream-compatible drivers vs custom gaming patches
- Armbian focuses on general-purpose use vs gaming specialization

**Integration Strategy**:
- Start with ROCKNIX device tree as foundation
- Port essential drivers to mainline kernel
- Adapt hardware configurations for Armbian standards
- Maintain gaming compatibility while ensuring general usability

This comprehensive hardware specification provides the foundation for developing complete Armbian support for the RG34XXSP handheld gaming device.