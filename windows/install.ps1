# [학생용 Windows] 파이썬 3.12 + 패키지를 한 번에 설치합니다. 다른 버전의 파이썬이 깔려 있어도 상관없습니다.
# 1순위: uv 가 3.12 를 받아 .venv 에만 씁니다. 2순위(uv 가 막히거나 실패하면): PC 에 이미 있는 3.12/3.11 로 .venv 를 만듭니다.
# 실행: windows 폴더의 install.bat 더블클릭, 또는 (루트에서) powershell -ExecutionPolicy Bypass -File windows\install.ps1
$root = Split-Path $PSScriptRoot -Parent   # 스크립트는 windows\ 안에 있고, .venv/.env 등은 그 부모(루트)에 둡니다
Set-Location $root
if ($root.Length -gt 100) { Write-Host ">> 폴더 경로가 깁니다($($root.Length)자). Windows 경로 길이 제한 때문에 설치가 실패할 수 있습니다. C:\edu 처럼 짧은 경로로 옮겨 다시 실행하세요." }
$env:PYTHONPATH = $null; $env:PYTHONHOME = $null   # 다른 파이썬 설정이 .venv 를 오염시키지 않게
$py = ".\.venv\Scripts\python.exe"
$ok = $false

try {
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
        powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
        $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
    }
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        uv venv .venv --python 3.12 --managed-python --clear --force   # 시스템/conda 파이썬을 쓰지 않고 uv 가 받은 3.12 만 사용
        if ($LASTEXITCODE -eq 0) {
            uv pip install -r requirements.lock --python $py
            if ($LASTEXITCODE -ne 0) { Write-Host "`n>> requirements.lock 으로 설치하지 못해 requirements.txt 로 설치합니다"; uv pip install -r requirements.txt --python $py }
            if ($LASTEXITCODE -eq 0) { $ok = $true; Write-Host "`n>> uv 로 설치했습니다 (파이썬 3.12)" }
        }
    }
} catch { }

if (-not $ok) {
    Write-Host "`n>> uv 를 쓸 수 없어(회사망 차단 등) PC 에 있는 파이썬으로 설치합니다..."
    $found = $null
    foreach ($c in @(@("py", "-3.12"), @("py", "-3.11"), @("python"), @("python3"))) {
        if (-not (Get-Command $c[0] -ErrorAction SilentlyContinue)) { continue }
        $extra = @($c | Select-Object -Skip 1)
        try { $v = "$(& $c[0] @extra -c "import sys;print('%d.%d' % sys.version_info[:2])" 2>$null)".Trim() } catch { continue }
        if ($v -eq "3.12" -or $v -eq "3.11") { $found = $c; $ver = $v; break }   # 마이크로소프트 스토어 별칭은 여기서 걸러짐
    }
    if (-not $found) {
        Write-Host "사용할 수 있는 파이썬 3.12/3.11 이 없습니다. python.org 에서 3.12 설치 후 다시 실행하세요."
        exit 1
    }
    $extra = @($found | Select-Object -Skip 1)
    & $found[0] @extra -m venv .venv --clear
    if ($LASTEXITCODE -ne 0) { Write-Host ".venv 를 만들지 못했습니다. VS Code/터미널을 모두 닫고 다시 실행하세요."; exit 1 }
    & $py -m pip install -r requirements.lock
    if ($LASTEXITCODE -ne 0) { Write-Host "`n>> requirements.lock 으로 설치하지 못해 requirements.txt 로 설치합니다"; & $py -m pip install -r requirements.txt }
    if ($LASTEXITCODE -ne 0) { Write-Host "라이브러리 설치에 실패했습니다. 인터넷/프록시를 확인하거나 강사에게 문의하세요."; exit 1 }
    Write-Host "`n>> PC 의 파이썬 $ver 로 설치했습니다"
}

if (-not (Test-Path .env)) { Copy-Item .env.example .env }
& $py check_env.py
