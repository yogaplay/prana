package com.prana.backend.ai_feedback.repository;

import com.prana.backend.entity.AiFeedback;
import org.springframework.data.repository.CrudRepository;

public interface AiFeedbackRepository extends CrudRepository<AiFeedback, Integer> {
}
