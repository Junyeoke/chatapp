package com.example.chatproject.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * WebConfig 클래스는 Spring MVC의 CORS(Cross-Origin Resource Sharing) 설정을 구성합니다.
 * CORS는 다른 출처의 웹 페이지가 현재 출처의 리소스에 접근할 수 있도록 허용하는 메커니즘입니다.
 * 이 설정을 통해 특정 출처에서 오는 요청을 허용하고, 허용할 HTTP 메서드 및 자격 증명 사용 여부를 지정합니다.
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // CORS 설정 추가
        registry.addMapping("/chat/**") // "/chat/**" 경로에 대한 CORS 설정
                .allowedOrigins("http://localhost:8080", "http://localhost:3000") // 허용할 출처
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // 허용할 HTTP 메서드
                .allowCredentials(true); // 자격 증명(쿠키, 인증 헤더 등) 허용
    }
}
