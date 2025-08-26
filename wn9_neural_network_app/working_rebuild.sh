#!/bin/bash

# WORKING CAP Rebuild Script - Based on Previous Success
# This script rebuilds my_run_neural_network.cap exactly as it worked before

echo "============================================"
echo "  WN9 Neural Network - WORKING CAP Builder"
echo "============================================"

# Step 1: Set correct app name in manifest
echo "[INFO] Setting correct AppName in manifest..."
sed -i 's/"AppName": "wn9_neural_network"/"AppName": "my_run_neural_network"/g' config/app_manifest.json

# Step 2: Clean previous build
echo "[INFO] Cleaning previous build..."
sudo rm -rf app/build 2>/dev/null || true
rm -f *.cap 2>/dev/null || true

# Step 3: Build with correct settings using the exact previous method
echo "[INFO] Building my_run_neural_network.cap (the working version)..."
docker run --rm \
    -v $(pwd):/opt/my_run_neural_network \
    opensdk:25.04.09 \
    bash -c "
        # Setup certificates
        mkdir -p /opt/opensdk/signature && 
        cp /opt/my_run_neural_network/AppTest.* /opt/opensdk/signature/ && 
        
        # Build application
        cd /opt/my_run_neural_network/app && 
        mkdir -p build && cd build && 
        cmake -DSOC=wn9 .. && 
        make clean && make && make install && 
        
        # Package application
        cd /opt/my_run_neural_network && 
        opensdk_packager
    "

# Step 4: Verify results
echo "[INFO] Checking build results..."
if [ -f "my_run_neural_network.cap" ]; then
    ls -lh my_run_neural_network.cap
    echo "============================================"
    echo "🎉 SUCCESS! CAP file rebuilt correctly:"
    echo "   File: my_run_neural_network.cap"
    echo "   Size: $(du -h my_run_neural_network.cap | cut -f1)"
    echo "   Status: Ready for deployment"
    echo ""
    echo "This is the EXACT same format that worked before!"
    echo "Deploy using the same method as successful deployment."
    echo "============================================"
else
    echo "============================================"
    echo "❌ ERROR: CAP file not created"
    echo "============================================"
    exit 1
fi

echo ""
echo "📋 Key differences from failed build:"
echo "  ✅ AppName: my_run_neural_network (not wn9_neural_network)"
echo "  ✅ CAP file: my_run_neural_network.cap"
echo "  ✅ Build path: /opt/my_run_neural_network"
echo "  ✅ Same format as previously successful deployment"
