package com.prana.backend.calendar.service.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name="sequence")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sequence {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    @Column(name="sequence_id")
    private Integer sequenceId;

    @Column(name="sequence_name", nullable=false)
    private String sequenceName;

    @Column(name="sequence_time", nullable=false)
    private Integer sequenceTime;

    @Column(name="yoga_cnt", nullable=false)
    private Short yogaCnt;

    @Column(name="description", nullable=false, columnDefinition="text")
    private String description;

    @Column(name="image", nullable=false)
    private String image;
}
