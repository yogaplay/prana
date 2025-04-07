package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "yoga_feedback")
public class YogaFeedback {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "yoga_feedback_id")
    private Integer yogaFeedbackId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sequence_yoga_id", nullable = false)
    private SequenceYoga sequenceYoga;

    @Column(name = "body_part", nullable = false)
    private String bodyPart;

    @Column(name = "feedback_cnt", nullable = false)
    private int feedbackCnt;
}

