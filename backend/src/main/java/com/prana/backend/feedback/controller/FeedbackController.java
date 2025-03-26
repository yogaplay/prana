package com.prana.backend.feedback.controller;

import com.prana.backend.feedback.service.FeedbackService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/feedback")
public class FeedbackController {

    private final FeedbackService feedbackService;

    // 0.5초 주기: 성공/실패 횟수 판단 요청
    @PostMapping("/short")
    public ResponseEntity<String> processShortFeedback(
            @RequestParam("image") MultipartFile image,
            @RequestParam("userSequenceId") Integer userSequenceId
    ) {
        feedbackService.handleShortFeedback(image, userSequenceId);
        return ResponseEntity.ok("Short feedback processed");
    }

    // 3초 주기: 상세 피드백 요청
    @PostMapping("/long")
    public ResponseEntity<String> processLongFeedback(
            @RequestParam("image") MultipartFile image,
            @RequestParam("userSequenceId") Integer userSequenceId
    ) {
        feedbackService.handleLongFeedback(image, userSequenceId);
        return ResponseEntity.ok("Long feedback processed");
    }
}

