package com.example.chatproject.repository;

import com.example.chatproject.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Long> {
    List<Message> findBySender_IdOrReceiver_Id(Long senderId, Long receiverId);
}
