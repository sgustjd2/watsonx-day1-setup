#!/bin/bash
# [Mac 학생용] 환경 구축 (폴더 이름/위치 무관). 실행: bash setup.sh
# wheelhouse-mac 폴더가 있으면 인터넷 없이 설치, 없거나 실패하면 인터넷으로 설치합니다.
# 라이브러리 버전은 requirements.lock 에 고정되어 있고, lock 으로 설치하지 못하면 requirements.txt 로 설치합니다.
cd "$(dirname "$0")"
[ -d .venv ] || python3 -m venv .venv
PY=.venv/bin/python
done_=0
if [ -d wheelhouse-mac ]; then
  "$PY" -m pip install -q --no-index --find-links wheelhouse-mac -r requirements.lock \
    || "$PY" -m pip install -q --no-index --find-links wheelhouse-mac -r requirements.txt \
    && done_=1
fi
if [ "$done_" -eq 0 ]; then
  if ! "$PY" -m pip install -r requirements.lock; then
    echo; echo ">> requirements.lock 으로 설치하지 못해 requirements.txt 로 설치합니다"
    "$PY" -m pip install -r requirements.txt
  fi
fi
[ -f .env ] || cp .env.example .env
"$PY" check_env.py
echo; echo "다음: .env 에 키 입력 → VS Code 로 이 폴더 열기 → Python: Select Interpreter 에서 .venv 선택"
