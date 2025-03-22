CREATE TABLE star
(
    star_id     INT AUTO_INCREMENT PRIMARY KEY,                                           -- 자동 증가하는 고유 ID
    user_id     INT NOT NULL,                                                             -- 사용자 ID (외래 키)
    sequence_id INT NOT NULL,                                                             -- 시퀀스의 ID (sequence 테이블의 외래 키)
    CONSTRAINT fk_s_user FOREIGN KEY (user_id) REFERENCES user (user_id),                 -- 외래 키 (user 테이블)
    CONSTRAINT fk_s_sequence FOREIGN KEY (sequence_id) REFERENCES sequence (sequence_id), -- sequence 테이블과 연결
    CONSTRAINT uk_s_user_sequence UNIQUE (user_id, sequence_id)                           -- 동일한 user_id sequence_id의 조합은 중복되지 않도록 제약
);
