package com.prana.backend.look.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LookSearchResponse {

    private int sequenceId;
    private String sequenceName;
    private String image;
    private List<String> tagList;
}
