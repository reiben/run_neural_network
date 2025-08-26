# WN9 Neural Network Application - Development Guide

## Architecture Overview

This application follows the OpenSDK architecture pattern with these key components:

### Component Architecture
```
┌─────────────────────────────────────────┐
│            Life Cycle Manager           │
├─────────────────────────────────────────┤
│            App Dispatcher               │
├─────────────────────────────────────────┤
│         Classification Component        │
├─────────────────────────────────────────┤
│            Neural Network API           │
├─────────────────────────────────────────┤
│         WN9 Video Frame Provider        │
└─────────────────────────────────────────┘
```

## Key Classes and Functions

### Classification Class

The main component inheriting from `Component` base class:

```cpp
class Classification : public Component {
    // Neural Network Management
    NeuralNetwork* GetOrCreateNetwork(const string& name);
    NeuralNetwork* GetNetwork(const string& name);
    void RemoveNetwork(const string& name);
    
    // Neural Network Operations
    bool CreateNetwork(NeuralNetwork* network, JsonUtility::JsonDocument& document);
    bool CreateTensor(NeuralNetwork* network, JsonUtility::JsonDocument& document, const string& request);
    bool LoadNetwork(NeuralNetwork* network);
    bool RunNetwork(NeuralNetwork* network);
    bool UnloadNetwork(NeuralNetwork* network);
    
    // Processing Pipeline
    void ProcessRawVideo(Event* event);
    void Inference(shared_ptr<RawImage> img);
    bool PreProcess(const string& model_path, shared_ptr<Tensor> rgb);
    bool Execute(const string& model_path);
    bool PostProcess(const string& model_path, const shared_ptr<Tensor>& img);
    bool ParseResult(float* data, int out_width);
};
```

### Neural Network API Flow

#### 1. Network Creation
```cpp
auto network = GetOrCreateNetwork("google_net.bin");
```

#### 2. Tensor Setup
```cpp
const shared_ptr<Tensor>& input_tensor(network->CreateInputTensor("data_0"));
const shared_ptr<Tensor>& output_tensor(network->CreateOutputTensor("prob_1"));
```

#### 3. Model Loading
```cpp
auto mean = std::vector<float>{123.68, 116.779, 103.939};
auto scale = std::vector<float>{1.0, 1.0, 1.0};
network->LoadNetwork(model_path, mean, scale);
```

#### 4. Inference Execution
```cpp
stat_t stat = { 0, };
network->RunNetwork(stat);
```

## Event Processing Flow

### Video Frame Processing
1. **Frame Reception**: Raw video frames arrive via `ProcessRawVideo` event
2. **Image Extraction**: Convert event blob to `RawImage` object
3. **Resolution Selection**: Choose appropriate resolution (≤4096x4096)
4. **Tensor Allocation**: Allocate RGB tensor for the frame
5. **Inference Pipeline**: Execute PreProcess → Execute → PostProcess

### Processing Pipeline Details

#### PreProcess
- Get input tensor dimensions from loaded model
- Resize input image to match tensor requirements
- Apply mean subtraction and scaling

#### Execute
- Run neural network inference
- Return status information

#### PostProcess
- Extract output tensor data
- Parse classification results
- Generate metadata XML
- Send metadata to camera system

## Configuration Management

### Attribute Serialization
The application uses JSON serialization for persistent configuration:

```json
{
    "Version": "1.0.0",
    "Attributes": [{
        "model_name": "google_net.bin",
        "input_tensor_names": "data_0",
        "output_tensor_names": "prob_1",
        "get_index_input_name": "data_0",
        "get_index_output_name": "prob_1",
        "get_name_input_index": "0",
        "get_name_output_index": "0"
    }]
}
```

### Manifest Processing
- Reads application permissions from `app_manifest.json`
- Validates required permissions: SDCard, Device, VideoAnalytics
- Sets up channel configuration

## Web Interface Integration

### API Endpoints
All neural network operations are exposed via HTTP POST to:
`/opensdk/{app_id}/configuration`

### Request Processing
```cpp
bool Classification::ParseNpuEvent(const string& event_body) {
    JsonUtility::JsonDocument document;
    document.Parse(event_body);
    
    string mode = document["mode"].GetString();
    
    if (mode == "create_network") {
        return CreateNetwork(network, document);
    } else if (mode == "load_network") {
        return LoadNetwork(network);
    }
    // ... handle other modes
}
```

## Memory Management

### Neural Network Lifecycle
- Networks stored in `unordered_map<string, unique_ptr<NeuralNetwork>>`
- Automatic cleanup on component destruction
- Manual cleanup via `UnloadNetwork`

### Tensor Management
- Tensors managed by shared_ptr
- Automatic reference counting
- Explicit allocation for input frames

## WN9 SoC Specific Features

### Video Integration
```cpp
// WN9-specific video SDK linking
elseif(SOC STREQUAL "wn9")
  include_directories(${WISENET_PRODUCT_RELEASE_PATH}/lib/wn9_sdk/video)
  link_libraries(sdk_wn9_video)
  link_libraries(wn9_technical_streamingService_sharedBuffer)
```

### NPU API Integration
- Links against `npu_api` library
- Provides hardware-accelerated inference
- Optimized for WN9 SoC architecture

## Error Handling

### Debug Logging
```cpp
void DebugLog(const char* format, ...) {
    // Format message
    // Send to ILogManager for remote debugging
    // Output to console
}
```

### Exception Management
- Component-level exception handling
- Graceful failure modes
- Status reporting via return values

## Performance Considerations

### Frame Processing Optimization
- Multi-resolution support (automatically selects smaller frames)
- Maximum processing size: 4096x4096
- Efficient memory allocation patterns

### Inference Optimization
- Reuse allocated tensors when possible
- Minimize memory copies
- Hardware-accelerated operations on WN9

## Extension Points

### Adding New Models
1. Place model file in `app/res/ai_bin/`
2. Update tensor names in configuration
3. Modify preprocessing parameters if needed
4. Update parsing logic for new output format

### Custom Preprocessing
- Modify `PreProcess` function
- Update mean/scale values
- Add model-specific transformations

### Custom Postprocessing
- Extend `ParseResult` function
- Modify metadata generation
- Add custom output formats

## Build System Details

### CMake Configuration
- Multi-SoC support with conditional compilation
- Automatic library copying for deployment
- Manifest installation handling

### Docker Integration
- Consistent build environment
- Cross-compilation for ARM64
- Automated packaging workflow

## Testing and Debugging

### Local Testing
- Use Docker environment for consistency
- Debug logging to track execution flow
- Web interface for interactive testing

### On-Device Debugging
- Remote debug message support
- System log integration
- Performance profiling capabilities

## Security Considerations

### Application Signing
- Required for production deployment
- Certificate validation by camera firmware
- Encrypted application packages

### Resource Protection
- Limited memory allocation
- Sandboxed execution environment
- Permission-based API access

---

This development guide provides the technical foundation for understanding and extending the WN9 neural network application.