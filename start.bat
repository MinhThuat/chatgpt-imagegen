@echo off
chcp 65001 >nul
title chatgpt-imagegen

:: Neu chua o trong Windows Terminal, thu mo lai o do de hien thi Unicode dung
if defined WT_SESSION goto :main
where wt >nul 2>&1
if %ERRORLEVEL% equ 0 (
    wt -d "%~dp0" --title "chatgpt-imagegen" cmd /c ""%~f0""
    exit /b
)

:main
echo [1/3] Dang kiem tra cap nhat...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$url = 'https://github.com/MinhThuat/chatgpt-imagegen/archive/refs/heads/main.zip';" ^
  "$zip = [System.IO.Path]::GetTempFileName() + '.zip';" ^
  "$extract = Join-Path ([System.IO.Path]::GetTempPath()) 'cgi_update';" ^
  "try {" ^
  "  Invoke-WebRequest $url -OutFile $zip -UseBasicParsing -ErrorAction Stop;" ^
  "  if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }" ^
  "  Expand-Archive $zip $extract -Force;" ^
  "  $src = Join-Path $extract 'chatgpt-imagegen-main';" ^
  "  $dst = '%~dp0';" ^
  "  $skip = @('anh_tham_chieu','out_','run_','.codex','__pycache__');" ^
  "  Get-ChildItem $src | Where-Object {" ^
  "    $name = $_.Name;" ^
  "    -not ($skip | Where-Object { $name -like $_ + '*' })" ^
  "  } | ForEach-Object { Copy-Item $_.FullName $dst -Recurse -Force };" ^
  "  Remove-Item $zip -Force;" ^
  "  Remove-Item $extract -Recurse -Force;" ^
  "  Write-Host 'Cap nhat thanh cong.'" ^
  "} catch {" ^
  "  Write-Host 'Khong the cap nhat (co the do mat mang). Tiep tuc voi phien ban hien tai...'" ^
  "}"

echo.
echo [2/3] Kiem tra token va khoi dong refresh loop...
python refresh_token.py
if %errorlevel% neq 0 goto :token_expired
start "" /min pythonw "%~dp0refresh_loop.pyw"
goto :continue
:token_expired
echo.
echo TOKEN HET HAN. Vui long chay lenh sau trong terminal:
echo.
echo     codex login
echo.
pause
exit /b 1
:continue

echo.
echo [3/3] Mo Claude Code...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; $OutputEncoding=[System.Text.Encoding]::UTF8; claude ."
