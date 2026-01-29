#!/bin/bash
#
# ============================================================================
#                    D2L PyTorch Environment Setup Script
# ============================================================================
#
# Purpose:
#   Automated setup script for the "Dive into Deep Learning" (d2l) PyTorch 
#   environment in GitHub Codespaces or any Ubuntu-based Linux system.
#
# Why Python 3.10?
#   The d2l library (version 1.0.3) and its dependencies (numpy, scipy, etc.)
#   require Python 3.10 for compatibility. The default Python 3.12 in Ubuntu 24.04
#   is NOT compatible with the pinned package versions in LinuxRequirement.txt.
#
# Caveats:
#   • Colab: Limited Python version control and prebuilt packages. You can 
#     install d2l via `pip install d2l`, but it may not always match the 
#     notebook's exact version, and switching Python can break GPU support.
#   • Codespaces: CPU-only, no GPU, so heavy training (like train_ch13) 
#     will be very slow.
#
# Usage:
#   chmod +x setup_env.sh
#   ./setup_env.sh
#
# After running this script:
#   1. Activate the environment: source /workspaces/pytorch-d2l/.venv310/bin/activate
#   2. In Jupyter notebooks, select kernel: "Python 3.10 (d2l)"
#
# ============================================================================

set -e  # Exit immediately on error

echo "=========================================="
echo "D2L PyTorch Environment Setup Script"
echo "=========================================="

# ============================================================================
# Step 1: Check OS Version
# ============================================================================
# Inside a GitHub Codespace, the OS is always Linux. This step verifies
# the exact distro and version (expected: Ubuntu 24.04 LTS).
echo ""
echo "[Step 1] Checking OS version..."
cat /etc/os-release | grep PRETTY_NAME

# ============================================================================
# Step 2: Check Current Python Versions
# ============================================================================
# List available Python interpreters. Typically Ubuntu 24.04 comes with
# Python 3.12, which is incompatible with d2l's pinned dependencies.
echo ""
echo "[Step 2] Current Python versions available:"
ls /usr/bin/python* 2>/dev/null || echo "No python found in /usr/bin"

# ============================================================================
# Step 3: Add Deadsnakes PPA for Python 3.10
# ============================================================================
# The deadsnakes PPA provides Python versions not included in the default
# Ubuntu repositories. We need Python 3.10 for d2l compatibility.
# Reference: https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa
echo ""
echo "[Step 3] Adding deadsnakes PPA..."

# Fix broken Yarn repository GPG key (common issue in Codespaces)
# This prevents apt update from failing due to signature verification errors
if [ -f /etc/apt/sources.list.d/yarn.list ]; then
    echo "Fixing Yarn repository GPG key..."
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg 2>/dev/null || true
    echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null
fi

# Update package lists and install prerequisites
sudo apt update
sudo apt install -y -qq software-properties-common

# Add the deadsnakes PPA and update again
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update

# ============================================================================
# Step 4: Install Python 3.10 + venv Module
# ============================================================================
# Install Python 3.10 with:
#   - python3.10-venv: Required to create virtual environments
#   - python3.10-dev: Development headers for compiling C extensions
echo ""
echo "[Step 4] Installing Python 3.10..."
sudo apt install -y python3.10 python3.10-venv python3.10-dev
echo "Python 3.10 version:"
python3.10 --version

# ============================================================================
# Step 5: Create Virtual Environment
# ============================================================================
# Create a Python 3.10 virtual environment in .venv310
# This isolates the d2l dependencies from the system Python.
echo ""
echo "[Step 5] Creating virtual environment .venv310..."
cd /workspaces/pytorch-d2l
python3.10 -m venv .venv310

# Activate the virtual environment
# After activation, 'python' and 'pip' commands use the venv's Python 3.10
echo "Activating virtual environment..."
source .venv310/bin/activate

# Upgrade pip to latest version for better dependency resolution
echo "Upgrading pip..."
pip install --upgrade pip -q

# ============================================================================
# Step 6: Install Dependencies
# ============================================================================
# Install PyTorch, d2l, and all required packages.
#
# Option A (preferred): Install from LinuxRequirement.txt
#   - Contains all pinned versions for reproducibility
#   - IMPORTANT: This file is built for Python 3.10 ONLY!
#
# Option B (fallback): Install minimal dependencies
#   - torch==2.0.0 and torchvision==0.15.1 (CUDA 11.7 support)
#   - d2l==1.0.3 (Dive into Deep Learning library)
echo ""
echo "[Step 6] Installing PyTorch and d2l dependencies..."

if [ -f "LinuxRequirement.txt" ]; then
    echo "Installing from LinuxRequirement.txt..."
    echo "(This may take several minutes for large packages like PyTorch)"
    pip install -r LinuxRequirement.txt
else
    echo "LinuxRequirement.txt not found, installing minimal dependencies..."
    pip install torch==2.0.0 torchvision==0.15.1
    pip install d2l==1.0.3
fi

# ============================================================================
# Step 7: Register Jupyter Kernel
# ============================================================================
# Register the virtual environment as a Jupyter kernel so notebooks can use it.
#
# How it works:
#   - Creates a kernel spec at: ~/.local/share/jupyter/kernels/py310/kernel.json
#   - The kernel spec tells Jupyter to use .venv310/bin/python for execution
#   - MUST be run from inside the activated venv to point to correct Python
#
# After registration, select "Python 3.10 (d2l)" kernel in Jupyter notebooks.
echo ""
echo "[Step 7] Registering Jupyter kernel..."
pip install ipykernel -q
python -m ipykernel install --user --name py310 --display-name "Python 3.10 (d2l)"

# ============================================================================
# Verify Installation
# ============================================================================
# Quick sanity check to ensure core packages are importable
echo ""
echo "=========================================="
echo "Verifying installation..."
echo "=========================================="
python -c "import torch; print(f'PyTorch version: {torch.__version__}')"
python -c "import d2l; print(f'd2l version: {d2l.__version__}')"
python -c "import gym; print(f'Gym version: {gym.__version__}')"

# ============================================================================
# Setup Complete
# ============================================================================
echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "To use this environment:"
echo ""
echo "  1. Activate the virtual environment:"
echo "     source /workspaces/pytorch-d2l/.venv310/bin/activate"
echo ""
echo "  2. In Jupyter notebooks, select kernel:"
echo "     'Python 3.10 (d2l)'"
echo ""
echo "  3. To deactivate when done:"
echo "     deactivate"
echo ""
echo "Note: The virtual environment must be activated each time you open"
echo "a new terminal. Jupyter notebooks use the registered kernel directly."
echo ""
