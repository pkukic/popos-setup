#!/bin/bash

# MATLAB Installation Helper
# Based on: https://www.mathworks.com/help/install/ug/install-noninteractively-silent-installation.html
# Download from: https://www.mathworks.com/downloads

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}MATLAB Installation${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check for installer
if [ ! -f "./install" ]; then
    echo -e "${RED}Error: MATLAB installer not found${NC}"
    echo ""
    echo "Please download MATLAB from MathWorks:"
    echo "https://www.mathworks.com/downloads"
    echo ""
    echo "Extract the downloaded archive and run this script from the MATLAB installer directory."
    exit 1
fi

echo -e "Found MATLAB installer"
echo ""

# Check for input file
if [ ! -f "installer_input.txt" ]; then
    echo -e "${YELLOW}Creating installer_input.txt template...${NC}"
    cat > installer_input.txt << 'EOF'
# Sample MATLAB installer input file
# Modify this file with your File Installation Key and license path

destinationFolder=/usr/local/MATLAB/R2024b
fileInstallationKey=YOUR_FILE_INSTALLATION_KEY_HERE
agreeToLicense=yes
mode=silent
licensePath=YOUR_LICENSE_FILE_PATH_HERE

# Optional: Select specific products
# product.MATLAB
# product.Simulink
EOF

    echo -e "${RED}Please edit installer_input.txt with your license information:${NC}"
    echo "  1. Add your File Installation Key"
    echo "  2. Add your license file path"
    echo "  3. Uncomment products you want to install"
    echo ""
    echo "Then run this script again."
    exit 1
fi

# Run installer
echo -e "${YELLOW}Launching MATLAB installer...${NC}"
echo ""
sudo ./install -inputFile installer_input.txt

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "To use MATLAB, add this to your ~/.bashrc:"
echo ""
echo "  export PATH=\"/usr/local/MATLAB/R2024b/bin:\$PATH\""
echo ""
echo "Then run: matlab"
echo ""
