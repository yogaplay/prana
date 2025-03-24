package com.prana.backend.home.repository;

import com.prana.backend.entity.QSequence;
import com.prana.backend.entity.QStar;
import com.prana.backend.home.controller.response.StarResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class StarRepository {

    private final JPAQueryFactory queryFactory;

    public List<StarResponse> star(Integer userId) {

        QSequence sequence = QSequence.sequence;
        QStar star = QStar.star;

        return queryFactory
                .select(Projections.bean(
                        StarResponse.class,
                        sequence.id.as("sequenceId"),
                        sequence.name.as("sequenceName"),
                        sequence.image.as("image"),
                        star.id.isNotNull().as("star")
                ))
                .from(star)
                .join(sequence).on(star.sequence.eq(sequence))
                .where(star.user.id.eq(userId))
                .orderBy(sequence.id.asc())
                .limit(1)
                .fetch();

    }


}
