package com.prana.backend.music.repository;

import com.prana.backend.entity.QMusic;
import com.prana.backend.entity.QUserMusic;
import com.prana.backend.music.controller.response.MusicResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class CustomMusicRepository {

    private final JPAQueryFactory queryFactory;

    public List<MusicResponse> musicList() {

        QMusic music = QMusic.music;

        return queryFactory
                .select(Projections.bean(
                        MusicResponse.class,
                        music.id.as("musicId"),
                        music.musicLocation.as("musicLocation"),
                        music.name.as("name")
                ))
                .from(music)
                .orderBy(music.name.asc())
                .fetch();
    }

    public MusicResponse myMusic(Integer userId) {
        QMusic music = QMusic.music;
        QUserMusic userMusic = QUserMusic.userMusic;
        return queryFactory
                .select(Projections.bean(
                        MusicResponse.class,
                        music.id.as("musicId"),
                        music.musicLocation.as("musicLocation"),
                        music.name.as("name")
                ))
                .from(userMusic)
                .join(music).on(userMusic.music.eq(music))
                .where(userMusic.user.id.eq(userId))
                .orderBy(music.id.asc())
                .fetchFirst();
    }

    public MusicResponse defaultMusic() {
        QMusic music = QMusic.music;
        return queryFactory
                .select(Projections.bean(
                        MusicResponse.class,
                        music.id.as("musicId"),
                        music.musicLocation.as("musicLocation"),
                        music.name.as("name")
                ))
                .from(music)
                .orderBy(music.id.asc())
                .fetchFirst();
    }

}
