# Armbian Community Build Guide

This guide provides comprehensive instructions for creating community builds for Armbian, specifically focused on adding new board support like the RG34XXSP.

## Overview

Armbian is a Debian/Ubuntu-based Linux distribution optimized for ARM-based single-board computers. Community builds allow developers to add support for new hardware platforms and contribute to the Armbian ecosystem.

## Requirements

### System Requirements
- **Architecture**: x86_64, aarch64, or riscv64 machine
- **Memory**: Minimum 8GB RAM (for non-BTF builds)
- **Storage**: ~50GB disk space for VM, container, or bare-metal
- **OS**: Armbian/Ubuntu Noble 24.04.x for native building, or Docker-capable Linux for containerized builds
- **Privileges**: Superuser rights (sudo or root access)
- **System State**: Up-to-date system (outdated Docker binaries can cause issues)

### For Windows Users
- **OS**: Windows 10/11 with WSL2 subsystem
- **WSL Distribution**: Armbian/Ubuntu Noble 24.04.x

## Getting Started

### 1. Clone the Repository
```bash
apt-get -y install git
git clone --depth=1 --branch=main https://github.com/armbian/build
cd build
```

### 2. Initial Build (Interactive Mode)
```bash
./compile.sh
```

This launches an interactive graphical interface that:
- Prepares the workspace by installing dependencies
- Downloads necessary sources
- Guides through the build process
- Creates kernel packages or SD card images

### 3. Expert Mode
```bash
./compile.sh EXPERT="yes"
```

Shows work-in-progress areas and advanced options.

## Build Commands

### Basic Build Commands

#### 1. Build Full Image
```bash
./compile.sh build BOARD=<board> BRANCH=<branch> RELEASE=<release>
```

#### 2. Build Kernel Only
```bash
./compile.sh kernel BOARD=<board> BRANCH=<branch>
```

#### 3. Interactive Kernel Configuration
```bash
./compile.sh kernel-config BOARD=<board> BRANCH=<branch>
```

#### 4. Device Tree Validation
```bash
./compile.sh dts-check BOARD=<board> BRANCH=<branch>
```

#### 5. Board Inventory
```bash
./compile.sh inventory-boards
```

### Build Parameters

#### Core Parameters
- **BOARD**: Target board name (e.g., `rg34xxsp`)
- **BRANCH**: Kernel branch (`legacy`, `current`, `edge`)
- **RELEASE**: OS release (`noble`, `jammy`, `bookworm`)
- **BUILD_DESKTOP**: Build desktop variant (`yes`/`no`)
- **BUILD_MINIMAL**: Build minimal system (`yes`/`no`)
- **KERNEL_CONFIGURE**: Interactive kernel config (`yes`/`no`)

#### Example Build Commands
```bash
# Minimal CLI build
./compile.sh build \
BOARD=rg34xxsp \
BRANCH=current \
RELEASE=noble \
BUILD_MINIMAL=yes \
BUILD_DESKTOP=no \
KERNEL_CONFIGURE=no

# Desktop build
./compile.sh build \
BOARD=rg34xxsp \
BRANCH=current \
RELEASE=noble \
BUILD_DESKTOP=yes \
BUILD_MINIMAL=no
```

## Creating New Board Support

### 1. Board Configuration Structure

Board configurations are stored in `config/boards/` with the following structure:

```
config/boards/
├── <board-name>.conf     # Main board configuration
├── <board-name>.csc      # Community supported configuration
├── <board-name>.wip      # Work in progress
├── <board-name>.tvb      # TV box configuration
└── <board-name>.eos      # End of support
```

### 2. Board Configuration File Format

Create `config/boards/rg34xxsp.conf`:

```bash
# Armbian RG34XXSP Board Configuration

# Board identification
BOARD_NAME="RG34XXSP"
BOARDFAMILY="sun50iw9"
BOARD_MAINTAINER="Community"
BOOTCONFIG="anbernic_rg34xxsp_defconfig"

# Architecture and CPU
ARCH="arm64"
KERNEL_TARGET="current,edge"
BOOTLOADER_TARGET="legacy,current"

# SoC specifications
LINUXFAMILY="sunxi64"
CPUMIN="408000"
CPUMAX="1512000"
GOVERNOR="interactive"

# Memory and storage
SERIALCON="ttyS0"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="allwinner/sun50i-h700-anbernic-rg34xx-sp.dtb"

# Build options
BOOTSIZE="256"
BOOTFS_TYPE="fat"
MODULES="#w1-sunxi #w1-gpio #w1-therm #sunxi-cir"
MODULES_BLACKLIST="lima"

# Package inclusions
PACKAGE_LIST_BOARD="device-tree-compiler"
PACKAGE_LIST_BOARD_DESKTOP="mesa-utils"

# Custom functions
function family_tweaks() {
    # Custom board-specific tweaks
    echo "Applying RG34XXSP specific tweaks"
}

function family_tweaks_bsp() {
    # BSP package tweaks
    echo "Applying RG34XXSP BSP tweaks"
}
```

### 3. Device Tree Integration

#### Add Device Tree Source
Create or copy device tree file:
```bash
# Copy from reference implementation
cp repos_reference/rocknix-distribution/projects/Allwinner/patches/linux/H700/0146-Create-sun50i-h700-anbernic-rg34xx-sp.dts.patch \
   patch/kernel/sunxi64-current/

# Or create new device tree file
# arch/arm64/boot/dts/allwinner/sun50i-h700-anbernic-rg34xx-sp.dts
```

#### Device Tree Content Structure
```dts
// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
// Copyright (C) 2025 Armbian Community

/dts-v1/;

#include "sun50i-h700.dtsi"
#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>

/ {
    model = "Anbernic RG34XX-SP";
    compatible = "anbernic,rg34xx-sp", "allwinner,sun50i-h700";

    aliases {
        serial0 = &uart0;
        ethernet0 = &rtl8821cs;
    };

    chosen {
        stdout-path = "serial0:115200n8";
    };

    gpio-keys {
        compatible = "gpio-keys";
        pinctrl-names = "default";
        pinctrl-0 = <&gpio_keys_pins>;

        button-a {
            label = "Button A";
            linux,code = <KEY_SPACE>;
            gpios = <&pio 0 0 GPIO_ACTIVE_LOW>; /* PA0 */
        };

        button-b {
            label = "Button B";
            linux,code = <KEY_LEFTCTRL>;
            gpios = <&pio 0 1 GPIO_ACTIVE_LOW>; /* PA1 */
        };

        /* Additional buttons... */
    };

    gpio-leds {
        compatible = "gpio-leds";
        pinctrl-names = "default";
        pinctrl-0 = <&gpio_leds_pins>;

        power {
            label = "rg34xxsp:power";
            gpios = <&pio 8 12 GPIO_ACTIVE_HIGH>; /* PI12 */
        };

        status {
            label = "rg34xxsp:status";
            gpios = <&pio 8 11 GPIO_ACTIVE_HIGH>; /* PI11 */
        };
    };

    sound {
        compatible = "simple-audio-card";
        simple-audio-card,name = "RG34XXSP Audio";
        simple-audio-card,format = "i2s";
        simple-audio-card,mclk-fs = <256>;

        simple-audio-card,cpu {
            sound-dai = <&i2s0>;
        };

        simple-audio-card,codec {
            sound-dai = <&codec>;
        };
    };
};

&ehci0 {
    status = "okay";
};

&mmc0 {
    vmmc-supply = <&reg_dcdc1>;
    vqmmc-supply = <&reg_dldo1>;
    cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 */
    bus-width = <4>;
    status = "okay";
};

&mmc1 {
    vmmc-supply = <&reg_dcdc1>;
    vqmmc-supply = <&reg_dldo1>;
    non-removable;
    bus-width = <4>;
    status = "okay";

    rtl8821cs: wifi@1 {
        reg = <1>;
        interrupt-parent = <&pio>;
        interrupts = <6 10 IRQ_TYPE_LEVEL_LOW>; /* PG10 */
        interrupt-names = "host-wake";
    };
};

&ohci0 {
    status = "okay";
};

&pio {
    gpio_keys_pins: gpio-keys-pins {
        pins = "PA0", "PA1", "PA2", "PA3", "PA4", "PA5",
               "PA6", "PA7", "PA8", "PA9", "PA10", "PA11", "PA12",
               "PE0", "PE1", "PE2", "PE3";
        function = "gpio_in";
        bias-pull-up;
    };

    gpio_leds_pins: gpio-leds-pins {
        pins = "PI11", "PI12";
        function = "gpio_out";
        drive-strength = <10>;
    };
};

&r_rsb {
    status = "okay";

    axp717: pmic@3a3 {
        compatible = "x-powers,axp717";
        reg = <0x3a3>;
        interrupt-parent = <&nmi_intc>;
        interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
        interrupt-controller;
        #interrupt-cells = <1>;

        regulators {
            reg_dcdc1: dcdc1 {
                regulator-name = "vcc-3v3";
                regulator-min-microvolt = <3300000>;
                regulator-max-microvolt = <3300000>;
                regulator-always-on;
            };

            reg_dldo1: dldo1 {
                regulator-name = "vcc-1v8";
                regulator-min-microvolt = <1800000>;
                regulator-max-microvolt = <1800000>;
                regulator-always-on;
            };
        };
    };
};

&uart0 {
    pinctrl-names = "default";
    pinctrl-0 = <&uart0_ph_pins>;
    status = "okay";
};

&usb_otg {
    dr_mode = "otg";
    status = "okay";
};

&usbphy {
    status = "okay";
};
```

### 4. Kernel Configuration

#### Create Kernel Config
```bash
# Create kernel configuration for the board
./compile.sh kernel-config BOARD=rg34xxsp BRANCH=current

# This creates/modifies:
# config/kernel/linux-sunxi64-current.config
```

#### Essential Kernel Options for RG34XXSP
```
# H700 SoC Support
CONFIG_ARCH_SUNXI=y
CONFIG_MACH_SUN50I_H616=y

# Mali GPU
CONFIG_DRM_PANFROST=y
CONFIG_DRM_PANFROST_DEVFREQ=y

# Display Engine
CONFIG_DRM_SUN4I=y
CONFIG_DRM_SUN8I_DW_HDMI=y
CONFIG_DRM_SUN8I_MIXER=y

# Audio
CONFIG_SND_SOC_SUN8I_CODEC=y
CONFIG_SND_SOC_SUN4I_I2S=y

# Input
CONFIG_INPUT_GPIO_KEYS=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_JOYDEV=y

# WiFi/Bluetooth
CONFIG_RTL8821CS=y
CONFIG_BT_RTL8821CS=y

# GPIO and Pinctrl
CONFIG_PINCTRL_SUN50I_H616=y
CONFIG_GPIO_SYSFS=y

# Power Management
CONFIG_AXP717_PMIC=y
CONFIG_REGULATOR_AXP717=y

# LEDs
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y

# USB
CONFIG_USB_MUSB_SUNXI=y
CONFIG_USB_SUNXI_MUSB_FORCE_DEVICE_MODE=y
```

### 5. U-Boot Configuration

#### Create U-Boot Defconfig
Create `config/bootloaders/u-boot_anbernic_rg34xxsp_defconfig`:

```
CONFIG_ARM=y
CONFIG_ARCH_SUNXI=y
CONFIG_DEFAULT_DEVICE_TREE="sun50i-h700-anbernic-rg34xx-sp"
CONFIG_SPL=y
CONFIG_MACH_SUN50I_H616=y
CONFIG_MMC0_CD_PIN=""
CONFIG_MMC_SUNXI_SLOT_EXTRA=2
CONFIG_SPL_SPI_SUNXI=y
CONFIG_SPI=y
CONFIG_TARGET_ANBERNIC_RG34XXSP=y
```

### 6. Patches and Customizations

#### Add Hardware-Specific Patches
Create patch files in `patch/kernel/sunxi64-current/`:

```bash
# Gaming controller support
patch/kernel/sunxi64-current/0001-rg34xxsp-gaming-controller.patch

# Display panel support
patch/kernel/sunxi64-current/0002-rg34xxsp-display-panel.patch

# Audio codec support
patch/kernel/sunxi64-current/0003-rg34xxsp-audio-codec.patch

# Power management
patch/kernel/sunxi64-current/0004-rg34xxsp-power-management.patch
```

#### Create BSP Package
Create `packages/bsp/rg34xxsp/` with:
- `postinst` script for post-installation setup
- Configuration files for hardware-specific settings
- Service files for gaming-specific daemons

### 7. User Customizations

#### Create Custom Configuration
Create `userpatches/config-rg34xxsp.conf`:

```bash
#!/bin/bash

# RG34XXSP specific configuration
BOARD="rg34xxsp"
BRANCH="current"
RELEASE="noble"
BUILD_DESKTOP="no"
BUILD_MINIMAL="yes"
KERNEL_CONFIGURE="no"
BOOTLOADER_TARGET="current"

# Custom packages
PACKAGE_LIST_ADDITIONAL="device-tree-compiler joystick joyutils"

# Image size for gaming device
FIXED_IMAGE_SIZE="4000"

# Enable specific features
ENABLE_EXTENSIONS="gaming-support"
```

#### Create Image Customization Script
Create `userpatches/customize-image.sh`:

```bash
#!/bin/bash

# RG34XXSP image customization
display_alert "Customizing RG34XXSP image" "gaming optimizations" "info"

# Install gaming-specific packages
chroot_sdcard "apt-get -y install joystick joyutils"

# Configure gaming controls
cat > "${SDCARD}/etc/udev/rules.d/99-rg34xxsp-gaming.rules" << EOF
# RG34XXSP Gaming Controls
SUBSYSTEM=="input", ATTRS{name}=="RG34XXSP Gamepad", ENV{ID_INPUT_JOYSTICK}="1"
EOF

# Create gaming startup script
cat > "${SDCARD}/usr/local/bin/rg34xxsp-gaming-init" << EOF
#!/bin/bash
# RG34XXSP Gaming Initialization
echo "Initializing RG34XXSP gaming controls..."
# Add gaming-specific initialization here
EOF

chmod +x "${SDCARD}/usr/local/bin/rg34xxsp-gaming-init"

# Add to systemd
cat > "${SDCARD}/etc/systemd/system/rg34xxsp-gaming.service" << EOF
[Unit]
Description=RG34XXSP Gaming Initialization
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/rg34xxsp-gaming-init
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
chroot_sdcard "systemctl enable rg34xxsp-gaming.service"
```

## Community Build Process

### 1. Development Workflow

#### Step 1: Create Working Branch
```bash
git checkout -b rg34xxsp-support
```

#### Step 2: Implement Board Support
- Create board configuration file
- Add device tree source
- Create kernel configuration
- Add necessary patches

#### Step 3: Test Build
```bash
./compile.sh build BOARD=rg34xxsp BRANCH=current RELEASE=noble
```

#### Step 4: Validate on Hardware
- Flash image to SD card
- Test basic functionality
- Verify all hardware components

#### Step 5: Create Pull Request
- Document changes thoroughly
- Include hardware testing results
- Follow Armbian contribution guidelines

### 2. Testing Requirements

#### Minimum Testing Checklist
- [ ] System boots successfully
- [ ] Serial console accessible
- [ ] Display output working
- [ ] WiFi connectivity functional
- [ ] SSH access available
- [ ] Audio output working
- [ ] Input controls responsive
- [ ] Storage devices accessible
- [ ] Power management functional
- [ ] LED indicators working

#### Hardware Validation Tests
- [ ] All GPIO pins properly mapped
- [ ] Device tree correctly describes hardware
- [ ] Kernel modules load successfully
- [ ] No critical boot errors
- [ ] Hardware sensors accessible
- [ ] USB ports functional
- [ ] HDMI output working (if applicable)

### 3. Community Contribution Guidelines

#### Code Quality Standards
- Follow Linux kernel coding style
- Include proper SPDX license headers
- Use descriptive commit messages
- Document all changes thoroughly

#### Documentation Requirements
- Update board-specific documentation
- Include hardware specifications
- Provide testing instructions
- Document known issues/limitations

#### Review Process
- Submit pull request to Armbian repository
- Respond to maintainer feedback
- Provide hardware for testing (if possible)
- Support ongoing maintenance

## Advanced Features

### 1. Multi-Boot Support
```bash
# Configure for multiple boot options
BOOTCONFIG="anbernic_rg34xxsp_defconfig"
BOOTLOADER_TARGET="legacy,current"
KERNEL_TARGET="current,edge"
```

### 2. Hardware Variants
```bash
# Support different hardware variants
if [[ $BOARD == "rg34xxsp-v1" ]]; then
    BOOT_FDT_FILE="allwinner/sun50i-h700-anbernic-rg34xx-sp-v1.dtb"
elif [[ $BOARD == "rg34xxsp-v2" ]]; then
    BOOT_FDT_FILE="allwinner/sun50i-h700-anbernic-rg34xx-sp-v2.dtb"
fi
```

### 3. Performance Optimizations
```bash
# Gaming performance tweaks
function family_tweaks() {
    # CPU governor for gaming
    echo "interactive" > $SDCARD/etc/default/cpufrequtils
    
    # GPU performance mode
    echo "performance" > $SDCARD/sys/class/devfreq/1c40000.gpu/governor
    
    # Gaming-specific sysctl settings
    cat >> $SDCARD/etc/sysctl.d/99-gaming.conf << EOF
# Gaming optimizations
vm.swappiness=1
vm.vfs_cache_pressure=50
kernel.sched_latency_ns=10000000
EOF
}
```

### 4. Gaming-Specific Extensions
```bash
# Create gaming extension
mkdir -p extensions/gaming-support
cat > extensions/gaming-support/gaming-support.sh << EOF
#!/bin/bash

display_alert "Installing gaming support" "RG34XXSP" "info"

# Install gaming libraries
add_packages_to_image "libsdl2-dev libsdl2-image-dev retroarch"

# Configure gaming environment
function gaming_tweaks() {
    # Add gaming-specific configurations
    return 0
}
EOF
```

## Troubleshooting

### Common Issues

#### 1. Build Failures
```bash
# Clean build environment
./compile.sh clean

# Enable debug logging
./compile.sh build DEBUG=yes BOARD=rg34xxsp BRANCH=current RELEASE=noble
```

#### 2. Device Tree Validation
```bash
# Check device tree syntax
./compile.sh dts-check BOARD=rg34xxsp BRANCH=current

# Validate device tree bindings
scripts/dtc/dt-validate -p dt-bindings/processed-schema.json arch/arm64/boot/dts/allwinner/sun50i-h700-anbernic-rg34xx-sp.dtb
```

#### 3. Hardware Detection Issues
```bash
# Check hardware detection
dmesg | grep -i "rg34xxsp\|h700\|anbernic"

# Verify device tree loading
cat /proc/device-tree/model
cat /proc/device-tree/compatible
```

### Log Analysis

#### Build Logs
```bash
# Check build logs
tail -f output/logs/build-*.log

# Specific component logs
tail -f output/logs/kernel-*.log
tail -f output/logs/uboot-*.log
```

#### Runtime Logs
```bash
# System logs
journalctl -f

# Hardware-specific logs
dmesg | grep -i "gpio\|input\|display\|audio"
```

## Conclusion

Creating community builds for Armbian requires:

1. **Hardware Understanding**: Thorough knowledge of the target hardware
2. **Device Tree Mastery**: Proper device tree implementation
3. **Kernel Configuration**: Appropriate kernel options for hardware support
4. **Testing Validation**: Comprehensive testing on actual hardware
5. **Community Engagement**: Active participation in the Armbian community

The RG34XXSP community build should leverage existing H700 support while adding device-specific optimizations for the gaming handheld form factor. By following this guide and the established Armbian development practices, contributors can successfully add robust support for new hardware platforms.

For ongoing support and collaboration, engage with the Armbian community through:
- GitHub Issues and Pull Requests
- Armbian Forum discussions
- Community chat channels
- Documentation contributions

This comprehensive approach ensures that community builds meet Armbian's quality standards while providing excellent support for new hardware platforms like the RG34XXSP.