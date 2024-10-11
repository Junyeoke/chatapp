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
        return "index";
    }

    @GetMapping("/username")
    public String username() {
        return "username"; // username.jsp로 이동
    }

    @MessageMapping("/chat")
    @SendTo("/topic/messages")
    public String send(String message) throws Exception {
        return message;
    }

    @GetMapping("/chat")
    public String chat(@RequestParam("username") String username, Model model, HttpSession session) {
        if (session == null) {
            System.out.println("Session is null");
        } else {
            session.setAttribute("username", username);
            activeUsers.add(username);
            messagingTemplate.convertAndSend("/topic/users", activeUsers);
            System.out.println("Username stored in session: " + username);
        }
        model.addAttribute("username", username);
        return "chat";
    }

    @MessageMapping("/users")
    @SendTo("/topic/users")
    public Set<String> getUsers() {
        return activeUsers;
    }

    // 사용자 퇴장 시 목록에서 제거
    public void removeUser(String username) {
        if (activeUsers.remove(username)) {
            messagingTemplate.convertAndSend("/topic/users", activeUsers);
        }
    }

    @MessageMapping("/disconnect")
    public void disconnect(String username) {
        removeUser(username); // 사용자가 목록에서 제거

        // 사용자 퇴장 메시지 전송
        String disconnectMessage = username + "님이 나갔습니다.";
        messagingTemplate.convertAndSend("/topic/messages", disconnectMessage);
    }
}
