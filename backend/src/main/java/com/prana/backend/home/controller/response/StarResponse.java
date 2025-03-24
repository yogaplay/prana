package com.prana.backend.home.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class StarResponse {

    private int sequenceId;
    private String sequenceName;
    private String image;
    private boolean star;

}
