package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name="weekly_data")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class WeeklyData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="weekly_data_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private int year;

    @Column(nullable = false)
    private int month;

    @Column(nullable = false)
    private int week;

    // 주별 요가 시간 (5주)
    @Column(name = "week1_yoga_time", nullable = false)
    private int week1YogaTime;

    @Column(name = "week2_yoga_time", nullable = false)
    private int week2YogaTime;

    @Column(name = "week3_yoga_time", nullable = false)
    private int week3YogaTime;

    @Column(name = "week4_yoga_time", nullable = false)
    private int week4YogaTime;

    @Column(name = "week5_yoga_time", nullable = false)
    private int week5YogaTime;

    // 주별 정확도 (DECIMAL(4,1))
    @Column(name = "week1_score", nullable = false)
    private Double week1Score;

    @Column(name = "week2_score", nullable = false)
    private Double week2Score;

    @Column(name = "week3_score", nullable = false)
    private Double week3Score;

    @Column(name = "week4_score", nullable = false)
    private Double week4Score;

    @Column(name = "week5_score", nullable = false)
    private Double week5Score;

    // 피드백 (부위별)
    @Column(name = "feedback_shoulder", nullable = false)
    private int feedbackShoulder;

    @Column(name = "feedback_elbow_left", nullable = false)
    private int feedbackElbowLeft;

    @Column(name = "feedback_elbow_right", nullable = false)
    private int feedbackElbowRight;

    @Column(name = "feedback_arm_left", nullable = false)
    private int feedbackArmLeft;

    @Column(name = "feedback_arm_right", nullable = false)
    private int feedbackArmRight;

    @Column(name = "feedback_hip_left", nullable = false)
    private int feedbackHipLeft;

    @Column(name = "feedback_hip_right", nullable = false)
    private int feedbackHipRight;

    @Column(name = "feedback_knee_left", nullable = false)
    private int feedbackKneeLeft;

    @Column(name = "feedback_knee_right", nullable = false)
    private int feedbackKneeRight;

    @Column(name = "feedback_leg_left", nullable = false)
    private int feedbackLegLeft;

    @Column(name = "feedback_leg_right", nullable = false)
    private int feedbackLegRight;

    // 주별 체질량 (DECIMAL(4,1))
    @Column(name = "week1_bmi", nullable = false)
    private Double week1Bmi;

    @Column(name = "week2_bmi", nullable = false)
    private Double week2Bmi;

    @Column(name = "week3_bmi", nullable = false)
    private Double week3Bmi;

    @Column(name = "week4_bmi", nullable = false)
    private Double week4Bmi;

    @Column(name = "week5_bmi", nullable = false)
    private Double week5Bmi;

    // 생성일 및 수정일
    @CreationTimestamp
    @Column(name = "created_date", nullable = false)
    private LocalDateTime createdDate;

    @UpdateTimestamp
    @Column(name = "updated_date", nullable = false)
    private LocalDateTime updatedDate;
}
