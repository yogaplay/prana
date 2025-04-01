package com.prana.backend.accuracy.controller.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class AccuracyRequest {
    private int userSequenceId;
    private Integer yogaId;
    private Integer sequenceId;
}
