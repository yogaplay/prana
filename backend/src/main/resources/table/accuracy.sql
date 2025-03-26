CREATE TABLE accuracy
(
    accuracy_id INT AUTO_INCREMENT PRIMARY KEY,                                          -- 피드백 ID (자동 증가)
    user_id     INT                    NOT NULL,                                         -- 사용자 ID (외래 키)
    yoga_id     INT                    NOT NULL,                                         -- 요가 ID (외래 키)
    sequence_id INT                    NOT NULL,                                         -- 시퀀스 ID (외래 키)
    success     INT                    NOT NULL,                                         -- 성공 횟수
    fail        INT                    NOT NULL,                                         -- 실패 횟수
    created_at  TIMESTAMP              NOT NULL DEFAULT CURRENT_TIMESTAMP,               -- 피드백 생성 시간 (기본값: 현재 시간)

    CONSTRAINT fk_a_user FOREIGN KEY (user_id) REFERENCES user (user_id),                -- 외래 키 (user 테이블)
    CONSTRAINT fk_a_yoga FOREIGN KEY (yoga_id) REFERENCES yoga (yoga_id),                -- 외래 키 (yoga 테이블)
    CONSTRAINT fk_a_sequence FOREIGN KEY (sequence_id) REFERENCES sequence (sequence_id) -- 외래 키 (sequence 테이블)
);


