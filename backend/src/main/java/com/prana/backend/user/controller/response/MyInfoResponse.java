package com.prana.backend.user.controller.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MyInfoResponse {

    private String nickname;
    private Short height;
    private Short age;
    private Short weight;
    private String gender;

}
