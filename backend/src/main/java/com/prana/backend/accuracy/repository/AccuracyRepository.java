package com.prana.backend.accuracy.repository;

import com.prana.backend.accuracy.repository.dto.CountAccuracyByWeekDTO;
import com.prana.backend.entity.Accuracy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AccuracyRepository extends JpaRepository<Accuracy, Integer> {

    @Query("""
            SELECT new com.prana.backend.accuracy.repository.dto.CountAccuracyByWeekDTO(
                a.userId, a.sequenceId, SUM(a.success), SUM(a.fail))
            FROM Accuracy a
            WHERE a.createdAt >= :start AND a.createdAt < :end
            GROUP BY a.userId, a.sequenceId
    """
    )
    List<CountAccuracyByWeekDTO> countAccuracyByWeek(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}

