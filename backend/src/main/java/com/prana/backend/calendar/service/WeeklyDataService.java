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

        // 월요일 자정으로 시간 고정
        LocalDateTime start = today.minusWeeks(1).with(DayOfWeek.MONDAY).with(LocalTime.MIDNIGHT);
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

        // 2. accuracy
        // 모든 user별로 수행한 모든 sequence에 대해 success, fail 조회
        List<CountAccuracyByWeekDTO> weekAccuracys = accuracyRepository.countAccuracyByWeek(start, end);
        log.debug("weekAccuracys: {}", weekAccuracys.toString());

        // userId : [accuracy 총 개수, 합]
        Map<Integer, double[]> accuracyMapTemp = new HashMap<>();
        for(CountAccuracyByWeekDTO dto : weekAccuracys) {
            int userId = dto.getUserId();
            int success = dto.getSuccess().intValue();
            int fail = dto.getFail().intValue();
            double accuracy = 0.0;

            if((success + fail) != 0){
                accuracy = (double) success / (success + fail) * 100;
            }

            accuracyMapTemp.computeIfAbsent(userId, k -> new double[2]);

            accuracyMapTemp.get(userId)[0]+=1.0;
            accuracyMapTemp.get(userId)[1]+=accuracy;
        }

        Map<Integer, Double> accuracyMap = new HashMap<>();
        for(int userId : accuracyMapTemp.keySet()) {
            accuracyMap.put(userId, accuracyMapTemp.get(userId)[1] / accuracyMapTemp.get(userId)[0]);
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

            double week1YogaAccuracy = accuracyMap.getOrDefault(userId, 0.0);
            int week1YogaTime = yogatimeMap.getOrDefault(userId, 0);
            double week1Bmi = bmiMap.getOrDefault(userId, 0.0);

            if(prevWeeklyDataMap.containsKey(userId)) {
                WeeklyData wd = prevWeeklyDataMap.get(userId);
                data.add(new WeeklyData().builder()
                        .user(User.builder().id(userId).build())
                        .year(year)
                        .month(month)
                        .week(week)
                        .week1YogaTime(week1YogaTime)
                        .week1Accuracy(week1YogaAccuracy)
                        .week1Bmi(week1Bmi)
                        .week2YogaTime(wd.getWeek1YogaTime())
                        .week2Accuracy(wd.getWeek1Accuracy())
                        .week2Bmi(wd.getWeek1Bmi())
                        .week3YogaTime(wd.getWeek2YogaTime())
                        .week3Accuracy(wd.getWeek2Accuracy())
                        .week3Bmi(wd.getWeek2Bmi())
                        .week4YogaTime(wd.getWeek3YogaTime())
                        .week4Accuracy(wd.getWeek3Accuracy())
                        .week4Bmi(wd.getWeek3Bmi())
                        .week5YogaTime(wd.getWeek4YogaTime())
                        .week5Accuracy(wd.getWeek4Accuracy())
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
                data.add(new WeeklyData().builder()
                        .user(User.builder().id(userId).build())
                        .year(year)
                        .month(month)
                        .week(week)
                        .week1YogaTime(week1YogaTime)
                        .week1Accuracy(week1YogaAccuracy)
                        .week1Bmi(week1Bmi)
                        .week2YogaTime(0)
                        .week2Accuracy(0.0)
                        .week2Bmi(0.0)
                        .week3YogaTime(0)
                        .week3Accuracy(0.0)
                        .week3Bmi(0.0)
                        .week4YogaTime(0)
                        .week4Accuracy(0.0)
                        .week4Bmi(0.0)
                        .week5YogaTime(0)
                        .week5Accuracy(0.0)
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

        weeklyDataRepository.saveAll(data);
    }
}
