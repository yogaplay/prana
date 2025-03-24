package com.prana.backend.yogaSequence.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@AllArgsConstructor
@NoArgsConstructor
public class YogaSequenceResponse {
    private int yogaId;
    private String yogaName;
    private String video;
    private String image;
    private String scription;
}
