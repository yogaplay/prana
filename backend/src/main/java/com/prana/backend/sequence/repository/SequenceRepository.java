package com.prana.backend.sequence.repository;

import com.prana.backend.entity.Sequence;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SequenceRepository extends JpaRepository<Sequence, Integer> {
    @Query(value = """
        SELECT s.*
        FROM sequence s
        JOIN sequence_tag st ON st.sequence_id = s.sequence_id
        JOIN tag t ON st.tag_id = t.tag_id
        WHERE t.tag_name = :tagName
        ORDER BY RAND()
        LIMIT 3
        """, nativeQuery = true)
    List<Sequence> findRandom3ByTagName(@Param("tagName") String tagName);

    @Query(value = "SELECT s.* " +
            "FROM sequence s " +
            "JOIN sequence_tag st ON s.sequence_id = st.sequence_id " +
            "JOIN tag t ON st.tag_id = t.tag_id " +
            "WHERE t.tag_name = :tagName " +
            "LIMIT 3", nativeQuery = true)
    List<Sequence> findTop3SequencesByTagName(@Param("tagName") String tagName);


    @Query(value = """
        SELECT s.sequence_id, s.sequence_name, s.image, GROUP_CONCAT(DISTINCT t.tag_name)
        FROM sequence s
        JOIN sequence_tag st ON st.sequence_id = s.sequence_id
        JOIN tag t ON st.tag_id = t.tag_id
        GROUP BY s.sequence_id, s.sequence_name, s.image
        HAVING FIND_IN_SET(:tagName, GROUP_CONCAT(DISTINCT t.tag_name)) > 0
""", nativeQuery = true)
    List<Object[]> findByTag(@Param("tagName") String tagName);
}
