import cv2
import numpy as np
from scipy.spatial.distance import cosine
import mediapipe as mp
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import uvicorn
import base64
import logging

# 로거 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

mp_pose = mp.solutions.pose
pose = mp_pose.Pose()

# Mediapipe landmark 매핑
target_landmarks = {
    "HEAD": mp_pose.PoseLandmark.NOSE,
    "SHOULDER_LEFT": mp_pose.PoseLandmark.LEFT_SHOULDER,
    "SHOULDER_RIGHT": mp_pose.PoseLandmark.RIGHT_SHOULDER,
    "ELBOW_LEFT": mp_pose.PoseLandmark.LEFT_ELBOW,
    "ELBOW_RIGHT": mp_pose.PoseLandmark.RIGHT_ELBOW,
    "WRIST_LEFT": mp_pose.PoseLandmark.LEFT_WRIST,
    "WRIST_RIGHT": mp_pose.PoseLandmark.RIGHT_WRIST,
    "HIP_LEFT": mp_pose.PoseLandmark.LEFT_HIP,
    "HIP_RIGHT": mp_pose.PoseLandmark.RIGHT_HIP,
    "KNEE_LEFT": mp_pose.PoseLandmark.LEFT_KNEE,
    "KNEE_RIGHT": mp_pose.PoseLandmark.RIGHT_KNEE,
    "ANKLE_LEFT": mp_pose.PoseLandmark.LEFT_ANKLE,
    "ANKLE_RIGHT": mp_pose.PoseLandmark.RIGHT_ANKLE,
}

# 정답 각도와 live 각도의 계산 순서가 일치해야 함
angle_definitions = [
    ("HEAD", "NECK", "SHOULDER_LEFT"),  # 인덱스 0
    ("SHOULDER_LEFT", "ELBOW_LEFT", "WRIST_LEFT"),  # 인덱스 1
    ("SHOULDER_RIGHT", "ELBOW_RIGHT", "WRIST_RIGHT"),  # 인덱스 2
    ("ELBOW_LEFT", "SHOULDER_LEFT", "HIP_LEFT"),  # 인덱스 3
    ("ELBOW_RIGHT", "SHOULDER_RIGHT", "HIP_RIGHT"),  # 인덱스 4
    ("SHOULDER_LEFT", "HIP_LEFT", "KNEE_LEFT"),  # 인덱스 5
    ("SHOULDER_RIGHT", "HIP_RIGHT", "KNEE_RIGHT"),  # 인덱스 6
    ("HIP_LEFT", "KNEE_LEFT", "ANKLE_LEFT"),  # 인덱스 7
    ("HIP_RIGHT", "KNEE_RIGHT", "ANKLE_RIGHT"),  # 인덱스 8
    ("HIP_LEFT", "HIP_RIGHT", "KNEE_RIGHT"),  # 인덱스 9
    ("HIP_RIGHT", "HIP_LEFT", "KNEE_LEFT"),  # 인덱스 10
]

angle_error_message_larger = [
    '왼쪽 어깨를 더 들어주세요',  # 0
    '왼쪽 팔꿈치를 더 오므려주세요',  # 1
    '오른쪽 팔꿈치를 더 오므려주세요',  # 2
    '왼쪽 팔을 더 오므려주세요',  # 3
    '오른쪽 팔을 더 오므려주세요',  # 4
    '왼쪽 엉덩이를 더 올려주세요',  # 5
    '오른쪽 엉덩이를 더 올려주세요',  # 6
    '왼쪽 무릎을 더 구부려야 합니다',  # 7
    '오른쪽 무릎을 더 구부려야 합니다',  # 8
    '왼쪽 다리를 더 오므려야 합니다',  # 9
    '오른쪽 다리를 더 오므려야 합니다',  # 10
]

angle_error_message_smaller = [
    '왼쪽 어깨를 더 내려주세요',  # 0
    '왼쪽 팔꿈치를 더 벌려주세요',  # 1
    '오른쪽 팔꿈치를 더 벌려주세요',  # 2
    '왼쪽 팔을 더 벌려주세요',  # 3
    '오른쪽 팔을 더 벌려주세요',  # 4
    '왼쪽 엉덩이를 더 내리세요',  # 5
    '오른쪽 엉덩이를 더 내리세요',  # 6
    '왼쪽 무릎을 더 낮게 내려주세요',  # 7
    '오른쪽 무릎을 더 낮게 내려주세요',  # 8
    '왼쪽 다리를 더 벌려야 합니다',  # 9
    '오른쪽 다리를 더 벌려야 합니다',  # 10
]

position_mapping = {
    0: "SHOULDER",
    1: "ELBOW_LEFT",
    2: "ELBOW_RIGHT",
    3: "ARM_LEFT",
    4: "ARM_RIGHT",
    5: "HIP_LEFT",
    6: "HIP_RIGHT",
    7: "KNEE_LEFT",
    8: "KNEE_RIGHT",
    9: "LEG_LEFT",
    10: "LEG_RIGHT"
}


class FeedbackRequest(BaseModel):
    userSequenceId: int
    yoga_id: int
    correct_angles: str  # 예: "133.4,69.17,68.03,24.78,35.71,47.98,45.29,33.76,35.55,158.53,138.07"
    image: str  # Base64 인코딩된 이미지
    std: str    # 예: "133.4,69.17,68.03,24.78,35.71,47.98,45.29,33.76,35.55,158.53,138.07"


def calculate_angle_2d(A, B, C):
    a = np.array(A[:2])
    b = np.array(B[:2])
    c = np.array(C[:2])
    ba = a - b
    bc = c - b
    cosine_angle = np.dot(ba, bc) / (np.linalg.norm(ba) * np.linalg.norm(bc))
    angle = np.degrees(np.arccos(np.clip(cosine_angle, -1.0, 1.0)))
    return round(angle, 2)

def calculate_angle_3d(A, B, C):
    a = np.array(A)
    b = np.array(B)
    c = np.array(C)
    ba = a - b
    bc = c - b
    cosine_angle = np.dot(ba, bc) / (np.linalg.norm(ba) * np.linalg.norm(bc))
    angle = np.degrees(np.arccos(np.clip(cosine_angle, -1.0, 1.0)))

    return round(angle,2)

@app.post("/api/short-feedback")
async def short_feedback(request: FeedbackRequest):
    try:
        # 이미지 디코딩
        img_data = base64.b64decode(request.image)
        nparr = np.frombuffer(img_data, np.uint8)
        frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        if frame is None:
            raise HTTPException(status_code=400, detail="Invalid image data")
        image_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        logger.info("이미지 디코딩 성공")

        # 포즈 추론
        results = pose.process(image_rgb)
        if not results.pose_landmarks:
            logger.info("포즈 랜드마크 감지 실패")
            return JSONResponse(content={"result": "fail"})
        landmarks = results.pose_landmarks.landmark

        # NECK 포인트 계산 (양 어깨 중간)
        left_shoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER]
        right_shoulder = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER]
        neck_point = ((left_shoulder.x + right_shoulder.x) / 2,
                      (left_shoulder.y + right_shoulder.y) / 2,
                      (left_shoulder.z + right_shoulder.z) / 2)

        # live 각도 계산
        live_angles_list = []
        for idx, (A, B, C) in enumerate(angle_definitions):
            if B == "NECK":
                B_point = neck_point
            else:
                B_point = (
                    landmarks[target_landmarks[B]].x,
                    landmarks[target_landmarks[B]].y,
                    landmarks[target_landmarks[B]].z
                )
            A_point = (
                landmarks[target_landmarks[A]].x,
                landmarks[target_landmarks[A]].y,
                landmarks[target_landmarks[A]].z
            )
            C_point = (
                landmarks[target_landmarks[C]].x,
                landmarks[target_landmarks[C]].y,
                landmarks[target_landmarks[C]].z
            )
            angle_val = calculate_angle_3d(A_point, B_point, C_point)
            live_angles_list.append(angle_val)
        live_angles = np.array(live_angles_list)

        # 정답 각도 파싱
        correct_angles = np.array([float(x.strip()) for x in request.correct_angles.split(',')])
        logger.info(f"정답 각도: {correct_angles}")
        logger.info(f"실제 각도: {live_angles}")

        std_value = np.array([float(x.strip()) for x in request.std.split(',')])
        logger.info(f"표준 편차: {std_value}")

        # Cosine similarity 계산 및 로깅
        similarity = 1 - cosine(correct_angles, live_angles)
        logger.info(f"Cosine similarity: {similarity}")
        abs_diff = np.abs(live_angles-correct_angles)
        max_diff = np.max(abs_diff)
        logger.info(f"maximum difference: {max_diff}")

        # 1. 가중치 계산 (표준편차의 역수)
        epsilon = 1e-6  # prevent zero division error
        weights = 1 / (std_value + epsilon)
        weights = weights / weights.sum()  # 가중치 총합이 1이 되도록 정규화

        # 2. 절대 차이 계산
        diffs = np.abs(live_angles - correct_angles)
        diffs = np.where(diffs < 10, np.exp(diffs - 10), diffs)

        # 3. 가중합으로 점수 계산
        weight_mul = weights * diffs
        weighted_error = np.sum(weights * diffs)
        logger.info(f"weight : {weight_mul}")

        # 4. 점수를 100점 만점에서 감점 방식으로 계산 (예: max_error=30으로 설정)
        max_error = 200
        score = max(0, 100 * (1 - weighted_error / max_error))
        logger.info(f"점수 : {score}")


        result_str = "success" if similarity >= 0.95 and max_diff<20 else "fail"
        return JSONResponse(content={"result": result_str, "score": score})
    except Exception as e:
        logger.exception("단기 피드백 처리 중 오류 발생")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/long-feedback")
async def long_feedback(request: FeedbackRequest):
    try:
        # 이미지 디코딩
        img_data = base64.b64decode(request.image)
        nparr = np.frombuffer(img_data, np.uint8)
        frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        if frame is None:
            raise HTTPException(status_code=400, detail="Invalid image data")
        image_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        logger.info("이미지 디코딩 성공 (long-feedback)")

        # 포즈 추론
        results = pose.process(image_rgb)
        if not results.pose_landmarks:
            logger.info("포즈 랜드마크 감지 실패 (long-feedback)")
            return JSONResponse(
                content={"feedback": {"position": "", "message": "No pose landmarks detected", "count": 0}})
        landmarks = results.pose_landmarks.landmark

        # NECK 포인트 계산
        left_shoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER]
        right_shoulder = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER]
        neck_point = ((left_shoulder.x + right_shoulder.x) / 2,
                      (left_shoulder.y + right_shoulder.y) / 2,
                      (left_shoulder.z + right_shoulder.z) / 2)

        # live 각도 계산
        live_angles_list = []
        for idx, (A, B, C) in enumerate(angle_definitions):
            if B == "NECK":
                B_point = neck_point
            else:
                B_point = (
                    landmarks[target_landmarks[B]].x,
                    landmarks[target_landmarks[B]].y,
                    landmarks[target_landmarks[B]].z
                )
            A_point = (
                landmarks[target_landmarks[A]].x,
                landmarks[target_landmarks[A]].y,
                landmarks[target_landmarks[A]].z
            )
            C_point = (
                landmarks[target_landmarks[C]].x,
                landmarks[target_landmarks[C]].y,
                landmarks[target_landmarks[C]].z
            )
            angle_val = calculate_angle_3d(A_point, B_point, C_point)
            live_angles_list.append(angle_val)
            logger.info(f"각도[{idx}]: live 각도 = {angle_val}")
        live_angles = np.array(live_angles_list)

        # 정답 각도 파싱
        correct_angles = np.array([float(x.strip()) for x in request.correct_angles.split(',')])
        logger.info(f"정답 각도 (long-feedback): {correct_angles}")
        logger.info(f"실제 각도 (long-feedback): {live_angles}")

        # 각도 차이 계산 및 로깅
        diff = correct_angles - live_angles
        abs_diff = np.abs(diff)
        logger.info(f"각도 차이: {diff}")
        logger.info(f"절대 차이: {abs_diff}")

        # 가장 큰 차이 항목 선택
        final_idx = int(np.argmax(abs_diff))
        logger.info(f"가장 큰 차이 항목 인덱스: {final_idx}")

        # 피드백 메시지 결정
        if diff[final_idx] > 0:
            feedback_msg = angle_error_message_larger[final_idx]
        else:
            feedback_msg = angle_error_message_smaller[final_idx]
        position = position_mapping.get(final_idx, "")
        logger.info(f"피드백 메시지: {feedback_msg}, 부위: {position}")

        response_payload = {
            "feedback": {
                "position": position,
                "message": feedback_msg
            }
        }
        return JSONResponse(content=response_payload)
    except Exception as e:
        logger.exception("장기 피드백 처리 중 오류 발생")
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=False)
