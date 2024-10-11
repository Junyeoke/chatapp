package com.example.chatproject.listener;

import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class WebSocketEventListener {

    private final SimpMessagingTemplate messagingTemplate;
    private final Set<String> activeUsers = ConcurrentHashMap.newKeySet(); // 중복되지 않는 사용자 목록 관리

    public WebSocketEventListener(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    @EventListener
    public void handleWebSocketConnectListener(SessionConnectEvent event) {
        // WebSocket 연결 이벤트를 처리하는 메서드
        SimpMessageHeaderAccessor headerAccessor = SimpMessageHeaderAccessor.wrap(event.getMessage());
        String username = (String) headerAccessor.getSessionAttributes().get("username");

        // 유저가 유효한 경우 activeUsers에 추가하고 전체 사용자에게 목록 전송
        if (username != null && activeUsers.add(username)) {
            System.out.println("User Connected: " + username); // 연결된 사용자 이름을 로그로 출력
            messagingTemplate.convertAndSend("/topic/users", activeUsers); // 전체 사용자에게 목록 전송
        }
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        // WebSocket 연결 해제 이벤트를 처리하는 메서드
        SimpMessageHeaderAccessor headerAccessor = SimpMessageHeaderAccessor.wrap(event.getMessage());
        String username = (String) headerAccessor.getSessionAttributes().get("username");

        // 유저가 유효한 경우 목록에서 제거하고 전체 사용자에게 목록 전송
        if (username != null && activeUsers.remove(username)) {
            System.out.println("User Disconnected: " + username); // 연결 해제된 사용자 이름을 로그로 출력
            messagingTemplate.convertAndSend("/topic/users", activeUsers); // 전체 사용자에게 목록 전송
        }
    }
}