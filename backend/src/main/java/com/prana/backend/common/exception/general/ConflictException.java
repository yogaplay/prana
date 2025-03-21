package com.prana.backend.common.exception.general;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class ConflictException extends PranaException {
  public ConflictException() {
    super(APIErrorCode.CONFLICT);
  }
}
