#!/bin/bash

# Vivado 2024.1 Installation Helper
# Based on: https://dspdev.io/en/posts/vivado-2024-ubuntu/
# Download from: https://www.xilinx.com/support/download.html

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Vivado 2024.1 Installation${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check for installer
INSTALLER=$(ls FPGAs_AdaptiveSoCs_Unified_2024.1_*_Lin64.bin 2>/dev/null | head -n1)

if [ -z "$INSTALLER" ]; then
    echo -e "${RED}Error: Vivado installer not found${NC}"
    echo ""
    echo "Please download Vivado 2024.1 from:"
    echo "https://www.xilinx.com/support/download.html"
    echo ""
    echo "Place the installer file in this directory and run this script again."
    exit 1
fi

echo -e "Found installer: ${GREEN}$INSTALLER${NC}"
echo ""

# Make installer executable
chmod +x "$INSTALLER"

# Run installer
echo -e "${YELLOW}Launching Vivado installer...${NC}"
echo ""
echo "Installation tips:"
echo "  1. Log in with your AMD/Xilinx account"
echo "  2. Select 'Download Image (Install Separately)' for Linux"
echo "  3. Choose 'Selected Products Only' to save space"
echo "  4. Recommended install path: /tools/Xilinx"
echo ""
echo -e "${YELLOW}Press Enter to continue...${NC}"
read

./"$INSTALLER"

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "To use Vivado, add this to your ~/.bashrc:"
echo ""
echo "  source /tools/Xilinx/Vivado/2024.1/settings64.sh"
echo ""
echo "Then run: vivado"
echo ""
