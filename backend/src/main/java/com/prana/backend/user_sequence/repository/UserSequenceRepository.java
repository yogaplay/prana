package com.prana.backend.user_sequence.repository;

import com.prana.backend.entity.UserSequence;
import com.prana.backend.user_sequence.repository.dto.DailySequenceRepositoryDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface UserSequenceRepository extends JpaRepository<UserSequence, Integer> {

    @Query(value = "SELECT EXISTS(SELECT 1 FROM user_sequence WHERE DATE(updated_at) = CURDATE() - INTERVAL 1 DAY)", nativeQuery = true)
    boolean existsYesterdayUserSequence();

    @Query(value = "SELECT EXISTS(SELECT 1 FROM user_sequence WHERE DATE(updated_at) = CURDATE())", nativeQuery = true)
    boolean existsTodayUserSequence();

    @Query("SELECT new com.prana.backend.user_sequence.repository.dto.DailySequenceRepositoryDTO("
            + "us.id, s.name, CONCAT(us.resultStatus, ''), us.lastPoint, s.image, s.yogaCount) "
            + "FROM UserSequence us "
            + "JOIN us.sequence s "
            + "WHERE us.user.id = :userId "
            + "AND function('date', us.updatedAt) = :date "
            + "AND us.updatedAt = ("
            + "SELECT MAX(sub.updatedAt) FROM UserSequence sub "
            + "    WHERE sub.user.id = us.user.id "
            + "    AND sub.sequence.id = us.sequence.id "
            + "    AND function('date', sub.updatedAt) = :date"
            + ") "
    )
    List<DailySequenceRepositoryDTO> findByUserIdAndUpdatedAtDate(@Param("userId") int userId, @Param("date") LocalDate date);
}
