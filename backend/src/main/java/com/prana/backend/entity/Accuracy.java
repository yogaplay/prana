package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter

@Builder
@Table(name = "accuracy")
public class Accuracy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "accuracy_id")
    private Integer id;

    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @Column(name = "yoga_id", nullable = false)
    private Integer yogaId;

    @Column(name = "sequence_id", nullable = false)
    private Integer sequenceId;

    @Column(name = "success", nullable = false)
    private int success;

    @Column(name = "fail", nullable = false)
    private int fail;

    @Column(name = "score", nullable = false)
    private int score;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Timestamp createdAt;

}

