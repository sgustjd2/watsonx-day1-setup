# [Windows 학생용] 환경 구축: 이 폴더 안에 .venv 생성 + 패키지 설치 + .env 준비 + 점검 (폴더 이름/위치 무관)
# 실행: windows 폴더의 setup.bat 더블클릭, 또는 (루트에서) powershell -ExecutionPolicy Bypass -File windows\setup.ps1
# wheelhouse-win 폴더가 있으면 인터넷 없이 설치, 없거나 실패하면 인터넷으로 설치합니다.
$root = Split-Path $PSScriptRoot -Parent   # 스크립트는 windows\ 안에 있고, .venv/.env 등은 그 부모(루트)에 둡니다
Set-Location $root
if ($root.Length -gt 100) { Write-Host ">> 폴더 경로가 깁니다($($root.Length)자). Windows 경로 길이 제한 때문에 설치가 실패할 수 있습니다. C:\edu 처럼 짧은 경로로 옮겨 다시 실행하세요." }
if (-not (Test-Path .venv)) { python -m venv .venv }
$py = ".\.venv\Scripts\python.exe"
$done = $false
if (Test-Path wheelhouse-win) {
    & $py -m pip install -q --no-index --find-links wheelhouse-win -r requirements.lock
    $done = ($LASTEXITCODE -eq 0)
    if (-not $done) { & $py -m pip install -q --no-index --find-links wheelhouse-win -r requirements.txt; $done = ($LASTEXITCODE -eq 0) }
}
if (-not $done) {
    & $py -m pip install -r requirements.lock
    if ($LASTEXITCODE -ne 0) { Write-Host "`n>> requirements.lock 으로 설치하지 못해 requirements.txt 로 설치합니다"; & $py -m pip install -r requirements.txt }
}
if (-not (Test-Path .env)) { if (Test-Path .env.example) { Copy-Item .env.example .env } else { Set-Content .env -Value "WXO_ENDPOINT_URL=","WXO_AGENT_ID=","WXO_API_KEY=" -Encoding ascii } }
& $py check_env.py
Write-Host "`n다음: .env 에 키 입력 → VS Code 로 이 폴더 열기 → Python: Select Interpreter 에서 .venv 선택"
