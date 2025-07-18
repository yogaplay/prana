package com.prana.backend.user.controller;

import com.prana.backend.common.PranaPrincipal;
import com.prana.backend.user.controller.request.PatchMyInfoRequest;
import com.prana.backend.user.controller.request.SignUpRequest;
import com.prana.backend.user.controller.response.MyInfoResponse;
import com.prana.backend.user.service.UserService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
@AllArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<Void> signUp(@Valid @RequestBody SignUpRequest signUpRequest, @AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return userService.signUp(pranaPrincipal.getUserId(), signUpRequest);
    }

    @PutMapping
    public ResponseEntity<Void> updateMyInfo(@Valid @RequestBody PatchMyInfoRequest patchMyInfoRequest, @AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        if (patchMyInfoRequest.isEmpty()) {
            return ResponseEntity.ok().build();
        }
        return userService.updateMyInfo(pranaPrincipal.getUserId(), patchMyInfoRequest);
    }

    @GetMapping
    public ResponseEntity<MyInfoResponse> myInfo(@AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return userService.myInfo(pranaPrincipal.getUserId());
    }

}
