<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat Room</title>
    <style>
        /* 기존 스타일 유지 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            padding: 20px;
        }

        #chat {
            width: 100%;
            max-width: 600px;
            height: 400px;
            border: none;
            padding: 10px;
            background-color: #ffffff;
            overflow-y: scroll;
            margin-bottom: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        .message {
            display: flex;
            margin-bottom: 10px;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .message .content {
            max-width: 70%;
            padding: 10px;
            border-radius: 10px;
            word-wrap: break-word;
            position: relative;
            overflow: hidden;
        }

        .message.from-user {
            justify-content: flex-end;
        }

        .message.from-user .content {
            background-color: #0084ff;
            color: white;
            text-align: right;
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
            border-top-right-radius: 10px;
        }

        .message.from-others {
            justify-content: flex-start;
        }

        .message.from-others .content {
            background-color: #e1ffc7;
            color: black;
            text-align: left;
            border-top-right-radius: 10px;
            border-bottom-right-radius: 10px;
            border-top-left-radius: 10px;
        }

        /* 시스템 메시지 스타일 */
        .system-message {
            display: flex;
            justify-content: center;
            margin: 10px 0;
        }

        .system-message .content {
            background-color: #ffdddd; /* 밝은 빨간색 배경 */
            color: red; /* 빨간색 글자 */
            padding: 10px;
            border-radius: 10px;
            max-width: 70%;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        input[type="text"], button {
            padding: 10px;
            margin-right: 10px;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ccc;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus {
            border-color: #0084ff;
            outline: none;
        }

        button {
            background-color: #0084ff;
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #005fcb;
        }

        /* 사용자 목록 스타일 */
        #userList {
            max-width: 200px;
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 10px;
            height: 400px;
            overflow-y: auto;
            margin-left: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        #userList ul {
            list-style-type: none;
            padding: 0;
        }

        #userList li {
            padding: 5px 0;
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s;
        }

        #userList li:hover {
            background-color: #f0f0f0;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>
<h2>안녕하세요, <span id="username"><%= request.getParameter("username") %></span>님</h2>
<div style="display: flex;">
    <div id="chat">
        <!-- 채팅 메시지들이 표시되는 부분 -->
    </div>
    <div id="userList">
        <h3>Users Online</h3>
        <ul id="users">
            <!-- 사용자 목록이 여기에 표시됨 -->
        </ul>
    </div>
</div>

<input type="text" id="messageInput" placeholder="Type your message...">
<button onclick="sendMessage()">Send</button>
<button onclick="leaveChat()">Leave Chat</button> <!-- 나가기 버튼 추가 -->

<script>
    var username = document.getElementById('username').textContent;
    var socket = new SockJS('/ws');
    var stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
        console.log("Connected: " + frame);

        // 사용자 목록 요청
        stompClient.send("/app/users", {}, {});

        stompClient.subscribe('/topic/messages', function (message) {
            var msgData = JSON.parse(message.body);
            var chat = document.getElementById('chat');
            var messageElement = document.createElement('div');
            messageElement.classList.add('message');

            var displayName = msgData.from === username ? "나" : msgData.from;

            if (msgData.from === username) {
                messageElement.classList.add('from-user');
            } else {
                messageElement.classList.add('from-others');
            }

            var contentElement = document.createElement('div');
            contentElement.classList.add('content');
            contentElement.innerText = displayName + ": " + msgData.message;

            messageElement.appendChild(contentElement);
            chat.appendChild(messageElement);
            chat.scrollTop = chat.scrollHeight; // 스크롤을 맨 아래로 이동
        });

        // 사용자 목록 갱신
        stompClient.subscribe('/topic/users', function (message) {
            console.log("Received user list: ", message.body);
            var users = JSON.parse(message.body);
            var userList = document.getElementById('users');
            userList.innerHTML = '';
            users.forEach(function (user) {
                var userElement = document.createElement('li');
                userElement.textContent = user;
                userList.appendChild(userElement);
            });
        });
    });

    // 메시지 전송
    function sendMessage() {
        var message = document.getElementById('messageInput').value;
        if (message.trim() !== '') {
            stompClient.send("/app/chat", {}, JSON.stringify({'from': username, 'message': message}));
            document.getElementById('messageInput').value = '';
        }
    }

    // 나가기 버튼 클릭 시
    function leaveChat() {
        // 다른 사용자에게 퇴장 메시지를 전송
        stompClient.send("/app/chat", {}, JSON.stringify({'from': username, 'message': username + "님이 나갔습니다."}));

        // 사용자 퇴장 시 호출
        stompClient.send("/app/disconnect", {}, username);

        // 리디렉션 전에 잠시 대기
        setTimeout(function() {
            window.location.href = '/username'; // username.jsp로 리디렉션
        }, 1000); // 2초 후에 리디렉션
    }

    // 시스템 메시지 표시 함수
    function displaySystemMessage(message) {
        var chat = document.getElementById('chat');
        var messageElement = document.createElement('div');
        messageElement.classList.add('system-message'); // 시스템 메시지 클래스 추가

        var contentElement = document.createElement('div');
        contentElement.classList.add('content');
        contentElement.innerText = message;

        messageElement.appendChild(contentElement);
        chat.appendChild(messageElement);
        chat.scrollTop = chat.scrollHeight; // 스크롤을 맨 아래로 이동
    }

    // 페이지가 닫힐 때 사용자 목록에서 제거
    window.onbeforeunload = function() {
        stompClient.send("/app/disconnect", {}, username); // 사용자 퇴장 시 호출
    };
</script>
</body>
</html>
