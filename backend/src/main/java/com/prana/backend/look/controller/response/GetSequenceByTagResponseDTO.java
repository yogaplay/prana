package com.prana.backend.look.controller.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
@AllArgsConstructor
public class GetSequenceByTagResponseDTO {
    private List<Sequence> sequences;

    @Getter
    @Builder
    @AllArgsConstructor
    public static class Sequence {
        private int sequenceId;
        private String sequenceName;
        private List<String> tags;
        private String image;
    }
}
