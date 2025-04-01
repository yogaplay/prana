package com.prana.backend.calendar.controller;

import com.prana.backend.calendar.controller.response.DailySequenceResponseDTO;
import com.prana.backend.calendar.controller.response.WeeklyReportResponseDTO;
import com.prana.backend.calendar.service.CalendarService;
import com.prana.backend.common.PranaPrincipal;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/calendar")
@AllArgsConstructor
public class CalendarController {
    private final CalendarService calendarService;

    @GetMapping("/daily-sequence/{date}")
    public ResponseEntity<List<DailySequenceResponseDTO>> getDailySequence(@PathVariable("date") LocalDate date, @AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        int userId = pranaPrincipal.getUserId();
        List<DailySequenceResponseDTO> result = calendarService.getDailySequence(date, userId);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/weekly-report/{date}")
    public ResponseEntity<WeeklyReportResponseDTO> getWeeklyReport(@PathVariable("date") LocalDate date,
                                                                   @AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        int userId = pranaPrincipal.getUserId();
        WeeklyReportResponseDTO result = calendarService.getWeeklyReport(userId, date);

        return ResponseEntity.ok(result);
    }
}
