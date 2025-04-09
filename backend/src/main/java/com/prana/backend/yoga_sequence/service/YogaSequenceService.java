package com.prana.backend.yoga_sequence.service;

import com.prana.backend.calendar.service.TagUtil;
import com.prana.backend.common.exception.sequence.SequenceNotFoundException;
import com.prana.backend.common.exception.user.UserNotFoundException;
import com.prana.backend.entity.*;
import com.prana.backend.home.repository.StarRepository;
import com.prana.backend.user_music.repository.JpaUserMusicRepository;
import com.prana.backend.sequence.repository.SequenceRepository;
import com.prana.backend.sequence_body.repository.SequenceBodyRepository;
import com.prana.backend.sequence_yoga.repository.SequenceYogaRepository;
import com.prana.backend.user.repository.UserRepository;
import com.prana.backend.user_sequence.repository.UserSequenceRepository;
import com.prana.backend.yoga_feedback.repository.YogaFeedbackRepository;
import com.prana.backend.yoga_sequence.controller.response.*;
import com.prana.backend.yoga_sequence.repository.YogaSequenceRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class YogaSequenceService {
    private final YogaSequenceRepository yogaSequenceRepository;
    private final UserSequenceRepository userSequenceRepository;
    private final SequenceRepository sequenceRepository;
    private final UserRepository userRepository;
    private final StarRepository starRepository;
    private final SequenceBodyRepository sequenceBodyRepository;
    private final SequenceYogaRepository sequenceYogaRepository;
    private final JpaUserMusicRepository userMusicRepository;
    private final YogaFeedbackRepository yogaFeedbackRepository;

    public SequenceResponse getYogaSequence(Integer sequenceId, Integer userId) {
        List<YogaSequenceResponse> yogaSequence = yogaSequenceRepository.findYogaBySequenceIdOrderByOrder(sequenceId);
        Sequence sequence = sequenceRepository.findById(sequenceId).orElseThrow(SequenceNotFoundException::new);
        Star star = starRepository.findBySequence_IdAndUser_Id(sequenceId, userId).orElse(null);
        String musicLocation = userMusicRepository.findMusicLocationsByUserId(userId);

        return SequenceResponse.builder()
                .sequenceId(sequence.getId())
                .yogaCnt(sequence.getYogaCount())
                .sequenceImage(sequence.getImage())
                .sequenceName(sequence.getName())
                .time(sequence.getTime())
                .description(sequence.getDescription())
                .isStar(star != null)
                .music(musicLocation)
                .yogaSequence(yogaSequence)
                .build();
    }

    public UserSequenceResponse saveUserSequence(Integer sequenceId, Integer userId) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        Sequence sequence = sequenceRepository.findById(sequenceId).orElseThrow(SequenceNotFoundException::new);

        UserSequence userSequence = UserSequence.builder()
                .user(user)
                .sequence(sequence)
                .createdDate(LocalDate.now())
                .build();
        userSequenceRepository.save(userSequence);

        //만약 userSequence가 어제 있고 오늘 userSequence를 처음 저장하는거면 streak +1
        if (userSequenceRepository.existsYesterdayUserSequence()==0 && userSequenceRepository.existsTodayUserSequence() !=0) {
            user.setStreakDays(user.getStreakDays() + 1);
        }
        return UserSequenceResponse.builder()
                .userSequenceId(userSequence.getId()).build();
    }

    public void checkYogaSequence(Integer userSequenceId) {
        UserSequence userSequence = userSequenceRepository
                .findById(userSequenceId).orElseThrow(UserNotFoundException::new);

        userSequence.setLastPoint(userSequence.getLastPoint() + 1);
    }

    public FinishResponse finishYogaSequence(Integer userSequenceId, Integer sequenceId) {
        List<AccuracyResponse> accuracyResponses = new ArrayList<>();
        List<SequenceYoga> sequenceYoga = sequenceYogaRepository.findByUserSequence_Id(userSequenceId);
        for(SequenceYoga yoga : sequenceYoga) {
            accuracyResponses.add(AccuracyResponse.builder()
                    .yogaName(yoga.getYogaName())
                    .accuracy(yoga.getAccuracy())
                    .image(yoga.getYogaImage())
                    .feedback(yogaFeedbackRepository.findFeedbackBySequenceYogaId(yoga.getSequenceYogaId()))
                    .build());
        }

        List<FeedbackResponse> feedbackResponses = sequenceBodyRepository.findFeedbackByUserSequenceId(userSequenceId);

        // 피드백 그룹 집계 결과 조회
        List<Object[]> aggregates = sequenceBodyRepository.aggregateFeedbackByGroup(userSequenceId);
        String bodyF = "";
        String bodyS = "";
        List<RecommendSequence> recommendSequenceF = Collections.emptyList();
        List<RecommendSequence> recommendSequenceS = Collections.emptyList();

        if (!aggregates.isEmpty()) {
            // 첫 번째 추천 그룹 (bodyF)
            Object[] topAggregate = aggregates.get(0);
            String groupNameFirst = (String) topAggregate[0];
            String tagKorFirst = TagUtil.ENG_TO_KOR.get(groupNameFirst);
            if (tagKorFirst != null) {
                bodyF = tagKorFirst;
                List<Sequence> sequences = sequenceRepository.findTop3SequencesByTagName(tagKorFirst);
                recommendSequenceF = sequences.stream()
                        .map(seq -> RecommendSequence.builder()
                                .sequenceId(seq.getId())
                                .sequenceName(seq.getName())
                                .sequenceTime(seq.getTime())
                                .sequenceImage(seq.getImage())
                                .build())
                        .collect(Collectors.toList());
            }
            // 두 번째 추천 그룹 (bodyS) 존재 여부 확인
            if (aggregates.size() > 1) {
                Object[] secondAggregate = aggregates.get(1);
                String groupNameSecond = (String) secondAggregate[0];
                String tagKorSecond = TagUtil.ENG_TO_KOR.get(groupNameSecond);
                if (tagKorSecond != null) {
                    bodyS = tagKorSecond;
                    List<Sequence> sequences = sequenceRepository.findTop3SequencesByTagName(tagKorSecond);
                    recommendSequenceS = sequences.stream()
                            .map(seq -> RecommendSequence.builder()
                                    .sequenceId(seq.getId())
                                    .sequenceName(seq.getName())
                                    .sequenceTime(seq.getTime())
                                    .sequenceImage(seq.getImage())
                                    .build())
                            .collect(Collectors.toList());
                }
            }
        }

        int averageAccuracy = (int) Math.round(accuracyResponses.stream()
                .mapToInt(AccuracyResponse::getAccuracy)
                .average()
                .orElse(0.0));
        Sequence sequence = sequenceRepository.findById(sequenceId).orElseThrow(SequenceNotFoundException::new);

        return FinishResponse.builder()
                .sequenceId(sequence.getId())
                .sequenceName(sequence.getName())
                .yogaTime(sequence.getTime() / 30)
                .sequenceCnt(sequence.getYogaCount())
                .totalAccuracy(averageAccuracy)
                .totalFeedback(feedbackResponses)
                .recommendSequenceF(recommendSequenceF)
                .recommendSequenceS(recommendSequenceS)
                .positionAccuracy(accuracyResponses)
                .bodyF(bodyF)
                .bodyS(bodyS)
                .build();
    }
}
