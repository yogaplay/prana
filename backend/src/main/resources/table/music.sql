CREATE TABLE music
(
    music_id       INT AUTO_INCREMENT PRIMARY KEY, -- 유니크한 yoga_id (자동 증가)
    music_location VARCHAR(255),                   -- 음악 URL 또는 경로
    name           VARCHAR(255)                    -- 음악 이름
);
