package com.prana.backend.token.controller;

import com.prana.backend.token.controller.request.RefreshRequest;
import com.prana.backend.token.controller.request.TokenRequest;
import com.prana.backend.token.controller.response.RefreshResponse;
import com.prana.backend.token.controller.response.TokenResponse;
import com.prana.backend.token.service.TokenService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/token")
@AllArgsConstructor
public class TokenController {

    private final TokenService tokenService;

    @PostMapping("/generate")
    public ResponseEntity<TokenResponse> generate(@Valid @RequestBody TokenRequest tokenRequest) {
        return tokenService.generate(tokenRequest);
    }

    @PostMapping("/refresh")
    public ResponseEntity<RefreshResponse> refresh(@Valid @RequestBody RefreshRequest refreshRequest) {
        return tokenService.refresh(refreshRequest);
    }

}
