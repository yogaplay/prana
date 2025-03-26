package com.prana.backend.look.service;

import com.prana.backend.entity.Tag;
import com.prana.backend.look.controller.request.LookRequest;
import com.prana.backend.look.controller.response.LookResponse;
import com.prana.backend.look.repository.CustomLookRepository;
import com.prana.backend.look.repository.RandomTagRepository;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;


@Slf4j
@Service
@AllArgsConstructor
public class LookService {

    private final CustomLookRepository customLookRepository;
    private final RandomTagRepository randomTagRepository;

    /**
     * 둘러보기 페이지
     *
     * @param request LookRequest
     * @return ResponseEntity<PagedResponse < LookResponse>>
     */
    @Transactional(readOnly = true)
    public ResponseEntity<List<LookResponse>> look(@Valid LookRequest request) {
        List<Tag> randomTagPerType = randomTagRepository.findRandomTagPerType();
        List<LookResponse> lookList = new ArrayList<>();
        for (Tag tag : randomTagPerType) {
            lookList.add(
                    LookResponse.builder()
                            .tagId(tag.getId())
                            .tagName(tag.getName())
                            .tagType(tag.getType())
                            // N + 1
                            .sampleList(customLookRepository.sampleList(tag.getId(), request.getSampleSize()))
                            .build()
            );
        }

        return ResponseEntity.ok().body(lookList);
    }
}
