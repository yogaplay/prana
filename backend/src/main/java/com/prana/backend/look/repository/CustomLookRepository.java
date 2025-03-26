package com.prana.backend.look.repository;


import com.prana.backend.entity.QSequence;
import com.prana.backend.entity.QSequenceTag;
import com.prana.backend.entity.QTag;
import com.prana.backend.look.controller.request.LookSearchRequest;
import com.prana.backend.look.controller.response.LookSampleResponse;
import com.prana.backend.look.controller.response.LookSearchResponse;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

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

    public Page<LookSearchResponse> lookSearch(Pageable pageable, LookSearchRequest request) {

        QSequence sequence = QSequence.sequence;
        QSequenceTag sequenceTag = QSequenceTag.sequenceTag;
        QTag tag = QTag.tag;


        BooleanBuilder whereBuilder = new BooleanBuilder();


        if (StringUtils.hasText(request.getKeyword())) {
            whereBuilder.or(sequence.name.containsIgnoreCase(request.getKeyword()));
        }

        if (request.getTagIdList() != null && !request.getTagIdList().isEmpty()) {
            whereBuilder.or(tag.id.in(request.getTagIdList()));
        }

        if (request.getTagNameList() != null && !request.getTagNameList().isEmpty()) {
            whereBuilder.or(tag.name.in(request.getTagNameList()));
        }

        List<LookSearchResponse> content = queryFactory
                .select(Projections.bean(
                        LookSearchResponse.class,
                        sequence.id.as("sequenceId"),
                        sequence.name.as("sequenceName"),
                        sequence.image.as("image"),
                        Expressions.stringTemplate("GROUP_CONCAT({0})", tag.name).as("tags")
                ))
                .from(sequenceTag)
                .join(sequence).on(sequenceTag.sequence.eq(sequence))
                .join(tag).on(sequenceTag.tag.eq(tag))
                .where(
                        whereBuilder
                )
                .groupBy(sequence.id) // Group to avoid duplicates
                .orderBy(sequence.id.asc())
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> countQuery = queryFactory
                .select(sequence.countDistinct()) // Distinct
                .from(sequenceTag)
                .join(sequence).on(sequenceTag.sequence.eq(sequence))
                .join(tag).on(sequenceTag.tag.eq(tag))
                .where(
                        whereBuilder
                );

        return PageableExecutionUtils.getPage(content, pageable, countQuery::fetchOne);
    }

}