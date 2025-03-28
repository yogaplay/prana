package com.prana.backend.look.controller;

import com.prana.backend.common.PagedResponse;
import com.prana.backend.look.controller.request.LookRequest;
import com.prana.backend.look.controller.request.LookSearchRequest;
import com.prana.backend.look.controller.response.LookResult;
import com.prana.backend.look.controller.response.LookSearchResponse;
import com.prana.backend.look.service.LookService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/look")
@AllArgsConstructor
public class LookController {

    private final LookService lookService;

    @GetMapping
    public ResponseEntity<LookResult> look(@Valid LookRequest request) {
        return lookService.look(request);
    }

    @GetMapping("/search")
    public ResponseEntity<PagedResponse<LookSearchResponse>> lookSearch(@Valid LookSearchRequest request) {
        return lookService.lookSearch(request);
    }

}
