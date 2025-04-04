package com.prana.backend.look.service;

import com.prana.backend.common.PagedResponse;
import com.prana.backend.entity.Tag;
import com.prana.backend.look.controller.request.LookRequest;
import com.prana.backend.look.controller.request.LookSearchRequest;
import com.prana.backend.look.controller.response.GetSequenceByTagResponseDTO;
import com.prana.backend.look.controller.response.LookResponse;
import com.prana.backend.look.controller.response.LookResult;
import com.prana.backend.look.controller.response.LookSearchResponse;
import com.prana.backend.look.repository.CustomLookRepository;
import com.prana.backend.look.repository.RandomTagRepository;
import com.prana.backend.sequence.repository.SequenceRepository;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
    private final SequenceRepository sequenceRepository;

    /**
     * 둘러보기 페이지
     *
     * @param request LookRequest
     * @return ResponseEntity<LookResult>>
     */
    @Transactional(readOnly = true)
    public ResponseEntity<LookResult> look(@Valid LookRequest request) {
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

        return ResponseEntity.ok().body(new LookResult(lookList));
    }

    /**
     * 둘러보기 검색
     *
     * @param request LookSearchRequest
     * @return ResponseEntity<PagedResponse < LookSearchResponse>>
     */
    @Transactional(readOnly = true)
    public ResponseEntity<PagedResponse<LookSearchResponse>> lookSearch(LookSearchRequest request) {
        Pageable pageable = PageRequest.of(request.getPage(), request.getSize());
        Page<LookSearchResponse> page = customLookRepository.lookSearch(pageable, request);
        List<LookSearchResponse> lookSearchList = page.getContent();
        // N + 1
        for (LookSearchResponse lookSearch : lookSearchList) {
            lookSearch.setTagList(customLookRepository.lookSearchTagList(lookSearch.getSequenceId()));
        }
        PagedResponse<LookSearchResponse> response = new PagedResponse<>(
                lookSearchList,
                page.getNumber(),
                page.getSize(),
                page.getTotalElements(),
                page.getTotalPages()
        );
        return ResponseEntity.ok().body(response);
    }

    public GetSequenceByTagResponseDTO getSequenceByTag(String tagName) {
        List<Object[]> sequences = sequenceRepository.findByTag(tagName);

        List<GetSequenceByTagResponseDTO.Sequence> sequenceList = sequences.stream()
                .map(row -> GetSequenceByTagResponseDTO.Sequence.builder()
                        .sequenceId((Integer) row[0])
                        .sequenceName((String) row[1])
                        .image((String) row[2])
                        .tags(List.of(((String) row[3]).split(",")))
                        .build())
                .toList();

        return GetSequenceByTagResponseDTO.builder()
                .sequences(sequenceList)
                .build();
    }
}
