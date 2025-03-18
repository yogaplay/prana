CREATE TABLE user
(
    user_id  INT AUTO_INCREMENT PRIMARY KEY, -- 유니크한 user_id (자동 증가)
    nickname VARCHAR(100) NOT NULL,          -- 사용자 닉네임 (최대 100자)
    email    VARCHAR(255) NOT NULL UNIQUE,   -- 이메일 (유니크, 최대 255자)
    height   SMALLINT,                       -- 키 (정수형, 예: 170)
    age      SMALLINT,                       -- 나이 (정수형, 예: 170))
    weight   SMALLINT,                       -- 몸무게 (정수형, 예: 65)
    gender   CHAR(1),                        -- 성별 (M, F)

    CONSTRAINT chk_gender CHECK (gender IN ('M', 'F'))
);


INSERT INTO user (nickname, email, height, age, weight, gender)
VALUES ('임혁', 'cs.javah@kakao.com', 178, 27, 73, 'M');
