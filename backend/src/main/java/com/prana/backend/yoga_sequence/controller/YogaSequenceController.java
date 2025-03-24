package com.prana.backend.yoga_sequence.controller;

import com.prana.backend.common.PranaPrincipal;
import com.prana.backend.yoga_sequence.controller.request.CheckSequenceRequest;
import com.prana.backend.yoga_sequence.controller.request.YogaSequenceRequest;
import com.prana.backend.yoga_sequence.controller.response.SequenceResponse;
import com.prana.backend.yoga_sequence.controller.response.UserSequenceResponse;
import com.prana.backend.yoga_sequence.service.YogaSequenceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/yoga")
public class YogaSequenceController {

    private final YogaSequenceService yogaService;

    /**
     * @param request (sequenceId)
     * @return 시퀀스에 대한 정보와 해당 시퀀스의 요가 정보를 반환
     */
    @PostMapping("/sequence")
    public ResponseEntity<SequenceResponse> getYogaSequence(YogaSequenceRequest request) {
        SequenceResponse responses = yogaService.getYogaSequence(request.getSequenceId());
        return ResponseEntity.status(HttpStatus.OK).body(responses);
    }

    /**
     * @param prana   (User 정보)
     * @param request (SequenceId)
     * @return 요가 수행 결과인 userSequenceId 반환
     */
    @PostMapping("/start")
    public ResponseEntity<UserSequenceResponse> startYogaSequence(@AuthenticationPrincipal PranaPrincipal prana, YogaSequenceRequest request) {
        return ResponseEntity.status(HttpStatus.OK)
                .body(yogaService.saveUserSequence(request.getSequenceId(), prana.getUserId()));
    }

    /**
     * @param request (userSequenceId)
     * @return 저장 성공 시, 200 ok 반환
     */
    @PostMapping("/pose")
    public ResponseEntity<String> checkYogaSequence(CheckSequenceRequest request) {
        yogaService.checkYogaSequence(request.getUserSequenceId());
        return ResponseEntity.status(HttpStatus.OK).body("200 OK");
    }
}
