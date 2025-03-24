package com.prana.backend.home.controller;

import com.prana.backend.common.PranaPrincipal;
import com.prana.backend.home.controller.response.HomeResponse;
import com.prana.backend.home.service.HomeService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/home")
@AllArgsConstructor
public class HomeController {

    private final HomeService homeService;

    @GetMapping
    public ResponseEntity<HomeResponse> home(@AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return homeService.home(pranaPrincipal.getUserId());
    }
}
