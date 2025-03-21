package com.prana.backend.common.exception.general;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class UnauthorizedException extends PranaException {
  public UnauthorizedException() {
    super(APIErrorCode.UNAUTHORIZED);
  }
}
