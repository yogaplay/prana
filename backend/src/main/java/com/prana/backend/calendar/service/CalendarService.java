package com.prana.backend.calendar.service;

import com.prana.backend.calendar.controller.response.DailySequenceResponseDTO;
import com.prana.backend.calendar.controller.response.WeeklyReportResponseDTO;
import com.prana.backend.calendar.exception.RecommendationSequenceNot3Exception;
import com.prana.backend.entity.Sequence;
import com.prana.backend.entity.WeeklyData;
import com.prana.backend.sequence.repository.SequenceRepository;
import com.prana.backend.user_sequence.repository.UserSequenceRepository;
import com.prana.backend.user_sequence.repository.dto.DailySequenceRepositoryDTO;
import com.prana.backend.weekly_data.repository.WeeklyDataRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;


@Slf4j
@Service
@AllArgsConstructor
public class CalendarService {
    private final UserSequenceRepository userSequenceRepository;
    private final WeeklyDataRepository weeklyDataRepository;
    private final SequenceRepository sequenceRepository;
    private final int recommendationSequenceCount = 3;

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

    @Transactional
    public WeeklyReportResponseDTO getWeeklyReport(int userId, LocalDate date) {
        // 날짜를 년,월,주로 변환
        int year = date.getYear();
        int month = date.getMonthValue();
        int week = getWeekOfDate(date);

        WeeklyData weeklyData = weeklyDataRepository.findWeeklyDataByUserIdAndYearAndMonthAndWeek(userId, year, month, week);
        log.debug("weeklyData = {}", weeklyData.toString());
        /*
        ** feedback 4개 **
            등(back): 어깨
            팔(arm): 팔꿈치(좌우), 팔(좌우)
            다리(leg): 무릎(좌우), 다리(좌우)
            코어(core): 엉덩이(좌우)
         */

        Map<String, Integer> feedbackMap = new LinkedHashMap<>();
        feedbackMap.put("back", weeklyData.getFeedbackShoulder());
        feedbackMap.put("arm", weeklyData.getFeedbackArmLeft()+weeklyData.getFeedbackArmRight()+weeklyData.getFeedbackElbowLeft()+weeklyData.getFeedbackElbowRight());
        feedbackMap.put("leg", weeklyData.getFeedbackKneeLeft()+weeklyData.getFeedbackKneeRight()+weeklyData.getFeedbackLegLeft()+weeklyData.getFeedbackLegRight());
        feedbackMap.put("core", weeklyData.getFeedbackHipLeft()+weeklyData.getFeedbackHipRight());

        List<WeeklyReportResponseDTO.Feedback> feedbacks = feedbackMap.entrySet().stream()
                .map(entry -> WeeklyReportResponseDTO.Feedback.builder()
                        .position(entry.getKey())
                        .count(entry.getValue())
                        .build())
                .collect(Collectors.toList());

        /*
        ** recommend_sequences
            feedback 수 상위 2부위에 대한 sequence 3개씩 추천
         */
        List<String> feedbackTop2 = feedbackMap.entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .limit(2)
                .map(Map.Entry::getKey)
                .toList();

        String position1 =  TagUtil.ENG_TO_KOR.get(feedbackTop2.get(0));
        String position2 =  TagUtil.ENG_TO_KOR.get(feedbackTop2.get(1));
        log.debug("position1 = {}", position1);
        log.debug("position2 = {}", position2);

        // top2 태그별 추천 시퀀스 3개씩 추출
        List<Sequence> recommendSequence1 = sequenceRepository.findRandom3ByTagName(position1);
        log.debug("recommendSequence1 = {}", recommendSequence1.toString());
        log.debug("recommendSequence1-size = {}", recommendSequence1.size());
        if(recommendSequence1.size()!=recommendationSequenceCount) {
            throw new RecommendationSequenceNot3Exception("추천 시퀀스는 3개여야 합니다.");
        }
        List<Sequence> recommendSequence2 = sequenceRepository.findRandom3ByTagName(position2);
        log.debug("recommendSequence2 = {}", recommendSequence2.toString());
        log.debug("recommendSequence2-size = {}", recommendSequence2.size());
        if(recommendSequence2.size()!=recommendationSequenceCount) {
            throw new RecommendationSequenceNot3Exception("추천 시퀀스는 3개여야 합니다.");
        }

        List<WeeklyReportResponseDTO.Sequence> sequences1 = toSequenceList(recommendSequence1);
        List<WeeklyReportResponseDTO.Sequence> sequences2 = toSequenceList(recommendSequence2);

        List<WeeklyReportResponseDTO.RecommendSequences> recommendSequences = new ArrayList<>();
        recommendSequences.add(WeeklyReportResponseDTO.RecommendSequences.builder()
                .position(position1)
                .sequences(sequences1)
                .build());

        recommendSequences.add(WeeklyReportResponseDTO.RecommendSequences.builder()
                .position(position2)
                .sequences(sequences2)
                .build());

        // 5주차 데이터
        WeeklyReportResponseDTO.Week week1 = WeeklyReportResponseDTO.Week.builder()
                .year(year)
                .month(month)
                .week(week)
                .time(weeklyData.getWeek1YogaTime())
                .accuracy(weeklyData.getWeek1Accuracy())
                .bmi(weeklyData.getWeek1Bmi())
                .build();

        List<int[]> previous4Weeks = getPrevious4Weeks(date);

        // 1주전
        WeeklyReportResponseDTO.Week week2 = WeeklyReportResponseDTO.Week.builder()
                .year(previous4Weeks.get(0)[0])
                .month(previous4Weeks.get(0)[1])
                .week(previous4Weeks.get(0)[2])
                .time(weeklyData.getWeek2YogaTime())
                .accuracy(weeklyData.getWeek2Accuracy())
                .bmi(weeklyData.getWeek2Bmi())
                .build();

        // 2주전
        WeeklyReportResponseDTO.Week week3 = WeeklyReportResponseDTO.Week.builder()
                .year(previous4Weeks.get(1)[0])
                .month(previous4Weeks.get(1)[1])
                .week(previous4Weeks.get(1)[2])
                .time(weeklyData.getWeek3YogaTime())
                .accuracy(weeklyData.getWeek3Accuracy())
                .bmi(weeklyData.getWeek3Bmi())
                .build();

        // 3주전
        WeeklyReportResponseDTO.Week week4 = WeeklyReportResponseDTO.Week.builder()
                .year(previous4Weeks.get(2)[0])
                .month(previous4Weeks.get(2)[1])
                .week(previous4Weeks.get(2)[2])
                .time(weeklyData.getWeek4YogaTime())
                .accuracy(weeklyData.getWeek4Accuracy())
                .bmi(weeklyData.getWeek4Bmi())
                .build();

        // 4주전
        WeeklyReportResponseDTO.Week week5 = WeeklyReportResponseDTO.Week.builder()
                .year(previous4Weeks.get(3)[0])
                .month(previous4Weeks.get(3)[1])
                .week(previous4Weeks.get(3)[2])
                .time(weeklyData.getWeek5YogaTime())
                .accuracy(weeklyData.getWeek5Accuracy())
                .bmi(weeklyData.getWeek5Bmi())
                .build();

        return WeeklyReportResponseDTO.builder()
                .feedbacks(feedbacks)
                .recommendSequences(recommendSequences)
                .week1(week1)
                .week2(week2)
                .week3(week3)
                .week4(week4)
                .week5(week5)
                .build();
    }

    public int getWeekOfDate(LocalDate date) {
        // date에서 day만 1로 변경
        LocalDate firstDay = date.withDayOfMonth(1);

        // 요일 추출 (일~토 = 0~6)
        int firstDayWeekValue = (firstDay.getDayOfWeek().getValue()) % 7;

        int day = date.getDayOfMonth();

        return (day + firstDayWeekValue -1) / 7 + 1;
    }

    private List<WeeklyReportResponseDTO.Sequence> toSequenceList(List<Sequence> recommendSequence) {
        List<WeeklyReportResponseDTO.Sequence> sequences = new ArrayList<>();

        for(Sequence sequence : recommendSequence) {
            sequences.add(WeeklyReportResponseDTO.Sequence.builder()
                    .sequenceId(sequence.getId())
                    .sequenceName(sequence.getName())
                    .sequenceTime(sequence.getTime())
                    .image(sequence.getImage())
                    .build()
            );
        }
        return sequences;
    }

    private List<int[]> getPrevious4Weeks(LocalDate date) {
        List<int[]> result = new ArrayList<>();
        for (int i = 1; i <= 4; i++) {
            LocalDate target = date.minusWeeks(i);

            result.add(new int[]{target.getYear(),
                    target.getMonthValue(),
                    getWeekOfDate(target)});
        }

        return result;
    }

}

