package com.prana.backend.token.service.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class KakaoAccessTokenInfo {
    private Long id;
    private Integer expiresIn;
    private Integer appId;
}
