package com.prana.backend.weekly_data.repository;

import com.prana.backend.entity.WeeklyData;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WeeklyDataReposiory extends JpaRepository<WeeklyData, Long> {
    WeeklyData findWeeklyDataByUserIdAndYearAndMonthAndWeek(int userId, int year, int month, int week);
}
