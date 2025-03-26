package com.prana.backend.accuracy.service;


import com.prana.backend.accuracy.repository.AccuracyRepository;
import com.prana.backend.ai_feedback.repository.AiFeedbackRepository;
import com.prana.backend.common.exception.user.UserNotFoundException;
import com.prana.backend.entity.*;
import com.prana.backend.feedback.repository.FeedbackRepository;
import com.prana.backend.user.repository.UserRepository;
import com.prana.backend.yoga.repository.YogaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class AccuracyService {

    private final AiFeedbackRepository aiFeedbackRepository;
    private final AccuracyRepository accuracyRepository;
    private final UserRepository userRepository;
    private final YogaRepository yogaRepository;
    private final FeedbackRepository feedbackRepository;

    /**
     * 클라이언트가 동작 완료를 알리는 경우, Redis에 저장된 AiFeedback을 읽어 DB의 Accuracy 테이블에 저장
     */
    public boolean saveAccuracyToDb(Integer userSequenceId, Integer userId, Integer yogaId, Integer sequenceId) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        Yoga yoga = yogaRepository.findById(yogaId).orElse(null);
        return aiFeedbackRepository.findById(userSequenceId).map(feedback -> {
            Accuracy accuracy = Accuracy.builder()
                    .userId(userId)
                    .yogaId(yogaId)
                    .sequenceId(sequenceId)
                    .success(feedback.getSuccessCount())
                    .fail(feedback.getFailureCount())
                    .build();
            for(AiFeedback.FeedbackTotal feed : feedback.getFeedbackTotal()) {
                Feedback nextFeedback = Feedback.builder()
                        .user(user)
                        .yoga(yoga)
                        .bodyPart(feed.getPosition())
                        .build();
                feedbackRepository.save(nextFeedback);
            }
            accuracyRepository.save(accuracy);

            aiFeedbackRepository.deleteById(userSequenceId);
            return true;
        }).orElse(false);
    }
}

