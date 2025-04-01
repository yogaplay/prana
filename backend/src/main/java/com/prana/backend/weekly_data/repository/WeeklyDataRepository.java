package com.prana.backend.weekly_data.repository;

import com.prana.backend.entity.WeeklyData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface WeeklyDataRepository extends JpaRepository<WeeklyData, Long> {
    Optional<WeeklyData> findWeeklyDataByUserIdAndYearAndMonthAndWeek(int userId, int year, int month, int week);

    @Query("""
    SELECT wd
    FROM WeeklyData wd
    WHERE wd.year = :year AND wd.month = :month AND wd.week = :week
    AND wd.user.id IN :userIds
""")
    List<WeeklyData> findAllByYearMonthWeekAndUserIdIn(
            @Param("year") int year,
            @Param("month") int month,
            @Param("week") int week,
            @Param("userIds") List<Integer> userIds
    );
}
