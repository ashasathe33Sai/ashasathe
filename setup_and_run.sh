#!/usr/bin/env bash
set -e

echo "===================================================================="
echo "Initializing Video Summarization Application Setup (Linux / macOS)"
echo "===================================================================="

# 1. Check Python
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] python3 not found. Please install Python 3.10, 3.11, or 3.12."
    exit 1
fi

# 2. Create virtual environment
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment (.venv)..."
    python3 -m venv .venv
fi

# 3. Activate and install dependencies
source .venv/bin/activate
echo "Upgrading pip and installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# 4. Run verification
echo "Running self-verification suite..."
python scripts/verify_product.py

# 5. Launch application
echo "Launching application..."
python run.py
