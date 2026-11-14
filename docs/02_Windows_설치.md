# 개발환경 세팅 — Windows

**한 줄 요약:** 실습 폴더의 `install.bat`을 더블클릭(또는 VS Code 터미널에 `powershell -ExecutionPolicy Bypass -File install.ps1`) 한 번. 파이썬 3.12와 라이브러리가 이 폴더의 `.venv`에만 설치됩니다. 내 PC에 다른 파이썬이나 conda가 있어도 상관없습니다.

> 이 문서의 검증 범위: Windows 11에서 실제로 실행해 확인했습니다. VS Code 한국어 메뉴 이름은 **미확인**으로 표시했습니다.

## 0. 준비물
- VS Code + 확장 **Python**(Microsoft)
- 인터넷 연결 (약 100MB 다운로드, 2~5분). 막힌 회사망이면 맨 아래 "오프라인 설치"
- 실습 폴더: 강사가 준 폴더(또는 `watsonx_setup.zip`을 푼 폴더). 이름·위치는 상관없습니다. OneDrive 밖(예: `C:\edu`)이 더 빠릅니다.
- 파이썬·conda를 따로 설치할 필요는 **없습니다.**

## 1. VS Code로 폴더 열고 터미널 열기
1. `File > Open Folder`(한국어 **미확인**: 파일 > 폴더 열기)로 실습 폴더를 엽니다.
2. 상단에 **Restricted Mode** 배너가 뜨면 `Manage` → **Trust Folder & Continue**.
3. `Terminal > New Terminal`(한국어 **미확인**: 터미널 > 새 터미널). 터미널이 실습 폴더에서 열렸는지 확인합니다.

## 2. 설치 (한 번)
**방법 A (권장):** 파일 탐색기에서 실습 폴더의 `install.bat`을 더블클릭. 검은 창이 열려 설치가 진행되고 끝나면 `pause`로 멈춥니다.

**방법 B:** VS Code 터미널에서
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```
- 그냥 `.\install.ps1`은 PC 보안 정책에 막힐 수 있어 위처럼 씁니다.
- 하는 일: ① uv 설치(없으면) ② 파이썬 3.12를 받아 `.venv` 생성 ③ 라이브러리 설치(ADK 포함) ④ `.env` 복사 ⑤ 점검 실행
- 라이브러리 버전은 `requirements.lock`에 고정되어 있어 검증한 버전 그대로 설치됩니다(lock으로 설치하지 못하면 `requirements.txt`로 설치하고 화면에 알려 줍니다).
- uv 다운로드가 막히거나 uv가 실행·설치에 실패하면 **자동으로 PC에 있는 파이썬 3.12/3.11**로 `.venv`를 만들어 설치합니다. 화면에 `>> uv 로 설치했습니다` 또는 `>> PC 의 파이썬 3.x 로 설치했습니다`가 나옵니다.
- 끝에 `✅ import ...`가 줄줄이 나오면 성공입니다. `.env`의 ❌는 다음 단계에서 채웁니다.
- 다시 실행하면 `.venv`를 지우고 새로 만듭니다(VS Code가 `.venv`를 쓰는 중이면 터미널을 닫고 다시).

## 3. `.env` 채우기
VS Code 왼쪽 목록에서 `.env`를 열어 강사가 알려 준 값을 `=` 뒤에 붙여넣고 저장합니다.
```
WXO_ENDPOINT_URL=
WXO_AGENT_ID=
WXO_API_KEY=
```
`WXO_*`는 14시 Agent 배포 후에 채워도 됩니다. 값을 캡처·채팅·문서에 올리지 마세요.

## 4. VS Code에 `.venv` 연결
`Ctrl+Shift+P` → **Python: Select Interpreter**(한국어 **미확인**: Python: 인터프리터 선택) → `.venv` 가 붙은 항목(Recommended). 오른쪽 아래 상태 표시줄의 파이썬 버전을 눌러도 같은 목록이 열립니다. 목록에 없으면 **Enter Interpreter Path...** → `.venv\Scripts\python.exe`. 새 터미널 앞에 `(.venv)`가 보이면 연결 완료입니다.

## 5. 점검 (`check_env.py`)
```powershell
python check_env.py
```
기대 결과(`.env`를 채우기 전이면 마지막 `WXO_*` 3줄은 ❌여도 정상):
```
✅ 파이썬 3.12.x (3.11 이상 필요, 3.12 권장)
✅ 가상환경(.venv) 사용 중
✅ import streamlit
✅ import fastapi
✅ import uvicorn
✅ import requests
✅ import dotenv
✅ import httpx
✅ import ibm_watsonx_orchestrate
```

## 6. 예제 실행해 보기
예제11 폴더에서 (키 없이 시연하려면 먼저 `$env:MOCK = "1"`):
```powershell
python -m streamlit run app.py
python -m uvicorn app:api --reload
```
화면 http://localhost:8501, API 문서 http://127.0.0.1:8000/docs. 둘을 동시에 켤 필요는 없습니다. `streamlit run`이 아니라 `python -m streamlit run`을 쓰는 이유: 일부 PC에서 `streamlit.exe`가 보안 정책에 막힙니다.

## 7. 내 PC에 이미 파이썬/conda가 있다면 (직접 실행해 확인한 결과)
`install.ps1`은 PATH의 파이썬을 쓰지 않고 uv가 받은 3.12만 씁니다. 아래 상황에서 실제로 돌려 `.venv`가 3.12가 되고 import 7개가 모두 ✅인 것을 확인했습니다.

| 내 PC 상태 | 실제 결과 |
|---|---|
| conda(base, 파이썬 3.14.7)가 PATH 맨 앞 + `PYTHONPATH`에 가짜 `requests.py` | `.venv` = 3.12.16, ✅ 전부 |
| uv로 설치한 3.13이 PATH 맨 앞 + `PYTHONPATH` 설정 | `.venv` = 3.12.16, ✅ 전부 |
| Microsoft Store 파이썬 별칭 폴더(WindowsApps)가 PATH 맨 앞 + `PYTHONHOME` 엉터리 값 | `.venv` = 3.12.16, ✅ 전부 |
| 이미 만든 `.venv`가 있는 폴더에서 다시 실행 | 지우고 3.12로 재생성 |

**설치 후 이런 증상이 나오면** — 터미널의 `python`이 `.venv`가 아니라 conda/3.13을 가리키는 경우입니다.
```
✅ 파이썬 3.14.7 (...)
❌ 가상환경(.venv) 사용 중  → Python: Select Interpreter 에서 .venv 선택 ...
❌ import streamlit  → install.ps1 ... 를 다시 실행, 위 .venv 줄이 ❌ 면 먼저 인터프리터 선택
```
해결: 4단계 `Select Interpreter`에서 `.venv` 선택 → 새 터미널. 터미널 앞에 `(base)`가 보이면 `conda deactivate`. 급하면 `.venv`의 파이썬을 직접 호출합니다.
```powershell
.venv\Scripts\python.exe check_env.py
.venv\Scripts\python.exe -m streamlit run app.py
```
(이렇게 하면 `✅ 파이썬 3.12.x`, `✅ 가상환경(.venv)`가 나오는 것을 확인했습니다.)

pyenv가 있는 PC는 이 PC에 없어 **미확인**입니다. 같은 원리(uv가 받은 3.12만 사용)라 영향이 없을 것으로 보지만 확인하지 못했습니다.

## 8. 자주 나는 에러
| 증상 | 해결 |
|---|---|
| `스크립트를 실행할 수 없습니다`(실행 정책) | 2단계처럼 `-ExecutionPolicy Bypass`를 붙여 실행 |
| `streamlit.exe`가 애플리케이션 제어 정책에 막힘 | `python -m streamlit run app.py`, `python -m uvicorn app:api` |
| `python`을 찾을 수 없음 / Microsoft Store가 열림 | 설치에는 영향 없음. 4단계에서 `.venv`를 선택하면 해결 |
| uv 다운로드(astral.sh)가 막히거나 uv 실행이 차단됨 | 자동으로 PC의 파이썬 3.12/3.11로 설치합니다(화면에 `>> PC 의 파이썬 ... 로 설치했습니다`). 인터넷 자체가 막혔다면 아래 "오프라인 설치" |
| `사용할 수 있는 파이썬 3.12/3.11 이 없습니다. python.org 에서 3.12 설치 후 다시 실행하세요.` | uv도 막혔고 PC에 쓸 파이썬도 없는 경우(Microsoft Store 별칭은 인정 안 됨). python.org에서 3.12 설치("Add to PATH" 체크) 후 `install.bat` 다시 |
| `Failed to create virtual environment` | VS Code/터미널이 `.venv`를 쓰는 중. 모두 닫고 폴더를 열어 다시 실행 |
| `ModuleNotFoundError` | 7장의 "이미 파이썬/conda가 있다면" 증상 |
| pip 타임아웃/프록시·SSL | 회사망 설정 문제. 강사에게 문의, 오프라인 설치 사용 |

## 9. 오프라인 설치 (대체 방법)
강사가 `watsonx_setup.zip`(패키지 포함)을 줬거나 uv 다운로드가 막힌 PC에서 씁니다.
- zip을 풀고 그 폴더를 VS Code로 연 뒤 `setup.bat` 더블클릭 (또는 `powershell -ExecutionPolicy Bypass -File setup.ps1`)
- 직접 설치: python.org에서 3.12 설치 → `py -3.12 -m venv .venv` → `.venv\Scripts\python.exe -m pip install -r requirements.lock` → 3~6단계
- 파이썬 버전이 zip의 패키지 묶음과 다르면 자동으로 인터넷 설치로 넘어갑니다.
- 오프라인 패키지 묶음(`wheelhouse-win`)은 파이썬 3.12(Windows)용입니다. 폴더 경로가 길면(약 100자 이상) 설치가 실패할 수 있으니 `C:\edu` 같은 짧은 경로에 푸세요(실제로 약 120자 경로에서 실패를 확인했고, 스크립트가 경고를 출력합니다).
