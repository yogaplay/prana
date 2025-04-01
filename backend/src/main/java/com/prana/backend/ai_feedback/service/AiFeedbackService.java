package com.prana.backend.ai_feedback.service;


import com.prana.backend.ai_feedback.repository.AiFeedbackRepository;
import com.prana.backend.entity.AiFeedback;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class AiFeedbackService {
    private final AiFeedbackRepository aiFeedbackRepository;

    public AiFeedback getAiFeedbackByUserSequenceId(Integer userSequenceId) {
        return aiFeedbackRepository.findById(userSequenceId).orElse(null);
    }

    public AiFeedback saveAiFeedback(AiFeedback feedback) {
        return aiFeedbackRepository.save(feedback);
    }
}

