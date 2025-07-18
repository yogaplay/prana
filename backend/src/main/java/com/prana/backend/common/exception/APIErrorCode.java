package com.prana.backend.common.exception;

import lombok.Getter;

@Getter
public enum APIErrorCode {
    // 400 Bad Request
    BAD_REQUEST(40000, "Bad Request"),
    INVALID_INPUT(40001, "유효하지 않은 값입니다."),
    RECOMMENDATION_SEQUENCE_COUNT_MISMATCH(40002, "추천 시퀀스 개수가 부족하거나 초과되었습니다."),
    INVALID_YEAR_MONTH_FORMAT(40003, "날짜 형식이 잘못되었습니다"),

    // 401 Unauthorized
    UNAUTHORIZED(40100, "Unauthorized"),
    REFRESH_TOKEN_REQUIRED(40110, "Refresh Token이 존재하지 않습니다."),
    INVALID_REFRESH_TOKEN(40111, "유효하지 않은 Refresh Token입니다."),
    INVALID_ACCESS_TOKEN(40112, "유효하지 않은 Access Token입니다."),
    UNREGISTERED_USER(40113, "등록되지 않은 사용자입니다."),
    INVALID_KAKAO_ACCESS_TOKEN(40114, "유효하지 않은 Kakao Access Token입니다."),

    // 403 Forbidden
    FORBIDDEN(40300, "Forbidden"),
    USER_NOT_FORBIDDEN(40311, "접근이 허용되지 않은 사용자입니다."),

    // 404 Not Found
    NOT_FOUND(40400, "Not Found"),
    USER_NOT_FOUND(40410, "존재하지 않는 사용자입니다."),
    SEQUENCE_NOT_FOUND(40411, "존재하지 않는 시퀀스입니다."),
    WEEKLY_DATA_NOT_FOUND(40412, "주간 리포트 데이터가 존재하지 않습니다."),
    ACTIVE_DATA_NOT_FOUND(40413, "해당 달에 운동한 데이터가 없습니다."),
    MUSIC_NOT_FOUND(40414, "존재하지 않는 음악입니다."),

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
