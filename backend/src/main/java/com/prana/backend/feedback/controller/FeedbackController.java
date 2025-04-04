package com.prana.backend.feedback.controller;

import com.prana.backend.feedback.response.LongResponse;
import com.prana.backend.feedback.response.ShortResponse;
import com.prana.backend.feedback.service.FeedbackService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
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
    public ResponseEntity<ShortResponse> processShortFeedback(
            @RequestParam("image") MultipartFile image,
            @RequestParam("yogaId") Integer yogaId,
            @RequestParam("userSequenceId") Integer userSequenceId
    ) {

        return ResponseEntity.status(HttpStatus.OK)
                .body(ShortResponse.builder()
                        .message(feedbackService.handleShortFeedback(image, yogaId, userSequenceId)).build());
    }

    // 3초 주기: 상세 피드백 요청
    @PostMapping("/long")
    public ResponseEntity<LongResponse> processLongFeedback(
            @RequestParam("image") MultipartFile image,
            @RequestParam("yogaId") Integer yogaId,
            @RequestParam("userSequenceId") Integer userSequenceId
    ) {
        return ResponseEntity.status(HttpStatus.OK)
                .body(LongResponse.builder()
                        .message(feedbackService.handleLongFeedback(image, yogaId, userSequenceId)).build());
    }
}

