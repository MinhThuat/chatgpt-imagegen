$ErrorActionPreference = "Stop"

function Step($n, $msg) { Write-Host "`n[$n/5] $msg" -ForegroundColor Yellow }
function OK($msg)        { Write-Host "      $msg" -ForegroundColor Green }
function FAIL($msg)      { Write-Host "      $msg" -ForegroundColor Red }

Write-Host @"

 ================================================================
  chatgpt-imagegen - Tu dong cai dat (khong can Admin)
 ================================================================
 Se cai: Python 3.12, Node.js v20 LTS, Codex CLI, Claude Code

"@
Read-Host " Nhan Enter de bat dau"

# ── 1. PYTHON ─────────────────────────────────────────────────────
Step 1 "Python..."
if (Get-Command python -ErrorAction SilentlyContinue) {
    OK "Da co: $(& python --version 2>&1)"
} else {
    Write-Host "      Chua co. Tai Python 3.12.9 (~25 MB)..."
    $setup = "$env:TEMP\py_setup.exe"
    Invoke-WebRequest "https://www.python.org/ftp/python/3.12.9/python-3.12.9-amd64.exe" `
        -OutFile $setup -UseBasicParsing
    Write-Host "      Dang cai (khong can Admin)..."
    Start-Process $setup -ArgumentList "/quiet InstallAllUsers=0 PrependPath=1 Include_test=0 Include_doc=0" -Wait
    Remove-Item $setup -Force -ErrorAction SilentlyContinue
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","User") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH","Machine")
    if (Get-Command python -ErrorAction SilentlyContinue) { OK "Python da cai xong." }
    else { Write-Host "      Python cai xong. Mo lai terminal neu lenh 'python' chua nhan ra." -ForegroundColor DarkYellow }
}

# ── 2. NODE.JS v20 ────────────────────────────────────────────────
Step 2 "Node.js v20 LTS..."
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    $nver = & node --version 2>&1
    OK "Da co: Node.js $nver"
    if ($nver -like "v24*") {
        FAIL "CANH BAO: v24 co the gap loi 'Cannot find module graceful-fs'."
        FAIL "Khuyen: go cai v24, tai va cai lai Node.js v20 LTS."
    }
} else {
    Write-Host "      Chua co. Tim phien ban v20 LTS moi nhat..."
    $v20 = ((Invoke-RestMethod "https://nodejs.org/dist/index.json") |
             Where-Object { $_.lts -and $_.version -like "v20.*" } |
             Select-Object -First 1).version
    $url = "https://nodejs.org/dist/$v20/node-$v20-win-x64.zip"
    Write-Host "      Tai $url (~18 MB)..."
    $zip = "$env:TEMP\node.zip"
    $tmp = "$env:TEMP\node_ex"
    Invoke-WebRequest $url -OutFile $zip -UseBasicParsing
    Write-Host "      Giai nen..."
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    Expand-Archive $zip $tmp -Force
    # Fix double-nesting: lay thu muc con dau tien ben trong
    $inner = (Get-ChildItem $tmp -Directory | Select-Object -First 1).FullName
    $dst = "$env:LOCALAPPDATA\nodejs"
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
    Move-Item $inner $dst
    Remove-Item $zip -Force -ErrorAction SilentlyContinue
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
    $cur = [System.Environment]::GetEnvironmentVariable("PATH","User")
    if ($cur -notlike "*nodejs*") {
        [System.Environment]::SetEnvironmentVariable("PATH","$dst;$cur","User")
    }
    $env:PATH = "$dst;" + $env:PATH
    OK "Node.js $v20 da cai xong."
}

# ── 3. CODEX CLI ──────────────────────────────────────────────────
Step 3 "Codex CLI..."
if (Get-Command codex -ErrorAction SilentlyContinue) {
    OK "Da co san."
} else {
    Write-Host "      Cai @openai/codex..."
    & npm install -g @openai/codex
    if ($LASTEXITCODE -ne 0) { FAIL "LOI: Khong cai duoc Codex."; Read-Host; exit 1 }
    # Refresh npm global bin path neu can
    $npmBin = & npm bin -g 2>$null
    if ($npmBin -and ($env:PATH -notlike "*$npmBin*")) { $env:PATH = "$npmBin;" + $env:PATH }
    OK "Codex da cai xong."
}

# ── 4. CLAUDE CODE ────────────────────────────────────────────────
Step 4 "Claude Code..."
if (Get-Command claude -ErrorAction SilentlyContinue) {
    OK "Da co san."
} else {
    Write-Host "      Cai @anthropic-ai/claude-code..."
    & npm install -g @anthropic-ai/claude-code
    if ($LASTEXITCODE -ne 0) { FAIL "LOI: Khong cai duoc Claude Code."; Read-Host; exit 1 }
    OK "Claude Code da cai xong."
}

# ── 5. TASK SCHEDULER ────────────────────────────────────────────
Step 5 "Tu dong refresh token (30 phut/lan)..."
$pyExe = (Get-Command python -ErrorAction SilentlyContinue).Source
$refreshScript = Join-Path $PSScriptRoot "refresh_token.py"
if ($pyExe -and (Test-Path $refreshScript)) {
    $action  = New-ScheduledTaskAction -Execute $pyExe -Argument $refreshScript
    $trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 30) -Once -At (Get-Date)
    Register-ScheduledTask -TaskName "CodexTokenRefresh" -Action $action -Trigger $trigger -Force | Out-Null
    OK "Task 'CodexTokenRefresh' da dang ky."
} else {
    Write-Host "      Bo qua (Python chua tim thay). Chay lai setup.bat sau khi mo terminal moi." -ForegroundColor DarkYellow
}

# ── CODEX LOGIN ──────────────────────────────────────────────────
$authFile = Join-Path $env:USERPROFILE ".codex\auth.json"
if (Test-Path $authFile) {
    Write-Host "`n Codex da dang nhap san. Bo qua buoc login." -ForegroundColor Green
} else {
    Write-Host @"

 ================================================================
  Buoc cuoi: Dang nhap ChatGPT
 ================================================================
 Trinh duyet se tu mo. Hay dang nhap tai khoan ChatGPT cua ban.
 Sau khi dang nhap xong, dong tab trinh duyet va quay lai day.

"@
    Read-Host " Nhan Enter de mo trinh duyet"
    & codex login
}

Write-Host @"

 ================================================================
  SETUP HOAN TAT!
  Tu nay chi can double-click start.bat de su dung.
 ================================================================

"@
Read-Host " Nhan Enter de dong"
