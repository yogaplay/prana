package com.prana.backend.user.repository;


import com.prana.backend.entity.User;
import com.prana.backend.user.repository.dto.FindHeightAndWeightDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByKakaoId(Long kakaoId);

    @Query("SELECT u.id FROM User u")
    List<Integer> findAllUserId();

    @Query("""
        SELECT new com.prana.backend.user.repository.dto.FindHeightAndWeightDTO(u.id, u.height, u.weight)
        FROM User u
    """)
    List<FindHeightAndWeightDTO> findHeightAndWeight();
}
