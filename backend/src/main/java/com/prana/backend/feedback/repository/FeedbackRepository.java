package com.prana.backend.feedback.repository;

import com.prana.backend.entity.Feedback;
import com.prana.backend.feedback.repository.dto.CountFeedbackByWeekDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface FeedbackRepository extends JpaRepository<Feedback, Integer> {

    // 모든 user에 대해 bodyPart 종류별로 feedback 합 조회
    @Query("""
        SELECT new com.prana.backend.feedback.repository.dto.CountFeedbackByWeekDTO(
        f.user.id, f.bodyPart, COUNT(f))
        FROM Feedback f
        WHERE f.createdAt >= :start AND f.createdAt < :end
        GROUP BY f.user.id, f.bodyPart
"""
    )
    List<CountFeedbackByWeekDTO> countFeedbackByWeek(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}
