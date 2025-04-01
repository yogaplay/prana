CREATE TABLE sequence_tag
(
    sequence_tag_id INT AUTO_INCREMENT PRIMARY KEY,                                     -- 자동 증가하는 고유 ID
    sequence_id     INT NOT NULL,                                                       -- 시퀀스의 ID (sequence 테이블의 외래 키)
    tag_id          INT NOT NULL,                                                       -- 태그의 ID (tag 테이블의 외래 키)
    CONSTRAINT fk_st_sequence FOREIGN KEY (sequence_id) REFERENCES sequence (sequence_id), -- sequence 테이블과 연결
    CONSTRAINT fk_st_tag FOREIGN KEY (tag_id) REFERENCES tag (tag_id),                     -- tag 테이블과 연결
    CONSTRAINT uk_st_sequence_tag UNIQUE (tag_id, sequence_id)                             -- 동일한 tag_id와 sequence_id의 조합은 중복되지 않도록 제약
);
