package com.prana.backend.accuracy.controller.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Builder
public class AccuracyResponse {
    private int sequenceId;
    private String sequenceName;
    private int yogaTime;
    private int totalAccuracy;

    private List<TotalFeedback> totalFeedbacks;
    private List<RecommendSequence> recommendSequences;
    private List<PositionAccuracy> positionAccuracies;
}
