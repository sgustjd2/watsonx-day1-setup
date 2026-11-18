# [Windows 학생용] orchestrate 로그인(토큰 약 30분 만료 시 다시 실행): .env 의 WXO_API_KEY 를 실행 시점에만 읽어 env activate 에 넘깁니다. 키는 화면·파일에 출력하지 않습니다.
$root = Split-Path $PSScriptRoot -Parent   # 스크립트는 windows\ 안에 있고, .venv/.env 는 그 부모(루트)에 있습니다
$orch = Join-Path $root ".venv\Scripts\orchestrate.exe"
if (-not (Test-Path $orch)) { Write-Host ">> .venv 가 없습니다. 먼저 windows\setup.bat 을 실행하세요."; exit 1 }
$line = Get-Content (Join-Path $root ".env") -ErrorAction SilentlyContinue | Where-Object { $_ -match '^\s*WXO_API_KEY\s*=\s*\S' } | Select-Object -First 1
$key = if ($line) { ($line -replace '^\s*WXO_API_KEY\s*=\s*', '').Trim().Trim('"').Trim("'") }
if (-not $key) { Write-Host ">> .env 의 WXO_API_KEY 가 비어 있습니다. .env 에 키를 넣고 저장한 뒤 다시 실행하세요."; exit 1 }
& $orch env activate edu_us_south --api-key $key
if ($LASTEXITCODE -ne 0) { Write-Host "`n>> 로그인 실패. .env 의 WXO_API_KEY 값(앞뒤 공백·따옴표·복사 누락)을 확인하세요." }
exit $LASTEXITCODE
