package com.prana.backend.calendar.exception;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class InvalidYearMonthFormatException extends PranaException {
    public InvalidYearMonthFormatException(String details) {
        super(APIErrorCode.INVALID_YEAR_MONTH_FORMAT, details);
    }
}
