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
        print(f"{NO} import {mod}  → windows\\install.ps1(Windows) / bash mac/install.sh(Mac) 를 다시 실행, 위 .venv 줄이 ❌ 면 먼저 인터프리터 선택")

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass
for title, keys in [
    ("구역 A (Orchestrate 호출, 14시 이후)", [("WXO_ENDPOINT_URL", ""), ("WXO_API_KEY", ""), ("WXO_AGENT_ID", "  → 아직이면 정상 (15시에 채움)")]),
    ("구역 B (이미지 설명, 예제 13·15시 사진 첨부)", [("WATSONX_URL", "  → 아직이면 정상"), ("WATSONX_API_KEY", "  → 아직이면 정상"), ("WATSONX_PROJECT_ID", "  → 아직이면 정상")]),
]:
    print(f"\n{title}")
    for key, note in keys:  # 값은 출력하지 않고 채워졌는지만 본다
        ok = bool(os.environ.get(key))
        print(f"{OK if ok else NO} .env {key}" + ("" if ok else note))
print("\n※ 구역 A 의 URL·API 키는 14시 시작 전, WXO_AGENT_ID 는 15시, 구역 B 는 예제 13·15시 사진 첨부 때 채웁니다. 저장 후 앱·터미널을 다시 켜야 반영됩니다.")
