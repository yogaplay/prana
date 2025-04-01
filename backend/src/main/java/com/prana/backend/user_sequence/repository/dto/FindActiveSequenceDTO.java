package com.prana.backend.user_sequence.repository.dto;

import lombok.*;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Setter
public class FindActiveSequenceDTO {
    private int userId;
    private int sequenceId;
    private int lastPoint;
    private int sequenceTime;
    private int yogaCnt;
}
