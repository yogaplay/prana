package com.prana.backend.yoga_sequence.controller.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AccuracyResponse {
    private String yogaName;
    private String image;
    private int accuracy;
    private List<YogaFeedbackResponse> feedback;
}
