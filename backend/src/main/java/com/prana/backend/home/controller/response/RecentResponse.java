package com.prana.backend.home.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecentResponse {

    private int sequenceId;
    private int userSequenceId;
    private String sequenceName;
    private String image;
    private char resultStatus;
    private int percent;
    private LocalDateTime updatedAt;

}
