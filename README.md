# IBM watsonx Day1 실습 개발환경 설치 키트 (Windows / Mac)

IBM watsonx Day1 실습(Orchestrate Agent + 내 PC의 Streamlit/FastAPI 예제)에 필요한 파이썬 환경을 **한 번에** 만들어 주는 스크립트 모음입니다. 파이썬 3.12와 라이브러리(버전 고정)를 이 폴더의 `.venv`에만 설치하므로, 내 PC에 다른 파이썬이나 conda가 있어도 상관없습니다.

> 이 저장소에는 API 키·토큰·계정 정보가 **없습니다.** 실습 키 값은 강사가 따로 안내하며, 내 PC의 `.env` 파일에만 넣습니다.

## 받는 법

1. 이 페이지 위쪽 초록색 **Code → Download ZIP** 으로 받아 압축을 풉니다. (폴더 이름·위치는 상관없습니다. 경로가 너무 길면(약 100자 이상) 설치가 실패할 수 있으니 `C:\edu` 처럼 짧은 곳에 푸세요.)
2. 푼 폴더를 **VS Code** 로 엽니다(확장 *Python* 설치).
3. 설치 (인터넷 필요, 2~5분):
   - **Windows:** 폴더의 `install.bat` 더블클릭 (또는 VS Code 터미널에 `powershell -ExecutionPolicy Bypass -File install.ps1`)
   - **Mac:** VS Code 터미널에 `bash install.sh`
4. 끝에 `✅ import ...` 가 줄줄이 나오면 성공입니다. 이후 `.env` 채우기 → VS Code 에서 `.venv` 인터프리터 선택은 아래 가이드를 따릅니다.

## 가이드

- 화면 포함 단계별 안내(Notion): **개발환경 세팅 — Windows** / **개발환경 세팅 — Mac** (링크는 강사가 안내하는 실습 페이지에 있습니다)
- GitHub 에서 받는 방법(ZIP / git clone / 오프라인 zip / 자주 나는 에러): [설치가이드_GitHub.md](설치가이드_GitHub.md)
- 이 저장소의 문서: [설치가이드.md](설치가이드.md) · [설치가이드_Windows.md](설치가이드_Windows.md) · [설치가이드_Mac.md](설치가이드_Mac.md) · [설치_명령어_요약.md](설치_명령어_요약.md)

## 오프라인 설치 (인터넷이 막힌 PC, Windows 전용)

회사망이 막혀 있으면 **Releases** 의 `watsonx_setup.zip` 을 받으세요. 패키지가 함께 들어 있어 `setup.bat` 더블클릭으로 설치됩니다. **Windows 전용**이며(파이썬 3.12 기준), Mac 은 오프라인 설치를 지원하지 않고 `install.sh` 로 인터넷 설치합니다.

## 구성

| 파일 | 설명 |
|---|---|
| `install.bat` / `install.ps1` / `install.sh` | 설치 스크립트 (uv 로 파이썬 3.12 + 라이브러리, 막히면 PC 의 파이썬으로 대체) |
| `setup.bat` / `setup.ps1` / `setup.sh` | 오프라인 패키지(wheelhouse)가 있을 때 쓰는 설치 스크립트 |
| `requirements.txt` | 사람이 읽는 패키지 목록(출처 주석) |
| `requirements.lock` | 검증한 버전을 고정한 목록 |
| `check_env.py` | 설치 점검 (`✅`/`❌`, 키 값은 출력하지 않음) |
| `.env.example` | 환경변수 이름 예시(값은 비어 있음) |
