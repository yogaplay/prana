package com.prana.backend.common.exception;

import lombok.Getter;

@Getter
public class PranaException extends RuntimeException {
    private final ErrorCode errorCode;
    private final String details;

    public PranaException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.details = null;
    }

    public PranaException(ErrorCode errorCode, String details) {
        super(errorCode.getMessage() + " | " + details);
        this.errorCode = errorCode;
        this.details = details;
    }
}
