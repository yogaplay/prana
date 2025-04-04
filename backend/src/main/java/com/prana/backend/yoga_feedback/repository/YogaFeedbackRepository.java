package com.prana.backend.yoga_feedback.repository;

import com.prana.backend.entity.YogaFeedback;
import com.prana.backend.yoga_sequence.controller.response.YogaFeedbackResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface YogaFeedbackRepository extends JpaRepository<YogaFeedback, Integer> {

    @Query("select new com.prana.backend.yoga_sequence.controller.response.YogaFeedbackResponse(y.bodyPart, y.feedbackCnt) " +
            "from YogaFeedback y " +
            "where y.sequenceYoga.sequenceYogaId = :sequenceYogaId")
    List<YogaFeedbackResponse> findFeedbackBySequenceYogaId(@Param("sequenceYogaId") Integer sequenceYogaId);
}
