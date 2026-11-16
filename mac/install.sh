#!/bin/bash
# [학생용 Mac] 파이썬 3.12 + 패키지를 한 번에 설치합니다. 다른 버전의 파이썬이 있어도 상관없습니다. 실행: (루트에서) bash mac/install.sh
# 1순위: uv 가 3.12 를 받아 .venv 에만 씁니다. 2순위(uv 가 막히거나 실패하면): PC 에 이미 있는 3.12/3.11 로 .venv 를 만듭니다.
# 라이브러리 버전은 requirements.lock 에 고정되어 있고, lock 으로 설치하지 못하면 requirements.txt 로 설치합니다.
cd "$(dirname "$0")/.."  # 스크립트는 mac/ 안에 있고, .venv/.env 등은 그 부모(루트)에 둡니다
unset PYTHONPATH PYTHONHOME   # 다른 파이썬 설정이 .venv 를 오염시키지 않게
ok=0
LOCKMSG=">> requirements.lock 으로 설치하지 못해 requirements.txt 로 설치합니다"

if ! command -v uv >/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
if command -v uv >/dev/null \
   && uv venv .venv --python 3.12 --managed-python --clear --force; then   # 시스템/conda 파이썬을 쓰지 않고 uv 가 받은 3.12 만 사용
  if ! uv pip install -r requirements.lock --python .venv/bin/python; then
    echo; echo "$LOCKMSG"
    uv pip install -r requirements.txt --python .venv/bin/python
  fi
  if [ $? -eq 0 ]; then ok=1; echo; echo ">> uv 로 설치했습니다 (파이썬 3.12)"; fi
fi

if [ "$ok" -eq 0 ]; then
  echo; echo ">> uv 를 쓸 수 없어(회사망 차단 등) PC 에 있는 파이썬으로 설치합니다..."
  PY=""
  for c in python3.12 python3.11 python3; do
    if command -v "$c" >/dev/null && "$c" -c 'import sys; sys.exit(0 if sys.version_info[:2] in ((3,11),(3,12)) else 1)' 2>/dev/null; then PY="$c"; break; fi
  done
  if [ -z "$PY" ]; then
    echo "사용할 수 있는 파이썬 3.12/3.11 이 없습니다. python.org 에서 3.12 설치 후 다시 실행하세요."; exit 1
  fi
  "$PY" -m venv --clear .venv || { echo ".venv 를 만들지 못했습니다."; exit 1; }
  if ! .venv/bin/python -m pip install -r requirements.lock; then
    echo; echo "$LOCKMSG"
    .venv/bin/python -m pip install -r requirements.txt || { echo "라이브러리 설치에 실패했습니다. 인터넷/프록시를 확인하거나 강사에게 문의하세요."; exit 1; }
  fi
  echo; echo ">> PC 의 파이썬 $("$PY" --version 2>&1 | cut -d' ' -f2) 로 설치했습니다"
fi

[ -f .env ] || { [ -f .env.example ] && cp .env.example .env || printf 'WXO_ENDPOINT_URL=%s\nWXO_AGENT_ID=%s\nWXO_API_KEY=%s\n' '' '' '' > .env; }
.venv/bin/python check_env.py
