package com.prana.backend.home.repository;

import com.prana.backend.entity.Star;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StarRepository extends JpaRepository<Star, Integer> {
    Optional<Star> findByUser_IdAndSequence_Id(Integer userId, Integer sequenceId);
}
