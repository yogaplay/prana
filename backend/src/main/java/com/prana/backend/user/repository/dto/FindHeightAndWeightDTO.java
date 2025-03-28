package com.prana.backend.user.repository.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class FindHeightAndWeightDTO {
    private Integer userId;
    private Short height;
    private Short weight;
}
