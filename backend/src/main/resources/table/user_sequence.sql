CREATE TABLE user_sequence
(
    user_sequence_id INT AUTO_INCREMENT PRIMARY KEY,                                       -- 자동 증가하는 고유 ID
    user_id          INT                  NOT NULL,                                        -- 사용자 ID (user 테이블의 외래 키)
    sequence_id      INT                  NOT NULL,                                        -- 시퀀스 ID (sequence 테이블의 외래 키)
    result_status    char(1)  DEFAULT 'N' NOT NULL,                                        -- 시퀀스 수행 결과 상태
    last_point       SMALLINT DEFAULT 0   NOT NULL,                                        -- 총 요가 개수 중 진행한 포인트 (최대 yoga_cnt)
    created_date     DATE                 NOT NULL,                                        -- 레코드 생성 날짜 (기본값은 오늘 날짜)
    updated_at       timestamp            NOT NULL,                                        -- 레코드 수정 일시
    CONSTRAINT fk_us_user FOREIGN KEY (user_id) REFERENCES user (user_id),                 -- user 테이블과 연결
    CONSTRAINT fk_us_sequence FOREIGN KEY (sequence_id) REFERENCES sequence (sequence_id), -- sequence 테이블과 연결
    CONSTRAINT chk_us_result_status CHECK (result_status IN ('Y', 'N'))
);
