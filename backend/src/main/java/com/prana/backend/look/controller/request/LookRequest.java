package com.prana.backend.look.controller.request;

import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LookRequest {
    @Min(1)
    private Integer sampleSize;

    public Integer getSampleSize() {
        return sampleSize == null ? 3 : sampleSize;
    }
}
