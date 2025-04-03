package com.prana.backend.user_music.repository;

import com.prana.backend.entity.UserMusic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface JpaUserMusicRepository extends JpaRepository<UserMusic, Integer> {
    @Query("SELECT um.music.musicLocation FROM UserMusic um WHERE um.user.id = :userId")
    String findMusicLocationsByUserId(@Param("userId") Integer userId);
}
