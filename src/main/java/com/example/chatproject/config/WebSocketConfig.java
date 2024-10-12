package com.example.chatproject.config;

import com.example.chatproject.listener.CustomHttpSessionInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

/**
 * WebSocketConfig 클래스는 Spring WebSocket 메시지 브로커를 설정하는 클래스이다.
 * 이 클래스에서는 STOMP 프로토콜을 사용하여 웹소켓 엔드포인트를 등록하고,
 * 메시지 브로커를 구성하여 클라이언트와 서버 간의 실시간 메시지 전송을 가능하게 한다.
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // STOMP 엔드포인트 등록
        registry.addEndpoint("/ws") // 웹소켓 엔드포인트를 "/ws"로 설정
                .setAllowedOriginPatterns("http://localhost:8080") // 허용할 출처를 설정
                .withSockJS() // SockJS를 사용하여 브라우저 호환성 제공
                .setInterceptors(new CustomHttpSessionInterceptor()); // 커스텀 HTTP 세션 인터셉터 사용
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // 메시지 브로커 설정
        config.enableSimpleBroker("/topic"); // 메시지 브로커가 "/topic" 경로를 구독하도록 설정
        config.setApplicationDestinationPrefixes("/app"); // 애플리케이션 목적지의 접두사를 "/app"으로 설정
    }
}
