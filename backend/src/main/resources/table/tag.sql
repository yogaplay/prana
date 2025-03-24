CREATE TABLE tag
(
    tag_id   INT AUTO_INCREMENT PRIMARY KEY, -- 자동 증가하는 고유 ID
    tag_name VARCHAR(255) NOT NULL,          -- 태그 이름 (필수 항목)
    tag_type VARCHAR(20)  NOT NULL           -- 태그 타입 (유파, 운동 부위, 시간, 난이도)
);