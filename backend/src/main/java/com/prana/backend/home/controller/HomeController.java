package com.prana.backend.home.controller;

import com.prana.backend.common.PagedResponse;
import com.prana.backend.common.PranaPrincipal;
import com.prana.backend.home.controller.request.PagedRecentRequest;
import com.prana.backend.home.controller.request.PagedStarRequest;
import com.prana.backend.home.controller.request.StaringRequest;
import com.prana.backend.home.controller.response.*;
import com.prana.backend.home.service.HomeService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/home")
@AllArgsConstructor
public class HomeController {

    private final HomeService homeService;

    @GetMapping
    public ResponseEntity<HomeResponse> home(@AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return homeService.home(pranaPrincipal.getUserId());
    }

    @GetMapping("/star")
    public ResponseEntity<PagedResponse<StarResponse>> pagedStar(@Valid PagedStarRequest request, @AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return homeService.pagedStar(request, pranaPrincipal.getUserId());
    }

    @PostMapping("/star")
    public ResponseEntity<StaringResponse> staring(@Valid @RequestBody StaringRequest request, @AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return homeService.staring(request, pranaPrincipal.getUserId());
    }

    @GetMapping("/recent")
    public ResponseEntity<PagedResponse<RecentResponse>> pagedRecent(@Valid PagedRecentRequest request, @AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return homeService.pagedRecent(request, pranaPrincipal.getUserId());
    }

}
