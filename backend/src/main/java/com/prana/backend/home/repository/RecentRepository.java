package com.prana.backend.home.repository;

import com.prana.backend.entity.QSequence;
import com.prana.backend.entity.QUserSequence;
import com.prana.backend.home.controller.response.RecentResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class RecentRepository {

    private final JPAQueryFactory queryFactory;

    public List<RecentResponse> recent(Integer userId) {

        QUserSequence userSequence = QUserSequence.userSequence;
        QSequence sequence = QSequence.sequence;

        return queryFactory
                .select(Projections.bean(
                        RecentResponse.class,
                        sequence.id.as("sequenceId"),
                        userSequence.id.as("userSequenceId"),
                        sequence.name.as("sequenceName"),
                        sequence.image.as("image"),
                        userSequence.resultStatus.as("resultStatus"),
                        userSequence.lastPoint.multiply(100).divide(sequence.yogaCount).as("percent"),
                        userSequence.updatedAt.as("updatedAt")
                ))
                .from(userSequence)
                .join(sequence).on(userSequence.sequence.eq(sequence))
                .where(userSequence.user.id.eq(userId))
                .orderBy(userSequence.createdDate.desc())
                .limit(1)
                .fetch();
    }


}
