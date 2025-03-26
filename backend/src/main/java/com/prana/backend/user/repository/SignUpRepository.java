package com.prana.backend.user.repository;

import com.prana.backend.entity.QUser;
import com.prana.backend.user.controller.request.PatchMyInfoRequest;
import com.prana.backend.user.controller.request.SignUpRequest;
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

}
