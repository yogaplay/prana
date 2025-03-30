package com.prana.backend.yoga_sequence.service;

import com.prana.backend.common.exception.sequence.SequenceNotFoundException;
import com.prana.backend.common.exception.user.UserNotFoundException;
import com.prana.backend.entity.Sequence;
import com.prana.backend.entity.Star;
import com.prana.backend.entity.User;
import com.prana.backend.entity.UserSequence;
import com.prana.backend.home.repository.StarRepository;
import com.prana.backend.sequence.repository.SequenceRepository;
import com.prana.backend.user.repository.UserRepository;
import com.prana.backend.user_sequence.repository.UserSequenceRepository;
import com.prana.backend.yoga_sequence.controller.response.SequenceResponse;
import com.prana.backend.yoga_sequence.controller.response.UserSequenceResponse;
import com.prana.backend.yoga_sequence.controller.response.YogaSequenceResponse;
import com.prana.backend.yoga_sequence.repository.YogaSequenceRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class YogaSequenceService {
    private final YogaSequenceRepository yogaSequenceRepository;
    private final UserSequenceRepository userSequenceRepository;
    private final SequenceRepository sequenceRepository;
    private final UserRepository userRepository;
    private final StarRepository starRepository;

    public SequenceResponse getYogaSequence(Integer sequenceId) {
        List<YogaSequenceResponse> yogaSequence = yogaSequenceRepository.findYogaBySequenceIdOrderByOrder(sequenceId);
        Sequence sequence = sequenceRepository.findById(sequenceId).orElseThrow(SequenceNotFoundException::new);
        Star star = starRepository.findBySequence_Id(sequenceId).orElseThrow(SequenceNotFoundException::new);

        return SequenceResponse.builder()
                .sequenceId(sequence.getId())
                .yogaCnt(sequence.getYogaCount())
                .sequenceImage(sequence.getImage())
                .sequenceName(sequence.getName())
                .time(sequence.getTime())
                .description(sequence.getDescription())
                .isStar(star != null)
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
        if(userSequenceRepository.existsYesterdayUserSequence() && !userSequenceRepository.existsTodayUserSequence()) {
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
}
