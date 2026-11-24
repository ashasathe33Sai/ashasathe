"""
Production Entry Point for Video Summarization Application.

Starts the FastAPI backend and serves the client-facing UI.

Usage:
    python run.py
    python run.py --host 127.0.0.1 --port 8000
    python run.py --host 0.0.0.0 --port 8080
"""

import argparse
from pathlib import Path
import sys

# Ensure repository root is in sys.path
REPO_ROOT = Path(__file__).resolve().parent
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

import uvicorn


def main():
    parser = argparse.ArgumentParser(description="Launch Video Summarization Web Application")
    parser.add_argument("--host", type=str, default="127.0.0.1", help="Bind host (default: 127.0.0.1)")
    parser.add_argument("--port", type=int, default=8000, help="Port (default: 8000)")
    parser.add_argument("--reload", action="store_true", help="Enable code hot-reload")
    args = parser.parse_args()

    print("=" * 68)
    print("Intent-Aware Event-Centric Multimodal Video Summarization")
    print(f"Local Access URL: http://{args.host}:{args.port}/")
    print("Press CTRL+C in this terminal to stop the server.")
    print("=" * 68)

    uvicorn.run("app.backend.main:app", host=args.host, port=args.port, reload=args.reload)


if __name__ == "__main__":
    main()
