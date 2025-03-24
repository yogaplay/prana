package com.prana.backend.user.repository;

import com.prana.backend.user.QUser;
import com.prana.backend.user.controller.request.SignUpRequest;
import com.querydsl.jpa.impl.JPAQueryFactory;
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
                .where(user.userId.eq(userId))
                .execute();
    }

}
