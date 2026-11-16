"""웨이퍼 로그 확인 (환경 확인용 예제). 교육용 가상 데이터이며 실제 공정 기준이 아닙니다.
실행: python wafer_log_check.py   (외부 패키지 없이 파이썬 기본 기능만 씁니다)
"""
import os
import sys

# 1) 환경 확인: 지금 실행 중인 파이썬이 .venv 의 것인가
in_venv = sys.prefix != sys.base_prefix
print(f"파이썬 {sys.version.split()[0]} / 가상환경(.venv) 사용: {'예' if in_venv else '아니오 -> Select Interpreter 에서 .venv 선택'}")
print(f"실행 파일: {sys.executable}")

# 2) 키 확인: .env 값은 보여 주지 않고 '채워졌는지'만 봅니다
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    print("dotenv 없음 -> 설치가 덜 됐습니다 (python check_env.py 로 확인)")
print("WXO_API_KEY:", "채워짐" if os.environ.get("WXO_API_KEY") else "비어 있음 (지금은 정상)")

# 3) 웨이퍼 로그: 줄마다 웨이퍼ID, LOT, 전체 die 수, 불량 die 수
LOG = """\
W01,LOT-A,1000,38
W02,LOT-A,1000,52
W03,LOT-A,1000,41
W04,LOT-B,1000,130
W05,LOT-B,1000,47
W06,LOT-B,1000,215
"""
THRESHOLD = 90.0  # 수율(%)이 이 값보다 낮으면 확인 필요

lots = {}  # LOT -> [전체 die 합, 불량 die 합]
print(f"\n{'웨이퍼':<6}{'LOT':<8}{'수율(%)':>8}  판정")
for line in LOG.strip().splitlines():
    wafer, lot, total, fail = line.split(",")
    total, fail = int(total), int(fail)
    y = (total - fail) / total * 100  # 수율 = 양품 die / 전체 die
    print(f"{wafer:<6}{lot:<8}{y:>8.1f}  {'확인 필요' if y < THRESHOLD else 'OK'}")
    t = lots.setdefault(lot, [0, 0])
    t[0] += total
    t[1] += fail

print()
for lot, (total, fail) in lots.items():
    print(f"{lot} 평균 수율: {(total - fail) / total * 100:.2f}%")
