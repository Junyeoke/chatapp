package com.example.chatproject.service;

import com.example.chatproject.model.User;
import com.example.chatproject.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Set;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User registerUser(User user) {
        return userRepository.save(user);
    }


    private Set<String> activeUsers = new HashSet<>();

    public Set<String> getActiveUsers() {
        return activeUsers;
    }

    public void addUser(String username) {
        activeUsers.add(username);
    }

    public void removeUser(String username) {
        activeUsers.remove(username);
    }
    // 추가 메소드...
}
