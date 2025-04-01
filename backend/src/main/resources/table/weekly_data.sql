CREATE TABLE weekly_data
(
    weekly_data_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id                 INT NOT NULL,
    year                    INT NOT NULL,
    month                   INT NOT NULL,
    week                   INT NOT NULL,

    -- 주별 요가 시간 (5주)
    week1_yoga_time         INT NOT NULL DEFAULT 0,
    week2_yoga_time         INT NOT NULL DEFAULT 0,
    week3_yoga_time         INT NOT NULL DEFAULT 0,
    week4_yoga_time         INT NOT NULL DEFAULT 0,
    week5_yoga_time         INT NOT NULL DEFAULT 0,

    -- 주별 정확도 (5주)
    week1_accuracy          DECIMAL(4,1) NOT NULL DEFAULT 0.0,
    week2_accuracy          DECIMAL(4,1) NOT NULL DEFAULT 0.0,
    week3_accuracy          DECIMAL(4,1) NOT NULL DEFAULT 0.0,
    week4_accuracy          DECIMAL(4,1) NOT NULL DEFAULT 0.0,
    week5_accuracy          DECIMAL(4,1) NOT NULL DEFAULT 0.0,

    -- 피드백(부위별 횟수 or 점수)
    feedback_shoulder       INT NOT NULL DEFAULT 0,
    feedback_elbow_left     INT NOT NULL DEFAULT 0,
    feedback_elbow_right    INT NOT NULL DEFAULT 0,
    feedback_arm_left       INT NOT NULL DEFAULT 0,
    feedback_arm_right      INT NOT NULL DEFAULT 0,
    feedback_hip_left       INT NOT NULL DEFAULT 0,
    feedback_hip_right      INT NOT NULL DEFAULT 0,
    feedback_knee_left       INT NOT NULL DEFAULT 0,
    feedback_knee_right      INT NOT NULL DEFAULT 0,
    feedback_leg_left       INT NOT NULL DEFAULT 0,
    feedback_leg_right      INT NOT NULL DEFAULT 0,

    -- 주별 체질량 (5주)
    week1_bmi          DECIMAL(4,1) NOT NULL,
    week2_bmi          DECIMAL(4,1) NOT NULL,
    week3_bmi         DECIMAL(4,1) NOT NULL,
    week4_bmi         DECIMAL(4,1) NOT NULL,
    week5_bmi          DECIMAL(4,1) NOT NULL,

    created_date TIMESTAMP NOT NULL ,
    updated_date TIMESTAMP NOT NULL ,

    CONSTRAINT fk_wd_user FOREIGN KEY (user_id) REFERENCES user (user_id)
);