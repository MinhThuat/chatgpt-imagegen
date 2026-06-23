@echo off
chcp 65001 >nul
title chatgpt-imagegen - Setup
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
