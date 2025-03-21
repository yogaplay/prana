package com.prana.backend.common.exception;

import lombok.Getter;

@Getter
public enum APIErrorCode implements ErrorCode {
    // 400 Bad Request
    BAD_REQUEST(40000, "Bad Request"),
    INVALID_INPUT(40001, "유효하지 않은 값입니다."),

    // 401 Unauthorized
    UNAUTHORIZED(40100, "Unauthorized"),
    REFRESH_TOKEN_REQUIRED(40110, "Refresh Token이 존재하지 않습니다."),
    INVALID_REFRESH_TOKEN(40111, "유효하지 않은 Refresh Token입니다."),
    INVALID_ACCESS_TOKEN(40112, "유효하지 않은 Access Token입니다."),
    UNREGISTERED_USER(40113, "등록되지 않은 사용자입니다."),

    // 403 Forbidden
    FORBIDDEN(40300, "Forbidden"),
    USER_NOT_FORBIDDEN(40311, "접근이 허용되지 않은 사용자입니다."),

    // 404 Not Found
    NOT_FOUND(40400, "Not Found"),
    USER_NOT_FOUND(40410, "존재하지 않는 사용자입니다."),

    // 409 Conflict
    CONFLICT(40900, "Conflict"),


    // 410 Gone
    GONE(41000, "Gone"),

    // 500 Internal Server Error
    INTERNAL_SERVER_ERROR(50000, "Internal server error"),
    INTERNAL_KAKAO_ERROR(50001, "Internal kakao server error"),
    ;

    private final int code;
    private final String message;

    APIErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}
