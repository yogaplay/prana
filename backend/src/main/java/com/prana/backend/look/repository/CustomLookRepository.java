package com.prana.backend.look.repository;


import com.prana.backend.entity.QSequence;
import com.prana.backend.entity.QSequenceTag;
import com.prana.backend.look.controller.response.LookSampleResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class CustomLookRepository {

    private final JPAQueryFactory queryFactory;

    public List<LookSampleResponse> sampleList(Integer tagId, int sampleSize) {

        QSequence sequence = QSequence.sequence;
        QSequenceTag sequenceTag = QSequenceTag.sequenceTag;

        return queryFactory
                .select(Projections.bean(
                        LookSampleResponse.class,
                        sequence.id.as("sequenceId"),
                        sequence.name.as("sequenceName"),
                        sequence.time.as("sequenceTime"),
                        sequence.image.as("sequenceImage")
                ))
                .from(sequenceTag)
                .join(sequence).on(sequenceTag.sequence.eq(sequence))
                .where(sequenceTag.tag.id.eq(tagId))
                .orderBy(Expressions.numberTemplate(Double.class, "RAND()").asc())
                .limit(sampleSize)
                .fetch();
    }
}
