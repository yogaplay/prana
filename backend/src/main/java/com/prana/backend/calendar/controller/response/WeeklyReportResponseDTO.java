package com.prana.backend.calendar.controller.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
@AllArgsConstructor
public class WeeklyReportResponseDTO {
    private List<Feedback> feedbacks;
    private List<RecommendSequences> recommendSequences;
    private WeeklyData week1;
    private WeeklyData week2;
    private WeeklyData week3;
    private WeeklyData week4;
    private WeeklyData week5;

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
        // 상위 부위 3개. 모자르다면 그이하라도 담아서 줌
        private List<Sequence> sequences;
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
    public static class WeeklyData {
        private int month;
        private int week;
        private int time;
        private int accuracy;
        // todo: 체질량 논의필요
    }
}
