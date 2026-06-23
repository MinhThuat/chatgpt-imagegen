@echo off
chcp 65001 >nul
title chatgpt-imagegen - Setup

:: Neu chua o trong Windows Terminal, thu mo lai o do de hien thi Unicode dung
if defined WT_SESSION goto :main
where wt >nul 2>&1
if %ERRORLEVEL% equ 0 (
    wt -d "%~dp0" --title "chatgpt-imagegen Setup" cmd /c ""%~f0""
    exit /b
)

:main
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
