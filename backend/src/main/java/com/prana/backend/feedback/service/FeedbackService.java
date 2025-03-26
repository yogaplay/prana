package com.prana.backend.feedback.service;

import com.prana.backend.ai_feedback.service.AiFeedbackService;
import com.prana.backend.entity.AiFeedback;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class FeedbackService {
    private final RestTemplate restTemplate;
    private final AiFeedbackService aiFeedbackCacheService;

    @Value("${ai.server.shortFeedbackUrl}")
    private String shortFeedbackUrl;

    @Value("${ai.server.longFeedbackUrl}")
    private String longFeedbackUrl;

    // 0.5초 요청 처리: 성공/실패 횟수
    public void handleShortFeedback(MultipartFile image, Integer userSequenceId) {
        String base64Image = convertImageToBase64(image);
        Map<String, Object> payload = new HashMap<>();
        payload.put("userSequenceId", userSequenceId);
        payload.put("image", base64Image);

        ResponseEntity<Map> response = restTemplate.postForEntity(shortFeedbackUrl, payload, Map.class);
        if (response.getStatusCode().is2xxSuccessful()) {
            Map result = response.getBody();
            assert result != null;
            String resultStr = (String) result.get("result");

            AiFeedback feedback = aiFeedbackCacheService.getAiFeedbackByUserSequenceId(userSequenceId);
            if (feedback == null) {
                feedback = new AiFeedback();
                feedback.setId(userSequenceId);
            }
            // 결과에 따라 카운트 1씩 누적
            if ("success".equalsIgnoreCase(resultStr)) {
                feedback.setSuccessCount(feedback.getSuccessCount() + 1);
            } else {
                feedback.setFailureCount(feedback.getFailureCount() + 1);
            }

            aiFeedbackCacheService.saveAiFeedback(feedback);
        }
    }

    // 3초 요청 처리: 상세 피드백 (피드백 목록)
    public void handleLongFeedback(MultipartFile image, Integer userSequenceId) {
        String base64Image = convertImageToBase64(image);
        Map<String, Object> payload = new HashMap<>();
        payload.put("userSequenceId", userSequenceId);
        payload.put("image", base64Image);

        ResponseEntity<Map> response = restTemplate.postForEntity(longFeedbackUrl, payload, Map.class);
        if (response.getStatusCode().is2xxSuccessful()) {
            Map result = response.getBody();
            Map feedbackMap = (Map) result.get("feedback");
            String position = (String) feedbackMap.get("position");
            int countToAdd = (int) feedbackMap.get("count");

            AiFeedback feedback = aiFeedbackCacheService.getAiFeedbackByUserSequenceId(userSequenceId);
            if (feedback == null) {
                feedback = new AiFeedback();
                feedback.setId(userSequenceId);
                // 초기 피드백 목록 생성 후 새 항목 추가
                AiFeedback.FeedbackTotal ft = new AiFeedback.FeedbackTotal(position, countToAdd);
                feedback.setFeedbackTotal(new java.util.ArrayList<>());
                feedback.getFeedbackTotal().add(ft);
            } else {
                // 기존 목록에 해당 position이 있는지 확인하여 누적, 없으면 새로 추가
                java.util.List<AiFeedback.FeedbackTotal> existing = feedback.getFeedbackTotal();
                if (existing == null) {
                    existing = new java.util.ArrayList<>();
                }
                boolean found = false;
                for (AiFeedback.FeedbackTotal item : existing) {
                    if (item.getPosition().equals(position)) {
                        item.setCount(item.getCount() + countToAdd);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    existing.add(new AiFeedback.FeedbackTotal(position, countToAdd));
                }
                feedback.setFeedbackTotal(existing);
            }
            aiFeedbackCacheService.saveAiFeedback(feedback);
        }
    }


    private String convertImageToBase64(MultipartFile image) {
        try {
            return Base64.getEncoder().encodeToString(image.getBytes());
        } catch (IOException e) {
            throw new RuntimeException("Image conversion failed", e);
        }
    }
}

