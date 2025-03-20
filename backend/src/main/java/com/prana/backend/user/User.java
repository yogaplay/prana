package com.prana.backend.user;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "user")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "nickname", nullable = false, length = 100)
    private String nickname;

    @Column(name = "height")
    private Short height;

    @Column(name = "age")
    private Short age;

    @Column(name = "weight")
    private Short weight;

    @Column(name = "gender", length = 1)
    private String gender;

    @Column(name = "kakao_id", nullable = false)
    private Long kakaoId;

}