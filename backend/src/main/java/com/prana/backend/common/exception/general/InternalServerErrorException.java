package com.prana.backend.common.exception.general;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class InternalServerErrorException extends PranaException {
  public InternalServerErrorException() {
    super(APIErrorCode.INTERNAL_SERVER_ERROR);
  }
}
