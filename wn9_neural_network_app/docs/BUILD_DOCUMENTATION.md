# WN9 Neural Network Application - Complete Build Documentation

## Overview
This document provides step-by-step instructions for building a neural network application for Hanwha Vision WN9 SoC cameras using OpenSDK v25.04.09.

## Prerequisites

### Required Software
- **Hanwha Vision OpenSDK v25.04.09** (minimum version for WN9 SoC)
- **Docker** (for building within OpenSDK environment)
- **Valid Wisenet Platform Certificates** (AppTest.crt and AppTest.key)

### Target Hardware
- **Camera Model**: XND-A9084RV (Wisenet 9 SoC)
- **Chipset**: WN9
- **OpenSDK Platform**: 25.02.25 or higher

## Build Process - Step by Step

### Step 1: Environment Setup

1. **Extract OpenSDK**:
   ```bash
   # Extract the OpenSDK package
   tar -xf Opensdk_Docker_Image_25.04.09_R484.tar.gz
   cd Opensdk_Docker_Image_25.04.09_R484
   ```

2. **Prepare Certificate Directory**:
   ```bash
   # Create signature directory
   mkdir -p /tmp/signature
   
   # Copy Wisenet Platform certificates
   cp AppTest.crt AppTest.key /tmp/signature/
   ```

### Step 2: Application Structure

The application follows this directory structure:
```
wn9_neural_network_app/
├── config/
│   └── app_manifest.json          # Application configuration
├── app/
│   ├── bin/                       # Compiled executables
│   ├── src/                       # Source code
│   ├── libs/                      # Runtime libraries
│   ├── res/                       # Resources (AI models, certificates)
│   ├── html/                      # Web interface
│   └── storage/                   # Application data storage
└── certs/                         # Build certificates
```

### Step 3: Configure Application Manifest

**File**: `config/app_manifest.json`
```json
{
    "AppName": "my_run_neural_network",
    "AppVersion": "1.0",
    "Permission": [
        "SDCard",
        "Device",
        "VideoAnalytics"
    ],
    "ChannelType": "Single"
}
```

**Critical Requirements**:
- `AppName` must match the executable name in `app/bin/`
- `VideoAnalytics` permission required for neural network operations
- `ChannelType` can be "Single" or "Multiple"

### Step 4: Build Application

1. **Using Docker Environment**:
   ```bash
   # Navigate to sample application directory
   cd SampleApplication/run_neural_network
   
   # Build using Docker Compose with WN9 SOC parameter
   docker compose up
   ```

2. **Build Parameters**:
   - **SOC=wn9**: Critical parameter for WN9 SoC compatibility
   - **CMAKE_BUILD_TYPE=Release**: For production builds
   - **Target Architecture**: ARM64 for WN9 platform

3. **Verify Build Output**:
   ```bash
   # Check executable exists and is properly named
   ls -la app/bin/
   # Should contain: my_run_neural_network (matching AppName)
   ```

### Step 5: Package Application

1. **Using OpenSDK Packager**:
   ```bash
   # Navigate to application directory
   cd /path/to/your/app
   
   # Package with Wisenet Platform certificates
   /path/to/opensdk_packager -p /tmp/signature/
   ```

2. **Packaging Process**:
   - **Archiving**: Creates tar archive of config/ and app/ directories
   - **Encrypting**: Encrypts the application bundle
   - **Signing**: Signs with Wisenet Platform certificates
   - **Output**: `{AppName}.cap` file ready for deployment

### Step 6: Verify CAP File

```bash
# Check file size and type
ls -lh my_run_neural_network.cap
file my_run_neural_network.cap

# Verify certificate in package
tar -tf my_run_neural_network.cap | grep -E "(crt|sig)"
```

**Expected Output**:
- CAP file size: ~7-8MB for neural network application
- File type: POSIX tar archive
- Contains: application CAP, signature, and certificate

## Key Requirements for WN9 SoC

### 1. Certificate Requirements
- **Authority**: "Hanwha Openplatform App Signed CA"
- **Subject**: "O=Hanwha Vision"
- **Files**: AppTest.crt and AppTest.key (Wisenet Platform specific)

### 2. Build Requirements
- **SDK Version**: v25.04.09 or higher (required for WN9)
- **SOC Parameter**: Must be set to "wn9"
- **Target Architecture**: ARM64

### 3. Application Requirements
- **Executable Name**: Must match `AppName` in app_manifest.json
- **Permissions**: Include "VideoAnalytics" for neural network operations
- **Libraries**: Include WN9-specific NPU libraries

## Troubleshooting

### Common Issues

1. **"No exist Private key or Certification"**:
   - Ensure certificates are in `/tmp/signature/`
   - Use `-p /tmp/signature/` parameter with opensdk_packager

2. **Executable not found during packaging**:
   - Verify executable name matches AppName
   - Check executable permissions (should be executable)

3. **Application doesn't appear on camera**:
   - Verify camera OpenSDK platform is enabled
   - Check certificate compatibility with camera firmware
   - Ensure proper deployment method (CLI or web interface)

### Verification Steps

1. **Certificate Verification**:
   ```bash
   openssl x509 -in AppTest.crt -subject -issuer -noout
   ```

2. **Build Verification**:
   ```bash
   # Check CMake cache for SOC parameter
   grep "SOC.*wn9" app/build/CMakeCache.txt
   ```

3. **Package Verification**:
   ```bash
   # Verify CAP structure
   tar -tf my_run_neural_network.cap
   ```

## Success Criteria

A successful build should produce:
- ✅ CAP file of appropriate size (~7-8MB)
- ✅ Signed with correct Wisenet Platform certificates
- ✅ Contains all required components (executable, libraries, resources)
- ✅ Deployable to WN9 SoC cameras via opensdk_install CLI tool

## Next Steps

After successful build:
1. Deploy using `opensdk_install` CLI tool
2. Verify installation on camera web interface
3. Test neural network functionality
4. Monitor application logs and performance

---

*This documentation is based on successful deployment to XND-A9084RV camera with firmware 25.01.03_20250811_R551*