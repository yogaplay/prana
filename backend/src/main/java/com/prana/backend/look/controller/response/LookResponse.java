package com.prana.backend.look.controller.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LookResponse {
    private int tagId;
    private String tagName;
    private String tagType;
    List<LookSampleResponse> sampleList;
}
