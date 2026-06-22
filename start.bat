@echo off
chcp 65001 >nul
title chatgpt-imagegen

echo [1/3] Dang kiem tra cap nhat...
git pull
if %errorlevel% neq 0 (
    echo Khong the pull. Kiem tra ket noi mang hoac lien he ho tro.
    pause
    exit /b 1
)

echo.
echo [2/3] Kiem tra token...
python refresh_token.py
if %errorlevel% neq 0 (
    echo.
    echo TOKEN HET HAN. Vui long chay lenh sau trong terminal:
    echo.
    echo     codex login
    echo.
    pause
    exit /b 1
)

echo.
echo [3/3] Mo Claude Code...
claude .

