CREATE TABLE sequence_yoga
(
    sequence_yoga_id     INT AUTO_INCREMENT PRIMARY KEY,                                                 -- 자동 증가하는 고유 ID
    user_sequence_id     INT NOT NULL,                                                                   -- 시퀀스의 ID (sequence 테이블의 외래 키)
    yoga_name            VARCHAR(20) NOT NULL,
    accuracy             INT NOT NULL,
    yoga_image                VARCHAR(255) NOT NULL,
    CONSTRAINT fk_ss_sequence FOREIGN KEY (user_sequence_id) REFERENCES user_sequence (user_sequence_id) -- sequence 테이블과 연결
);
