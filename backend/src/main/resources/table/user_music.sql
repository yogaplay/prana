CREATE TABLE user_music
(
    user_music_id INT AUTO_INCREMENT PRIMARY KEY,                              -- 선택한 배경음악 ID (자동 증가)
    user_id       INT NOT NULL,                                                -- 사용자 ID (외래 키)
    music_id      INT NOT NULL,                                                -- 요가 배경음악 (왜리 키)
    CONSTRAINT fk_um_music FOREIGN KEY (music_id) REFERENCES music (music_id), -- 외래 키 (music 테이블)
    CONSTRAINT fk_um_user FOREIGN KEY (user_id) REFERENCES user (user_id)      -- 외래 키 (user 테이블)
);