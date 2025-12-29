# Pop OS Setup Script

Automated setup script to install all necessary packages for handling media and document files.

## Overview

This repository contains a setup script that installs software packages needed to open, edit, and work with various file formats.

## What It Installs

### Document Processing
- **LibreOffice** - For Microsoft Office files and OpenDocument formats
  - DOCX, XLSX, PPTX, DOC, PPT, XLS, XLSM
  - ODT, ODS, ODP
- **Pandoc** - Document conversion tool
- **Calibre** - eBook management for EPUB and MOBI files

### Note-Taking & Annotation
- **Xournal++** - For handwritten notes and PDF annotation
  - XOPP, XOJ files

### Diagramming
- **Draw.io** - Diagram creation and editing (via snap)
  - DRAWIO files

### Image Editing & Viewing
- **GIMP** - Advanced raster image editor
  - XCF, PSD, and general image editing
- **Inkscape** - Vector graphics editor
  - SVG, AI files
- **ImageMagick** - Command-line image manipulation
- **HEIF/HEIC support** - For iPhone images

Handles: JPG, PNG, GIF, BMP, WEBP, and more

### Audio & Video
- **VLC Media Player** - Universal media player
  - Video: MP4, MKV, WEBM, MOV, WMV, 3GP, AVI, OGV
  - Audio: MP3, M4A, WAV, AAC
- **Audacity** - Audio editing
- **FFmpeg** - Audio/video conversion
- **Subtitle Editor** - For SRT subtitle files
- **Ubuntu Restricted Extras** - Additional media codecs

### 3D Modeling & CAD
- **Blender** - 3D modeling and animation
  - BLEND, STL, OBJ files
- **FreeCAD** - CAD and 3D parametric modeling
  - F3D, F3Z, STL files

### Mathematical & Scientific Tools
- **GeoGebra** - Interactive mathematics software (via flatpak)
  - GGB files
- **Octave** - MATLAB alternative
  - MAT files
- **MATLAB** - Numerical computing (manual install via `./install-matlab.sh`)
- **LaTeX** - Document preparation
  - TeXLive + TeXmaker editor
  - TEX files

### Circuit Design & HDL/FPGA
- **Logisim** - Digital circuit simulator
  - CIRC files
- **GHDL** - VHDL simulator
- **Iverilog** - Verilog simulator
- **GTKWave** - Waveform viewer
  - VHD, VHDL, V, SV files
- **Vivado 2024.1** - Xilinx FPGA development (manual install via `./install-vivado.sh`)

### Learning Tools
- **Anki** - Flashcard application
  - APKG files

### Virtualization
- **VirtualBox** - Virtual machine management
  - OVA files

### Font Management
- **Font Manager** - GUI font management
- **Fontconfig** - Font configuration library

Handles: TTF, OTF, WOFF, WOFF2, PFB, AFM

### Archive Tools
- **unzip, p7zip-full, unrar** - Archive extraction
- **tar, gzip, bzip2** - Compression tools

Handles: ZIP, GZ, BZ2, TAR

### Additional Utilities
- **Git** - Version control
- **htop** - System monitor
- **tree** - Directory tree viewer
- **tldr** - Simplified man pages
- **curl, wget** - File retrieval tools

### Development Tools
- **Python** - uv package manager (modern, fast Python tool)
- **Rust** - rustup/cargo toolchain (requires shell restart after install)
- **Node.js** - npm and pnpm package managers
- **Java** - OpenJDK and Maven build tool
- **C/C++** - GCC, G++, CMake, make, pkg-config
- **R** - Statistical computing (r-base, r-base-dev, r-cran-rmarkdown)
- **MiniZinc** - Constraint programming language
- **Docker** - Containerization platform (docker.io, docker-compose)
- **Zephyr RTOS** - Embedded development (west, toolchain dependencies)
- **CUDA** - NVIDIA CUDA Toolkit for GPU computing

## What It DOESN'T Install

The script excludes:
- **IDEs** - Install your preferred IDE separately (VSCode, IntelliJ, etc.)
- **Default Pop OS applications** - PDF viewers, basic text editors, basic image viewers

## Usage

### Quick Start

```bash
cd popos-setup
chmod +x install.sh
./install.sh
```

### Step-by-Step

1. Clone or download this repository
2. Make the script executable: `chmod +x install.sh`
3. Run the script: `./install.sh`
4. Follow the prompts (script will ask for sudo password when needed)
5. After installation, restart your shell or run: `source "$HOME/.cargo/env"` to use Rust
6. For Docker, log out and back in for group changes to take effect

## Requirements

- Pop OS (or Ubuntu-based distribution)
- Internet connection
- Sudo privileges
- Flatpak support (included by default in Pop OS)

## Installation Methods

The script uses multiple package managers:
- **APT** - Most packages (LibreOffice, GIMP, VLC, etc.)
- **Snap** - Draw.io
- **Flatpak** - GeoGebra

All are handled automatically by the script.

## Notes

- The script skips packages already installed on your system
- Pop OS already includes basic PDF viewers, text editors, and archive managers
- All snaps and flatpaks are clearly indicated in the script output
- After installation:
  - Restart your shell to use Rust/cargo: `source "$HOME/.cargo/env"`
  - Log out and back in to use Docker without sudo
  - Initialize Zephyr workspace if needed: `west init ~/zephyrproject`

## Customization

Edit `install.sh` to:
- Comment out packages you don't need
- Add additional packages
- Change installation methods (e.g., snap vs flatpak vs apt)

## Maintenance

To update all installed packages:
```bash
# Update APT packages
sudo apt update && sudo apt upgrade -y

# Update Snap packages
sudo snap refresh

# Update Flatpak packages
flatpak update -y
```

## Troubleshooting

### Flatpak not installed
If GeoGebra installation fails:
```bash
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Ubuntu Restricted Extras prompts
The ubuntu-restricted-extras package may show license agreement prompts. Use Tab and Enter to accept.

## License

This is a personal setup script. Use and modify as needed.
