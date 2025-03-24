package com.prana.backend.yoga_sequence.controller.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SequenceResponse {
    private int sequenceId;
    private String sequenceName;
    private String description;
    private int time;
    private int yogaCnt;
    List<YogaSequenceResponse> yogaSequence;
}
