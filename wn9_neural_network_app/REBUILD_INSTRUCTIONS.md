# How to Rebuild the WN9 Neural Network CAP File

## 🚀 **Quick Rebuild Instructions**

Follow these exact steps to rebuild your CAP file:

### Step 1: Set Environment Variables
```bash
cd /home/akjh/hanwha/wn9_neural_network_app
export SDK_VER="25.04.09"
export APP_NAME="wn9_neural_network"
export SOC="wn9"
```

### Step 2: Clean Previous Build
```bash
sudo rm -rf app/build
rm -f *.cap
```

### Step 3: Build with Docker (Method 1 - Docker Compose)
```bash
docker-compose up --build
```

### Step 4: Complete Signing (If Step 3 fails with signing error)
```bash
# Copy certificates to the correct location
mkdir -p /tmp/signature
cp AppTest.crt /tmp/signature/
cp AppTest.key /tmp/signature/

# Run packaging with correct signature path
docker run --rm \
    -v $(pwd):/opt/wn9_neural_network \
    -v /tmp/signature:/opt/opensdk/signature \
    opensdk:25.04.09 \
    bash -c "cd /opt/wn9_neural_network && opensdk_packager"
```

### Step 5: Verify Results
```bash
ls -lh wn9_neural_network.cap
```

## 🔧 **Alternative Method (If above doesn't work)**

### Complete Manual Build:
```bash
# Set variables
export SDK_VER="25.04.09"
export APP_NAME="wn9_neural_network"
export SOC="wn9"

# Clean
sudo rm -rf app/build && rm -f *.cap

# Build everything in one Docker command
docker run --rm \
    -v $(pwd):/opt/wn9_neural_network \
    -v /home/akjh/hanwha:/tmp/certs \
    opensdk:25.04.09 \
    bash -c "
        # Copy certificates to signature directory
        mkdir -p /opt/opensdk/signature
        cp /tmp/certs/AppTest.crt /opt/opensdk/signature/
        cp /tmp/certs/AppTest.key /opt/opensdk/signature/
        
        # Build application
        cd /opt/wn9_neural_network/app
        mkdir -p build && cd build
        cmake -DSOC=wn9 ..
        make clean && make && make install
        
        # Package application
        cd /opt/wn9_neural_network
        opensdk_packager
    "
```

## 📋 **What Each Step Does**

1. **Environment Variables**: Required by Docker containers
2. **Clean Build**: Removes old build artifacts (may need sudo for permissions)
3. **Docker Build**: Compiles the C++ application for WN9 SoC
4. **Signing**: Creates the encrypted and signed CAP file
5. **Verification**: Confirms the CAP file was created successfully

## ✅ **Expected Output**

When successful, you should see:
```
wn9_neural_network.cap - approximately 7-8 MB
```

## 🚨 **Common Issues & Solutions**

### Issue 1: Permission Denied
```bash
sudo rm -rf app/build
```

### Issue 2: "No exist Private key or Certification"
```bash
# Ensure certificates are in the right place
ls -la AppTest.crt AppTest.key
# Copy to signature directory
mkdir -p /tmp/signature
cp AppTest.* /tmp/signature/
```

### Issue 3: Environment Variables Not Set
```bash
# Always export these before building
export SDK_VER="25.04.09"
export APP_NAME="wn9_neural_network" 
export SOC="wn9"
```

## 🎯 **Success Criteria**

✅ Compilation completes without errors  
✅ Archiving completes  
✅ Encrypting completes  
✅ Signing completes  
✅ CAP file created (~7-8 MB)  

Your `wn9_neural_network.cap` file is now ready for deployment to the XND-A9084RV camera!
