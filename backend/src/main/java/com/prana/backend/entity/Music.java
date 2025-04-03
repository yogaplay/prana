package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "music")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Music {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "music_id")
    private int id;

    @Column(name = "music_location", length = 255)
    private String musicLocation;

    @Column(name = "name", length = 255)
    private String name;
}