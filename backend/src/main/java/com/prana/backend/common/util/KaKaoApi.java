package com.prana.backend.common.util;

import com.prana.backend.common.exception.general.KakaoException;
import com.prana.backend.token.service.dto.KakaoAccessTokenInfo;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Slf4j
@Component
@AllArgsConstructor
public class KaKaoApi {

    private static final String KAKAO_API_URL = "https://kapi.kakao.com/v1/user/access_token_info";

    private final RestTemplate restTemplate;

    public KakaoAccessTokenInfo getKakaoAccessTokenInfo(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        try {
            ResponseEntity<KakaoAccessTokenInfo> response = restTemplate.exchange(
                    KAKAO_API_URL,
                    HttpMethod.GET,
                    new HttpEntity<>(headers),
                    KakaoAccessTokenInfo.class
            );
            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody();
            } else {
                throw new KakaoException();
            }
        } catch (RestClientException e) {
            log.error(e.getMessage(), e);
        }
        return null;
    }

}
