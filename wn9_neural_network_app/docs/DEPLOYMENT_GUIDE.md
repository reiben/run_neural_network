# WN9 Neural Network Application - Deployment Guide

## Overview

This guide provides comprehensive instructions for deploying the WN9 neural network application to Hanwha Vision cameras with WN9 SoC chipset.

## Prerequisites

### Camera Requirements
- **Compatible Models**: XND-A9084RV (and other WN9 SoC cameras)
- **Firmware**: Latest version (25.01.03 or higher recommended)
- **OpenSDK Platform**: Enabled and functional
- **Network**: Camera accessible via IP address

### Build Requirements
- **Built CAP File**: `my_run_neural_network.cap` (generated using build process)
- **Network Access**: HTTP/HTTPS connectivity to camera
- **Credentials**: Camera admin username and password

## Deployment Methods

### Method 1: Automated CLI Deployment (Recommended)

1. **Prepare Deployment Package**:
   ```bash
   # After building, deployment files are in deploy/ directory
   cd deploy
   ls -la
   # Should contain:
   # - my_run_neural_network.cap
   # - deploy_to_camera.sh
   # - opensdk_install (CLI tool)
   ```

2. **Deploy to Camera**:
   ```bash
   ./deploy_to_camera.sh <camera_ip> <username> <password>
   
   # Example:
   ./deploy_to_camera.sh 10.0.1.32 admin mypassword
   ```

3. **Expected Output**:
   ```
   Deploying to camera: 10.0.1.32
   Application: my_run_neural_network
   
   Hanwha Vision opensdk_install
   Application Name: my_run_neural_network
   Camera IP: 10.0.1.32
   ...
   ---> Upload Success
   ---> Install Success
   Install App to Camera Finished
   ```

### Method 2: Manual CLI Deployment

1. **Using opensdk_install directly**:
   ```bash
   ./opensdk_install -a my_run_neural_network -i <camera_ip> -c 1 -u <username> -w <password>
   ```

2. **Parameters Explanation**:
   - `-a`: Application name (must match CAP filename without .cap)
   - `-i`: Camera IP address
   - `-c`: Channel number (typically 1)
   - `-u`: Username (typically 'admin')
   - `-w`: Password

### Method 3: Web Interface Deployment

1. **Access Camera Web Interface**:
   ```
   https://<camera_ip>
   ```

2. **Navigate to OpenSDK Section**:
   - Login with admin credentials
   - Go to System → OpenSDK → Applications
   - Or navigate directly to: `https://<camera_ip>/wmf/index.html`

3. **Upload CAP File**:
   - Click "Install" or "Upload Application"
   - Select `my_run_neural_network.cap` file
   - Wait for upload to complete
   - Click "Install" if installation doesn't start automatically

## Verification

### Check Installation Status

1. **Via CLI**:
   ```bash
   curl -k --digest -u admin:password "https://<camera_ip>/stw-cgi/opensdk.cgi?msubmenu=apps&action=view"
   ```

2. **Expected Response**:
   ```
   InstalledApps=2
   WiseAI.AppName=WiseAI
   WiseAI.Status=Running
   ...
   my_run_neural_network.AppName=my_run_neural_network
   my_run_neural_network.Status=Running
   my_run_neural_network.InstalledDate=Mon Aug 25 15:40:12 2025
   my_run_neural_network.Version=1.0
   my_run_neural_network.Permission=SDCard,Device,VideoAnalytics
   my_run_neural_network.AutoStart=True
   my_run_neural_network.Priority=Normal
   my_run_neural_network.ChannelType=Single
   ```

3. **Via Web Interface**:
   - Check OpenSDK Applications list
   - Application should appear with "Running" status

### Access Application Interface

1. **Web Interface URL**:
   ```
   https://<camera_ip>/apps/my_run_neural_network/
   ```

2. **Features to Verify**:
   - Real-time video feed display
   - Neural network classification results
   - Configuration controls
   - Status indicators

## Troubleshooting

### Common Deployment Issues

#### 1. "Upload Success" but App Not Listed

**Symptoms**:
- CLI reports successful upload and installation
- Application doesn't appear in camera's app list
- No error messages during deployment

**Possible Causes**:
- Certificate authority mismatch
- OpenSDK platform restrictions
- Camera firmware limitations

**Solutions**:
1. Verify certificates are Wisenet Platform specific:
   ```bash
   openssl x509 -in certs/AppTest.crt -subject -issuer -noout
   # Should show: "Hanwha Openplatform App Signed CA"
   ```

2. Check camera OpenSDK status:
   ```bash
   curl -k --digest -u admin:password "https://<camera_ip>/stw-cgi/opensdk.cgi?msubmenu=status"
   ```

3. Contact Hanwha Vision support for platform enablement

#### 2. Error Code 603 - Missing Required Parameters

**Symptoms**:
```
NG
Error Code: 603
Error Details: 
```

**Solutions**:
1. Verify CAP file integrity:
   ```bash
   file my_run_neural_network.cap
   ls -lh my_run_neural_network.cap
   ```

2. Check curl parameters:
   ```bash
   curl -k --digest -u admin:password -F "DataFile=@my_run_neural_network.cap;type=application/octet-stream" \
     "https://<camera_ip>/stw-cgi/opensdk.cgi?msubmenu=apps&action=install" -H "Expect:"
   ```

#### 3. Error Code 608 - Unknown Error

**Symptoms**:
- API returns error 608
- OpenSDK status queries fail

**Solutions**:
1. Check if OpenSDK platform is enabled
2. Verify camera firmware supports OpenSDK
3. Restart camera and try again

#### 4. Network Connectivity Issues

**Symptoms**:
- Connection timeouts
- 301 Redirect loops
- SSL/TLS errors

**Solutions**:
1. Verify camera IP and network connectivity:
   ```bash
   ping <camera_ip>
   ```

2. Try HTTP instead of HTTPS:
   ```bash
   curl --digest -u admin:password "http://<camera_ip>/stw-cgi/opensdk.cgi?msubmenu=apps&action=view"
   ```

3. Check camera web interface accessibility:
   ```bash
   curl -k "https://<camera_ip>/wmf/index.html"
   ```

### Application Runtime Issues

#### 1. Application Shows "Stopped" Status

**Solutions**:
1. Check application logs on camera
2. Verify all required libraries are included
3. Check executable permissions and dependencies

#### 2. Neural Network Not Processing

**Solutions**:
1. Verify VideoAnalytics permission in app_manifest.json
2. Check NPU availability and compatibility
3. Validate AI model files in app/res/ai_bin/

#### 3. Web Interface Not Accessible

**Solutions**:
1. Verify HTML files in app/html/ directory
2. Check application is running and listening on correct port
3. Verify camera firewall settings

## Best Practices

### Pre-Deployment Checklist

- [ ] CAP file built with correct WN9 SOC parameter
- [ ] Wisenet Platform certificates used for signing
- [ ] Application name matches in app_manifest.json and executable
- [ ] All required permissions specified
- [ ] Camera accessible and credentials verified

### Post-Deployment Verification

- [ ] Application appears in OpenSDK app list
- [ ] Status shows "Running"
- [ ] Web interface accessible
- [ ] Neural network processing functional
- [ ] No error messages in application logs

### Performance Monitoring

1. **Resource Usage**:
   - Monitor CPU and memory consumption
   - Check NPU utilization
   - Verify real-time performance

2. **Logging**:
   - Application startup logs
   - Neural network inference logs
   - Error and warning messages

## Advanced Deployment Options

### Batch Deployment

For deploying to multiple cameras:

```bash
#!/bin/bash
# deploy_batch.sh

CAMERAS=(
    "10.0.1.32"
    "10.0.1.33" 
    "10.0.1.34"
)

USERNAME="admin"
PASSWORD="mypassword"

for camera in "${CAMERAS[@]}"; do
    echo "Deploying to $camera..."
    ./deploy_to_camera.sh "$camera" "$USERNAME" "$PASSWORD"
    echo "---"
done
```

### Custom Deployment Scripts

For specific deployment requirements, modify `deploy_to_camera.sh` or create custom scripts using the opensdk_install tool.

## Security Considerations

1. **Certificate Management**:
   - Keep private keys secure
   - Rotate certificates before expiration
   - Use production certificates for production deployments

2. **Network Security**:
   - Use HTTPS for production deployments
   - Implement proper authentication
   - Monitor deployment activities

3. **Access Control**:
   - Limit deployment credentials
   - Use specific user accounts for deployment
   - Log all deployment activities

---

*This guide is based on successful deployment to XND-A9084RV cameras with firmware 25.01.03_20250811_R551*