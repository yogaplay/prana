package com.prana.backend.sequence.repository;

import com.prana.backend.entity.Sequence;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SequenceRepository extends JpaRepository<Sequence, Integer> {

}
