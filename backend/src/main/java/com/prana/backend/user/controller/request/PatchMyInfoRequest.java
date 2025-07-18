package com.prana.backend.user.controller.request;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PatchMyInfoRequest {

    @Size(min = 2, max = 6, message = "2글자 이상 6글자 이하여야 합니다.")
    private String nickname;

    @DecimalMin(value = "1", message = "신장은 1cm 이상이어야 합니다.")
    @DecimalMax(value = "300", message = "신장은 300cm 이하여야 합니다.")
    private Short height;

    @DecimalMin(value = "1", message = "나이는 1세 이상이어야 합니다.")
    @DecimalMax(value = "200", message = "나이는 200세 이하여야 합니다.")
    private Short age;

    @DecimalMin(value = "1", message = "체중은 1kg 이상이어야 합니다.")
    @DecimalMax(value = "300", message = "체중은 300kg 이하여야 합니다.")
    private Short weight;

    @Pattern(regexp = "[MF]", message = "성별은 'M' 또는 'F' 여야 합니다.")
    private String gender;

    public boolean isEmpty() {
        return nickname == null
                && height == null
                && age == null
                && weight == null
                && gender == null;
    }

}
