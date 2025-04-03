CREATE TABLE yoga
(
    yoga_id       INT AUTO_INCREMENT PRIMARY KEY, -- 유니크한 yoga_id (자동 증가)
    yoga_name     VARCHAR(255) NOT NULL,          -- yoga 이름
    video         VARCHAR(255) NOT NULL,          -- 영상 URL 또는 경로
    description   TEXT,                           -- 설명 (자세한 설명을 담기 위해 TEXT 사용)
    solution_pose TEXT         NOT NULL,          -- 해결책 (자세한 해결책을 담기 위해 TEXT 사용)
    image         VARCHAR(255) NOT NULL,          -- yoga 이미지
    yoga_time     INT,                            -- 요가 소요시간 (초 단위)
    std           TEXT,                           -- 요가 별 표준편차
);
