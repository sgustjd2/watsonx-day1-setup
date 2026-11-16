"""화면 확인 (환경 확인용). 교육용 가상 데이터. 실행: python -m streamlit run streamlit_check.py"""
import pandas as pd
import streamlit as st

LOG = [("W01", "LOT-A", 1000, 38), ("W02", "LOT-A", 1000, 52), ("W03", "LOT-A", 1000, 41),
       ("W04", "LOT-B", 1000, 130), ("W05", "LOT-B", 1000, 47), ("W06", "LOT-B", 1000, 215)]

st.title("웨이퍼 수율 확인")
th = st.slider("기준 수율(%)", 80.0, 100.0, 90.0)  # 슬라이더를 움직이면 아래 표가 바로 바뀝니다
df = pd.DataFrame(LOG, columns=["웨이퍼", "LOT", "전체 die", "불량 die"])
df["수율(%)"] = ((df["전체 die"] - df["불량 die"]) / df["전체 die"] * 100).round(1)
df["판정"] = df["수율(%)"].apply(lambda y: "확인 필요" if y < th else "OK")
st.dataframe(df, hide_index=True)
