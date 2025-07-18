package com.prana.backend.common.util;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.JWSSigner;
import com.nimbusds.jose.crypto.RSASSASigner;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.time.Instant;
import java.util.Date;
import java.util.UUID;

@Slf4j
@Component
@AllArgsConstructor
public class PranaTokenProvider {

    private final RSAKey rsaKey;

    public enum TOKEN_TYPE {ACCESS_TOKEN, REFRESH_TOKEN}

    public boolean isRefreshToken(String token) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            JWTClaimsSet claims = signedJWT.getJWTClaimsSet();
            String type = claims.getClaimAsString("type");
            return type != null && type.equals(TOKEN_TYPE.REFRESH_TOKEN.toString());
        } catch (ParseException e) {
            return false;
        }
    }

    // JWT 유효성 검사
    public boolean validateToken(String token) {
        try {
            // 서명 검증
            SignedJWT signedJWT = SignedJWT.parse(token);
            return signedJWT.verify(new RSASSAVerifier(rsaKey));
        } catch (JOSEException | ParseException e) {
            return false;
        }
    }

    public boolean isNotExpired(String token) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            // 만료 시간이 현재 시간보다 이후인지 확인
            Date expirationTime = signedJWT.getJWTClaimsSet().getExpirationTime();
            return expirationTime != null && expirationTime.after(Date.from(Instant.now()));
        } catch (ParseException e) {
            return false;
        }
    }

    // JWT 에서 사용자 ID 추출
    public Integer getUserIdFromToken(String token) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            JWTClaimsSet claims = signedJWT.getJWTClaimsSet();
            return Integer.parseInt(claims.getSubject()); // subject 가 사용자 ID
        } catch (ParseException e) {
            return null;
        }
    }

    // 토큰 생성
    public String createJwtToken(Integer userId, long expiresIn, TOKEN_TYPE type) {
        try {
            JWSSigner signer = new RSASSASigner(rsaKey);
            Date now = new Date();
            Date expiration = new Date(now.getTime() + expiresIn);

            JWTClaimsSet claimsSet = new JWTClaimsSet.Builder()
                    .subject(String.valueOf(userId))
                    .claim("role", "kakao")
                    .claim("type", type.toString())
                    .issueTime(now)
                    .expirationTime(type.equals(TOKEN_TYPE.ACCESS_TOKEN) ? expiration : null)
                    .jwtID(UUID.randomUUID().toString())
                    .build();

            SignedJWT signedJWT = new SignedJWT(
                    new JWSHeader.Builder(JWSAlgorithm.RS256).keyID(rsaKey.getKeyID()).build(),
                    claimsSet
            );

            signedJWT.sign(signer);

            return signedJWT.serialize();
        } catch (JOSEException e) {
            log.error(e.getMessage(), e);
            throw new RuntimeException(e);
        }
    }

}
