package com.example.chatproject.controller;

import com.example.chatproject.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;
import java.util.HashMap;

@Controller
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final Set<String> activeUsers = ConcurrentHashMap.newKeySet();
    private final ObjectMapper objectMapper;

    public ChatController(SimpMessagingTemplate messagingTemplate, ObjectMapper objectMapper) {
        this.messagingTemplate = messagingTemplate;
        this.objectMapper = objectMapper;
    }

    @GetMapping("/")
    public String index() {
        return "index"; // index.jsp로 이동
    }

    @GetMapping("/username")
    public String username() {
        return "username"; // username.jsp로 이동
    }

    @MessageMapping("/chat")
    @SendTo("/topic/messages")
    public Map<String, Object> send(Map<String, String> message) {
        Map<String, Object> response = new HashMap<>(message);
        response.put("type", "chat");
        return response;
    }

    @GetMapping("/chat")
    public String chat(@RequestParam("username") String username, Model model, HttpSession session) {
        if (session == null) {
            System.out.println("Session is null");
        } else {
            session.setAttribute("username", username);
            if (activeUsers.add(username)) { // 새로운 사용자가 추가된 경우에만
                messagingTemplate.convertAndSend("/topic/users", activeUsers);
                
                // 입장 메시지를 시스템 메시지로 전송
                Map<String, Object> welcomeMessage = new HashMap<>();
                welcomeMessage.put("type", "system");
                welcomeMessage.put("message", username + "님이 입장하였습니다.");
                messagingTemplate.convertAndSend("/topic/messages", welcomeMessage);

                // 채팅 에티켓 메시지 전송
                Map<String, Object> etiquetteMessage = new HashMap<>();
                etiquetteMessage.put("type", "system");
                etiquetteMessage.put("message", "채팅방 이용 시 아름다운 언어를 이용하여 소통해주세요 :)");
                messagingTemplate.convertAndSend("/topic/messages", etiquetteMessage);
            }
            System.out.println("Username stored in session: " + username);
        }
        model.addAttribute("username", username);
        return "chat";
    }

    @MessageMapping("/users")
    @SendTo("/topic/users")
    public Set<String> getUsers() {
        return activeUsers; // 활성 사용자 목록 반환
    }

    // 사용자 퇴장 시 목록에서 제거
    public void removeUser(String username) {
        if (activeUsers.remove(username)) {
            messagingTemplate.convertAndSend("/topic/users", activeUsers); // 사용자 목록 갱신
        }
    }

    @MessageMapping("/disconnect")
    public void disconnect(String payload) {
        try {
            Map<String, String> payloadMap = objectMapper.readValue(payload, Map.class);
            String username = payloadMap.get("username");

            removeUser(username); // 사용자를 목록에서 제거

            // 사용자 퇴장 메시지를 시스템 메시지로 전송
            Map<String, Object> systemMessage = new HashMap<>();
            systemMessage.put("type", "system");
            systemMessage.put("message", username + "님이 퇴장하셨습니다.");
        
            messagingTemplate.convertAndSend("/topic/messages", systemMessage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 새로운 메서드 추가
    @MessageMapping("/join")
    public void userJoined(String payload) {
        try {
            Map<String, String> payloadMap = objectMapper.readValue(payload, Map.class);
            String username = payloadMap.get("username");

            if (activeUsers.add(username)) { // 새로운 사용자가 추가된 경우에만
                messagingTemplate.convertAndSend("/topic/users", activeUsers);
                
                // 입장 메시지를 시스템 메시지로 전송
                Map<String, Object> systemMessage = new HashMap<>();
                systemMessage.put("type", "system");
                systemMessage.put("message", username + "님이 입장하였습니다.");
                messagingTemplate.convertAndSend("/topic/messages", systemMessage);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
