package com.example.chatproject.service;

import com.example.chatproject.model.Message;
import com.example.chatproject.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MessageService {
    @Autowired
    private MessageRepository messageRepository;

    public Message sendMessage(Message message) {
        return messageRepository.save(message);
    }

    public List<Message> getMessages(Long userId) {
        return messageRepository.findBySender_IdOrReceiver_Id(userId, userId);
    }

    // 추가 메소드...
}