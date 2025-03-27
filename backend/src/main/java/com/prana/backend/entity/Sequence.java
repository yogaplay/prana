package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "sequence")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Sequence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sequence_id")
    private Integer id;

    @Column(name = "sequence_name", nullable = false, length = 255)
    private String name;

    @Column(name = "sequence_time", nullable = false)
    private int time;

    @Column(name = "yoga_cnt", nullable = false)
    private int yogaCount;

    @Column(name = "description", columnDefinition = "TEXT", nullable = false)
    private String description;

    @Column(name = "image", nullable = false, length = 255)
    private String image;
}
