CREATE TABLE sequence_body
(
    sequence_body_id     INT AUTO_INCREMENT PRIMARY KEY,                                                 -- 자동 증가하는 고유 ID
    user_sequence_id     INT NOT NULL,                                                                   -- 시퀀스의 ID (sequence 테이블의 외래 키)
    body_part   ENUM
        (
                        'SHOULDER',
                        'ELBOW_LEFT',
                        'ELBOW_RIGHT',
                        'ARM_LEFT',
                        'ARM_RIGHT',
                        'HIP_LEFT',
                        'HIP_RIGHT',
                        'KNEE_LEFT',
                        'KNEE_RIGHT',
                        'LEG_LEFT',
                        'LEG_RIGHT') NOT NULL,                                                           -- 태그의 ID (tag 테이블의 외래 키)
    feedback_cnt        INT NOT NULL,
    CONSTRAINT fk_ss_sequence FOREIGN KEY (user_sequence_id) REFERENCES user_sequence (user_sequence_id) -- sequence 테이블과 연결
);
