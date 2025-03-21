package com.prana.backend.yogaSequence.controller;

import com.prana.backend.yogaSequence.YogaSequence;
import com.prana.backend.yogaSequence.controller.request.CheckSequenceRequest;
import com.prana.backend.yogaSequence.controller.request.YogaSequenceRequest;
import com.prana.backend.yogaSequence.controller.response.YogaSequenceResponse;
import com.prana.backend.yogaSequence.service.YogaSequenceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/yoga")
public class YogaSequenceController {

    private final YogaSequenceService yogaService;

    @PostMapping("/sequence")
    public ResponseEntity<List<YogaSequenceResponse>> getYogaSequence(YogaSequenceRequest request) {

        List<YogaSequenceResponse> responses = yogaService.getYogaSequenceResponses(1, request.getSequenceId());
        return ResponseEntity.status(HttpStatus.OK).body(responses);
    }

    @PostMapping("/pose")
    public ResponseEntity<String> checkYogaSequence(CheckSequenceRequest request) {
        return ResponseEntity.status(HttpStatus.OK).body("200 OK");
    }
}
