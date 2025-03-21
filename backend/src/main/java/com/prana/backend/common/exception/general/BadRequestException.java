package com.prana.backend.common.exception.general;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class BadRequestException extends PranaException {
  public BadRequestException() {
    super(APIErrorCode.BAD_REQUEST);
  }
}
