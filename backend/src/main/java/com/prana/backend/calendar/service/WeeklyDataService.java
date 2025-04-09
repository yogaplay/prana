package com.prana.backend.calendar.service;

import com.prana.backend.accuracy.repository.AccuracyRepository;
import com.prana.backend.accuracy.repository.dto.CountAccuracyByWeekDTO;
import com.prana.backend.entity.User;
import com.prana.backend.entity.WeeklyData;
import com.prana.backend.feedback.repository.FeedbackRepository;
import com.prana.backend.feedback.repository.dto.CountFeedbackByWeekDTO;
import com.prana.backend.user.repository.UserRepository;
import com.prana.backend.user.repository.dto.FindHeightAndWeightDTO;
import com.prana.backend.user_sequence.repository.UserSequenceRepository;
import com.prana.backend.user_sequence.repository.dto.FindActiveSequenceDTO;
import com.prana.backend.weekly_data.repository.WeeklyDataRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class WeeklyDataService {
    private final FeedbackRepository feedbackRepository;
    private final AccuracyRepository accuracyRepository;
    private final WeeklyDataRepository weeklyDataRepository;
    private final UserRepository userRepository;
    private final UserSequenceRepository userSequenceRepository;
    private final CalendarService calendarService;

    @Transactional
    public void insertWeeklyData(LocalDateTime today) {
        log.debug("today: {}", today);

        // 일요일 자정으로 시간 고정
        LocalDateTime start = today.minusWeeks(2).with(DayOfWeek.SUNDAY).with(LocalTime.MIDNIGHT);
        LocalDateTime end = start.plusWeeks(1);
        log.debug("start: {}", start);
        log.debug("end: {}", end);

        int year = start.getYear();
        int month = start.getMonthValue();
        int week = calendarService.getWeekOfDate(start.toLocalDate());

        // 모든 유저에 대해 week1(이번주) 데이터 계산
        List<Integer> allUserIds = userRepository.findAllUserId();

        // 1. feedback
        // 데이터가 존재하는 모든 user에 대해 bodyPart 종류별로 feedback 합 조회
        List<CountFeedbackByWeekDTO> weekFeedbacks = feedbackRepository.countFeedbackByWeek(start, end);
        log.debug("weekFeedbacks: {}", weekFeedbacks.toString());

        Map<String, Long> feedbackMap = new HashMap<>();
        for (CountFeedbackByWeekDTO dto : weekFeedbacks) {
            String key = dto.getUserId() + ":" + dto.getBodyPart();  // ex: "6:SHOULDER"
            feedbackMap.put(key, dto.getCount());
        }

        // 2. score
        List<CountAccuracyByWeekDTO> weekAccuracys = accuracyRepository.countAccuracyByWeek(start, end);
        log.debug("weekAccuracys: {}", weekAccuracys.toString());

        // userId : [sequence1 점수합, sequence2 점수합...]
        Map<Integer, double[]> scoreMapTemp = new HashMap<>();
        for(CountAccuracyByWeekDTO dto : weekAccuracys) {
            int userId = dto.getUserId();
            int scoreSum = dto.getScore().intValue();
            int count = dto.getCount().intValue();
            double score = scoreSum / (double) count;

            scoreMapTemp.computeIfAbsent(userId, k -> new double[2]);

            scoreMapTemp.get(userId)[0]+=1.0;
            scoreMapTemp.get(userId)[1]+=score;
        }

        Map<Integer, Double> scoreMap = new HashMap<>();
        for(Integer userId : scoreMapTemp.keySet()) {
            scoreMap.put(userId, scoreMapTemp.get(userId)[1] / scoreMapTemp.get(userId)[0]);
        }

        // 3. yogatime
        List<FindActiveSequenceDTO> activeSequence = userSequenceRepository.findActiveSequenceByWeek(start, end);
        Map<Integer, Integer> yogatimeMap = new HashMap<>();

        for(FindActiveSequenceDTO dto : activeSequence) {
            int userId = dto.getUserId();
            int lastPoint = dto.getLastPoint();
            int yogaCnt = dto.getYogaCnt();
            int sequenceTime = dto.getSequenceTime();

            yogatimeMap.put(userId, (int) ((lastPoint / (double) yogaCnt) * sequenceTime));
        }

        // 4. bmi
        List<FindHeightAndWeightDTO> heightAndWeight = userRepository.findHeightAndWeight();
        Map<Integer, Double> bmiMap = new HashMap<>();

        for(FindHeightAndWeightDTO dto : heightAndWeight) {
            int userId = dto.getUserId();
            Short height = dto.getHeight();
            Short weight = dto.getWeight();

            if(height == null || weight == null || height==0){
                bmiMap.put(userId, 0.0);
                continue;
            }
            double heightDouble  = height / (double) 100; // m로 변환
            bmiMap.put(userId, weight / (heightDouble*heightDouble));

        }

        // week2~week5는 이전 주들의 데이터 불러와서 삽입
        // 최종 결과 WeeklyDataDB에 Insert
        List<WeeklyData> data = new ArrayList<>();

        LocalDate Prevday = start.toLocalDate().minusWeeks(1);

        int PrevYear = Prevday.getYear();
        int PrevMonth = Prevday.getMonthValue();
        int PrevWeek = calendarService.getWeekOfDate(Prevday);
        log.debug("PrevDay: {}년 {}월 {}주", PrevYear, PrevMonth, PrevWeek);

        List<WeeklyData> prevWeeklyData = weeklyDataRepository
                .findAllByYearMonthWeekAndUserIdIn(PrevYear, PrevMonth, PrevWeek, allUserIds);

        // Map<userId, WeeklyData>로 변환
        Map<Integer, WeeklyData> prevWeeklyDataMap = prevWeeklyData.stream()
                .collect(Collectors.toMap(
                        wd -> wd.getUser().getId(),
                        Function.identity() // wd 자기자신
                ));

        for(Integer userId : allUserIds){
            int shoulderCount     = feedbackMap.getOrDefault(userId + ":SHOULDER", 0L).intValue();
            int elbowLeftCount    = feedbackMap.getOrDefault(userId + ":ELBOW_LEFT", 0L).intValue();
            int elbowRightCount   = feedbackMap.getOrDefault(userId + ":ELBOW_RIGHT", 0L).intValue();
            int armLeftCount      = feedbackMap.getOrDefault(userId + ":ARM_LEFT", 0L).intValue();
            int armRightCount     = feedbackMap.getOrDefault(userId + ":ARM_RIGHT", 0L).intValue();
            int hipLeftCount      = feedbackMap.getOrDefault(userId + ":HIP_LEFT", 0L).intValue();
            int hipRightCount     = feedbackMap.getOrDefault(userId + ":HIP_RIGHT", 0L).intValue();
            int kneeLeftCount     = feedbackMap.getOrDefault(userId + ":KNEE_LEFT", 0L).intValue();
            int kneeRightCount    = feedbackMap.getOrDefault(userId + ":KNEE_RIGHT", 0L).intValue();
            int legLeftCount      = feedbackMap.getOrDefault(userId + ":LEG_LEFT", 0L).intValue();
            int legRightCount     = feedbackMap.getOrDefault(userId + ":LEG_RIGHT", 0L).intValue();

            double week1YogaScore = scoreMap.getOrDefault(userId, 0.0);
            int week1YogaTime = yogatimeMap.getOrDefault(userId, 0);
            double week1Bmi = bmiMap.getOrDefault(userId, 0.0);

            if(prevWeeklyDataMap.containsKey(userId)) {
                WeeklyData wd = prevWeeklyDataMap.get(userId);
                data.add(WeeklyData.builder()
                        .user(userRepository.getReferenceById(userId))
                        .year(year)
                        .month(month)
                        .week(week)
                        .week1YogaTime(week1YogaTime)
                        .week1Score(week1YogaScore)
                        .week1Bmi(week1Bmi)
                        .week2YogaTime(wd.getWeek1YogaTime())
                        .week2Score(wd.getWeek1Score())
                        .week2Bmi(wd.getWeek1Bmi())
                        .week3YogaTime(wd.getWeek2YogaTime())
                        .week3Score(wd.getWeek2Score())
                        .week3Bmi(wd.getWeek2Bmi())
                        .week4YogaTime(wd.getWeek3YogaTime())
                        .week4Score(wd.getWeek3Score())
                        .week4Bmi(wd.getWeek3Bmi())
                        .week5YogaTime(wd.getWeek4YogaTime())
                        .week5Score(wd.getWeek4Score())
                        .week5Bmi(wd.getWeek4Bmi())
                        .feedbackShoulder(shoulderCount)
                        .feedbackElbowLeft(elbowLeftCount)
                        .feedbackElbowRight(elbowRightCount)
                        .feedbackArmLeft(armLeftCount)
                        .feedbackArmRight(armRightCount)
                        .feedbackHipLeft(hipLeftCount)
                        .feedbackHipRight(hipRightCount)
                        .feedbackKneeLeft(kneeLeftCount)
                        .feedbackKneeRight(kneeRightCount)
                        .feedbackLegLeft(legLeftCount)
                        .feedbackLegRight(legRightCount)
                        .build());
            } else {
                // 전주 데이터가 없는 경우(첫 회원)
                data.add(WeeklyData.builder()
                        .user(userRepository.getReferenceById(userId))
                        .year(year)
                        .month(month)
                        .week(week)
                        .week1YogaTime(week1YogaTime)
                        .week1Score(week1YogaScore)
                        .week1Bmi(week1Bmi)
                        .week2YogaTime(0)
                        .week2Score(0.0)
                        .week2Bmi(0.0)
                        .week3YogaTime(0)
                        .week3Score(0.0)
                        .week3Bmi(0.0)
                        .week4YogaTime(0)
                        .week4Score(0.0)
                        .week4Bmi(0.0)
                        .week5YogaTime(0)
                        .week5Score(0.0)
                        .week5Bmi(0.0)
                        .feedbackShoulder(shoulderCount)
                        .feedbackElbowLeft(elbowLeftCount)
                        .feedbackElbowRight(elbowRightCount)
                        .feedbackArmLeft(armLeftCount)
                        .feedbackArmRight(armRightCount)
                        .feedbackHipLeft(hipLeftCount)
                        .feedbackHipRight(hipRightCount)
                        .feedbackKneeLeft(kneeLeftCount)
                        .feedbackKneeRight(kneeRightCount)
                        .feedbackLegLeft(legLeftCount)
                        .feedbackLegRight(legRightCount)
                        .build());
            }
        }

        // 저번달 마지막주, 이번달 첫주가 겹치는 경우 둘다 저장해줘야 db검색이 가능.
        // end기준으로도 저장

        if(start.getMonthValue() != end.getMonthValue()) {
            List<WeeklyData> copyDate = new ArrayList<>();
            int endYear = end.getYear();
            int endMonth = end.getMonthValue();
            int endWeek = 1;

            for(WeeklyData wd : data) {
                // 날짜만 바꾸고 데이터 2배로 복사
                copyDate.add(wd);
                copyDate.add(
                        WeeklyData.builder()
                                .user(wd.getUser())
                                .year(endYear)
                                .month(endMonth)
                                .week(endWeek)
                                .week1YogaTime(wd.getWeek1YogaTime())
                                .week1Score(wd.getWeek1Score())
                                .week1Bmi(wd.getWeek1Bmi())
                                .week2YogaTime(wd.getWeek2YogaTime())
                                .week2Score(wd.getWeek2Score())
                                .week2Bmi(wd.getWeek2Bmi())
                                .week3YogaTime(wd.getWeek3YogaTime())
                                .week3Score(wd.getWeek3Score())
                                .week3Bmi(wd.getWeek3Bmi())
                                .week4YogaTime(wd.getWeek4YogaTime())
                                .week4Score(wd.getWeek4Score())
                                .week4Bmi(wd.getWeek4Bmi())
                                .week5YogaTime(wd.getWeek5YogaTime())
                                .week5Score(wd.getWeek5Score())
                                .week5Bmi(wd.getWeek5Bmi())
                                .feedbackShoulder(wd.getFeedbackShoulder())
                                .feedbackElbowLeft(wd.getFeedbackElbowLeft())
                                .feedbackElbowRight(wd.getFeedbackElbowRight())
                                .feedbackArmLeft(wd.getFeedbackArmLeft())
                                .feedbackArmRight(wd.getFeedbackArmRight())
                                .feedbackHipLeft(wd.getFeedbackHipLeft())
                                .feedbackHipRight(wd.getFeedbackHipRight())
                                .feedbackKneeLeft(wd.getFeedbackKneeLeft())
                                .feedbackKneeRight(wd.getFeedbackKneeRight())
                                .feedbackLegLeft(wd.getFeedbackLegLeft())
                                .feedbackLegRight(wd.getFeedbackLegRight())
                                .build());
            }
            weeklyDataRepository.saveAll(copyDate);
        } else {
            weeklyDataRepository.saveAll(data);
        }


    }
}
