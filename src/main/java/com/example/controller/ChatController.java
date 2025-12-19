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
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private SnapDAO snapDAO;

    // 🔥 [중요] 발급받은 Gemini API 키를 여기에 넣으세요!
    private static final String API_KEY = "AIzaSyDOdJm_uoWRmsP_vlVbDV-rgryNfRh8mnM";
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + API_KEY;

    // 1. 채팅 페이지 이동
    @GetMapping("/")
    public String chatPage() {
        return "chat"; // chat.jsp로 이동
    }

    // 2. 메시지 처리 및 AI 응답
    @PostMapping(value = "/ask", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String askGemini(@RequestParam("message") String userMessage) {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode responseJson = mapper.createObjectNode();

        try {
            // 1. DB에서 모든 스냅 게시물 정보 가져오기 (AI에게 지식 주입)
            List<SnapVO> allSnaps = snapDAO.getSnapList();

            // AI에게 보낼 스냅 데이터 요약 (ID, 제목, 카테고리, 스타일, 색상)
            String snapDataString = allSnaps.stream()
                    .map(s -> String.format("{id:%d, title:'%s', category:'%s', style:'%s', color:'%s'}",
                            s.getSnap_id(), s.getSnap_title(), s.getCategory(), s.getStyle(), s.getColor()))
                    .collect(Collectors.joining(", "));

            // 2. 프롬프트 작성 (AI에게 역할 부여)
            String prompt = "당신은 패션 스타일리스트 AI입니다. 사용자의 질문에 맞춰 아래 제공된 '보유 스냅 리스트' 중에서 가장 적절한 코디를 추천해주세요.\n\n" +
                    "[사용자 질문]: \"" + userMessage + "\"\n\n" +
                    "[보유 스냅 리스트]: [" + snapDataString + "]\n\n" +
                    "[규칙]:\n" +
                    "1. 사용자의 상황(날씨, 장소)과 가진 옷을 고려하여 리스트에서 가장 어울리는 스냅을 1~3개 선택하세요.\n" +
                    "2. 답변은 반드시 JSON 형식으로만 하세요. 다른 말은 하지 마세요.\n" +
                    "3. JSON 형식: {\"reply\": \"추천 이유와 코디 조언(친절하게)\", \"recommended_ids\": [1, 5, ...]}\n";

            // 3. Gemini API 호출
            String geminiResponse = callGeminiApi(prompt);

            // 4. 응답 파싱
            JsonNode rootNode = mapper.readTree(geminiResponse);
            // Gemini 응답 구조에서 텍스트 추출 (candidates[0].content.parts[0].text)
            String contentText = rootNode.path("candidates").get(0).path("content").path("parts").get(0).path("text").asText();

            // JSON 코드 블록(```json ... ```) 제거
            contentText = contentText.replaceAll("```json", "").replaceAll("```", "").trim();

            JsonNode contentJson = mapper.readTree(contentText);
            String aiReply = contentJson.path("reply").asText();
            JsonNode idsNode = contentJson.path("recommended_ids");

            // 5. 추천된 ID에 해당하는 실제 스냅 정보 가져오기
            List<SnapVO> recommendedSnaps = new ArrayList<>();
            if (idsNode.isArray()) {
                for (JsonNode id : idsNode) {
                    SnapVO snap = snapDAO.getSnap(id.asInt());
                    if (snap != null) recommendedSnaps.add(snap);
                }
            }

            // 6. 결과 반환 (텍스트 + 스냅 객체들)
            responseJson.put("status", "success");
            responseJson.put("reply", aiReply);
            responseJson.set("snaps", mapper.valueToTree(recommendedSnaps));

        } catch (Exception e) {
            e.printStackTrace();
            responseJson.put("status", "error");
            responseJson.put("message", "AI 연결 중 오류가 발생했습니다: " + e.getMessage());
        }

        return responseJson.toString();
    }

    // Gemini API HTTP 요청 메서드
    private String callGeminiApi(String prompt) throws Exception {
        URL url = new URL(GEMINI_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // JSON 요청 본문 생성
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
            wr.write(requestBody.toString().getBytes("UTF-8"));
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            return response.toString();
        }
    }
}