package com.prana.backend.sequence_yoga.repository;

import com.prana.backend.entity.SequenceYoga;
import com.prana.backend.yoga_sequence.controller.response.AccuracyResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface SequenceYogaRepository extends JpaRepository<SequenceYoga, Integer> {
    List<SequenceYoga> findByUserSequence_Id(Integer userSequenceId);

//    @Query("SELECT new com.prana.backend.yoga_sequence.controller.response.AccuracyResponse(" +
//            "sy.sequenceYogaId, sy.yogaName, sy.yogaImage, sy.accuracy) " +
//            "FROM SequenceYoga sy " +
//            "WHERE sy.userSequence.id = :userSequenceId")
//    List<AccuracyResponse> findAccuracyByUserSequenceId(@Param("userSequenceId") Integer userSequenceId);
}
