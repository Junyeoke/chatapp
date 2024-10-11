package com.example.chatproject.controller;

import com.example.chatproject.model.Message;
import com.example.chatproject.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/messages")
public class MessageController {
    @Autowired
    private MessageService messageService;

    @PostMapping("/send")
    public Message sendMessage(@RequestBody Message message) {
        return messageService.sendMessage(message);
    }

    @GetMapping("/{userId}")
    public List<Message> getMessages(@PathVariable Long userId) {
        return messageService.getMessages(userId);
    }

    // 추가 엔드포인트...
}