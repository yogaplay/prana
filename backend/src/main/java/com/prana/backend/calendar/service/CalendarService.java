package com.prana.backend.calendar.service;

import com.prana.backend.calendar.controller.response.DailySequenceResponseDTO;
import com.prana.backend.user_sequence.repository.UserSequenceRepository;
import com.prana.backend.user_sequence.repository.dto.DailySequenceRepositoryDTO;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@AllArgsConstructor
public class CalendarService {
    private final UserSequenceRepository userSequenceRepository;

    @Transactional
    public List<DailySequenceResponseDTO> getDailySequence(LocalDate date, int userId) {
        List<DailySequenceRepositoryDTO> dailySequenceRepositoryDTOS = userSequenceRepository.findByUserIdAndUpdatedAtDate(userId, date);

        List<DailySequenceResponseDTO> result = new ArrayList<>();
        // percent 계산
        for(DailySequenceRepositoryDTO dto : dailySequenceRepositoryDTOS) {
            int percent = (int) Math.floor(dto.getLastPoint() / (float) dto.getYogaCount() * 100);
            log.debug("percent = {}", percent);

            result.add(DailySequenceResponseDTO
                    .builder()
                    .userSequenceId(dto.getUserSequenceId())
                    .sequenceName(dto.getSequenceName())
                    .resultStatus(dto.getResultStatus())
                    .percent(percent)
                    .image(dto.getImage())
                    .build());
        }

        return result;
    }
}

