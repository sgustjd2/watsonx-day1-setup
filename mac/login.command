#!/bin/bash
# [Mac 학생용, 미검증] orchestrate 로그인(토큰 약 30분 만료 시 다시 실행): .env 의 WXO_API_KEY 를 실행 시점에만 읽어 env activate 에 넘깁니다. 키는 출력하지 않습니다.
# 처음 한 번: chmod +x mac/login.command  후 Finder 에서 더블클릭
cd "$(dirname "$0")/.."  # 스크립트는 mac/ 안에 있고, .venv/.env 는 그 부모(루트)에 있습니다
ORCH=.venv/bin/orchestrate
[ -x "$ORCH" ] || { echo ">> .venv 가 없습니다. 먼저 bash mac/setup.sh 를 실행하세요."; read -n1 -p "아무 키나 누르세요"; exit 1; }
KEY=$(sed -n 's/^[[:space:]]*WXO_API_KEY[[:space:]]*=[[:space:]]*//p' .env 2>/dev/null | head -1 | tr -d '\r"'"'"' ')
[ -n "$KEY" ] || { echo ">> .env 의 WXO_API_KEY 가 비어 있습니다. 키를 넣고 저장한 뒤 다시 실행하세요."; read -n1 -p "아무 키나 누르세요"; exit 1; }
"$ORCH" env activate edu_us_south --api-key "$KEY" || echo ">> 로그인 실패. .env 의 WXO_API_KEY 값을 확인하세요."
read -n1 -p "아무 키나 누르세요"
