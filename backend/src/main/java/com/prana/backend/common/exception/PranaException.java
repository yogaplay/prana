package com.prana.backend.common.exception;

import lombok.Getter;

@Getter
public class PranaException extends RuntimeException {
    private final APIErrorCode errorCode;
    private final String details;

    public PranaException(APIErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.details = null;
    }

    public PranaException(APIErrorCode errorCode, String details) {
        super(errorCode.getMessage() + " | " + details);
        this.errorCode = errorCode;
        this.details = details;
    }
}
