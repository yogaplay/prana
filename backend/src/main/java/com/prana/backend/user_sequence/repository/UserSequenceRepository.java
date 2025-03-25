package com.prana.backend.user_sequence.repository;

import com.prana.backend.entity.UserSequence;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface UserSequenceRepository extends JpaRepository<UserSequence, Integer> {

    @Query(value = "SELECT EXISTS(SELECT 1 FROM user_sequence WHERE DATE(updated_at) = CURDATE() - INTERVAL 1 DAY)", nativeQuery = true)
    boolean existsYesterdayUserSequence();

    @Query(value = "SELECT EXISTS(SELECT 1 FROM user_sequence WHERE DATE(updated_at) = CURDATE())", nativeQuery = true)
    boolean existsTodayUserSequence();

}
