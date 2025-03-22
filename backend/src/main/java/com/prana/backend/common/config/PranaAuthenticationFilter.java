package com.prana.backend.common.config;

import com.prana.backend.common.PranaPrincipal;
import com.prana.backend.common.util.PranaTokenProvider;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@Component
@AllArgsConstructor
public class PranaAuthenticationFilter extends OncePerRequestFilter {

    private final PranaTokenProvider pranaTokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        String token = resolveToken(request); // 토큰을 요청에서 추출하는 메서드
        if (token != null && pranaTokenProvider.validateToken(token) && pranaTokenProvider.isNotExpired(token)) {
            Integer userId = pranaTokenProvider.getUserIdFromToken(token); // JWT 에서 사용자 ID를 추출

            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(new PranaPrincipal(userId), null, null); // 인증 객체 생성
            SecurityContextHolder.getContext().setAuthentication(authentication); // 인증 정보 설정
        }
        filterChain.doFilter(request, response); // 다음 필터로 진행
    }

    // 헤더에서 토큰 추출
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7); // "Bearer " 제거 후 토큰 반환
        }
        return null;
    }
}
