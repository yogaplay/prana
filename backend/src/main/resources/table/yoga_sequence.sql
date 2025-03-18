CREATE TABLE yoga_sequence
(
    yoga_sequence_id INT AUTO_INCREMENT PRIMARY KEY,                                    -- 자동 증가하는 고유 ID
    yoga_id          INT NOT NULL,                                                      -- 요가의 ID (yoga 테이블의 외래 키)
    sequence_id      INT NOT NULL,                                                      -- 시퀀스의 ID (sequence 테이블의 외래 키)
    CONSTRAINT fk_yoga FOREIGN KEY (yoga_id) REFERENCES yoga (yoga_id),                 -- yoga 테이블과 연결
    CONSTRAINT fk_sequence FOREIGN KEY (sequence_id) REFERENCES sequence (sequence_id), -- sequence 테이블과 연결
    CONSTRAINT uk_yoga_sequence UNIQUE (yoga_id, sequence_id)                           -- 동일한 yoga_id와 sequence_id의 조합은 중복되지 않도록 제약
);
