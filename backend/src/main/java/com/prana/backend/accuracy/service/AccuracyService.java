package com.prana.backend.accuracy.service;


import com.prana.backend.accuracy.controller.response.PositionAccuracy;
import com.prana.backend.accuracy.controller.response.TotalFeedback;
import com.prana.backend.accuracy.repository.AccuracyRepository;
import com.prana.backend.ai_feedback.repository.AiFeedbackRepository;
import com.prana.backend.calendar.controller.response.WeeklyReportResponseDTO;
import com.prana.backend.calendar.service.TagUtil;
import com.prana.backend.common.exception.user.UserNotFoundException;
import com.prana.backend.entity.*;
import com.prana.backend.feedback.repository.FeedbackRepository;
import com.prana.backend.sequence.repository.SequenceRepository;
import com.prana.backend.user.repository.UserRepository;
import com.prana.backend.yoga.repository.YogaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.swing.text.Position;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

    /**
     * 클라이언트가 동작 완료를 알리는 경우, Redis에 저장된 AiFeedback을 읽어 DB의 Accuracy 테이블에 저장
     */
    public boolean saveAccuracyToDb(Integer userSequenceId, Integer userId, Integer yogaId, Integer sequenceId) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        Yoga yoga = yogaRepository.findById(yogaId).orElse(null);
        Sequence sequence = sequenceRepository.findById(sequenceId).orElse(null);
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
                        .sequence(sequence)
                        .bodyPart(feed.getPosition())
                        .build();
                feedbackRepository.save(nextFeedback);
            }
            accuracyRepository.save(accuracy);

            aiFeedbackRepository.deleteById(userSequenceId);
            return true;
        }).orElse(false);
    }

    public TotalFeedback getTotalFeedback(Integer userSequenceId, Integer sequenceId, Integer userId) {
        Sequence sequence = sequenceRepository.findById(sequenceId).orElse(null);
        List<Feedback> feedback = feedbackRepository.findAllByUserIdAndYogaIdWithinTime(userId, sequenceId, sequence.getTime());

        List<TotalFeedback> totalFeedback = new ArrayList<>();
        List<PositionAccuracy> positionAccuracies = new ArrayList<>();
        Map<String, Integer> feedbackMap = new LinkedHashMap<>();

        /*
        ** feedback 4개 **
            등(back): 어깨
            팔(arm): 팔꿈치(좌우), 팔(좌우)
            다리(leg): 무릎(좌우), 다리(좌우)
            코어(core): 엉덩이(좌우)
         */
        for(Feedback f : feedback) {
            switch (f.getBodyPart()) {
                case "SHOULDER" -> feedbackMap.put("back", feedbackMap.getOrDefault("back", 0) + 1);
                case "ELBOW_LEFT", "ELBOW_RIGHT", "ARM_LEFT", "ARM_RIGHT" ->
                        feedbackMap.put("arm", feedbackMap.getOrDefault("arm", 0) + 1);
                case "HIP_LEFT", "HIP_RIGHT" -> feedbackMap.put("core", feedbackMap.getOrDefault("core", 0) + 1);
                default -> feedbackMap.put("leg", feedbackMap.getOrDefault("leg", 0) + 1);
            }
            Yoga yoga = f.getYoga();
            Accuracy accuracy = accuracyRepository.findByUserIdAndYogaIdAndSequenceId(userId, yoga.getYogaId(), sequenceId);
            positionAccuracies.add(new PositionAccuracy(yoga.getYogaId(), yoga.getYogaName(), yoga.getImage(), (int) 100*accuracy.getSuccess()/(accuracy.getSuccess()+accuracy.getFail())));
        }


        (Map<String, Integer> m : feedbackMap.entrySet()) {

        }

        /*
        ** recommend_sequences
            feedback 수 상위 2부위에 대한 sequence 3개씩 추천
         */
        List<String> feedbackTop = feedbackMap.entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .limit(1)
                .map(Map.Entry::getKey)
                .toList();

        String position1 =  TagUtil.ENG_TO_KOR.get(feedbackTop.get(0));

        // top2 태그별 추천 시퀀스 3개씩 추출
        List<Sequence> recommendSequence = sequenceRepository.findRandom3ByTagName(position1);
    }
}

