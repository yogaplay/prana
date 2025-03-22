package com.prana.backend.token.service;

import com.prana.backend.common.exception.PranaException;
import com.prana.backend.common.util.KaKaoApi;
import com.prana.backend.token.controller.request.RefreshRequest;
import com.prana.backend.token.controller.request.TokenRequest;
import com.prana.backend.token.controller.response.RefreshResponse;
import com.prana.backend.token.controller.response.TokenResponse;
import com.prana.backend.token.service.dto.KakaoAccessTokenInfo;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import static com.prana.backend.common.exception.APIErrorCode.INVALID_KAKAO_ACCESS_TOKEN;

@Slf4j
@Service
@AllArgsConstructor
public class TokenService {

    private final KaKaoApi kaKaoApi;
    private TokenGenerateService tokenGenerateService;
    private TokenRefreshService tokenRefreshService;

    /**
     * 카카오 액세스 토큰을 검증하고 프란의 토큰을 생성한다.
     *
     * @param tokenRequest 카카오 액세스 토큰
     * @return 프란의 토큰 쌍
     */
    public ResponseEntity<TokenResponse> generate(TokenRequest tokenRequest) {
        // Request 본문에서 access_token 추출
        String accessToken = tokenRequest.getKakaoAccessToken();

        // 카카오 API 호출하여 사용자 정보 가져오기
        KakaoAccessTokenInfo kakaoAccessTokenInfo = kaKaoApi.getKakaoAccessTokenInfo(accessToken);
        if (kakaoAccessTokenInfo != null) {
            // 토큰이 유효하면 토큰 발급
            TokenResponse tokenResponse = tokenGenerateService.generatePranaToken(kakaoAccessTokenInfo);
            return ResponseEntity.ok(tokenResponse);
        }
        throw new PranaException(INVALID_KAKAO_ACCESS_TOKEN);
    }

    /**
     * 프란의 토큰 갱신
     *
     * @param refreshRequest 프란 리프레쉬 토큰
     * @return 프란의 액세스 토큰
     */
    public ResponseEntity<RefreshResponse> refresh(RefreshRequest refreshRequest) {
        String pranaRefreshToken = refreshRequest.getPranaRefreshToken();
        RefreshResponse refreshResponse = tokenRefreshService.refreshPranaToken(pranaRefreshToken);
        return ResponseEntity.ok(refreshResponse);
    }

}
