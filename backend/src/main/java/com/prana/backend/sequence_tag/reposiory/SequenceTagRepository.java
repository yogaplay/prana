package com.prana.backend.sequence_tag.reposiory;

import com.prana.backend.entity.SequenceTag;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SequenceTagRepository extends JpaRepository<SequenceTag, Long> {

}
