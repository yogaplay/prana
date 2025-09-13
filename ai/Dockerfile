# ----- Base 이미지로 Python 3.9 slim을 사용 -----
FROM python:3.9-slim

# ----- OpenCV와 Mediapipe 실행 시 필요한 라이브러리 설치 -----
# libgl1-mesa-glx는 최신 데비안 배포판에서 libgl1으로 대체되었습니다.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# ----- 컨테이너 내 작업 디렉토리 설정 -----
WORKDIR /app

# ----- 소스 코드(app.py 등) 복사 -----
COPY app.py .

# ----- Python 패키지 설치 -----
RUN pip install --no-cache-dir \
    opencv-python \
    numpy \
    scipy \
    mediapipe \
    fastapi \
    uvicorn \
    pydantic

# ----- FastAPI 서버용 포트 개방 -----
EXPOSE 8000

# ----- 컨테이너 구동 시 app.py 실행 -----
CMD ["python", "app.py"]
