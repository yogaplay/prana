package com.prana.backend.look.repository;

import com.prana.backend.entity.Tag;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RandomTagRepository extends CrudRepository<Tag, Integer> {

    /**
     * tag_type 별로 랜덤한 한개의 태그를 가져옵니다.
     * @return List<Tag>
     */
    @Query(value = """
        SELECT t1.*
        FROM tag t1
        JOIN (
            SELECT tag_type, tag_id
            FROM (
                SELECT tag_type, tag_id, ROW_NUMBER() OVER (PARTITION BY tag_type ORDER BY RAND()) AS rn
                FROM tag
            ) t
            WHERE rn = 1
        ) t2 ON t1.tag_id = t2.tag_id
        """, nativeQuery = true)
    List<Tag> findRandomTagPerType();
}