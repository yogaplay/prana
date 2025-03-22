CREATE TABLE feedback
(
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,                            -- 피드백 ID (자동 증가)
    user_id     INT                    NOT NULL,                           -- 사용자 ID (외래 키)
    yoga_id     INT                    NOT NULL,                           -- 요가 ID (외래 키)
    body_part   ENUM
                    ('HEAD',
                        'SHOULDER_LEFT',
                        'SHOULDER_RIGHT',
                        'ELBOW_LEFT',
                        'ELBOW_RIGHT',
                        'WRIST_LEFT',
                        'WRIST_RIGHT',
                        'HIP_LEFT',
                        'HIP_RIGHT',
                        'KNEE_LEFT',
                        'KNEE_RIGHT',
                        'ANKLE_LEFT',
                        'ANKLE_RIGHT') NOT NULL,                           -- 피드백을 제공하는 신체 부위 (예: '허리', '어깨' 등)
    created_at  TIMESTAMP              NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 피드백 생성 시간 (기본값: 현재 시간)

    CONSTRAINT fk_f_user FOREIGN KEY (user_id) REFERENCES user (user_id),    -- 외래 키 (user 테이블)
    CONSTRAINT fk_f_yoga FOREIGN KEY (yoga_id) REFERENCES yoga (yoga_id)     -- 외래 키 (yoga 테이블)
);


