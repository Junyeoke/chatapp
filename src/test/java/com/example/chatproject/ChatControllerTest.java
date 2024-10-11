package com.example.chatproject;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.messaging.simp.stomp.StompSession;
import org.springframework.messaging.simp.stomp.StompSessionHandlerAdapter;
import org.springframework.messaging.simp.stomp.StompHeaders;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.socket.messaging.WebSocketStompClient;
import org.springframework.web.socket.client.WebSocketClient;
import org.springframework.web.socket.client.standard.StandardWebSocketClient;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class ChatControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private WebSocketStompClient stompClient;

    @BeforeEach
    public void setup() {
        WebSocketClient client = new StandardWebSocketClient();
        stompClient = new WebSocketStompClient(client);
    }

    @Test
    public void testSendMessage() throws Exception {
        String message = "Hello, WebSocket!";

        stompClient.connect("ws://localhost:8080/chat", new StompSessionHandlerAdapter() {
            @Override
            public void afterConnected(StompSession session, StompHeaders connectedHeaders) {
                session.send("/app/send", message);
            }
        });

        // 메시지 전송 후 응답을 검증하는 로직이 필요합니다.
    }
}