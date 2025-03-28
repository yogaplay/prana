package com.prana.backend.accuracy.controller.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TotalFeedback {
    private String position;
    private int feedbackCnt;
}
