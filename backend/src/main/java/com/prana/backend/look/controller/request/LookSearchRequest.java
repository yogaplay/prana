package com.prana.backend.look.controller.request;

import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LookSearchRequest {

    private String keyword;
    private List<Integer> tagIdList;
    private List<String> tagNameList;
    @Min(0)
    private Integer page;

    @Min(1)
    private Integer size;

    public Integer getPage() {
        return page == null ? 0 : page;
    }

    public Integer getSize() {
        return size == null ? 10 : size;
    }

}
