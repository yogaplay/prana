package com.prana.backend.aws.controller;


import com.prana.backend.common.util.S3Uploader;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Validated
@RestController
@RequestMapping("/api/s3")
@RequiredArgsConstructor
public class S3UploadController {

    private final S3Uploader s3Uploader;

    @PostMapping
    public ResponseEntity<Map<String, String>> uploadFile(@NotNull(message = "파일은 필수입니다!") @RequestParam("file") MultipartFile file) throws IOException {
        String url = s3Uploader.upload(file);
        return ResponseEntity.ok(Map.of("url", url));
    }
}