package com.prana.backend.user.repository;

import com.prana.backend.entity.QUser;
import com.prana.backend.user.controller.request.PatchMyInfoRequest;
import com.prana.backend.user.controller.request.SignUpRequest;
import com.prana.backend.user.controller.response.MyInfoResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.querydsl.jpa.impl.JPAUpdateClause;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class SignUpRepository {

    private final JPAQueryFactory queryFactory;

    public void signUp(Integer userId, SignUpRequest signUpRequest) {
        QUser user = QUser.user;
        queryFactory.update(user)
                .set(user.height, signUpRequest.getHeight())
                .set(user.age, signUpRequest.getAge())
                .set(user.weight, signUpRequest.getWeight())
                .set(user.gender, signUpRequest.getGender())
                .where(user.id.eq(userId))
                .execute();
    }

    public void updateMyInfo(Integer userId, PatchMyInfoRequest request) {
        QUser user = QUser.user;
        JPAUpdateClause updateClause = queryFactory.update(user);

        if (request.getNickname() != null) {
            updateClause.set(user.nickname, request.getNickname());
        }
        if (request.getHeight() != null) {
            updateClause.set(user.height, request.getHeight());
        }
        if (request.getAge() != null) {
            updateClause.set(user.age, request.getAge());
        }
        if (request.getWeight() != null) {
            updateClause.set(user.weight, request.getWeight());
        }
        if (request.getGender() != null) {
            updateClause.set(user.gender, request.getGender());
        }

        updateClause.where(user.id.eq(userId))
                .execute();
    }

    public MyInfoResponse myInfo(Integer userId) {
        QUser user = QUser.user;
        return queryFactory
                .select(Projections.bean(
                        MyInfoResponse.class,
                        user.nickname.as("nickname"),
                        user.height.as("height"),
                        user.age.as("age"),
                        user.weight.as("weight"),
                        user.gender.as("gender")
                ))
                .from(user)
                .where(user.id.eq(userId))
                .fetchOne();
    }
}
