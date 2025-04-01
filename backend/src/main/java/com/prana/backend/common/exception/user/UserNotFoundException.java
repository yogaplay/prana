package com.prana.backend.common.exception.user;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class UserNotFoundException extends PranaException {
    public UserNotFoundException() {
        super(APIErrorCode.USER_NOT_FOUND);
    }
}
