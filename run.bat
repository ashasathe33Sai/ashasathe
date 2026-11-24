@echo off
setlocal
echo ====================================================================
echo Starting Video Summarization Application...
echo ====================================================================

if exist ".venv\Scripts\python.exe" (
    echo Using virtual environment at .venv...
    ".venv\Scripts\python.exe" run.py %*
) else (
    echo Using system Python...
    python run.py %*
)
pause
