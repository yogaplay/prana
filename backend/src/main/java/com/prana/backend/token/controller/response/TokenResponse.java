package com.prana.backend.token.controller.response;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TokenResponse {
    private String pranaAccessToken;
    private String pranaRefreshToken;
    private Boolean isFirst;
}
