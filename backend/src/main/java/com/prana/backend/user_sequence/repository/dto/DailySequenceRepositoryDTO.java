package com.prana.backend.user_sequence.repository.dto;

import lombok.*;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Setter
// Calendar dailySequence 결과 추출을 위한 dto
public class DailySequenceRepositoryDTO {
    private int userSequenceId;
    private String sequenceName;
    private String resultStatus;
    private int lastPoint;
    private String image;
    private int yogaCount;
}
