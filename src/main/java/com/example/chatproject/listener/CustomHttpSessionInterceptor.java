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
        if (request instanceof ServletServerHttpRequest) {
            ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
            HttpSession session = servletRequest.getServletRequest().getSession(false); // 세션이 없으면 null 반환

            if (session != null) {
                attributes.put("HTTP_SESSION", session);
                System.out.println("HttpSession found: " + session.getAttribute("username"));
            } else {
                System.out.println("HttpSession is null");
            }
        }
        return super.beforeHandshake(request, response, wsHandler, attributes);
    }
}