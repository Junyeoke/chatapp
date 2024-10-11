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

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Controller
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final Set<String> activeUsers = ConcurrentHashMap.newKeySet();

    public ChatController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
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
    public String send(String message) throws Exception {
        return message; // 메시지를 /topic/messages로 전송
    }

    @GetMapping("/chat")
    public String chat(@RequestParam("username") String username, Model model, HttpSession session) {
        if (session == null) {
            System.out.println("Session is null"); // 세션이 null인 경우 로그 출력
        } else {
            session.setAttribute("username", username); // 세션에 사용자 이름 저장
            activeUsers.add(username); // 활성 사용자 목록에 추가
            messagingTemplate.convertAndSend("/topic/users", activeUsers); // 사용자 목록을 /topic/users로 전송
            System.out.println("Username stored in session: " + username); // 사용자 이름 로그 출력
        }
        model.addAttribute("username", username); // 모델에 사용자 이름 추가
        return "chat"; // chat.jsp로 이동
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
    public void disconnect(String username) {
        removeUser(username); // 사용자가 목록에서 제거

        // 사용자 퇴장 메시지 전송
        String disconnectMessage = username + "님이 나갔습니다.";
        messagingTemplate.convertAndSend("/topic/messages", disconnectMessage); // 퇴장 메시지를 /topic/messages로 전송
    }
}