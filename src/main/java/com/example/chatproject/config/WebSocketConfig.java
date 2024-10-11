package com.example.chatproject.config;

import com.example.chatproject.listener.CustomHttpSessionInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // STOMP 엔드포인트 등록
        registry.addEndpoint("/ws") // 웹소켓 엔드포인트 설정
                .setAllowedOriginPatterns("http://localhost:8080") // 허용할 출처 설정
                .withSockJS() // SockJS 사용 설정
                .setInterceptors(new CustomHttpSessionInterceptor()); // 커스텀 인터셉터 사용
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // 메시지 브로커 설정
        config.enableSimpleBroker("/topic"); // 메시지 브로커가 "/topic" 경로를 구독하도록 설정
        config.setApplicationDestinationPrefixes("/app"); // 애플리케이션 목적지 접두사 설정
    }
}