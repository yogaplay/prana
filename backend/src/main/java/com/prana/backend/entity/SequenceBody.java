package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@Table(name = "sequence_body")
public class SequenceBody {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sequence_body_id")
    private Integer sequenceBodyId;

    // 외래키 user_sequence_id와 연관된 UserSequence 엔티티 매핑
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_sequence_id", nullable = false)
    private UserSequence userSequence;

    @Column(name = "body_part", nullable = false)
    private String bodyPart;

    @Column(name = "feedback_cnt", nullable = false)
    private Integer feedbackCnt;
}
