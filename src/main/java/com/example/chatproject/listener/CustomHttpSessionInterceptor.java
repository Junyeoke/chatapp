package com.example.chatproject.listener;

import jakarta.servlet.http.HttpSession;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import java.util.Map;

public class CustomHttpSessionInterceptor extends HttpSessionHandshakeInterceptor {

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
        // 요청이 ServletServerHttpRequest의 인스턴스인지 확인
        if (request instanceof ServletServerHttpRequest) {
            ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
            // 세션이 존재하는지 확인, 없으면 null 반환
            HttpSession session = servletRequest.getServletRequest().getSession(false);

            if (session != null) {
                // 세션이 존재하면 attributes 맵에 세션을 추가
                attributes.put("HTTP_SESSION", session);
                // 세션에 저장된 사용자 이름을 로그로 출력
                System.out.println("HttpSession found: " + session.getAttribute("username"));
            } else {
                // 세션이 존재하지 않으면 로그로 출력
                System.out.println("HttpSession is null");
            }
        }
        // 부모 클래스의 beforeHandshake 메서드 호출
        return super.beforeHandshake(request, response, wsHandler, attributes);
    }
}