package com.prana.backend.home.controller.request;

import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PagedStarRequest {
    @Min(0)
    private int page = 0;

    @Min(1)
    private int size = 10;
}
