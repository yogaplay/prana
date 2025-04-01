package com.prana.backend.home.controller.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportResponse {

    private int userId;
    private String nickname;
    private int streakDays;
    private int totalTime;
    private long totalYogaCnt;

}
