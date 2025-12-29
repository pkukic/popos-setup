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
# MATHEMATICAL TOOLS
# =============================================================================
echo ""
echo -e "${BLUE}=== Mathematical Tools ===${NC}"
# For GGB (2) files - GeoGebra
if ! command -v geogebra &> /dev/null && ! flatpak list | grep -q "org.geogebra.GeoGebra"; then
    echo -e "${YELLOW}Installing GeoGebra via flatpak...${NC}"
    flatpak install -y flathub org.geogebra.GeoGebra
else
    echo -e "${GREEN}✓${NC} GeoGebra already installed"
fi

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
echo "  • Office documents (DOCX, XLSX, PPTX, ODT, ODS, ODP) - LibreOffice"
echo "  • Note-taking (XOPP, XOJ) - Xournal++"
echo "  • Diagrams (DRAWIO) - Draw.io"
echo "  • eBooks (EPUB, MOBI) - Calibre"
echo "  • Images (JPG, PNG, SVG, HEIC, XCF, PSD) - GIMP, Inkscape, ImageMagick"
echo "  • Audio (MP3, M4A, WAV, AAC) - VLC, Audacity, FFmpeg"
echo "  • Video (MP4, MKV, WEBM, MOV) - VLC, FFmpeg"
echo "  • Subtitles (SRT) - Subtitle Editor"
echo "  • 3D Models (STL, OBJ, BLEND, F3D) - Blender, FreeCAD"
echo "  • Mathematics (GGB) - GeoGebra"
echo "  • Flashcards (APKG) - Anki"
echo "  • Fonts (TTF, OTF, WOFF) - Font Manager"
echo "  • Archives (ZIP, GZ, BZ2, TAR) - Archive tools"
echo ""
