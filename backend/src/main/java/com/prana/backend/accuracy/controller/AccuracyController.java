package com.prana.backend.accuracy.controller;


import com.prana.backend.accuracy.controller.request.AccuracyRequest;
import com.prana.backend.accuracy.controller.response.AccuracyResponse;
import com.prana.backend.accuracy.service.AccuracyService;
import com.prana.backend.common.PranaPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/accuracy")
@RequiredArgsConstructor
public class AccuracyController {

    private final AccuracyService accuracyService;

    /**
     * 클라이언트가 동작 완료 시 호출하는 API.
     * userSequenceId, userId, yogaId, sequenceId 등의 파라미터를 받습니다.
     */
    @PostMapping("/complete")
    public ResponseEntity<String> completeMovement(
            @RequestBody AccuracyRequest request,
            @AuthenticationPrincipal PranaPrincipal prana) {
        boolean saved = accuracyService.saveAccuracyToDb(request.getUserSequenceId(), prana.getUserId(), request.getYogaId(), request.getSequenceId());
        if (saved) {
            return ResponseEntity.ok("Accuracy data saved to DB");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("No AI feedback found in cache");
        }
    }

    @GetMapping("/end")
    public ResponseEntity<AccuracyResponse> getTotalFeedback(
            @RequestParam("userSequenceId") Integer userSequenceId,
            @RequestParam("sequenceId") Integer sequenceId,
            @AuthenticationPrincipal PranaPrincipal principal
    ) {
        return ResponseEntity.status(HttpStatus.OK)
                .body(accuracyService.)
    }
}

