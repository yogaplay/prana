package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "star")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Star {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "star_id")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sequence_id", nullable = false)
    private Sequence sequence;
}