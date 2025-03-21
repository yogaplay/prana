package com.prana.backend.userSequence.repository;

import com.prana.backend.userSequence.UserSequence;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserSequenceRepository extends JpaRepository<UserSequence, Integer> {
}
