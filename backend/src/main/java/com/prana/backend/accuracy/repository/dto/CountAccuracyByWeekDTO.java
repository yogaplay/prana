package com.prana.backend.accuracy.repository.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class CountAccuracyByWeekDTO {
    private Integer userId;
    private Integer sequenceId;
    private Long success;
    private Long fail;
}
