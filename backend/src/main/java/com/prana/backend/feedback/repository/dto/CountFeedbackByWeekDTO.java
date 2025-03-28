package com.prana.backend.feedback.repository.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class CountFeedbackByWeekDTO {
    private Integer userId;
    private String bodyPart;
    private Long count;
}
