package com.prana.backend.common.util;

import java.util.Random;


public class RandomName {

    private static final String[] adjectives = {
            "유연한", "고요한", "평온한",
            "집중된", "깊은",
    };

    private static final String[] nouns = {
            "호흡", "균형", "흐름", "명상", "평온",
            "자연", "에너지", "마음", "움직임", "조화"
    };

    private static final Random random = new Random();

    public static String getName() {
        // 랜덤 형용사 선택
        String randomAdjective = adjectives[random.nextInt(adjectives.length)];
        // 랜덤 명사 선택
        String randomNoun = nouns[random.nextInt(nouns.length)];
        // 1~1000 사이의 랜덤 숫자 생성
        int randomNumber = random.nextInt(1000) + 1;

        // 닉네임 생성
        return randomAdjective + randomNoun;
    }
}
