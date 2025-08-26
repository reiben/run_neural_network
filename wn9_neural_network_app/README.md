# WN9 Neural Network Application for Hanwha Vision Cameras

A complete neural network application designed for Hanwha Vision WN9 SoC cameras using OpenSDK v25.04.09.

## 🎯 Overview

This repository contains a fully functional neural network application that performs image classification using GoogleNet on WN9 SoC cameras. The application demonstrates how to:

- Utilize the camera's NPU (Neural Processing Unit) for AI inference
- Implement real-time video analytics
- Create a web-based user interface
- Package applications for deployment on Hanwha Vision cameras

## 🔧 Quick Start

### Prerequisites

- **Hanwha Vision OpenSDK v25.04.09** (required for WN9 SoC)
- **Docker** (for building from source)
- **Valid Wisenet Platform Certificates** (provided in `certs/` directory)

### Build and Deploy

1. **One-Command Build**:
   ```bash
   ./scripts/build_wn9_cap.sh
   ```

2. **Deploy to Camera**:
   ```bash
   cd deploy
   ./deploy_to_camera.sh <camera_ip> <username> <password>
   ```

## 📁 Repository Structure

```
wn9_neural_network_app/
├── src/                          # Source code
│   ├── classification/           # Neural network classification module
│   └── CMakeLists.txt           # Build configuration
├── app/                         # Runtime application
│   ├── bin/                     # Compiled executables
│   ├── libs/                    # Runtime libraries
│   ├── res/                     # Resources (AI models, certificates)
│   ├── html/                    # Web interface
│   └── storage/                 # Application data
├── config/
│   └── app_manifest.json       # Application configuration
├── certs/                       # Wisenet Platform certificates
│   ├── AppTest.crt              # Certificate file
│   └── AppTest.key              # Private key
├── scripts/
│   └── build_wn9_cap.sh         # Automated build script
├── docs/
│   └── BUILD_DOCUMENTATION.md   # Detailed build instructions
└── deploy/                      # Deployment tools (generated)
    ├── my_run_neural_network.cap
    └── deploy_to_camera.sh
```

## 🏗️ Build Process

### Automated Build

```bash
# Simple one-command build
./scripts/build_wn9_cap.sh

# Check prerequisites only
./scripts/build_wn9_cap.sh --check-only

# Get help
./scripts/build_wn9_cap.sh --help
```

### Manual Build

See [BUILD_DOCUMENTATION.md](docs/BUILD_DOCUMENTATION.md) for detailed step-by-step instructions.

## 🚀 Deployment

### Using CLI Tool

```bash
cd deploy
./deploy_to_camera.sh 10.0.1.32 admin mypassword
```

### Using Web Interface

1. Access camera web interface
2. Navigate to OpenSDK applications
3. Upload the generated `.cap` file
4. Install and start the application

## ✨ Features

### Neural Network Capabilities
- **GoogleNet Classification**: Real-time image classification
- **NPU Acceleration**: Optimized for WN9 SoC Neural Processing Unit
- **Video Analytics**: Live video stream analysis

### Web Interface
- **Real-time Results**: Live classification results display
- **Configuration Panel**: Adjustable parameters
- **Status Monitoring**: Application health and performance metrics

### Technical Features
- **Multi-threaded Processing**: Efficient resource utilization
- **Memory Optimization**: Designed for embedded camera platform
- **Lifecycle Management**: Proper startup, shutdown, and error handling

## 🎛️ Configuration

### Application Manifest (`config/app_manifest.json`)

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

### Key Configuration Parameters

- **AppName**: Must match executable name in `app/bin/`
- **VideoAnalytics**: Required permission for neural network operations
- **ChannelType**: "Single" for single-channel, "Multiple" for multi-channel

## 🔍 Troubleshooting

### Common Build Issues

1. **Certificate Errors**:
   - Ensure Wisenet Platform certificates are in `certs/` directory
   - Verify certificates match: `openssl x509 -in certs/AppTest.crt -text -noout`

2. **Executable Not Found**:
   - Check executable name matches AppName in app_manifest.json
   - Verify executable has proper permissions: `chmod +x app/bin/my_run_neural_network`

3. **Docker Build Failures**:
   - Ensure Docker daemon is running
   - Check SOC parameter is set to "wn9"

### Deployment Issues

1. **Application Not Installing**:
   - Verify camera OpenSDK platform is enabled
   - Check certificate compatibility with camera firmware
   - Ensure proper network connectivity

2. **301 Redirect Errors**:
   - Normal behavior during CLI deployment
   - Verify installation via camera web interface

## 📋 System Requirements

### Development Environment
- **OS**: Linux (recommended) or Windows with WSL
- **Docker**: Version 20.10 or higher
- **Storage**: At least 2GB free space

### Target Camera
- **Model**: XND-A9084RV (or other WN9 SoC cameras)
- **Firmware**: Latest version recommended
- **OpenSDK**: Platform enabled

## 🔐 Security

- **Certificate Signing**: All applications signed with Wisenet Platform certificates
- **Secure Communication**: HTTPS/TLS for camera communication
- **Permission Model**: Granular permissions for system resources

## 📚 Documentation

- [BUILD_DOCUMENTATION.md](docs/BUILD_DOCUMENTATION.md) - Complete build instructions
- [OpenSDK Programming Guide](https://developer.hanwha-security.com) - Official documentation
- [Neural Network API Reference](docs/API_REFERENCE.md) - API documentation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on actual WN9 SoC camera
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

- **Technical Issues**: Check troubleshooting section
- **Camera Compatibility**: Consult Hanwha Vision documentation
- **Certificate Issues**: Contact your Hanwha Vision representative

---

**Successfully tested on**: XND-A9084RV with firmware 25.01.03_20250811_R551