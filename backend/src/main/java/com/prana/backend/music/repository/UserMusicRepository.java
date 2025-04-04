package com.prana.backend.music.repository;

import com.prana.backend.entity.UserMusic;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserMusicRepository extends CrudRepository<UserMusic, Integer> {
    Optional<UserMusic> findFirstByUser_IdOrderByMusicIdAsc(Integer userId);
}
