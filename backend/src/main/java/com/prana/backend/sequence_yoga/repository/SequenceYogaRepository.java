package com.prana.backend.sequence_yoga.repository;

import com.prana.backend.entity.SequenceBody;
import com.prana.backend.entity.SequenceYoga;
import com.prana.backend.entity.UserSequence;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SequenceYogaRepository extends JpaRepository<SequenceYoga, Integer> {
    Optional<SequenceYoga> findByUserSequence_Id(Integer userSequenceId);
}
