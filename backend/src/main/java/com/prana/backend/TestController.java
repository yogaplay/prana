package com.prana.backend;

import com.prana.backend.common.PranaPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/test")
public class TestController {

    @GetMapping
    public ResponseEntity<Integer> generate(@AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return ResponseEntity.ok().body(pranaPrincipal.getUserId());
    }

}
