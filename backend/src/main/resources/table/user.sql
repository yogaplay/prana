CREATE TABLE user
(
    user_id     INT AUTO_INCREMENT PRIMARY KEY, -- 유니크한 user_id (자동 증가)
    nickname    VARCHAR(100) NOT NULL,          -- 사용자 닉네임 (최대 100자)
    height      SMALLINT,                       -- 키 (정수형, 예: 170)
    age         SMALLINT,                       -- 나이 (정수형, 예: 170))
    weight      SMALLINT,                       -- 몸무게 (정수형, 예: 65)
    gender      CHAR(1),                        -- 성별 (M, F)
    kakao_id    INT          NOT NULL,          -- 카카오 회원번호 LONG
    streak_days INT          NOT NULL,          -- 스트릭 몇일째 유지중인지

    CONSTRAINT chk_u_gender CHECK (gender IN ('M', 'F'))
);
