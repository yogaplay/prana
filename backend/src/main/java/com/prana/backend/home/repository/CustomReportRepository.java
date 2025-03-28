package com.prana.backend.home.repository;

import com.prana.backend.entity.QSequence;
import com.prana.backend.entity.QUser;
import com.prana.backend.entity.QUserSequence;
import com.prana.backend.home.controller.response.ReportResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class CustomReportRepository {

    private final JPAQueryFactory queryFactory;

    public ReportResponse report(Integer userId) {

        QUserSequence userSequence = QUserSequence.userSequence;
        QSequence sequence = QSequence.sequence;
        QUser user = QUser.user;

        return queryFactory
                .select(Projections.bean(ReportResponse.class,
                        user.id.as("userId"),
                        user.nickname.as("nickname"),
                        user.streakDays.as("streakDays"),
                        sequence.time.sum().as("totalTime"),
                        userSequence.count().as("totalYogaCnt")
                ))
                .from(user)
                .leftJoin(userSequence).on(user.eq(userSequence.user))
                .leftJoin(sequence).on(userSequence.sequence.eq(sequence))
                .where(user.id.eq(userId))
                .groupBy(user.id)
                .fetchOne();

    }
}
