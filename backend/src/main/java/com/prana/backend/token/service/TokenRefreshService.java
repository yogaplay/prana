package com.prana.backend.token.service;

import com.prana.backend.common.exception.PranaException;
import com.prana.backend.common.util.PranaTokenProvider;
import com.prana.backend.token.controller.response.RefreshResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import static com.prana.backend.common.exception.APIErrorCode.INVALID_REFRESH_TOKEN;

@Slf4j
@Service
@AllArgsConstructor
public class TokenRefreshService {

    private final PranaTokenProvider pranaTokenProvider;

    /**
     * 토큰 재발급을 책임진다.
     *
     * @param pranaRefreshToken 프란 리프레쉬 토큰
     * @return 새로운 프라나 액세스 토큰을 담은 RefreshResponse
     */
    public RefreshResponse refreshPranaToken(String pranaRefreshToken) {
        if (pranaTokenProvider.validateToken(pranaRefreshToken) &&
                pranaTokenProvider.isRefreshToken(pranaRefreshToken)) {
            Integer userId = pranaTokenProvider.getUserIdFromToken(pranaRefreshToken);
            String pranaAccessToken = pranaTokenProvider.createJwtToken(userId, 1000L * 60 * 60, PranaTokenProvider.TOKEN_TYPE.ACCESS_TOKEN);
            return new RefreshResponse(pranaAccessToken);
        }
        throw new PranaException(INVALID_REFRESH_TOKEN);
    }
}
