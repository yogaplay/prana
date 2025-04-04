package com.prana.backend.music.controller;

import com.prana.backend.common.PranaPrincipal;
import com.prana.backend.music.controller.request.MusicRequest;
import com.prana.backend.music.controller.response.MusicListResponse;
import com.prana.backend.music.controller.response.MusicResponse;
import com.prana.backend.music.service.MusicService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/music")
@AllArgsConstructor
public class MusicController {

    private final MusicService musicService;

    // 모든 요가 음악 조회
    @GetMapping("/list")
    public ResponseEntity<MusicListResponse> musicList() {
        return musicService.musicList();
    }

    // 내 요가 음악 조회
    @GetMapping
    public ResponseEntity<MusicResponse> myMusic(@AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return musicService.myMusic(pranaPrincipal.getUserId());
    }

    // 내 요가 음악 설정
    @PostMapping
    public ResponseEntity<Void> setMyMusic(@Valid @RequestBody MusicRequest request, @AuthenticationPrincipal PranaPrincipal pranaPrincipal) {
        return musicService.setMyMusic(request, pranaPrincipal.getUserId());
    }

}
