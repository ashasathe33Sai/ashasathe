#!/usr/bin/env bash
set -e
echo "===================================================================="
echo "Starting Video Summarization Application..."
echo "===================================================================="

if [ -f ".venv/bin/python" ]; then
    echo "Using virtual environment at .venv..."
    .venv/bin/python run.py "$@"
else
    echo "Using system python3..."
    python3 run.py "$@"
fi
