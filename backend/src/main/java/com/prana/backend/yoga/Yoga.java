package com.prana.backend.yoga;


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
@Table(name = "yoga")
public class Yoga {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "yoga_id")
    private Integer yogaId;

    @Column(name = "yoga_name", nullable = false, length = 255)
    private String yogaName;

    @Column(name = "video", nullable = false, length = 255)
    private String video;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "solution_pose", nullable = false, columnDefinition = "TEXT")
    private String solutionPose;

    @Column(name = "image", nullable = false)
    private String image;

}
