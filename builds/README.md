# RG34XXSP Armbian Build Images

This directory contains Armbian build images for the RG34XXSP device, organized by development phase. These images can be flashed directly to SD cards using tools like Balena Etcher.

## Build Organization

### Phase 1 - Foundation, Display, and Basic Input
- **Objective**: Basic system boot with display output and USB keyboard input
- **Files**: `phase1-*.img.xz`
- **Testing**: Boot to console, USB keyboard functionality

### Phase 2 - Network Connectivity and Remote Access  
- **Objective**: WiFi connectivity and SSH remote access
- **Files**: `phase2-*.img.xz`
- **Testing**: WiFi connection, SSH access

### Phase 3 - Audio and Input Controls
- **Objective**: Audio output and standard input controls
- **Files**: `phase3-*.img.xz` 
- **Testing**: Audio playback, button functionality

### Phase 4 - Power Management and Advanced Features
- **Objective**: Power management and remaining hardware features
- **Files**: `phase4-*.img.xz`
- **Testing**: Battery monitoring, Bluetooth, HDMI

### Phase 5 - Desktop Environment (Optional)
- **Objective**: Desktop environment and user-friendly features
- **Files**: `phase5-*.img.xz`
- **Testing**: Desktop functionality, optimized user experience

## File Naming Convention

```
phaseX-YYYYMMDD-HHMM-description.img.xz
```

Where:
- `X` = Phase number (1-5)
- `YYYYMMDD-HHMM` = Build timestamp
- `description` = Brief description of build features

## Usage Instructions

1. **Download**: Clone this repository or download specific build files
2. **Flash**: Use Balena Etcher, Raspberry Pi Imager, or dd to flash to SD card
3. **Test**: Follow testing procedures in TESTING.md for the corresponding phase
4. **Report**: Update test results and feedback in GitLab issues

## Build Requirements

- **SD Card**: Class 10 or better, minimum 8GB
- **Hardware**: RG34XXSP device for testing
- **Tools**: Balena Etcher or equivalent flashing software

## Current Builds

<!-- This section will be updated as builds are created -->

*No builds available yet. Builds will appear here as development progresses through each phase.*

## Important Notes

- **Backup**: Always backup your original SD card before flashing
- **Testing**: Each build should be thoroughly tested before proceeding to next phase
- **Compatibility**: Builds are specifically for RG34XXSP hardware only
- **Support**: Report issues through GitLab repository issues