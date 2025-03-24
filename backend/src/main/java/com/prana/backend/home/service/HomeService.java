package com.prana.backend.home.service;

import com.prana.backend.home.controller.response.HomeResponse;
import com.prana.backend.home.controller.response.RecentResponse;
import com.prana.backend.home.controller.response.ReportResponse;
import com.prana.backend.home.controller.response.StarResponse;
import com.prana.backend.home.repository.RecentRepository;
import com.prana.backend.home.repository.ReportRepository;
import com.prana.backend.home.repository.StarRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@AllArgsConstructor
public class HomeService {

    private final ReportRepository reportRepository;
    private final RecentRepository recentRepository;
    private final StarRepository starRepository;

    /**
     * 홈 화면에 필요한 3가지 [리포트, 최근, 즐겨찾기]
     *
     * @param userId 사용자 Id
     * @return ResponseEntity<HomeResponse>
     */
    @Transactional(readOnly = true)
    public ResponseEntity<HomeResponse> home(Integer userId) {
        ReportResponse report = reportRepository.report(userId);
        List<RecentResponse> recentList = recentRepository.recent(userId);
        List<StarResponse> starList = starRepository.star(userId);
        HomeResponse homeResponse = HomeResponse
                .builder()
                .report(report)
                .recentList(recentList)
                .starList(starList)
                .build();
        return ResponseEntity.ok().body(homeResponse);
    }

}
