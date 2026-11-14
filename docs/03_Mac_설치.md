# 개발환경 세팅 — Mac

**한 줄 요약:** VS Code로 실습 폴더를 열고 터미널에 `bash mac/install.sh` 한 줄. 파이썬 3.12와 라이브러리가 이 폴더의 `.venv`에만 설치됩니다. 내 Mac에 다른 파이썬이나 conda, pyenv가 있어도 상관없습니다.

> 이 문서의 검증 범위: 실제 Mac에서는 실행해 보지 못했습니다. 같은 스크립트를 Linux(WSL)에서 실행해 확인했고, Mac 고유 항목은 **미확인**으로 표시했습니다.

## 0. 준비물
- VS Code + 확장 **Python**(Microsoft)
- 인터넷 연결 (약 100MB 다운로드, 2~5분)
- 실습 폴더: GitHub ZIP 을 푼 **안쪽 폴더**(`mac` 폴더가 보이는 폴더), 강사가 준 폴더, 또는 `watsonx_setup.zip`을 푼 폴더. 이름·위치는 상관없습니다.
- 파이썬·conda·Homebrew를 따로 설치할 필요는 **없습니다.** (Mac 기본 파이썬이 낮거나 없어도 됩니다.)

## 1. Xcode 도구 확인 (처음 한 번, 컴파일 오류 대비) — 미확인
```bash
xcode-select -p
```
경로가 나오면 통과. 없으면 `xcode-select --install`을 실행하고 설치 창에서 진행합니다.

## 2. VS Code로 폴더 열고 터미널 열기
1. `File > Open Folder`(한국어 **미확인**: 파일 > 폴더 열기)로 실습 폴더를 엽니다.
2. **Restricted Mode** 배너가 뜨면 `Manage` → **Trust Folder & Continue**.
3. `Terminal > New Terminal`(한국어 **미확인**: 터미널 > 새 터미널). 터미널의 현재 폴더가 실습 폴더인지 확인합니다.

## 3. 설치 (한 줄)
```bash
bash mac/install.sh
```
- 하는 일: ① uv 설치(없으면) ② 파이썬 3.12를 받아 `.venv` 생성 ③ 라이브러리 설치(ADK 포함) ④ `.env` 복사 ⑤ 점검 실행
- 라이브러리 버전은 `requirements.lock`에 고정되어 있어 검증한 버전 그대로 설치됩니다(lock으로 설치하지 못하면 `requirements.txt`로 설치하고 화면에 알려 줍니다).
- uv 다운로드가 막히거나 uv가 실패하면 **자동으로 Mac에 있는 `python3.12` / `python3.11` / `python3`(3.11~3.12일 때)**로 `.venv`를 만들어 설치합니다. 화면에 `>> uv 로 설치했습니다` 또는 `>> PC 의 파이썬 3.x 로 설치했습니다`가 나옵니다.
- 끝에 `✅ import ...`가 줄줄이 나오면 성공입니다. `.env`의 ❌는 다음 단계에서 채웁니다.
- 다시 실행하면 `.venv`를 지우고 새로 만듭니다.

## 4. `.env` 채우기
VS Code 왼쪽 목록에서 `.env`를 열어 강사가 알려 준 값을 `=` 뒤에 붙여넣고 저장합니다. Finder에서는 점(.)으로 시작하는 파일이 숨겨지므로 VS Code 목록에서 찾습니다.
```
WXO_ENDPOINT_URL=
WXO_AGENT_ID=
WXO_API_KEY=
```
`WXO_*`는 14시 Agent 배포 후에 채워도 됩니다. 값을 캡처·채팅·문서에 올리지 마세요.

## 5. VS Code에 `.venv` 연결
`Cmd+Shift+P` → **Python: Select Interpreter**(한국어 **미확인**) → `.venv` 선택. 목록에 없으면 **Enter Interpreter Path...** → `.venv/bin/python`. 새 터미널 앞에 `(.venv)`가 보이면 연결 완료입니다.

## 6. 점검 (`check_env.py`)
```bash
python check_env.py
```
`python`이 없다는 오류가 나면 `.venv/bin/python check_env.py`. 기대 결과(`.env`를 채우기 전이면 마지막 `WXO_*` 3줄은 ❌여도 정상):
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

## 7. 예제 실행해 보기
예제11 폴더에서 (키 없이 시연하려면 먼저 `export MOCK=1`):
```bash
python -m streamlit run app.py
python -m uvicorn app:api --reload
```
화면 http://localhost:8501, API 문서 http://127.0.0.1:8000/docs. 둘을 동시에 켤 필요는 없습니다.

## 8. 내 Mac에 이미 파이썬/conda/pyenv가 있다면
`mac/install.sh`는 PATH의 파이썬을 쓰지 않고 uv가 받은 3.12만 씁니다. Linux에서 `PYTHONPATH`에 가짜 `requests.py`, `CONDA_DEFAULT_ENV=base`, 깨진 `.venv` 폴더를 둔 채 실행해 `.venv`가 3.12가 되고 import 7개가 ✅인 것을 확인했습니다. **Mac에서 conda·pyenv·Homebrew 파이썬이 있는 상태는 미확인**입니다.

**설치 후 이런 증상이 나오면** — 터미널의 `python`이 `.venv`가 아니라 conda/pyenv를 가리키는 경우입니다.
```
❌ 가상환경(.venv) 사용 중  → Python: Select Interpreter 에서 .venv 선택 ...
❌ import streamlit ...
```
해결: 5단계 `Select Interpreter`에서 `.venv` 선택 → 새 터미널. 터미널 앞에 `(base)`가 보이면 `conda deactivate`. 급하면 `.venv`의 파이썬을 직접 호출합니다(Windows에서 같은 증상을 재현해 이 방법으로 해결되는 것을 확인했습니다).
```bash
.venv/bin/python check_env.py
.venv/bin/python -m streamlit run app.py
```

## 9. 자주 나는 에러
| 증상 | 해결 |
|---|---|
| `xcode-select` / 컴파일 오류 | `xcode-select --install` 후 3단계 다시 |
| uv 다운로드(astral.sh)가 막히거나 uv가 실패 | 자동으로 Mac의 파이썬 3.12/3.11로 설치합니다. 인터넷 자체가 막혔다면 아래 "오프라인 설치" |
| `사용할 수 있는 파이썬 3.12/3.11 이 없습니다. python.org 에서 3.12 설치 후 다시 실행하세요.` | uv도 막혔고 쓸 파이썬도 없는 경우. python.org에서 3.12 설치 후 `bash mac/install.sh` 다시 |
| `python: command not found` | 5단계에서 `.venv` 선택 후 새 터미널, 또는 `.venv/bin/python` 사용 |
| `ModuleNotFoundError` | 8장의 증상 확인 |
| 터미널 앞에 `(base)` | `conda deactivate` |
| pip 타임아웃/프록시·SSL | 회사망 설정 문제. 강사에게 문의, 오프라인 설치 사용 |

## 10. 오프라인 설치 (대체 방법)
**오프라인 패키지 묶음은 Windows용만 있습니다. Mac은 오프라인 설치를 지원하지 않습니다.** zip을 받아도 Mac에서는 `mac/setup.sh`가 인터넷에서 `requirements.lock` 버전대로 설치합니다(미확인: 실제 Mac 실행).
- zip을 풀고 그 폴더를 VS Code로 연 뒤 `bash mac/setup.sh`
- 직접 설치: python.org에서 3.12 설치 → `python3.12 -m venv .venv` → `.venv/bin/python -m pip install -r requirements.lock` → 4~7단계
- 파이썬 버전·칩(Apple Silicon/Intel)이 zip의 패키지 묶음과 다르면 자동으로 인터넷 설치로 넘어갑니다.
