package com.prana.backend.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;

import java.io.Serializable;
import java.util.List;

@RedisHash("aiFeedback")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class AiFeedback implements Serializable {

    @Id
    private Integer id;

    private List<FeedbackTotal> feedbackTotal;

    private int successCount;
    private int failureCount;

    @NoArgsConstructor
    @AllArgsConstructor
    @Getter
    @Setter
    public static class FeedbackTotal implements Serializable {
        private String position;
    }
}

