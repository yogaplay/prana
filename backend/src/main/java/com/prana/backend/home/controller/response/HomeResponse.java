package com.prana.backend.home.controller.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HomeResponse {

    private ReportResponse report;
    private List<RecentResponse> recentList;
    private List<StarResponse> starList;
}
