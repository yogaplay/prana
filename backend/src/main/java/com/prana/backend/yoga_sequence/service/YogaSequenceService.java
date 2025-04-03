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
import com.prana.backend.yoga_sequence.controller.response.*;
import com.prana.backend.yoga_sequence.repository.YogaSequenceRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
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
        List<AccuracyResponse> accuracyResponses = sequenceYogaRepository.findAccuracyByUserSequenceId(userSequenceId);
        List<FeedbackResponse> feedbackResponses = sequenceBodyRepository.findFeedbackByUserSequenceId(userSequenceId);
        List<RecommendSequence> recommendSequences = getRecommendedSequences(userSequenceId);
        int averageAccuracy = (int) Math.round(accuracyResponses.stream()
                .mapToInt(AccuracyResponse::getAccuracy)
                .average()
                .orElse(0.0));
        Sequence sequence = sequenceRepository.findById(sequenceId).orElseThrow(SequenceNotFoundException::new);

        return FinishResponse.builder()
                .sequenceId(sequence.getId())
                .sequenceName(sequence.getName())
                .yogaTime(sequence.getTime() / 60)
                .sequenceCnt(sequence.getYogaCount())
                .totalAccuracy(averageAccuracy)
                .totalFeedback(feedbackResponses)
                .recommendSequence(recommendSequences)
                .positionAccuracy(accuracyResponses)
                .build();
    }


    public List<RecommendSequence> getRecommendedSequences(Integer userSequenceId) {
        // 1. 피드백 집계: 그룹별 총 피드백 수를 내림차순 정렬하여 조회
        List<Object[]> aggregates = sequenceBodyRepository.aggregateFeedbackByGroup(userSequenceId);
        if (aggregates.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. 가장 피드백이 많은 그룹 선택 (첫 번째 결과)
        Object[] topAggregate = aggregates.get(0);
        String groupName = (String) topAggregate[0]; // 예: "back", "arm", "leg", "core"

        // 3. 영문 그룹명을 한글 태그명으로 변환 (Tag 테이블의 tag_name과 일치)
        String tagKor = TagUtil.ENG_TO_KOR.get(groupName);
        if(tagKor == null) {
            return Collections.emptyList();
        }

        // 4. 해당 태그에 맞는 시퀀스들을 조회하여 반환
        List<Sequence> sequences = sequenceRepository.findSequencesByTagName(tagKor);

        return sequences.stream()
                .map(seq -> RecommendSequence.builder()
                        .sequenceId(seq.getId())
                        .sequenceName(seq.getName())
                        .sequenceTime(seq.getTime())
                        .sequenceImage(seq.getImage())
                        .build())
                .collect(Collectors.toList());
    }

}
