package com.prana.backend.common.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.prana.backend.common.exception.APIErrorCode;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class PranaAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final ObjectMapper objectMapper;

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("errorCode", APIErrorCode.INVALID_ACCESS_TOKEN.getCode());
        errorResponse.put("timestamp", LocalDateTime.now());
        errorResponse.put("message", APIErrorCode.INVALID_ACCESS_TOKEN.getMessage());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
    }
}
