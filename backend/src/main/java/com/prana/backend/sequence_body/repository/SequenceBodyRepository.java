package com.prana.backend.sequence_body.repository;

import com.prana.backend.entity.SequenceBody;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SequenceBodyRepository extends JpaRepository<SequenceBody, Integer> {
    Optional<SequenceBody> findByUserSequence_Id(Integer userSequenceId);
}
