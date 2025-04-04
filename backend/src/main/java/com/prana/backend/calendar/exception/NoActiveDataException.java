package com.prana.backend.calendar.exception;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class NoActiveDataException extends PranaException {
    public NoActiveDataException(String details) {
        super(APIErrorCode.ACTIVE_DATA_NOT_FOUND, details);
    }
}
