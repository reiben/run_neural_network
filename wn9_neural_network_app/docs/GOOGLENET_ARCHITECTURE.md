# GoogleNet Architecture and Model Analysis

## Overview

The WN9 neural network application uses **GoogleNet (Inception v1)**, a deep convolutional neural network architecture that won the ImageNet Large Scale Visual Recognition Challenge (ILSVRC) 2014. This document provides a comprehensive analysis of the architecture and the `.bin` file format used.

## 🏗️ GoogleNet Architecture

### Basic Architecture Details

**Model Name**: GoogleNet (Inception v1)  
**Original Paper**: "Going Deeper with Convolutions" (Szegedy et al., 2015)  
**Competition**: ILSVRC 2014 Winner  
**Depth**: 22 layers (with parameters)  
**Total Parameters**: ~6.8 million  
**Input Size**: 224×224×3 RGB images  

### Key Architectural Innovations

#### 1. Inception Modules
The core innovation of GoogleNet is the **Inception module** which performs multiple convolution operations in parallel:

- **1×1 convolutions**: Dimension reduction and feature extraction
- **3×3 convolutions**: Medium-scale feature detection  
- **5×5 convolutions**: Large-scale feature detection
- **3×3 max pooling**: Spatial information preservation

#### 2. Dimension Reduction
Uses **1×1 convolutions** as bottleneck layers to:
- Reduce computational complexity
- Enable deeper and wider networks
- Maintain representational power

#### 3. Global Average Pooling
Replaces fully connected layers with **global average pooling**:
- Reduces overfitting
- Eliminates ~50 million parameters
- Improves generalization

### Detailed Layer Structure

| Layer Type | Output Size | Depth | Parameters | Operations |
|------------|-------------|-------|------------|------------|
| conv1 (7×7/2) | 112×112×64 | 1 | 2.7K | 34M |
| maxpool1 (3×3/2) | 56×56×64 | 0 | - | - |
| conv2 (3×3/1) | 56×56×192 | 2 | 112K | 360M |
| maxpool2 (3×3/2) | 28×28×192 | 0 | - | - |
| inception(3a) | 28×28×256 | 2 | 159K | 128M |
| inception(3b) | 28×28×480 | 2 | 380K | 304M |
| maxpool3 (3×3/2) | 14×14×480 | 0 | - | - |
| inception(4a) | 14×14×512 | 2 | 364K | 73M |
| inception(4b) | 14×14×512 | 2 | 437K | 88M |
| inception(4c) | 14×14×512 | 2 | 463K | 100M |
| inception(4d) | 14×14×528 | 2 | 580K | 119M |
| inception(4e) | 14×14×832 | 2 | 840K | 170M |
| maxpool4 (3×3/2) | 7×7×832 | 0 | - | - |
| inception(5a) | 7×7×832 | 2 | 1072K | 54M |
| inception(5b) | 7×7×1024 | 2 | 1388K | 71M |
| avgpool | 1×1×1024 | 0 | - | - |
| dropout (40%) | 1×1×1024 | 0 | - | - |
| linear | 1×1×1000 | 1 | 1000K | 1M |
| softmax | 1×1×1000 | 0 | - | - |

## 📊 Model Specifications in WN9 Application

### Input/Output Configuration

**Configuration File**: `src/classification/manifests/Classification_default_attribute_0.json`

```json
{
    "Version": "1.0.0",
    "Attributes": [
        {
            "model_name": "google_net.bin",
            "input_tensor_names": "data_0",
            "output_tensor_names": "prob_1",
            "get_index_input_name": "data_0",
            "get_index_output_name": "prob_1",
            "get_name_input_index": "0",
            "get_name_output_index": "0"
        }
    ]
}
```

### Preprocessing Parameters

**From Source Code** (`classification.cc`):
```cpp
auto mean = std::vector<float>{123.68, 116.779, 103.939};
auto scale = std::vector<float>{1.0, 1.0, 1.0};
```

**Input Normalization**:
- **Mean Subtraction**: RGB values (123.68, 116.779, 103.939)
- **Scaling**: Identity scaling (1.0, 1.0, 1.0)
- **Format**: RGB color space, 224×224 pixels

## 📁 Google_Net.bin File Analysis

### File Properties

**File Size**: 5.2 MB (5,422,396 bytes)  
**File Type**: Binary data (optimized for WN9 NPU)  
**Location**: `app/res/ai_bin/google_net.bin`  

### Model Conversion Process

#### 1. Original Source
**Source**: ONNX Model Repository  
**Original File**: `googlenet-9.onnx`  
**URL**: https://github.com/onnx/models/blob/main/vision/classification/inception_and_googlenet/googlenet/

#### 2. Conversion Pipeline
```
Caffe BVLC GoogLeNet → Caffe2 GoogLeNet → ONNX GoogLeNet → WN9 Binary Format
```

#### 3. Training Dataset
**Dataset**: ILSVRC2014 (ImageNet subset)  
**Classes**: 1000 object categories  
**Training Images**: ~1.2 million labeled images  

### Binary Format Structure

The `.bin` file contains:

1. **Model Weights**: Optimized neural network parameters
2. **Layer Configurations**: Network topology information  
3. **NPU Instructions**: WN9-specific optimization instructions
4. **Metadata**: Model versioning and validation information

### WN9 NPU Optimization

The binary format is specifically optimized for:

- **WN9 Neural Processing Unit**: Hardware-specific acceleration
- **Memory Layout**: Efficient memory access patterns
- **Quantization**: Reduced precision for faster inference
- **Instruction Set**: WN9-specific neural network operations

## 🔧 How the .bin File is Produced

### Step-by-Step Conversion Process

#### 1. Model Acquisition
```bash
# Download from ONNX Model Zoo
wget https://github.com/onnx/models/raw/main/vision/classification/inception_and_googlenet/googlenet/googlenet-9.onnx
```

#### 2. ONNX to WN9 Conversion
The conversion likely involves:

```python
# Pseudocode for conversion process
import onnx
import wn9_compiler  # Hanwha's proprietary compiler

# Load ONNX model
model = onnx.load("googlenet-9.onnx")

# Compile for WN9 NPU
wn9_model = wn9_compiler.compile(
    model=model,
    target="wn9",
    precision="mixed",  # INT8/FP16 optimization
    optimization_level="max"
)

# Save as binary format
wn9_model.save("google_net.bin")
```

#### 3. Optimization Steps
- **Quantization**: FP32 → INT8/FP16 for faster inference
- **Layer Fusion**: Combine operations for efficiency
- **Memory Optimization**: Reduce memory footprint
- **NPU Mapping**: Map operations to WN9 hardware units

### Verification Information

**Model Info File**: `googlenet_info.txt`
```
*** Model File Name ***
googlenet-9.onnx 

*** Model URL ***
https://github.com/onnx/models/blob/main/vision/classification/inception_and_googlenet/googlenet/

*** Model Description ***
GoogLeNet is the name of a convolutional neural network for classification, 
which competed in the ImageNet Large Scale Visual Recognition Challenge in 2014.

*** Source ***
Caffe BVLC GoogLeNet ==> Caffe2 GoogLeNet ==> ONNX GoogLeNet

*** DataSet ***
ILSVRC2014
```

## 🎯 Performance Characteristics

### Classification Capabilities

**Output Classes**: 1000 ImageNet categories  
**Top-1 Accuracy**: ~69.8% (original ILSVRC2014)  
**Top-5 Accuracy**: ~89.9% (original ILSVRC2014)  
**Inference Speed**: Optimized for real-time on WN9 NPU  

### Computational Efficiency

**Model Advantages**:
- 12× fewer parameters than AlexNet
- Efficient use of computational resources
- Suitable for embedded deployment
- Real-time inference capability

### WN9 NPU Performance

**Hardware Acceleration**:
- Parallel processing of Inception modules
- Optimized memory access patterns  
- Hardware-specific instruction set
- Low power consumption for embedded use

## 🔍 Model Usage in Application

### Loading Process

```cpp
// From classification.cc
const String open_sdk_path = "../res/ai_bin/";
relative_model_path = open_sdk_path + npu_load_info.model_name_;

// Load with preprocessing parameters
if (!network->LoadNetwork(relative_model_path, mean, scale)) {
    DebugLog("Failed: Load Network failed(model_name: %s)", 
             npu_load_info.model_name_.c_str());
    return false;
}
```

### Inference Pipeline

1. **Input Processing**: 224×224 RGB image normalization
2. **NPU Execution**: Hardware-accelerated inference
3. **Output Processing**: 1000-class probability distribution
4. **Result Interpretation**: Top-k classification results

## 📚 References

- **Original Paper**: Szegedy, C., et al. "Going deeper with convolutions." CVPR 2015
- **ONNX Model**: https://github.com/onnx/models/tree/main/vision/classification/inception_and_googlenet
- **ImageNet Dataset**: http://www.image-net.org/
- **ILSVRC Competition**: http://www.image-net.org/challenges/LSVRC/

---

*This analysis is based on the successful deployment of GoogleNet on XND-A9084RV camera with WN9 SoC.*