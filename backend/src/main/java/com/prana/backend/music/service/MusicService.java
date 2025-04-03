package com.prana.backend.music.service;

import com.prana.backend.common.exception.music.MusicNotFoundException;
import com.prana.backend.common.exception.user.UserNotFoundException;
import com.prana.backend.entity.Music;
import com.prana.backend.entity.User;
import com.prana.backend.entity.UserMusic;
import com.prana.backend.music.controller.request.MusicRequest;
import com.prana.backend.music.controller.response.MusicListResponse;
import com.prana.backend.music.controller.response.MusicResponse;
import com.prana.backend.music.repository.CustomMusicRepository;
import com.prana.backend.music.repository.MusicRepository;
import com.prana.backend.music.repository.UserMusicRepository;
import com.prana.backend.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@AllArgsConstructor
public class MusicService {

    private final UserRepository userRepository;
    private final MusicRepository musicRepository;
    private final UserMusicRepository userMusicRepository;
    private final CustomMusicRepository customMusicRepository;

    /**
     * 모든 요가 음악 조회
     *
     * @return ResponseEntity<MusicListResponse>
     */
    @Transactional(readOnly = true)
    public ResponseEntity<MusicListResponse> musicList() {
        List<MusicResponse> musicResponseList = customMusicRepository.musicList();
        return ResponseEntity.ok().body(new MusicListResponse(musicResponseList));
    }

    /**
     * 내 요가 음악 조회
     *
     * @param userId 사용자 ID
     * @return ResponseEntity<MusicResponse>
     */
    @Transactional(readOnly = true)
    public ResponseEntity<MusicResponse> myMusic(Integer userId) {
        MusicResponse musicResponse = customMusicRepository.myMusic(userId);
        if (musicResponse == null) {
            musicResponse = customMusicRepository.defaultMusic();
        }
        return ResponseEntity.ok().body(musicResponse);
    }

    /**
     * 내 요가 음악 설정
     *
     * @param request MusicRequest
     * @param userId  사용자 ID
     * @return ResponseEntity<Void>
     */
    @Transactional
    public ResponseEntity<Void> setMyMusic(MusicRequest request, Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(UserNotFoundException::new);
        Music music = musicRepository.findById(request.getMusicId())
                .orElseThrow(MusicNotFoundException::new);

        Optional<UserMusic> optionalUserMusic = userMusicRepository.findFirstByUser_IdOrderByMusicIdAsc(user.getId());
        if (optionalUserMusic.isPresent()) {
            optionalUserMusic.get().setMusic(music);
        } else {
            userMusicRepository.save(
                    UserMusic.builder()
                            .user(user)
                            .music(music)
                            .build()
            );
        }

        return ResponseEntity.ok().build();
    }

}
