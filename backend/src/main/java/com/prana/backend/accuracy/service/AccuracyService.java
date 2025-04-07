package com.prana.backend.accuracy.service;


import com.prana.backend.accuracy.repository.AccuracyRepository;
import com.prana.backend.ai_feedback.repository.AiFeedbackRepository;
import com.prana.backend.common.exception.user.UserNotFoundException;
import com.prana.backend.entity.*;
import com.prana.backend.feedback.repository.FeedbackRepository;
import com.prana.backend.sequence.repository.SequenceRepository;
import com.prana.backend.sequence_body.repository.SequenceBodyRepository;
import com.prana.backend.sequence_yoga.repository.SequenceYogaRepository;
import com.prana.backend.user.repository.UserRepository;
import com.prana.backend.user_sequence.repository.UserSequenceRepository;
import com.prana.backend.yoga.repository.YogaRepository;
import com.prana.backend.yoga_feedback.repository.YogaFeedbackRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class AccuracyService {

    private final AiFeedbackRepository aiFeedbackRepository;
    private final AccuracyRepository accuracyRepository;
    private final UserRepository userRepository;
    private final YogaRepository yogaRepository;
    private final FeedbackRepository feedbackRepository;
    private final SequenceRepository sequenceRepository;
    private final SequenceYogaRepository sequenceYogaRepository;
    private final SequenceBodyRepository sequenceBodyRepository;
    private final UserSequenceRepository userSequenceRepository;
    private final YogaFeedbackRepository yogaFeedbackRepository;

    /**
     * 클라이언트가 동작 완료를 알리는 경우, Redis에 저장된 AiFeedback을 읽어 DB의 Accuracy 테이블에 저장
     */
    public boolean saveAccuracyToDb(Integer userSequenceId, Integer userId, Integer yogaId, Integer sequenceId) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        Yoga yoga = yogaRepository.findById(yogaId).orElse(null);
        Sequence sequence = sequenceRepository.findById(sequenceId).orElse(null);
        UserSequence userSequence = userSequenceRepository.findById(userSequenceId).orElse(null);

        return aiFeedbackRepository.findById(userSequenceId).map(feedback -> {
            Accuracy accuracy = Accuracy.builder()
                    .userId(userId)
                    .yogaId(yogaId)
                    .sequenceId(sequenceId)
                    .success(feedback.getSuccessCount())
                    .fail(feedback.getFailureCount())
                    .score(feedback.getFeedbackSum())
                    .build();
            accuracyRepository.save(accuracy);

            int accuracyScore = 0;
            if(feedback.getSuccessCount() != 0 || feedback.getFailureCount() != 0) {
                accuracyScore = (feedback.getSuccessCount() * 100 / (feedback.getFailureCount() + feedback.getSuccessCount()));
            }

            SequenceYoga sequenceYoga = SequenceYoga.builder()
                    .userSequence(userSequence)
                    .yogaName(yoga.getYogaName())
                    .yogaImage(yoga.getImage())
                    .accuracy(accuracyScore)
                    .build();
            sequenceYogaRepository.save(sequenceYoga);

            List<AiFeedback.FeedbackTotal> feedbackTotals = feedback.getFeedbackTotal();
            if (feedbackTotals == null) {
                feedbackTotals = new ArrayList<>();
            }

            for(AiFeedback.FeedbackTotal feed : feedbackTotals) {
                if(!StringUtils.hasText(feed.getPosition())) continue;
                Feedback nextFeedback = Feedback.builder()
                        .user(user)
                        .yoga(yoga)
                        .sequence(sequence)
                        .bodyPart(feed.getPosition())
                        .build();
                feedbackRepository.save(nextFeedback);

                Optional<SequenceBody> sequenceBody = sequenceBodyRepository.findByUserSequence_IdAndBodyPart(userSequenceId, feed.getPosition());
                if (sequenceBody.isPresent()) {
                    SequenceBody sequenceBody1 = sequenceBody.get();
                    sequenceBody1.setFeedbackCnt(sequenceBody1.getFeedbackCnt() + 1);
                    sequenceBodyRepository.save(sequenceBody1);
                } else {
                    SequenceBody newSequenceBody = SequenceBody.builder()
                            .userSequence(userSequence)
                            .bodyPart(feed.getPosition())
                            .feedbackCnt(1)
                            .build();
                    sequenceBodyRepository.save(newSequenceBody);
                }

                Optional<YogaFeedback> yogaFeedback = yogaFeedbackRepository.findBySequenceYoga_SequenceYogaIdAndBodyPart(sequenceYoga.getSequenceYogaId(), feed.getPosition());
                if (yogaFeedback.isPresent()) {
                    YogaFeedback yogaFeedback1 = yogaFeedback.get();
                    yogaFeedback1.setFeedbackCnt(yogaFeedback1.getFeedbackCnt() + 1);
                    yogaFeedbackRepository.save(yogaFeedback1);
                } else {
                    YogaFeedback newYogaFeedback = YogaFeedback.builder()
                            .sequenceYoga(sequenceYoga)
                            .bodyPart(feed.getPosition())
                            .feedbackCnt(1)
                            .build();
                    yogaFeedbackRepository.save(newYogaFeedback);
                }
            }

            aiFeedbackRepository.deleteById(userSequenceId);
            return true;
        }).orElse(false);
    }
}

