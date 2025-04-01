package com.prana.backend.common.exception.general;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class KakaoException extends PranaException {
    public KakaoException() {
        super(APIErrorCode.INTERNAL_KAKAO_ERROR);
    }
}