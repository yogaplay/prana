

package com.prana.backend.calendar.service.entity;

import com.prana.backend.user.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;


@Entity
@Table(name = "user_sequence")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserSequence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="user_sequence_id")
    private Integer userSequenceId;

    @ManyToOne
    @JoinColumn(name="user_id", nullable=false)
    private User user;

    @ManyToOne
    @JoinColumn(name="sequence_id", nullable=false)
    private Sequence sequence;

    @Column(name ="result_status", nullable=false, length=1)
    private String resultStatus;

    @Column(name="last_point", nullable = false)
    private int lastPoint;

    @Column(name="created_date", nullable = false)
    private LocalDate createdDate;

    @Column(name="updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
