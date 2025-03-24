package com.prana.backend.entity;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "yoga_sequence")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class YogaSequence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "yoga_sequence_id")
    private Integer yogaSequenceId;

    @ManyToOne
    @JoinColumn(name = "yoga_id", nullable = false)
    private Yoga yoga;

    @ManyToOne
    @JoinColumn(name = "sequence_id", nullable = false)
    private Sequence sequence;

    @Column(name = "order", nullable = false)
    private Integer orderIndex;
}

