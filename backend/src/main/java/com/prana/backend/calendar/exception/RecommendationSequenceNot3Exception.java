package com.prana.backend.calendar.exception;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class RecommendationSequenceNot3Exception extends PranaException {
    public RecommendationSequenceNot3Exception(String details) {
        super(APIErrorCode.RECOMMENDATION_SEQUENCE_COUNT_MISMATCH, details);
    }
}
