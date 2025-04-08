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
public class FinishResponse {
    private int sequenceId;
    private String sequenceName;
    private int yogaTime;
    private int sequenceCnt;
    private int totalAccuracy;
    private String bodyF;
    private String bodyS;
    private List<RecommendSequence> recommendSequenceF;
    private List<RecommendSequence> recommendSequenceS;
    private List<FeedbackResponse> totalFeedback;
    private List<AccuracyResponse> positionAccuracy;
}
