package com.prana.backend.yoga_sequence.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@NoArgsConstructor
@AllArgsConstructor
public class YogaSequenceResponse {
    private int yogaId;
    private String yogaName;
    private String video;
    private String image;
    private String description;
    private Integer yogaTime;
}
