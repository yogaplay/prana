package com.prana.backend.user.service;

import com.prana.backend.user.controller.request.SignUpRequest;
import com.prana.backend.user.repository.SignUpRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@AllArgsConstructor
public class UserService {

    private SignUpRepository signUpRepository;

    /**
     * 최초 회원정보 입력
     *
     * @param userId        사용자 Id
     * @param signUpRequest SignUpRequest
     * @return ResponseEntity<Void>
     */
    @Transactional
    public ResponseEntity<Void> signUp(Integer userId, SignUpRequest signUpRequest) {
        signUpRepository.signUp(userId, signUpRequest);
        return ResponseEntity.ok().build();
    }

}
