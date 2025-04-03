package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "user_music")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserMusic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_music_id")
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "music_id", nullable = false)
    private Music music;

}
