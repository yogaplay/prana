CREATE TABLE tag
(
    tag_id   INT AUTO_INCREMENT PRIMARY KEY, -- 자동 증가하는 고유 ID
    tag_name VARCHAR(255) NOT NULL           -- 태그 이름 (필수 항목)
);


INSERT INTO tag (tag_name)
VALUES ('중급');