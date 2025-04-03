package com.prana.backend.music.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MusicResponse {
    private int musicId;
    private String musicLocation;
    private String name;
}
