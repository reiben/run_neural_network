# WN9 Neural Network Application - Deployment Instructions

## Quick Start

### Prerequisites
- WN9 SoC camera with firmware supporting OpenSDK
- Administrative access to camera web interface
- Network connectivity to camera
- Valid application signing certificate

### Deployment Steps

1. **Prepare Application Package**
   ```bash
   # Extract the provided package
   tar -xzf wn9_neural_network_unsigned.tar.gz
   
   # Place your signing certificate and key
   cp your_cert.crt app/res/cert/app_skel.crt
   cp your_key.key app/res/cert/app_skel.key
   cp your_key.pem app/res/cert/app_skel.pem
   ```

2. **Sign and Package (if certificates available)**
   ```bash
   # Run in OpenSDK Docker environment
   docker run --rm -v $(pwd):/opt/wn9_neural_network -w /opt/wn9_neural_network opensdk:25.04.09 opensdk_packager
   ```

3. **Upload to Camera**
   - Access camera web interface
   - Navigate to Applications → Install
   - Upload the .cap file (or unsigned package for testing)
   - Wait for installation completion

4. **Configure Application**
   - Enable the application in Applications → Management
   - Set appropriate channel assignments
   - Configure video analytics permissions

5. **Verify Installation**
   - Access application web interface at: `http://camera_ip/opensdk/wn9_neural_network/`
   - Test neural network operations through the interface

## Configuration Options

### Camera System Configuration

#### Video Analytics Setup
- Enable Video Analytics in camera settings
- Configure appropriate video channels
- Set resolution and frame rate parameters
- Ensure sufficient system resources

#### Network Configuration
- Configure network access for API calls
- Set up HTTPS if required
- Configure firewall rules for application access

### Application-Specific Configuration

#### Model Configuration
The application comes with GoogleNet pre-configured:
- Model file: `google_net.bin` (included)
- Input resolution: 224x224
- Input tensor: `data_0`
- Output tensor: `prob_1`

#### Permission Requirements
Required permissions in manifest:
- `SDCard`: For model file access
- `Device`: For system integration
- `VideoAnalytics`: For video stream access

## Testing the Installation

### Basic Functionality Test

1. **Access Web Interface**
   ```
   http://your_camera_ip/opensdk/wn9_neural_network/
   ```

2. **Create Neural Network**
   - Click "Send" next to CreateNetwork
   - Verify successful creation response

3. **Setup Tensors**
   - Create input tensor with name "data_0"
   - Create output tensor with name "prob_1"
   - Verify both tensors created successfully

4. **Load and Run Network**
   - Click "Send" for LoadNetwork
   - Click "Send" for RunNetwork
   - Verify network starts processing

5. **Check Results**
   - Click "Send" for CheckParseResult
   - Should show classification results

### API Testing

Use curl commands to test programmatically:

```bash
# Replace camera_ip with your camera's IP address
CAMERA_IP="192.168.1.100"
APP_URL="http://${CAMERA_IP}/opensdk/wn9_neural_network/configuration"

# Test network creation
curl -X POST "${APP_URL}" \
  -H "Content-Type: application/json" \
  -d '{"mode": "create_network", "model_name": "google_net.bin"}'

# Test tensor creation
curl -X POST "${APP_URL}" \
  -H "Content-Type: application/json" \
  -d '{"mode": "create_input_tensor", "input_tensor": "data_0"}'

curl -X POST "${APP_URL}" \
  -H "Content-Type: application/json" \
  -d '{"mode": "create_output_tensor", "output_tensor": "prob_1"}'

# Test network loading and execution
curl -X POST "${APP_URL}" \
  -H "Content-Type: application/json" \
  -d '{"mode": "load_network"}'

curl -X POST "${APP_URL}" \
  -H "Content-Type: application/json" \
  -d '{"mode": "run_network"}'
```

## Troubleshooting

### Common Installation Issues

#### 1. Package Upload Failure
**Symptoms**: Upload fails or package rejected
**Solutions**:
- Verify camera supports OpenSDK applications
- Check package integrity
- Ensure sufficient storage space
- Verify package signing (if required)

#### 2. Application Won't Start
**Symptoms**: Application shows as installed but not running
**Solutions**:
- Check system logs for error messages
- Verify all required permissions granted
- Ensure sufficient system resources
- Check compatibility with camera firmware version

#### 3. Neural Network Creation Fails
**Symptoms**: CreateNetwork operation returns error
**Solutions**:
- Verify model file exists in correct location
- Check file permissions and access
- Ensure NPU resources available
- Verify model compatibility with WN9 SoC

#### 4. Tensor Operations Fail
**Symptoms**: Tensor creation or access operations fail
**Solutions**:
- Check tensor names match model specifications
- Verify sufficient memory available
- Ensure model loaded successfully first
- Check input/output tensor compatibility

#### 5. Inference Not Working
**Symptoms**: RunNetwork succeeds but no results
**Solutions**:
- Verify video stream active and accessible
- Check video analytics permissions
- Ensure appropriate video resolution
- Verify frame processing pipeline

### Log Analysis

#### Application Logs
- Access through camera system logs
- Look for debug messages from application
- Check for error patterns or exceptions

#### System Resource Monitoring
- Monitor CPU and memory usage
- Check NPU utilization
- Verify network bandwidth availability

### Performance Optimization

#### System Tuning
- Adjust video processing resolution
- Configure appropriate frame rates
- Balance system resource allocation
- Optimize network inference frequency

#### Application Tuning
- Monitor inference timing
- Adjust preprocessing parameters
- Optimize memory allocation patterns
- Configure result processing efficiency

## Maintenance

### Regular Maintenance Tasks

1. **Monitor System Performance**
   - Check application resource usage
   - Monitor inference accuracy and timing
   - Review system logs for issues

2. **Update Management**
   - Keep camera firmware updated
   - Update application when new versions available
   - Maintain signing certificates

3. **Backup and Recovery**
   - Backup application configuration
   - Document custom modifications
   - Maintain deployment procedures

### Scaling Considerations

#### Multi-Camera Deployment
- Use consistent configuration across cameras
- Implement centralized monitoring
- Standardize deployment procedures
- Document camera-specific configurations

#### Integration with External Systems
- Configure metadata output formats
- Set up external API integrations
- Implement result aggregation systems
- Monitor network connectivity requirements

## Security Notes

### Certificate Management
- Keep signing certificates secure
- Regularly update certificates before expiration
- Use appropriate certificate validation
- Monitor for certificate-related issues

### Network Security
- Use HTTPS where possible
- Implement appropriate firewall rules
- Monitor for unauthorized access attempts
- Regular security assessment of deployment

### Application Security
- Monitor for unusual application behavior
- Keep application permissions minimal
- Regular security updates when available
- Audit application access patterns

---

For additional support, refer to the camera documentation or contact technical support.