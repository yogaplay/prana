package com.prana.backend.yoga_sequence.repository;

import com.prana.backend.entity.YogaSequence;
import com.prana.backend.yoga_sequence.controller.response.YogaSequenceResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface YogaSequenceRepository extends JpaRepository<YogaSequence, Integer> {

    @Query("SELECT new com.prana.backend.yoga_sequence.controller.response.YogaSequenceResponse(" +
            "y.yogaId, y.yogaName, y.video, y.image, y.description, y.time) " +
            "FROM YogaSequence ys " +
            "JOIN ys.yoga y " +
            "WHERE ys.sequence.id = :sequenceId " +
            "ORDER BY ys.orderIndex")
    List<YogaSequenceResponse> findYogaBySequenceIdOrderByOrder(@Param("sequenceId") Integer sequenceId);
}
