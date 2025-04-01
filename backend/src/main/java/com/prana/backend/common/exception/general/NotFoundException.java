package com.prana.backend.common.exception.general;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class NotFoundException extends PranaException {
  public NotFoundException() {
    super(APIErrorCode.NOT_FOUND);
  }
}
