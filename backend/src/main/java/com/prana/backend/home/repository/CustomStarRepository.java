package com.prana.backend.home.repository;

import com.prana.backend.entity.*;
import com.prana.backend.home.controller.response.StarResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;

import java.util.List;

@Slf4j
@Repository
@RequiredArgsConstructor
public class CustomStarRepository {

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


    public List<String> starTagList(Integer sequenceId) {

        QTag tag = QTag.tag;
        QSequenceTag sequenceTag = QSequenceTag.sequenceTag;

        return queryFactory
                .select(tag.name)
                .from(sequenceTag)
                .join(tag).on(sequenceTag.tag.eq(tag))
                .where(sequenceTag.sequence.id.eq(sequenceId))
                .orderBy(tag.type.asc(), tag.id.asc())
                .fetch();
    }


    public Page<StarResponse> pagedStar(Pageable pageable, Integer userId) {

        QSequence sequence = QSequence.sequence;
        QStar star = QStar.star;

        List<StarResponse> content = queryFactory
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
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> countQuery = queryFactory
                .select(star.count())
                .from(star)
                .join(sequence).on(star.sequence.eq(sequence))
                .where(star.user.id.eq(userId));

        return PageableExecutionUtils.getPage(content, pageable, countQuery::fetchOne);
    }


}
