package com.prana.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_sequence")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserSequence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_sequence_id")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sequence_id", nullable = false)
    private Sequence sequence;

    @Builder.Default
    @Column(name = "result_status", nullable = false, length = 1)
    private char resultStatus = 'N';

    @Builder.Default
    @Column(name = "last_point", nullable = false)
    private int lastPoint = 0;

    @CreationTimestamp
    @Column(name = "created_date", nullable = false)
    private LocalDate createdDate;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
