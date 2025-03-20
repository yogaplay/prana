package com.prana.backend.token.service;

import com.prana.backend.common.util.KaKaoApi;
import com.prana.backend.token.controller.request.TokenRequest;
import com.prana.backend.token.controller.response.TokenResponse;
import com.prana.backend.token.service.dto.KakaoAccessTokenInfo;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@AllArgsConstructor
public class TokenService {

    private final KaKaoApi kaKaoApi;
    private TokenGenerateService tokenGenerateService;

    public ResponseEntity<TokenResponse> generate(TokenRequest tokenRequest) {
        // Request 본문에서 access_token 추출
        String accessToken = tokenRequest.getKakaoAccessToken();

        // 카카오 API 호출하여 사용자 정보 가져오기
        KakaoAccessTokenInfo kakaoAccessTokenInfo = kaKaoApi.getKakaoAccessTokenInfo(accessToken);
        if (kakaoAccessTokenInfo != null) {
            // 토큰이 유효하면 토큰 발급
            TokenResponse tokenResponse = tokenGenerateService.generatePranaToken(kakaoAccessTokenInfo);
            return ResponseEntity.ok(tokenResponse);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }

}
