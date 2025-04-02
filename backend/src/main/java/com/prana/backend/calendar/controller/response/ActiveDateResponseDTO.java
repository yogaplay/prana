package com.prana.backend.calendar.controller.response;

import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Getter
@Builder
@AllArgsConstructor
public class ActiveDateResponseDTO {
    private List<LocalDate> activeDates;
}
