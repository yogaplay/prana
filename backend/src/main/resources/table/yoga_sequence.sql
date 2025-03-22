CREATE TABLE yoga_sequence
(
    yoga_sequence_id INT AUTO_INCREMENT PRIMARY KEY,                                   -- 자동 증가하는 고유 ID
    yoga_id          INT NOT NULL,                                                     -- 요가의 ID (yoga 테이블의 외래 키)
    sequence_id      INT NOT NULL,                                                     -- 시퀀스의 ID (sequence 테이블의 외래 키)
    `order`          INT NOT NULL,                                                     -- 시퀀스의 순서
    CONSTRAINT fk_ys_yoga FOREIGN KEY (yoga_id) REFERENCES yoga (yoga_id),                -- yoga 테이블과 연결
    CONSTRAINT fk_ys_sequence FOREIGN KEY (sequence_id) REFERENCES sequence (sequence_id) -- sequence 테이블과 연결
);
