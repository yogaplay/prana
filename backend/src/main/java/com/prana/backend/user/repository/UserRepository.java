package com.prana.backend.user.repository;


import com.prana.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByKakaoId(Long kakaoId);
}
