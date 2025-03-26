package com.prana.backend.calendar.controller.response;

import lombok.*;

@Getter
@Builder
@AllArgsConstructor
public class DailySequenceResponseDTO {
    private int userSequenceId;
    private String sequenceName;
    private String resultStatus;
    private int percent;
    private String image;
}
