package com.prana.backend.tts.controller;

import com.prana.backend.tts.controller.request.TtsRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.http.*;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/tts")
@RequiredArgsConstructor
public class TtsController {

    @Value("${openai.api.key}")
    private String openAiApiKey;

    private final RestTemplate restTemplate;

    @PostMapping
    public ResponseEntity<byte[]> generateTts(@Valid @RequestBody TtsRequest ttsRequest) {
        String text = ttsRequest.getText();

        // 시도 1: 리소스 경로에서 mp3 파일 존재 여부 확인
        byte[] staticAudio = getStaticAudioIfExists(text);
        if (staticAudio != null) {
            return ResponseEntity.ok()
                    .contentType(MediaType.valueOf("audio/mpeg"))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + text + ".mp3\"")
                    .body(staticAudio);
        }

        // 시도 2: OpenAI API 호출
        byte[] audioData = getTtsAudioFromOpenAI(text);
        return ResponseEntity.ok()
                .contentType(MediaType.valueOf("audio/mpeg"))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"tts.mp3\"")
                .body(audioData);
    }


    private byte[] getStaticAudioIfExists(String text) {
        try {
            // resources/tts 경로에서 파일 리스트 읽기
            ResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
            Resource[] resources = resolver.getResources("classpath:/tts/*.mp3");

            for (Resource resource : resources) {
                String filename = resource.getFilename();
                if (filename == null) continue;

                // "1. 왼쪽 어깨를 더 들어주세요.mp3" → "왼쪽 어깨를 더 들어주세요"
                String cleaned = filename.replaceAll("^\\d+\\.\\s*", "").replace(".mp3", "");

                if (cleaned.equals(text)) {
                    return StreamUtils.copyToByteArray(resource.getInputStream());
                }
            }
        } catch (IOException e) {
            // 필요 시 로깅
        }
        return null;
    }


    public byte[] getTtsAudioFromOpenAI(String text) {
        String apiUrl = "https://api.openai.com/v1/audio/speech";
        String apiKey = "Bearer " + openAiApiKey;

        Map<String, Object> payload = new HashMap<>();
        payload.put("model", "gpt-4o-mini-tts");
        payload.put("voice", "sage");
        payload.put("input", text);
        payload.put("instructions", "Accent/Affect: 부드럽고 차분하며, 경험 많은 요가 강사가 안내하는 듯한 느낌.\n\nTone: 안정적이고 따뜻하며, 몸과 마음의 연결을 강조하는 명상적인 톤.\n\nPacing: 느긋하고 유연하게, 충분한 여유를 두어 호흡과 동작을 자연스럽게 따라갈 수 있도록 함.\n\nEmotion: 평온하고 따뜻한 격려, 현재 순간을 온전히 경험할 수 있도록 돕는 부드러운 에너지.\n\nPronunciation: 요가와 관련된 용어(예: \"프라나야마,\" \"아사나,\" \"차크라\")를 또렷하게 발음하되, 자연스럽고 유려하게 전달.\n\nPersonality Affect: 친근하고 포용적이며, 깊이 있는 이해를 바탕으로 편안하게 이끌어 주는 느낌. 신체적 수행뿐만 아니라 내면의 안정과 조화를 찾을 수 있도록 안내.");
        payload.put("response_format", "mp3");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", apiKey);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(payload, headers);

        ResponseEntity<byte[]> response = restTemplate.exchange(
                apiUrl,
                HttpMethod.POST,
                request,
                byte[].class
        );

        if (response.getStatusCode() == HttpStatus.OK) {
            return response.getBody();
        } else {
            throw new RuntimeException("TTS API 요청 실패: " + response.getStatusCode());
        }
    }
}
