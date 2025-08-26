# WN9 Toolchain and Model Conversion Analysis

## 🔍 **Investigation Summary**

After thorough investigation of the OpenSDK v25.04.09 and the available WN9 toolchain, here are the key findings about model conversion capabilities:

## 🏗️ **Available WN9 Toolchain Components**

### ✅ **What's Available in OpenSDK Docker**

**Docker Image**: `opensdk:25.04.09`
- **Size**: 5.34GB (comprehensive development environment)
- **WN9 Cross-Compiler**: `/opt/opensdk/toolchain/aarch64-wn9-linux-gnu/`
- **NPU Runtime API**: `/opt/opensdk/common/product/wn9/lib/npu_api/`
- **Application Build System**: CMake + Make toolchain

### 🧠 **NPU API Functions (neural_network.h)**

**Core NeuralNetwork Class Methods:**
```cpp
class NeuralNetwork {
public:
    // Creation
    static NeuralNetwork* Create();
    
    // Tensor Management
    virtual std::shared_ptr<Tensor> CreateInputTensor(const std::string &name) = 0;
    virtual std::shared_ptr<Tensor> CreateOutputTensor(const std::string &name) = 0;
    virtual std::shared_ptr<Tensor> GetInputTensor(const std::string &name) const = 0;
    virtual std::shared_ptr<Tensor> GetOutputTensor(const std::string &name) const = 0;
    
    // Model Loading & Inference
    virtual bool LoadNetwork(const std::string &bin) = 0;  // ← Key function!
    virtual bool LoadNetwork(const std::string &bin, std::vector<float>& mean, std::vector<float>& scale) = 0;
    virtual void UnloadNetwork() = 0;
    virtual bool RunNetwork(stat_t &) = 0;
    
    // Tensor Access
    virtual std::vector<std::shared_ptr<Tensor>> GetAllInputTensors() const = 0;
    virtual std::vector<std::shared_ptr<Tensor>> GetAllOutputTensors() const = 0;
    virtual size_t GetInputTensorCount() const = 0;
    virtual size_t GetOutputTensorCount() const = 0;
};
```

## ❌ **What's Missing: Model Conversion Tools**

### **No ONNX-to-Binary Converter Found**

**Searched For:**
- ONNX model conversion utilities
- Neural network compilers
- Model optimization tools
- Binary format converters

**Result**: No dedicated model conversion tools found in the OpenSDK package.

### **Key Missing Components:**
1. **ONNX Parser**: No tool to read ONNX models
2. **NPU Compiler**: No neural network compilation for WN9
3. **Model Optimizer**: No quantization or optimization tools
4. **Format Converter**: No ONNX → .bin conversion utility

## 🎯 **Critical Finding: LoadNetwork() Only Accepts .bin Files**

**From NPU API Documentation:**
```cpp
// Example usage from documentation
std::string relative_model_path = "../res/ai_bin/google_net.bin";
bool ret = network->LoadNetwork(relative_model_path);
```

**This confirms:**
- The NPU API **only loads pre-compiled .bin files**
- It does **NOT** accept ONNX, PyTorch, or TensorFlow models directly
- Model conversion must happen **outside** the runtime environment

## 🔧 **WN9 NPU Capabilities**

### **Supported Operations** (from documentation)

**WN9 Chipset Limitations:**
- **Downscaling Support**: 
  - YUV planar type: up to 1/7
  - Other types: up to 1/12

**Tensor Operations Available:**
- **Resize**: `tensor->Resize(*resized_tensor, img_size)`
- **Crop**: `tensor->Crop(*cropped_tensor, rect)`
- **Data Type Conversion**: Various tensor data types
- **Memory Management**: Allocate, assign, buffer operations

## 🚫 **Why No Model Conversion Tools?**

### **Possible Reasons:**

1. **Proprietary Technology**: WN9 NPU architecture may be proprietary
2. **Professional License Required**: Conversion tools may be in a separate package
3. **Cloud-Based Service**: Hanwha may provide conversion as a web service
4. **Partner Access Only**: Tools may be restricted to certified partners
5. **Custom Silicon**: WN9 NPU may require specialized compilation

## 💡 **How to Obtain Model Conversion Capabilities**

### **Recommended Approaches:**

#### 1. **Contact Hanwha Technical Support**
```
Request: WN9 NPU Model Conversion Tools
Requirements: ONNX to .bin converter for custom models
Camera Model: XND-A9084RV (WN9 SoC)
```

#### 2. **Professional SDK License**
- Request access to professional development tools
- May include advanced NPU compilation utilities
- Could provide model optimization frameworks

#### 3. **Partner Program**
- Join Hanwha developer partner program
- Access to proprietary development tools
- Technical support for custom model development

#### 4. **Cloud Conversion Service**
- Check if Hanwha provides model conversion as a service
- Upload ONNX models, receive optimized .bin files
- May be part of their AI platform offering

## 📋 **Current Workflow for Custom Models**

### **Available Options:**

#### Option 1: **Use Existing Models**
```bash
# Available pre-compiled models
ls app/res/ai_bin/
# google_net.bin (5.2MB) - ImageNet classification
```

#### Option 2: **Request Professional Tools**
```
Contact: Hanwha Vision Technical Support
Requirements: 
- WN9 NPU model compilation tools
- ONNX model conversion utilities
- Custom model development support
```

#### Option 3: **Partner with Model Provider**
- Find partners who already have WN9 conversion capabilities
- Commission custom model development
- Use third-party AI services compatible with WN9

## 🎯 **Technical Specifications for Model Conversion**

### **What We Need to Know:**

1. **Supported ONNX Opset Versions**
   - Which ONNX opset versions are compatible?
   - What operations are supported/unsupported?

2. **Model Format Requirements**
   - Input/output tensor specifications
   - Quantization requirements (INT8, FP16, FP32)
   - Memory layout constraints

3. **WN9 NPU Architecture Details**
   - Supported layer types
   - Memory limitations
   - Performance optimization guidelines

4. **Conversion Workflow**
   - Step-by-step conversion process
   - Validation and testing procedures
   - Performance benchmarking tools

## 🚀 **Next Steps for Model Conversion**

### **Immediate Actions:**

1. **Contact Hanwha Support**
   - Request WN9 model conversion documentation
   - Ask for professional development tools access
   - Inquire about partner programs

2. **Test Existing Models**
   - Understand performance characteristics
   - Analyze binary format structure
   - Document inference requirements

3. **Research Alternatives**
   - Look for third-party WN9 conversion tools
   - Check academic papers on WN9 NPU
   - Investigate reverse engineering possibilities

## 📚 **Documentation References**

- **NPU API Guide**: `HanwhaVision_OpenPlatform_NPU_API_25.04.09.html`
- **Programming Guide**: `HanwhaVision_OpenPlatform_Programming_Guide_25.04.09.html`
- **Sample Applications**: `HanwhaVision_OpenPlatform_Sample_Applications_25.04.09.html`

## 🎯 **Conclusion**

The WN9 toolchain in OpenSDK v25.04.09 provides:
- ✅ **Complete application development environment**
- ✅ **NPU runtime API for inference**
- ✅ **Cross-compilation for WN9 SoC**
- ❌ **NO model conversion tools (ONNX → .bin)**

**The model conversion capabilities are NOT included in the standard OpenSDK** and likely require:
- Professional/commercial licensing
- Partner program access
- Separate proprietary tools from Hanwha

---

*Investigation completed: WN9 toolchain analysis for model conversion requirements*
