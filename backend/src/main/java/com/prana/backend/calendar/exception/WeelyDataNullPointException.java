package com.prana.backend.calendar.exception;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class WeelyDataNullPointException extends PranaException {
    public WeelyDataNullPointException(String details) {
        super(APIErrorCode.WEEKLY_DATA_NOT_FOUNT, details);
    }
}
