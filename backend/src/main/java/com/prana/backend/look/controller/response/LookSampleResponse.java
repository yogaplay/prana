package com.prana.backend.look.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LookSampleResponse {
    private int sequenceId;
    private String sequenceName;
    private int sequenceTime;
    private String sequenceImage;
}
