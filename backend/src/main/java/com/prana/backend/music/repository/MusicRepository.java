package com.prana.backend.music.repository;

import com.prana.backend.entity.Music;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MusicRepository  extends CrudRepository<Music, Integer> {
}
