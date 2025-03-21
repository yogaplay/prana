package com.prana.backend.common.exception.general;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class ForbiddenException extends PranaException {
  public ForbiddenException() {
    super(APIErrorCode.FORBIDDEN);
  }
}
