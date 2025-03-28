package com.prana.backend.accuracy.controller.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PositionAccuracy {
    private int yogaId;
    private String yogaName;
    private String YogaImage;
    private int accuracy;
}
