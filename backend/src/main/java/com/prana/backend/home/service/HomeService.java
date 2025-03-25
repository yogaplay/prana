package com.prana.backend.home.service;

import com.prana.backend.common.exception.general.BadRequestException;
import com.prana.backend.entity.Sequence;
import com.prana.backend.entity.Star;
import com.prana.backend.entity.User;
import com.prana.backend.home.controller.request.PagedRecentRequest;
import com.prana.backend.home.controller.request.PagedStarRequest;
import com.prana.backend.home.controller.request.StaringRequest;
import com.prana.backend.home.controller.response.*;
import com.prana.backend.home.repository.CustomRecentRepository;
import com.prana.backend.home.repository.CustomReportRepository;
import com.prana.backend.home.repository.CustomStarRepository;
import com.prana.backend.home.repository.StarRepository;
import com.prana.backend.sequence.repository.SequenceRepository;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@AllArgsConstructor
public class HomeService {

    private final CustomReportRepository customReportRepository;
    private final CustomRecentRepository customRecentRepository;
    private final CustomStarRepository customStarRepository;
    private final StarRepository starRepository;
    private final SequenceRepository sequenceRepository;

    /**
     * 홈 화면에 필요한 3가지 [리포트, 최근, 즐겨찾기]
     *
     * @param userId 사용자 Id
     * @return ResponseEntity<HomeResponse>
     */
    @Transactional(readOnly = true)
    public ResponseEntity<HomeResponse> home(Integer userId) {
        ReportResponse report = customReportRepository.report(userId);
        List<RecentResponse> recentList = customRecentRepository.recent(userId);
        List<StarResponse> starList = customStarRepository.star(userId);
        // N + 1
        for (StarResponse star : starList) {
            star.setTagList(customStarRepository.starTagList(star.getSequenceId()));
        }
        HomeResponse homeResponse = HomeResponse
                .builder()
                .report(report)
                .recentList(recentList)
                .starList(starList)
                .build();
        return ResponseEntity.ok().body(homeResponse);
    }

    /**
     * 즐겨찾기 목록 페이지
     *
     * @param request PagedStarRequest
     * @param userId  사용자 Id
     * @return ResponseEntity<PagedResponse < StarResponse>>
     */
    @Transactional(readOnly = true)
    public ResponseEntity<PagedResponse<StarResponse>> pagedStar(PagedStarRequest request, Integer userId) {
        Pageable pageable = PageRequest.of(request.getPage(), request.getSize());
        Page<StarResponse> page = customStarRepository.pagedStar(pageable, userId);
        List<StarResponse> starList = page.getContent();
        // N + 1
        for (StarResponse star : starList) {
            star.setTagList(customStarRepository.starTagList(star.getSequenceId()));
        }
        PagedResponse<StarResponse> response = new PagedResponse<>(
                starList,
                page.getNumber(),
                page.getSize(),
                page.getTotalElements(),
                page.getTotalPages()
        );
        return ResponseEntity.ok().body(response);
    }

    /**
     * 즐겨찾기 하기
     *
     * @param request StaringRequest
     * @param userId  사용자 Id
     * @return ResponseEntity<StaringResponse>
     */
    @Transactional
    public ResponseEntity<StaringResponse> staring(StaringRequest request, Integer userId) {

        Sequence sequence = sequenceRepository.findById(request.getSequenceId())
                .orElseThrow(BadRequestException::new);

        Optional<Star> optionalStar = starRepository.findByUser_IdAndSequence_Id(userId, request.getSequenceId());
        if (optionalStar.isPresent()) {
            Star star = optionalStar.get();
            starRepository.delete(star);
            return ResponseEntity.ok().body(new StaringResponse(request.getSequenceId(), false));
        } else {
            starRepository.save(
                    Star
                            .builder()
                            .user(User.builder().id(userId).build())
                            .sequence(sequence)
                            .build()
            );
            return ResponseEntity.ok().body(new StaringResponse(request.getSequenceId(), true));
        }
    }

    @Transactional(readOnly = true)
    public ResponseEntity<PagedResponse<RecentResponse>> pagedRecent(@Valid PagedRecentRequest request, Integer userId) {
        Pageable pageable = PageRequest.of(request.getPage(), request.getSize());
        Page<RecentResponse> page = customRecentRepository.pagedRecent(pageable, userId);
        PagedResponse<RecentResponse> response = new PagedResponse<>(
                page.getContent(),
                page.getNumber(),
                page.getSize(),
                page.getTotalElements(),
                page.getTotalPages()
        );
        return ResponseEntity.ok().body(response);
    }
}
