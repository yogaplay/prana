package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;


@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@Table(name = "sequence_yoga")
public class SequenceYoga {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sequence_yoga_id")
    private Integer sequenceYogaId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_sequence_id", nullable = false)
    private UserSequence userSequence;

    @Column(name = "yoga_name", nullable = false, length = 20)
    private String yogaName;

    @Column(name = "accuracy", nullable = false)
    private Integer accuracy;

    @Column(name = "yoga_image", nullable = false, length = 255)
    private String yogaImage;
}
