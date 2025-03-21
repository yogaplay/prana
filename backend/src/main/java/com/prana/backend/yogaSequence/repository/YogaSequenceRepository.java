package com.prana.backend.yogaSequence.repository;

import com.prana.backend.yogaSequence.YogaSequence;
import com.prana.backend.yogaSequence.controller.response.YogaSequenceResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface YogaSequenceRepository extends JpaRepository<YogaSequence, Long> {

    @Query("SELECT new com.prana.backend.yogaSequence.controller.response.YogaSequenceResponse(" +
            "y.yogaId, y.yogaName, y.video, y.description) " +
            "FROM YogaSequence ys " +
            "JOIN ys.yoga y " +
            "WHERE ys.sequence.sequenceId = :sequenceId " +
            "ORDER BY ys.orderIndex")
    List<YogaSequenceResponse> findYogaBySequenceIdOrderByOrder(@Param("sequenceId") Integer sequenceId);
}
