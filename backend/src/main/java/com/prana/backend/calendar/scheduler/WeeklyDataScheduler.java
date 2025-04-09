package com.prana.backend.calendar.scheduler;

import com.prana.backend.calendar.service.WeeklyDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
@Slf4j
public class WeeklyDataScheduler {

    private final WeeklyDataService weeklyDataService;

    // 매주 월요일 00:00:00에 업데이트
    // 일요일 00:00:00 이상 ~ 다음주 일요일 00:00:00 미만 한주 데이터를 저장함
        @Scheduled(cron = "0 0 0 * * MON")
//  @Scheduled(cron = "0 */2 * * * *") // Todo:delete 테스트용 2분마다 업데이트
    public void batchWeeklyData() {
        LocalDateTime today = LocalDateTime.now();
        weeklyDataService.insertWeeklyData(today);
    }
}
