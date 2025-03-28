package com.prana.backend.calendar.controller.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Builder
@AllArgsConstructor
public class WeeklyReportResponseDTO {
    private List<Feedback> feedbacks; // length=4
    private List<RecommendSequences> recommendSequences; // length=2
    private Week week1;
    private Week week2;
    private Week week3;
    private Week week4;
    private Week week5;

    @Getter
    @Builder
    @AllArgsConstructor
    public static class Feedback {
        private String position;
        private int count;
    }

    @Getter
    @Builder
    @AllArgsConstructor
    public static class RecommendSequences {
        private String position;
        // 상위 부위 2개
        private List<Sequence> sequences;  // length=3
    }

    @Getter
    @Builder
    @AllArgsConstructor
    public static class Sequence {
        private int sequenceId;
        private String sequenceName;
        private int sequenceTime;
        private String image;
    }

    @Getter
    @Builder
    @AllArgsConstructor
    public static class Week {
        private int year;
        private int month;
        private int week;
        private int time;
        private double accuracy;
        private double bmi;

    }
}
