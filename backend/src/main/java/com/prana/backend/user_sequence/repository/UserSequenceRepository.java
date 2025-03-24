package com.prana.backend.user_sequence.repository;

import com.prana.backend.entity.UserSequence;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserSequenceRepository extends JpaRepository<UserSequence, Integer> {
}
