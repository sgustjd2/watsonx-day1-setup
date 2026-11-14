"""환경 점검: python check_env.py  (키 값은 출력하지 않습니다)"""
import importlib
import os
import sys

OK, NO = "✅", "❌"
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")  # Windows 콘솔에서 이모지 깨짐 방지

v = sys.version_info
print(f"{OK if v >= (3, 11) else NO} 파이썬 {v.major}.{v.minor}.{v.micro} (3.11 이상 필요, 3.12 권장)")

in_venv = sys.prefix != sys.base_prefix
print(f"{OK if in_venv else NO} 가상환경(.venv) 사용 중" + ("" if in_venv else "  → Python: Select Interpreter 에서 .venv 선택 후 새 터미널 (conda (base) 가 보이면 conda deactivate)"))

for mod in ["streamlit", "fastapi", "uvicorn", "requests", "dotenv", "httpx", "ibm_watsonx_orchestrate"]:
    try:
        importlib.import_module(mod)
        print(f"{OK} import {mod}")
    except ImportError:
        print(f"{NO} import {mod}  → install.ps1(Windows) / bash install.sh(Mac) 를 다시 실행, 위 .venv 줄이 ❌ 면 먼저 인터프리터 선택")

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass
for key in ["WXO_ENDPOINT_URL", "WXO_AGENT_ID", "WXO_API_KEY"]:
    print(f"{OK if os.environ.get(key) else NO} .env {key}")
print("\n※ WXO_* 는 14시 Agent 배포 후에 채워도 됩니다.")
