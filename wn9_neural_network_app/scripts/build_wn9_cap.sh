#!/bin/bash

# WN9 Neural Network Application - Automated Build Script
# This script automates the complete build process for WN9 SoC cameras

set -e  # Exit on any error

# Configuration
APP_NAME="my_run_neural_network"
OPENSDK_PATH="${OPENSDK_PATH:-/home/akjh/hanwha/Opensdk_Docker_Image_25.04.09_R484}"
SIGNATURE_DIR="/tmp/signature"
BUILD_DIR="$(pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if OpenSDK exists
    if [ ! -d "$OPENSDK_PATH" ]; then
        log_error "OpenSDK not found at: $OPENSDK_PATH"
        log_error "Please set OPENSDK_PATH environment variable or install OpenSDK"
        exit 1
    fi
    
    # Check if opensdk_packager exists
    if [ ! -f "$OPENSDK_PATH/CLI/opensdk_packager" ]; then
        log_error "opensdk_packager not found in OpenSDK installation"
        exit 1
    fi
    
    # Check if certificates exist
    if [ ! -f "certs/AppTest.crt" ] || [ ! -f "certs/AppTest.key" ]; then
        log_error "Wisenet Platform certificates not found in certs/ directory"
        log_error "Please ensure AppTest.crt and AppTest.key are in certs/ directory"
        exit 1
    fi
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        log_warning "Docker not found. Manual build process will be required."
    fi
    
    log_success "Prerequisites check completed"
}

# Function to setup signature directory
setup_certificates() {
    log_info "Setting up certificates..."
    
    # Create signature directory
    mkdir -p "$SIGNATURE_DIR"
    
    # Copy certificates
    cp certs/AppTest.crt certs/AppTest.key "$SIGNATURE_DIR/"
    
    # Verify certificates
    log_info "Verifying certificate authority..."
    local cert_info=$(openssl x509 -in "$SIGNATURE_DIR/AppTest.crt" -subject -issuer -noout)
    
    if echo "$cert_info" | grep -q "Hanwha Openplatform App Signed CA"; then
        log_success "Correct Wisenet Platform certificates detected"
    else
        log_warning "Certificate authority may not match expected Wisenet Platform CA"
        log_info "Certificate info: $cert_info"
    fi
}

# Function to verify application structure
verify_app_structure() {
    log_info "Verifying application structure..."
    
    # Check required directories
    local required_dirs=("config" "app/bin" "app/html" "app/libs" "app/res")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            log_error "Required directory missing: $dir"
            exit 1
        fi
    done
    
    # Check app_manifest.json
    if [ ! -f "config/app_manifest.json" ]; then
        log_error "app_manifest.json not found in config/ directory"
        exit 1
    fi
    
    # Extract app name from manifest
    local manifest_app_name=$(grep -o '"AppName": *"[^"]*"' config/app_manifest.json | cut -d'"' -f4)
    
    # Check if executable exists with correct name
    if [ ! -f "app/bin/$manifest_app_name" ]; then
        log_error "Executable not found: app/bin/$manifest_app_name"
        log_error "Executable name must match AppName in app_manifest.json"
        exit 1
    fi
    
    # Check if executable is actually executable
    if [ ! -x "app/bin/$manifest_app_name" ]; then
        log_warning "Executable permissions missing, fixing..."
        chmod +x "app/bin/$manifest_app_name"
    fi
    
    log_success "Application structure verified"
    log_info "Application name: $manifest_app_name"
}

# Function to build application using Docker
build_with_docker() {
    log_info "Building application with Docker..."
    
    if [ -f "docker-compose.yml" ]; then
        # Use existing docker-compose configuration
        log_info "Using existing docker-compose.yml"
        docker compose up --build
    else
        log_warning "docker-compose.yml not found, skipping Docker build"
        log_info "Assuming application is already compiled"
    fi
}

# Function to package application
package_application() {
    log_info "Packaging application..."
    
    # Clean up any existing CAP files
    rm -f *.cap
    
    # Run opensdk_packager
    log_info "Running opensdk_packager with Wisenet Platform certificates..."
    "$OPENSDK_PATH/CLI/opensdk_packager" -p "$SIGNATURE_DIR/"
    
    # Verify CAP file was created
    local cap_file="${APP_NAME}.cap"
    if [ -f "$cap_file" ]; then
        local file_size=$(ls -lh "$cap_file" | awk '{print $5}')
        log_success "CAP file created successfully: $cap_file ($file_size)"
        
        # Verify CAP file structure
        log_info "Verifying CAP file structure..."
        if tar -tf "$cap_file" | grep -q "app/bin"; then
            log_success "CAP file structure verified"
        else
            log_warning "CAP file structure may be incorrect"
        fi
    else
        log_error "CAP file creation failed"
        exit 1
    fi
}

# Function to create deployment package
create_deployment_package() {
    log_info "Creating deployment package..."
    
    local deploy_dir="deploy"
    mkdir -p "$deploy_dir"
    
    # Copy CAP file
    cp "${APP_NAME}.cap" "$deploy_dir/"
    
    # Copy deployment tools
    cp "$OPENSDK_PATH/CLI/opensdk_install" "$deploy_dir/" 2>/dev/null || log_warning "opensdk_install not copied"
    
    # Create deployment script
    cat > "$deploy_dir/deploy_to_camera.sh" << 'EOF'
#!/bin/bash

# Deployment script for WN9 Neural Network Application
# Usage: ./deploy_to_camera.sh <camera_ip> <username> <password>

if [ $# -ne 3 ]; then
    echo "Usage: $0 <camera_ip> <username> <password>"
    echo "Example: $0 10.0.1.32 admin mypassword"
    exit 1
fi

CAMERA_IP="$1"
USERNAME="$2"
PASSWORD="$3"
APP_NAME="my_run_neural_network"

echo "Deploying to camera: $CAMERA_IP"
echo "Application: $APP_NAME"

# Deploy using opensdk_install
./opensdk_install -a "$APP_NAME" -i "$CAMERA_IP" -c 1 -u "$USERNAME" -w "$PASSWORD"

echo "Deployment completed. Check camera web interface to verify installation."
EOF
    
    chmod +x "$deploy_dir/deploy_to_camera.sh"
    
    log_success "Deployment package created in deploy/ directory"
}

# Function to display build summary
display_summary() {
    log_success "Build completed successfully!"
    echo
    echo "=== BUILD SUMMARY ==="
    echo "Application Name: $APP_NAME"
    echo "CAP File: ${APP_NAME}.cap"
    echo "File Size: $(ls -lh ${APP_NAME}.cap | awk '{print $5}')"
    echo "Build Date: $(date)"
    echo "OpenSDK Version: 25.04.09"
    echo "Target Platform: WN9 SoC"
    echo
    echo "=== NEXT STEPS ==="
    echo "1. Deploy using: cd deploy && ./deploy_to_camera.sh <camera_ip> <username> <password>"
    echo "2. Or manually upload ${APP_NAME}.cap via camera web interface"
    echo "3. Verify installation in camera's OpenSDK application list"
    echo
}

# Main build process
main() {
    echo "============================================"
    echo "  WN9 Neural Network Application Builder"
    echo "============================================"
    echo
    
    check_prerequisites
    setup_certificates
    verify_app_structure
    
    if command -v docker &> /dev/null && [ -f "docker-compose.yml" ]; then
        build_with_docker
    else
        log_info "Skipping Docker build step"
    fi
    
    package_application
    create_deployment_package
    display_summary
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "WN9 Neural Network Application Builder"
        echo
        echo "Usage: $0 [OPTIONS]"
        echo
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --check-only   Only check prerequisites"
        echo
        echo "Environment Variables:"
        echo "  OPENSDK_PATH   Path to OpenSDK installation (default: /home/akjh/hanwha/Opensdk_Docker_Image_25.04.09_R484)"
        echo
        echo "Prerequisites:"
        echo "  - Hanwha Vision OpenSDK v25.04.09"
        echo "  - Wisenet Platform certificates (AppTest.crt, AppTest.key) in certs/ directory"
        echo "  - Docker (optional, for building from source)"
        echo
        exit 0
        ;;
    --check-only)
        check_prerequisites
        exit 0
        ;;
    *)
        main
        ;;
esac