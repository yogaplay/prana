package com.prana.backend.accuracy.repository;

import com.prana.backend.entity.Accuracy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AccuracyRepository extends JpaRepository<Accuracy, Integer> {
}

