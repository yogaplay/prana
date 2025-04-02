package com.prana.backend.sequence_body.repository;

import com.prana.backend.entity.SequenceBody;
import com.prana.backend.yoga_sequence.controller.response.FeedbackResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface SequenceBodyRepository extends JpaRepository<SequenceBody, Integer> {
    Optional<SequenceBody> findByUserSequence_Id(Integer userSequenceId);
    Optional<SequenceBody> findByUserSequence_IdAndBodyPart(Integer userSequenceId, String bodyPart);

    @Query("SELECT new com.prana.backend.yoga_sequence.controller.response.FeedbackResponse(sb.bodyPart, sb.feedbackCnt) " +
            "FROM SequenceBody sb " +
            "WHERE sb.userSequence.id = :userSequenceId")
    List<FeedbackResponse> findFeedbackByUserSequenceId(@Param("userSequenceId") Integer userSequenceId);

    @Query("SELECT " +
            "CASE " +
            "  WHEN sb.bodyPart = 'SHOULDER' THEN 'back' " +
            "  WHEN sb.bodyPart IN ('ELBOW_LEFT', 'ELBOW_RIGHT', 'ARM_LEFT', 'ARM_RIGHT') THEN 'arm' " +
            "  WHEN sb.bodyPart IN ('KNEE_LEFT', 'KNEE_RIGHT', 'LEG_LEFT', 'LEG_RIGHT') THEN 'leg' " +
            "  WHEN sb.bodyPart IN ('HIP_LEFT', 'HIP_RIGHT') THEN 'core' " +
            "END as groupName, SUM(sb.feedbackCnt) as totalFeedback " +
            "FROM SequenceBody sb " +
            "WHERE sb.userSequence.id = :userSequenceId " +
            "GROUP BY groupName " +
            "ORDER BY totalFeedback DESC")
    List<Object[]> aggregateFeedbackByGroup(@Param("userSequenceId") Integer userSequenceId);


}
