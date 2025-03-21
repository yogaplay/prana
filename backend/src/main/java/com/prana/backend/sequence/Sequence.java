package com.prana.backend.sequence;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
@Table(name = "sequence")
public class Sequence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sequence_id")
    private Integer sequenceId;

    @Column(name = "sequence_name", nullable = false, length = 255)
    private String sequenceName;

    @Column(name = "sequence_time", nullable = false)
    private Integer sequenceTime;

    @Column(name = "yoga_cnt", nullable = false)
    private Short yogaCnt;

    @Column(name = "description", nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "image", nullable = false)
    private String image;

}
