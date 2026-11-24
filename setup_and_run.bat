@echo off
setlocal
echo ====================================================================
echo Initializing Video Summarization Application Setup (Windows)
echo ====================================================================

REM 1. Check Python
where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Python not found in PATH. Please install Python 3.10, 3.11, or 3.12.
    pause
    exit /b 1
)

REM 2. Create virtual environment if not present
if not exist ".venv" (
    echo Creating virtual environment (.venv)...
    python -m venv .venv
    if %ERRORLEVEL% neq 0 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
)

REM 3. Activate and install requirements
echo Activating virtual environment...
call .venv\Scripts\activate.bat

echo Upgrading pip and installing dependencies...
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)

REM 4. Run verification
echo Running self-verification suite...
python scripts\verify_product.py

REM 5. Launch application
echo Launching application...
python run.py

pause
