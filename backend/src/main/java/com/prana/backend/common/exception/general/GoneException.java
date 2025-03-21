package com.prana.backend.common.exception.general;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class GoneException extends PranaException {
    public GoneException() {
        super(APIErrorCode.GONE);
    }
}
