package com.prana.backend.accuracy.controller.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RecommendSequence {
    private int sequenceId;
    private String sequenceName;
    private int sequenceTime;
    private String sequenceImage;
}
