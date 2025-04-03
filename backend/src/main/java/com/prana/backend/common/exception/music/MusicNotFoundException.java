package com.prana.backend.common.exception.music;

import com.prana.backend.common.exception.APIErrorCode;
import com.prana.backend.common.exception.PranaException;

public class MusicNotFoundException extends PranaException {
    public MusicNotFoundException() {
        super(APIErrorCode.MUSIC_NOT_FOUND);
    }
}
