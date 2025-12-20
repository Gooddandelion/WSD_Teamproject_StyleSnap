package com.example.controller;

import com.example.bean.SnapVO;
import com.example.dao.SnapDAO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.PostConstruct; // 추가
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream; // 추가
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties; // 추가
import java.util.stream.Collectors;

@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private SnapDAO snapDAO;

    // @Value 어노테이션 제거 (XML 설정 의존성 제거)
    private String apiKey;

    // [수정] 서버 시작 시 자바 코드로 직접 파일 읽기
    @PostConstruct
    public void init() {
        try {
            Properties prop = new Properties();
            // src/main/resources/secret.properties 파일을 읽음
            InputStream input = getClass().getClassLoader().getResourceAsStream("secret.properties");

            if (input == null) {
                System.err.println(">>> [오류] secret.properties 파일을 찾을 수 없습니다!");
                return;
            }

            prop.load(input);
            this.apiKey = prop.getProperty("gemini.api.key");

            // 공백 제거 (혹시 모를 실수 방지)
            if (this.apiKey != null) {
                this.apiKey = this.apiKey.trim();
                // 따옴표가 들어갔을 경우 제거
                this.apiKey = this.apiKey.replace("\"", "").replace("'", "");
            }

            System.out.println(">>> API Key 로드 성공 (길이): " + (this.apiKey != null ? this.apiKey.length() : "null"));

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println(">>> [오류] API Key 로드 실패: " + e.getMessage());
        }
    }

    @GetMapping("/")
    public String chatPage() {
        return "chat";
    }

    @PostMapping(value = "/ask", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String askGemini(@RequestParam("message") String userMessage) {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode responseJson = mapper.createObjectNode();

        // 키가 제대로 로드되지 않았을 경우 방어 코드
        if (this.apiKey == null || this.apiKey.isEmpty()) {
            responseJson.put("status", "error");
            responseJson.put("message", "서버 설정 오류: API 키가 로드되지 않았습니다.");
            return responseJson.toString();
        }

        try {
            // ... (기존 로직 동일)
            List<SnapVO> allSnaps = snapDAO.getSnapList(new HashMap<>());

            // ... (중략: 데이터 포맷팅 및 프롬프트 생성) ...
            String snapDataString = allSnaps.stream()
                    .limit(20)
                    .map(s -> String.format("{\"id\":%d, \"title\":\"%s\", \"category\":\"%s\", \"style\":\"%s\", \"color\":\"%s\"}",
                            s.getSnap_id(), s.getSnap_title(), s.getCategory(), s.getStyle(), s.getColor()))
                    .collect(Collectors.joining(", "));

            String prompt = "당신은 패션 AI 'StyleSnap'입니다.\n" +
                    "사용자의 질문과 상황을 분석해서, 아래 [보유 스냅 리스트] 중 가장 잘 어울리는 코디를 1~3개 추천해주세요.\n\n" +
                    "[사용자 질문]: \"" + userMessage + "\"\n\n" +
                    "[보유 스냅 리스트]: [" + snapDataString + "]\n\n" +
                    "[필수 규칙]:\n" +
                    "1. 사용자의 상황(날씨, TPO)과 가진 옷을 고려해 리스트에서 가장 적절한 'id'를 찾으세요.\n" +
                    "2. 답변은 오직 JSON 포맷으로만 하세요. 마크다운이나 다른 설명은 절대 추가하지 마세요.\n" +
                    "3. JSON 형식 예시:\n" +
                    "{\"reply\": \"추천 멘트(친절하게, 이모지 포함)\", \"recommended_ids\": [1, 5]}";

            // API 호출
            String geminiResponse = callGeminiApi(prompt);

            // ... (중략: 응답 파싱 및 결과 반환) ...
            JsonNode rootNode = mapper.readTree(geminiResponse);
            String contentText = rootNode.path("candidates").get(0).path("content").path("parts").get(0).path("text").asText();
            contentText = contentText.replaceAll("```json", "").replaceAll("```", "").trim();
            JsonNode contentJson = mapper.readTree(contentText);
            String aiReply = contentJson.path("reply").asText();
            JsonNode idsNode = contentJson.path("recommended_ids");

            List<SnapVO> recommendedSnaps = new ArrayList<>();
            if (idsNode.isArray()) {
                for (JsonNode id : idsNode) {
                    SnapVO snap = snapDAO.getSnap(id.asInt());
                    if (snap != null) recommendedSnaps.add(snap);
                }
            }

            responseJson.put("status", "success");
            responseJson.put("reply", aiReply);
            responseJson.set("snaps", mapper.valueToTree(recommendedSnaps));

        } catch (Exception e) {
            e.printStackTrace();
            responseJson.put("status", "error");
            responseJson.put("message", "AI 호출 중 오류가 발생했습니다: " + e.getMessage());
        }

        return responseJson.toString();
    }

    private String callGeminiApi(String prompt) throws Exception {
        // [수정] this.apiKey 사용
        String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=" + this.apiKey;

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode part = mapper.createObjectNode();
        part.put("text", prompt);
        ArrayNode parts = mapper.createArrayNode();
        parts.add(part);
        ObjectNode content = mapper.createObjectNode();
        content.set("parts", parts);
        ArrayNode contents = mapper.createArrayNode();
        contents.add(content);
        ObjectNode requestBody = mapper.createObjectNode();
        requestBody.set("contents", contents);

        try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
            wr.write(requestBody.toString().getBytes(StandardCharsets.UTF_8));
        }

        int responseCode = conn.getResponseCode();
        if (responseCode >= 400) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                StringBuilder errorResponse = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    errorResponse.append(line);
                }
                System.err.println("Gemini API Error: " + errorResponse.toString());
                throw new RuntimeException("Gemini API call failed with code " + responseCode + ": " + errorResponse.toString());
            }
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            return response.toString();
        }
    }
}