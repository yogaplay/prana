package com.prana.backend.token.service;

import com.prana.backend.common.util.PranaTokenProvider;
import com.prana.backend.common.util.RandomName;
import com.prana.backend.token.controller.response.TokenResponse;
import com.prana.backend.token.service.dto.KakaoAccessTokenInfo;
import com.prana.backend.user.User;
import com.prana.backend.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Service
@AllArgsConstructor
public class TokenGenerateService {

    private final PranaTokenProvider pranaTokenProvider;
    private final UserRepository userRepository;

    /**
     * 토큰 생성을 책임진다.
     *
     * @param kakaoAccessTokenInfo 카카오 정보
     * @return 새로운 프라나 (액세스,리프레쉬) 토큰을 담은 TokenResponse
     */
    @Transactional
    public TokenResponse generatePranaToken(KakaoAccessTokenInfo kakaoAccessTokenInfo) {
        Optional<User> optionalUser = userRepository.findByKakaoId(kakaoAccessTokenInfo.getId());
        User user = optionalUser.orElseGet(() -> userRepository.save(
                User.builder()
                        .nickname(RandomName.getName())
                        .kakaoId(kakaoAccessTokenInfo.getId())
                        .build()
        ));
        Integer userId = user.getUserId();
        // userId 를 가지는 토큰 생성

        String pranaAccessToken = pranaTokenProvider.createJwtToken(userId, 1000L * 60 * 60, PranaTokenProvider.TOKEN_TYPE.ACCESS_TOKEN);
        String pranaRefreshToken = pranaTokenProvider.createJwtToken(userId, 1000L * 60 * 60 * 24 * 30, PranaTokenProvider.TOKEN_TYPE.REFRESH_TOKEN);
        return new TokenResponse(pranaAccessToken, pranaRefreshToken, optionalUser.isEmpty());
    }

}
