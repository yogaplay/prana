package com.prana.backend.yogaSequence.service;

import com.prana.backend.common.exception.user.UserNotFoundException;
import com.prana.backend.userSequence.UserSequence;
import com.prana.backend.userSequence.repository.UserSequenceRepository;
import com.prana.backend.yogaSequence.controller.response.YogaSequenceResponse;
import com.prana.backend.yogaSequence.repository.YogaSequenceRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class YogaSequenceService {
    private final YogaSequenceRepository yogaSequenceRepository;
    private final UserSequenceRepository userSequenceRepository;

    public List<YogaSequenceResponse> getYogaSequenceResponses(Integer userId, Integer sequenceId) {
        return yogaSequenceRepository.findYogaBySequenceIdOrderByOrder(sequenceId);
    }

    public void checkYogaSequence(Integer userId, Integer sequenceId) {
        UserSequence userSequence = userSequenceRepository.findById(userId)
                .orElseThrow(UserNotFoundException::new);

        // 2. 필드 업데이트 (체크로직은 엔티티 내에 구현되어 있다고 가정)
        userSequence.setResultStatus(newResultStatus);
        userSequence.setLastPoint(newLastPoint);
        userSequence.setCreatedDate(newCreatedDate);
        // 트랜잭션 종료 시 자동으로 dirty checking에 의해 업데이트 됨.
    }
}
