package com.prana.backend.common.exception.sequence;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class SequenceNotFoundException extends PranaException {
  public SequenceNotFoundException() {
    super(APIErrorCode.SEQUENCE_NOT_FOUND);
  }
}
