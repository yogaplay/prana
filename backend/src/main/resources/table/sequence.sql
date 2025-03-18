CREATE TABLE sequence
(
    sequence_id   INT AUTO_INCREMENT PRIMARY KEY, -- 자동 증가하는 고유 ID
    sequence_name VARCHAR(255) NOT NULL,          -- 시퀀스의 이름 (필수 항목)
    sequence_time INT          NOT NULL,          -- 시퀀스 소요시간 (초 단위)
    yoga_cnt      SMALLINT     NOT NULL,          -- 시퀀스 요가 개수
    description   TEXT         NOT NULL           -- 시퀀스에 대한 설명
);
