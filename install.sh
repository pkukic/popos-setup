#!/bin/bash

# Pop OS Setup Script
# Installs packages needed to handle media and document files
# Based on comprehensive file analysis from Archive directory

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Pop OS Setup Script${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Please do not run as root/sudo${NC}"
    echo "This script will prompt for sudo when needed"
    exit 1
fi

# Update package list
echo -e "${YELLOW}Updating package lists...${NC}"
sudo apt update

# Function to install package if not already installed
install_if_missing() {
    if dpkg -l | grep -q "^ii  $1 "; then
        echo -e "${GREEN}✓${NC} $1 already installed"
    else
        echo -e "${YELLOW}Installing $1...${NC}"
        sudo apt install -y "$1"
    fi
}

# =============================================================================
# OFFICE & DOCUMENT TOOLS
# =============================================================================
echo ""
echo -e "${BLUE}=== Office & Document Tools ===${NC}"
# LibreOffice for DOCX (620), XLSX (114), PPTX (116), DOC (29), PPT (4), XLS, XLSM
# Also handles ODT (7), ODS (2), ODP (1)
install_if_missing "libreoffice"
install_if_missing "libreoffice-writer"
install_if_missing "libreoffice-calc"
install_if_missing "libreoffice-impress"

# Document conversion tool
install_if_missing "pandoc"

# =============================================================================
# NOTE-TAKING & ANNOTATION
# =============================================================================
echo ""
echo -e "${BLUE}=== Note-Taking & Annotation ===${NC}"
# Xournal++ for XOPP (157) and XOJ (46) files - handwritten notes/PDF annotation
install_if_missing "xournalpp"

# =============================================================================
# DIAGRAMMING
# =============================================================================
echo ""
echo -e "${BLUE}=== Diagramming Tools ===${NC}"
# Draw.io for DRAWIO (19) files
# Note: draw.io is available as a snap or flatpak
if ! command -v drawio &> /dev/null; then
    echo -e "${YELLOW}Installing draw.io via snap...${NC}"
    sudo snap install drawio
else
    echo -e "${GREEN}✓${NC} drawio already installed"
fi

# =============================================================================
# eBOOK MANAGEMENT
# =============================================================================
echo ""
echo -e "${BLUE}=== eBook Management ===${NC}"
# Calibre for EPUB (25) and MOBI (14) files
install_if_missing "calibre"

# =============================================================================
# IMAGE VIEWING & EDITING
# =============================================================================
echo ""
echo -e "${BLUE}=== Image Tools ===${NC}"
# For JPG (thousands), PNG (2658), SVG (133), GIF, BMP (45), WEBP, HEIC (2)
install_if_missing "gimp"              # Raster image editor (for XCF, PSD, general editing)
install_if_missing "inkscape"          # Vector graphics (SVG, AI files)
install_if_missing "imagemagick"       # CLI image manipulation & conversion

# HEIF/HEIC support (iPhone images)
install_if_missing "libheif-examples"  # For HEIC (2) files
install_if_missing "heif-gdk-pixbuf"   # HEIC thumbnail support

# =============================================================================
# MULTIMEDIA - AUDIO & VIDEO
# =============================================================================
echo ""
echo -e "${BLUE}=== Audio & Video ===${NC}"
# For MP3 (2370), M4A (4), WAV (16), AAC
# For MP4 (810+), MKV (51), WEBM (280), MOV (155+), WMV (3), 3GP (12), AVI, OGV
install_if_missing "vlc"               # Video/audio player with codec support
install_if_missing "audacity"          # Audio editing
install_if_missing "ffmpeg"            # Audio/video conversion

# Subtitle editor for SRT (31) files
install_if_missing "subtitleeditor"

# =============================================================================
# MEDIA CODECS
# =============================================================================
echo ""
echo -e "${BLUE}=== Media Codecs ===${NC}"
# For MP3, MP4, and various proprietary formats
install_if_missing "ubuntu-restricted-extras"

# =============================================================================
# 3D MODELING & CAD
# =============================================================================
echo ""
echo -e "${BLUE}=== 3D Modeling & CAD ===${NC}"
# For STL (12), OBJ (3), BLEND (1), F3D (10), F3Z (1) files
install_if_missing "blender"           # 3D modeling (BLEND, STL, OBJ)
install_if_missing "freecad"           # CAD tool (STL, F3D)

# =============================================================================
# MATHEMATICAL & SCIENTIFIC TOOLS
# =============================================================================
echo ""
echo -e "${BLUE}=== Mathematical & Scientific Tools ===${NC}"

# GeoGebra - for GGB files
if ! command -v geogebra &> /dev/null && ! flatpak list | grep -q "org.geogebra.GeoGebra"; then
    echo -e "${YELLOW}Installing GeoGebra via flatpak...${NC}"
    flatpak install -y flathub org.geogebra.GeoGebra
else
    echo -e "${GREEN}✓${NC} GeoGebra already installed"
fi

# Octave - MATLAB alternative for .mat files
install_if_missing "octave"

# MATLAB dependencies
echo ""
echo -e "${YELLOW}Installing MATLAB dependencies...${NC}"
install_if_missing "libxt6"
install_if_missing "libxtst6"
install_if_missing "libxmu6"

echo -e "${GREEN}✓${NC} MATLAB dependencies installed"
echo -e "${YELLOW}Note:${NC} Download MATLAB from MathWorks website"
echo -e "${YELLOW}      Then run: ./install-matlab.sh${NC}"

# LaTeX - for .tex files
echo ""
install_if_missing "texlive-full"
install_if_missing "texlive-latex-extra"
install_if_missing "texmaker"          # LaTeX editor

# =============================================================================
# CIRCUIT DESIGN & HDL
# =============================================================================
echo ""
echo -e "${BLUE}=== Circuit Design & HDL ===${NC}"

# Logisim - for .circ files (digital circuit simulator)
install_if_missing "logisim"

# HDL simulators for VHDL/Verilog (.vhd, .v, .sv files)
install_if_missing "ghdl"              # VHDL simulator
install_if_missing "iverilog"          # Verilog simulator
install_if_missing "gtkwave"           # Waveform viewer

# Vivado 2024.1 dependencies
echo ""
echo -e "${YELLOW}Installing Vivado 2024.1 dependencies...${NC}"
install_if_missing "libncurses5"
install_if_missing "libncurses5-dev"

# Create libtinfo5 and libncurses5 symlinks for Vivado
if [ ! -f /usr/lib/x86_64-linux-gnu/libtinfo.so.5 ]; then
    sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6 /usr/lib/x86_64-linux-gnu/libtinfo.so.5
fi
if [ ! -f /usr/lib/x86_64-linux-gnu/libncurses.so.5 ]; then
    sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
fi

echo -e "${GREEN}✓${NC} Vivado dependencies installed"
echo -e "${YELLOW}Note:${NC} Download Vivado 2024.1 from AMD Xilinx website"
echo -e "${YELLOW}      Then run: ./install-vivado.sh${NC}"

# =============================================================================
# FLASHCARD/LEARNING
# =============================================================================
echo ""
echo -e "${BLUE}=== Learning Tools ===${NC}"
# For APKG (2) files - Anki flashcards
install_if_missing "anki"

# =============================================================================
# VIRTUALIZATION
# =============================================================================
echo ""
echo -e "${BLUE}=== Virtualization ===${NC}"
# For OVA (1) files - VirtualBox
echo -e "${YELLOW}VirtualBox available for OVA files${NC}"
read -p "Install VirtualBox? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_if_missing "virtualbox"
    # Note: virtualbox-ext-pack has dependency conflicts, install manually if needed
    # Download from: https://www.virtualbox.org/wiki/Downloads
fi

# =============================================================================
# FONT MANAGEMENT
# =============================================================================
echo ""
echo -e "${BLUE}=== Font Management ===${NC}"
# For TTF (62), OTF (1), WOFF (23), WOFF2 (20), PFB (10), AFM (60) files
install_if_missing "font-manager"
install_if_missing "fontconfig"

# =============================================================================
# ARCHIVE TOOLS
# =============================================================================
echo ""
echo -e "${BLUE}=== Archive Tools ===${NC}"
# For ZIP (4), GZ (10), BZ2 (6), TAR files
# Most are handled by default, ensuring complete support
install_if_missing "unzip"
install_if_missing "p7zip-full"
install_if_missing "unrar"
install_if_missing "tar"
install_if_missing "gzip"
install_if_missing "bzip2"

# =============================================================================
# ADDITIONAL UTILITIES
# =============================================================================
echo ""
echo -e "${BLUE}=== Additional Utilities ===${NC}"
install_if_missing "git"               # Version control
install_if_missing "htop"              # System monitor
install_if_missing "tree"              # Directory tree viewer
install_if_missing "tldr"              # Simplified man pages
install_if_missing "curl"              # URL transfer tool
install_if_missing "wget"              # File retriever

# =============================================================================
# DEVELOPMENT TOOLS
# =============================================================================
echo ""
echo -e "${BLUE}=== Development Tools ===${NC}"

# Build essentials for C/C++
install_if_missing "build-essential"   # GCC, G++, make
install_if_missing "cmake"             # Build system
install_if_missing "pkg-config"        # Package configuration

# Python - uv package manager
echo ""
if ! command -v uv &> /dev/null; then
    echo -e "${YELLOW}Installing uv (Python package manager)...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
else
    echo -e "${GREEN}✓${NC} uv already installed"
fi

# Rust - rustup/cargo
echo ""
if ! command -v cargo &> /dev/null; then
    echo -e "${YELLOW}Installing Rust via rustup...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo -e "${GREEN}✓${NC} Rust already installed"
fi

# Node.js and package managers
echo ""
install_if_missing "nodejs"
install_if_missing "npm"

if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}Installing pnpm (fast Node.js package manager)...${NC}"
    npm install -g pnpm
else
    echo -e "${GREEN}✓${NC} pnpm already installed"
fi

# Java Development Kit
echo ""
install_if_missing "default-jdk"       # OpenJDK
install_if_missing "maven"             # Build tool

# CUDA Toolkit (optional)
echo ""
echo -e "${YELLOW}CUDA Toolkit for GPU computing${NC}"
read -p "Install NVIDIA CUDA Toolkit? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_if_missing "nvidia-cuda-toolkit"
fi

# MiniZinc - Constraint Programming
echo ""
if ! command -v minizinc &> /dev/null; then
    echo -e "${YELLOW}Installing MiniZinc (constraint programming)...${NC}"
    sudo snap install minizinc --classic
else
    echo -e "${GREEN}✓${NC} MiniZinc already installed"
fi

# =============================================================================
# CLEANUP
# =============================================================================
echo ""
echo -e "${YELLOW}Cleaning up...${NC}"
sudo apt autoremove -y
sudo apt autoclean

# =============================================================================
# SUMMARY
# =============================================================================
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Installed packages for:"
echo ""
echo "Media & Documents:"
echo "  • Office documents - LibreOffice"
echo "  • Note-taking - Xournal++"
echo "  • Diagrams - Draw.io"
echo "  • eBooks - Calibre"
echo "  • Images - GIMP, Inkscape, ImageMagick"
echo "  • Audio/Video - VLC, Audacity, FFmpeg"
echo "  • 3D Models - Blender, FreeCAD"
echo ""
echo "Scientific & Academic:"
echo "  • Mathematics - GeoGebra, Octave, MATLAB (manual install)"
echo "  • LaTeX - TeXLive, TeXmaker"
echo "  • Circuit Design - Logisim"
echo "  • HDL/FPGA - GHDL, Iverilog, GTKWave, Vivado 2024.1 (manual install)"
echo "  • Flashcards - Anki"
echo ""
echo "Development Tools:"
echo "  • Python - uv package manager"
echo "  • Rust - rustup/cargo"
echo "  • Node.js - npm, pnpm"
echo "  • Java - OpenJDK, Maven"
echo "  • C/C++ - GCC, G++, CMake"
echo "  • MiniZinc - Constraint programming"
echo "  • Build tools - make, pkg-config"
echo ""
