# RG34XXSP Project Instructions

## Project Overview
This project is focused on creating a community Armbian build for RG34XXSP hardware. The RG34XXSP is based on the Allwinner H700 SoC, which is part of the sunxi family. This repository contains reference implementations and build systems for H700-based devices.

## Project Objectives
- Create a community Armbian build for RG34XXSP handheld gaming device
- Leverage existing H700 device support from other projects
- Adapt existing configurations for RG34XXSP specific hardware

## Reference Repositories

### repos_reference/alpine-h700/
**Purpose**: Alpine Linux build system for H700 SoC devices
**Documentation**: `repos_reference/alpine-h700/README.md`
**Build**: `make` (requires stock SD card image as factory.img)
**Key Features**:
- Tested on Anbernic RG35XX Plus (H700-based)
- Extracts SPL, U-Boot, kernel, and firmware from stock image
- Creates minimal Alpine Linux system with WiFi and SSH
- Build requirements: podman, python3, sgdisk, guestfish, fakeroot

### repos_reference/armbian-build/
**Purpose**: Main Armbian build framework
**Documentation**: `repos_reference/armbian-build/README.md`
**Build**: `./compile.sh` (interactive) or with parameters
**Key Features**:
- Comprehensive build system for ARM devices
- Supports kernel, image, and distribution builds
- Uses buildroot-style configuration
- Board configurations in `config/boards/`

### repos_reference/knulli-distribution/
**Purpose**: Gaming-focused distribution based on Batocera
**H700 Support**: 
- Board config: `repos_reference/knulli-distribution/configs/knulli-h700.board`
- Defconfig: `repos_reference/knulli-distribution/configs/knulli-h700_defconfig`
**Key H700 Details**:
- Target: aarch64 Cortex-A53 with NEON
- Kernel: Linux 4.9.170 from orangepi-xunlong repo
- GPU: Mali-G31 with fbdev driver
- Uses Buildroot with custom Knulli packages

### repos_reference/rocknix-distribution/
**Purpose**: Gaming distribution fork of JELOS
**H700 Support**: Extensive support for H700 devices
**Key H700 Files**:
- Device options: `projects/Allwinner/devices/H700/options`
- Device tree patches: `projects/Allwinner/patches/linux/H700/`
- RG34XXSP specific: `0145-Create-sun50i-h700-anbernic-rg34xx.dts`
- RG34XXSP SP variant: `0146-Create-sun50i-h700-anbernic-rg34xx-sp.dts`

### repos_reference/sunxi-dt-overlays/
**Purpose**: Device tree overlays for Allwinner/sunxi devices
**Documentation**: `repos_reference/sunxi-dt-overlays/README.md`
**Compatibility**: Kernel 4.14.x (may need updates for newer kernels)
**Usage**: For hardware customization via device tree overlays

## H700 Device Build Documentation

### Hardware Specifications (H700 SoC)
- **Architecture**: ARM64 (aarch64)
- **CPU**: Cortex-A53 quad-core
- **GPU**: Mali-G31 
- **Kernel**: Linux 4.9.170 (legacy) or newer mainline
- **Bootloader**: U-Boot with ARM Trusted Firmware

### Build Requirements
- x86_64/aarch64 host with 8GB+ RAM, 50GB+ disk
- Ubuntu 22.04+ or Armbian host system
- For Alpine build: podman, python3, sgdisk, guestfish, fakeroot
- For Armbian build: `./compile.sh` handles dependencies

### Build Commands by Repository

#### Alpine H700 Build
```bash
cd repos_reference/alpine-h700/
# Place stock image as factory.img
make
# Output: artifacts/alpine-h700.img
```

#### Armbian Build (General)
```bash
cd repos_reference/armbian-build/
./compile.sh BOARD=<board> BRANCH=current RELEASE=noble
```

#### Knulli Build (H700)
```bash
cd repos_reference/knulli-distribution/
make knulli-h700_defconfig
make
```

### RG34XXSP Specific Notes
- Device tree files exist in ROCKNIX: `sun50i-h700-anbernic-rg34xx.dts` and `sun50i-h700-anbernic-rg34xx-sp.dts`
- Based on H700 SoC with standard Allwinner bootloader chain
- Should leverage existing H700 board support in Armbian
- Need to create board configuration file for Armbian build system

## Development Guidelines
- Follow existing code style in each repository
- Test changes thoroughly before committing
- Document hardware-specific configurations in HARDWARE.md
- Track project progress in PLAN.md

## Repository Structure
- `repos_reference/` - Reference implementations and documentation for H700 devices
  - `alpine-h700/` - Alpine Linux build system for H700 SoC
  - `armbian-build/` - Main Armbian build framework
  - `knulli-distribution/` - Gaming distribution with H700 support
  - `rocknix-distribution/` - Gaming distribution with extensive H700 patches
  - `sunxi-dt-overlays/` - Device tree overlays for Allwinner devices
  - `linux-kernel/` - Linux kernel source tree
  - `muos-core/` - MuOS core build system
  - `muos-internal/` - MuOS internal tools
- `repos_to_update/` - Working directory for repositories to be modified for RG34XXSP support
- `PLAN.md` - Project roadmap and planning
- `HARDWARE.md` - Hardware specifications and documentation
- `TODO.md` - User-defined task list
- `CLAUDE.md` - Project instructions and documentation (this file)

## Ongoing Tasks
- Always keep the HARDWARE.md up to date with what is learned about the objective to compile Armbian for RG34XXSP
- Focus on adapting existing H700 support for RG34XXSP specific hardware differences
- **README.md Maintenance**: For every commit, update README.md with current phase indicators and exactly 1 sentence describing the commit

## Development Rules

### Rule 1: Documentation Reference for PLAN.md Updates
**MANDATORY**: When updating PLAN.md, Claude must ALWAYS reference and incorporate information from:
1. **ALTERNATIVE_IMPLEMENTATIONS.md** - For understanding existing H700 implementations and their approaches
2. **HARDWARE.md** - For hardware specifications and distribution-specific handling
3. **ARMBIAN_COMMUNITY_BUILD_GUIDE.md** - For Armbian-specific build requirements and community guidelines

This ensures all planning decisions are based on:
- Proven implementations from other distributions
- Complete hardware understanding
- Armbian community standards and best practices

### Rule 2: Documentation Reference for Plan Execution
**MANDATORY**: When executing the plan, Claude must ALWAYS reference and consult:
1. **ALTERNATIVE_IMPLEMENTATIONS.md** - For implementation patterns and proven solutions
2. **HARDWARE.md** - For hardware-specific requirements and constraints

This ensures all implementation decisions are informed by existing successful approaches and hardware realities.

### Rule 3: Testing Confirmation Requirement
**MANDATORY**: Claude must NOT proceed to the next phase of implementation without explicit user confirmation that tests have passed. The process is:

1. **Test Creation**: Claude creates TESTING.md with specific test procedures for the current phase
2. **User Testing**: User performs tests on actual hardware following TESTING.md instructions
3. **Results Documentation**: User updates TESTING.md with test results and marks PASS/FAIL
4. **Confirmation Required**: Claude can only proceed when user confirms "ALL TESTS PASSED" in TESTING.md
5. **Issue Resolution**: If tests fail, Claude must fix issues and provide updated TESTING.md for retest

**No exceptions**: Implementation phases cannot proceed without successful user testing confirmation on actual hardware.

### Rule 4: TESTING.md Lifecycle Management
**MANDATORY**: The TESTING.md file must follow strict lifecycle management:

1. **Creation**: Only created when active testing is required for a specific phase
2. **Active Use**: Contains specific test procedures and user result documentation
3. **Completion**: After successful testing, results are incorporated into PLAN.md
4. **Cleanup**: TESTING.md is removed between testing phases to avoid confusion
5. **Regeneration**: New TESTING.md created for each new phase requiring testing

**Purpose**: Ensures testing documentation is current, relevant, and not cluttered with obsolete information.

### Rule 5: README.md Status Maintenance
**MANDATORY**: Before every git commit, Claude must update README.md with:

1. **Phase Indicators**: Update phase status using proper emojis:
   - ✅ = Complete phases
   - ▶️ = Current active phase (with ✨*Current*✨ suffix)
   - 🔜 = Future pending phases

2. **Status Summary**: Replace the "Status:" field with exactly one sentence describing what the current commit accomplishes

3. **Timing**: This update must happen before the git commit, ensuring the public GitHub page always reflects current development status

**Purpose**: Maintains up-to-date public visibility of project progress and current development state.