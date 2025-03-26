package com.prana.backend.accuracy.controller;


import com.prana.backend.accuracy.service.AccuracyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
            @RequestParam Integer userSequenceId,
            @RequestParam Integer userId,
            @RequestParam Integer yogaId,
            @RequestParam Integer sequenceId) {
        boolean saved = accuracyService.saveAccuracyToDb(userSequenceId, userId, yogaId, sequenceId);
        if (saved) {
            return ResponseEntity.ok("Accuracy data saved to DB");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("No AI feedback found in cache");
        }
    }
}

