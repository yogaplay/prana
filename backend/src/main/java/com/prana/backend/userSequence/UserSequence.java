package com.prana.backend.userSequence;

import com.prana.backend.sequence.Sequence;
import com.prana.backend.user.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@Table(name = "user_sequence")
public class UserSequence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_sequence_id")
    private Integer userSequenceId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sequence_id", nullable = false)
    private Sequence sequence;

    @Column(name = "result_status", nullable = false, columnDefinition = "char(1) default 'N'")
    private String resultStatus = "N";

    @Column(name = "last_point", nullable = false, columnDefinition = "smallint default 0")
    private Short lastPoint = 0;

    @Column(name = "created_date", nullable = false)
    private LocalDate createdDate;


    @PrePersist
    protected void onCreate() {
        this.createdDate = LocalDate.now();
    }
}

