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

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private SnapDAO snapDAO;

    // 🔥 발급받은 본인의 API 키로 교체 필수
    private static final String API_KEY = "AIzaSyDOdJm_uoWRmsP_vlVbDV-rgryNfRh8mnM";
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + API_KEY;

    @GetMapping("/")
    public String chatPage() {
        return "chat";
    }

    @PostMapping(value = "/ask", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String askGemini(@RequestParam("message") String userMessage) {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode responseJson = mapper.createObjectNode();

        try {
            // 1. DB 데이터 가져오기 (지식 주입)
            List<SnapVO> allSnaps = snapDAO.getSnapList();

            // 데이터가 너무 많으면 토큰 제한에 걸릴 수 있으므로 최근 30개만 자르거나 필터링 고려
            // 현재는 전체 전송
            String snapDataString = allSnaps.stream()
                    .map(s -> String.format("{\"id\":%d, \"title\":\"%s\", \"category\":\"%s\", \"style\":\"%s\", \"color\":\"%s\"}",
                            s.getSnap_id(), s.getSnap_title(), s.getCategory(), s.getStyle(), s.getColor()))
                    .collect(Collectors.joining(", "));

            // 2. 프롬프트 엔지니어링 (JSON 응답 강제)
            String prompt = "당신은 패션 AI 'StyleSnap'입니다.\n" +
                    "사용자의 질문과 상황을 분석해서, 아래 [보유 스냅 리스트] 중 가장 잘 어울리는 코디를 1~3개 추천해주세요.\n\n" +
                    "[사용자 질문]: \"" + userMessage + "\"\n\n" +
                    "[보유 스냅 리스트]: [" + snapDataString + "]\n\n" +
                    "[필수 규칙]:\n" +
                    "1. 사용자의 상황(날씨, TPO)과 가진 옷을 고려해 리스트에서 가장 적절한 'id'를 찾으세요.\n" +
                    "2. 답변은 오직 JSON 포맷으로만 하세요. 마크다운이나 다른 설명은 절대 추가하지 마세요.\n" +
                    "3. JSON 형식 예시:\n" +
                    "{\"reply\": \"추천 멘트(친절하게, 이모지 포함)\", \"recommended_ids\": [1, 5]}";

            System.out.println(">>> User Prompt: " + userMessage); // 로그 확인용

            // 3. API 호출
            String geminiResponse = callGeminiApi(prompt);
            System.out.println(">>> Gemini Raw Response: " + geminiResponse); // 로그 확인용

            // 4. 응답 파싱
            JsonNode rootNode = mapper.readTree(geminiResponse);
            String contentText = rootNode.path("candidates").get(0).path("content").path("parts").get(0).path("text").asText();

            // ```json 등의 마크다운 제거
            contentText = contentText.replaceAll("```json", "").replaceAll("```", "").trim();
            System.out.println(">>> Cleaned JSON: " + contentText); // 로그 확인용

            JsonNode contentJson = mapper.readTree(contentText);
            String aiReply = contentJson.path("reply").asText();
            JsonNode idsNode = contentJson.path("recommended_ids");

            // 5. 추천된 스냅 정보 매핑
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
            e.printStackTrace(); // 콘솔창에 에러 스택트레이스 출력 (필수)
            responseJson.put("status", "error");
            responseJson.put("message", "Error: " + e.getMessage());
        }

        return responseJson.toString();
    }

    private String callGeminiApi(String prompt) throws Exception {
        URL url = new URL(GEMINI_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        ObjectMapper mapper = new ObjectMapper();

        // Gemini API Request Body 구조 생성
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

        // 안전 설정 (선택사항 - 유해 콘텐츠 차단 등급 낮추기)
        // 필요 시 추가

        // 요청 전송
        try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
            wr.write(requestBody.toString().getBytes(StandardCharsets.UTF_8));
        }

        int responseCode = conn.getResponseCode();

        // 🔥 [중요] 에러 스트림 처리 (400, 500 에러 시 구글의 에러 메시지 읽기)
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

        // 성공 시 응답 읽기
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