<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("username.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat Room</title>
    <style>
        body {
            font-family: 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif;
            background-color: #b2c7d9;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background-color: #fff;
            width: 90%;
            max-width: 1000px;
            height: 90vh;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        h2 {
            padding: 15px;
            margin: 0;
            background-color: #fee500;
            color: #000;
            font-size: 18px;
        }

        .chat-area {
            display: flex;
            flex: 1;
            overflow: hidden;
        }

        #chat {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 20px;
            overflow-y: auto;
            width: 100%; /* 수정: max-width 제거 */
        }

        .message {
            max-width: 100%; /* 수정: 70%에서 100%로 변경 */
            margin-bottom: 10px;
            clear: both;
            width: 100%; /* 유지 */
        }

        .message.from-user, .message.from-others {
            width: 100%; /* 추가: 메시지 너비를 100%로 설정 */
        }

        .message .content {
            display: inline-block;
            padding: 10px 15px;
            border-radius: 15px;
            font-size: 14px;
            line-height: 1.4;
            max-width: calc(100% - 30px); /* 수정: 패딩 고려하여 계산 */
            word-wrap: break-word; /* 유지 */
        }

        .message.from-user .content {
            background-color: #fee500;
            color: #000;
            border-top-right-radius: 0;
            float: right; /* 유지 */
        }

        .message.from-others .content {
            background-color: #fff;
            color: #000;
            border: 1px solid #ddd;
            border-top-left-radius: 0;
            float: left; /* 유지 */
        }

        .message .header, .message .time {
            clear: both; /* 추가: float 속성 해제 */
            width: 100%; /* 추가: 너비를 100%로 설정 */
            padding: 0 10px; /* 추가: 좌우 패딩 추가 */
        }

        .message.from-user .header, .message.from-user .time {
            text-align: right; /* 수정: 사용자 메시지의 헤더와 시간을 오른쪽 정렬 */
        }

        .message.from-others .header, .message.from-others .time {
            text-align: left; /* 수정: 다른 사용자 메시지의 헤더와 시간을 왼쪽 정렬 */
        }

        .message .header {
            font-size: 12px;
            color: #999;
            margin-bottom: 5px;
        }

        .message .time {
            font-size: 11px;
            color: #999;
            margin-top: 5px;
            text-align: right;
        }

        .system-message {
            text-align: center;
            margin: 10px 0;
            font-size: 12px;
            color: #999;
        }

        .system-message span {
            background-color: rgba(0,0,0,0.1);
            padding: 5px 10px;
            border-radius: 10px;
        }

        .input-container {
            background-color: #eee;
            padding: 10px;
            display: flex;
            align-items: center;
        }

        #messageInput {
            flex: 1;
            border: none;
            padding: 10px;
            border-radius: 20px;
            font-size: 14px;
        }

        .emoji-button {
            background: none;
            border: none;
            font-size: 24px;
            color: #3498db;
            cursor: pointer;
            margin-left: 10px;
            transition: color 0.3s ease;
        }

        .emoji-button:hover {
            color: #2980b9;
        }

        .send-button, .leave-button {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 24px;
            margin-left: 10px;
            transition: color 0.3s ease;
        }

        .send-button {
            color: #3498db;
        }

        .send-button:hover {
            color: #2980b9;
        }

        .leave-button {
            color: #e74c3c;
        }

        .leave-button:hover {
            color: #c0392b;
        }

        #userList {
            width: 200px;
            background-color: #f8f8f8;
            padding: 20px;
            overflow-y: auto;
        }

        #userList h3 {
            font-size: 16px;
            margin-bottom: 15px;
            color: #333;
        }

        #userList ul {
            list-style-type: none;
            padding: 0;
        }

        #userList li {
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 5px;
            background-color: #fff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        #userList li.current-user {
            font-weight: bold;
            color: #3498db;
        }

        .emoji-picker {
            position: absolute;
            bottom: 70px;
            right: 10px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 10px;
            display: none;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            max-width: 300px;
            max-height: 200px;
            overflow-y: auto;
        }

        .emoji-picker::-webkit-scrollbar {
            width: 6px;
        }

        .emoji-picker::-webkit-scrollbar-thumb {
            background-color: #888;
            border-radius: 3px;
        }

        .emoji-picker::-webkit-scrollbar-thumb:hover {
            background-color: #555;
        }

        .emoji-picker span {
            cursor: pointer;
            font-size: 24px;
            margin: 5px;
            display: inline-block;
            transition: transform 0.2s;
        }

        .emoji-picker span:hover {
            transform: scale(1.2);
        }

        .emoji-categories {
            display: flex;
            justify-content: space-around;
            margin-bottom: 10px;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }

        .emoji-category {
            cursor: pointer;
            font-size: 20px;
            padding: 5px;
            border-radius: 5px;
            transition: background-color 0.2s;
        }

        .emoji-category:hover, .emoji-category.active {
            background-color: #f0f0f0;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>
<div class="container">
    <h2>안녕하세요, <span id="username"><%= request.getParameter("username") %></span>님</h2>
    <div class="chat-area">
        <div id="chat">
            <!-- 채팅 메시지들이 표시되는 부분 -->
        </div>
        <div id="userList">
            <h3>접속자</h3>
            <ul id="users">
                <!-- 사용자 목록이 여기에 표시됨 -->
            </ul>
        </div>
    </div>
    <div class="input-container">
        <input type="text" id="messageInput" placeholder="메시지를 입력하세요 :)">
        <button id="emojiButton" class="emoji-button">😃</button>
        <div id="emojiPicker" class="emoji-picker"></div>
        <button onclick="sendMessage()" class="send-button" title="메시지 보내기">📤</button>
        <button onclick="leaveChat()" class="leave-button" title="채팅방 나가기">🚪</button>
    </div>
</div>
<script>
    var username = '<%= username %>'.trim(); // 서버에서 전달한 username 값 사용
    var socket = new SockJS('/ws');
    var stompClient = Stomp.over(socket);

    // WebSocket 연결 설정
    function connectAndSubscribe() {
        stompClient.connect({}, function (frame) {
            console.log("Connected: " + frame);

            // 채팅 메시지 수신 구독
            stompClient.subscribe('/topic/messages', function (message) {
                var msgData = JSON.parse(message.body);
                if (msgData.type === 'system') {
                    addMessageToChat({
                        type: 'system',
                        message: msgData.message
                    });
                } else {
                    addMessageToChat(msgData);
                }
            });

            // 사용자 목록 갱신 구독
            stompClient.subscribe('/topic/users', function (message) {
                console.log("Received user list: ", message.body);
                var users = JSON.parse(message.body);
                updateUserList(users);
            });

            // 사용자 목록을 요청
            requestUserList();

            // 입장 메시지 전송
            stompClient.send("/app/join", {}, JSON.stringify({
                'username': username
            }));
        });
    }

    // 사용자 목록 요청 함수
    function requestUserList() {
        // WebSocket 연결이 완료된 후 사용자 목록을 서버에 요청
        stompClient.send("/app/users", {}, {});
    }

    // 메시지 전송 함수
    function sendMessage() {
        var message = document.getElementById('messageInput').value.trim();
        if (message !== '') {
            // 메시지를 서버로 전송
            stompClient.send("/app/chat", {}, JSON.stringify({
                'from': username,
                'message': message
            }));
            document.getElementById('messageInput').value = ''; // 입력 필드 비우기
        }
    }

    // 나가기 버튼 클릭 시 처리
    function leaveChat() {
        if (confirm('정말로 채팅방을 나가시겠습니까?')) {
            // 서버에 사용자 퇴장 요청 전송
            stompClient.send("/app/disconnect", {}, JSON.stringify({
                'username': username
            }));

            // 즉시 리디렉션
            window.location.href = '/username'; // username.jsp로 리디렉션
        }
    }

    // 페이지가 닫히거나 새로고침 될 때 퇴장 처리 및 리디렉션
    window.onbeforeunload = function() {
        if (stompClient && stompClient.connected) {
            // 사용자가 페이지를 떠나기 전에 퇴장 메시지 전송
            var disconnectData = JSON.stringify({
                'username': username
            });

            // navigator.sendBeacon을 사용하여 퇴장 요청을 서버로 전송
            navigator.sendBeacon('/app/disconnect', disconnectData);

            // WebSocket 연결 종료
            stompClient.disconnect();
        }
    };

    function addMessageToChat(msgData) {
        var chat = document.getElementById('chat');
        var messageElement = document.createElement('div');

        if (msgData.type === 'system') {
            messageElement.classList.add('system-message');
            var spanElement = document.createElement('span');
            spanElement.innerText = msgData.message;
            messageElement.appendChild(spanElement);
        } else {
            messageElement.classList.add('message');

            var displayName = (msgData.from === username) ? "나" : msgData.from;
            var isFromUser = msgData.from === username;

            if (isFromUser) {
                messageElement.classList.add('from-user');
            } else {
                messageElement.classList.add('from-others');
            }

            var headerElement = document.createElement('div');
            headerElement.classList.add('header');
            headerElement.innerText = displayName;

            var contentElement = document.createElement('div');
            contentElement.classList.add('content');
            contentElement.innerText = msgData.message;

            var timeElement = document.createElement('div');
            timeElement.classList.add('time');
            timeElement.innerText = getCurrentTime(); // 현재 시간을 가져오는 함수 필요

            messageElement.appendChild(headerElement);
            messageElement.appendChild(contentElement);
            messageElement.appendChild(timeElement);
        }

        chat.appendChild(messageElement);
        chat.scrollTop = chat.scrollHeight;
    }

    function getCurrentTime() {
        var now = new Date();
        var hours = now.getHours().toString().padStart(2, '0');
        var minutes = now.getMinutes().toString().padStart(2, '0');
        return hours + ':' + minutes;
    }

    // 사용자 목록 업데이트 함수 수정
    function updateUserList(users) {
        var userList = document.getElementById('users');
        userList.innerHTML = ''; // 기존 목록 지우기

        users.forEach(function (user) {
            var userElement = document.createElement('li');
            userElement.textContent = user;

            if (user === username) {
                userElement.classList.add('current-user');
            }

            userList.appendChild(userElement);
        });
    }

    // 이모지 선택기 초기화 및 이벤트 리스너 추가
    function initializeEmojiPicker() {
        const emojiButton = document.getElementById('emojiButton');
        const emojiPicker = document.getElementById('emojiPicker');
        const messageInput = document.getElementById('messageInput');

        // 이모지 카테고리와 해당 이모지들
        const emojiCategories = {
            '😀': ['😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇'],
            '🥰': ['🥰', '😍', '😘', '😗', '😙', '😚', '😋', '😛', '😝', '😜'],
            '🤔': ['🤔', '🤨', '🧐', '🤓', '😎', '🤩', '🥳', '😏', '😒', '😞'],
            '😢': ['😢', '😭', '😤', '😠', '😡', '🤬', '🤯', '😳', '🥵', '🥶'],
            '🐶': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯']
        };

        // 이모지 카테고리 버튼 생성
        const categoryContainer = document.createElement('div');
        categoryContainer.className = 'emoji-categories';
        Object.keys(emojiCategories).forEach(category => {
            const categoryButton = document.createElement('span');
            categoryButton.className = 'emoji-category';
            categoryButton.textContent = category;
            categoryButton.onclick = () => showEmojiCategory(category);
            categoryContainer.appendChild(categoryButton);
        });
        emojiPicker.appendChild(categoryContainer);

        // 이모지 컨테이너
        const emojiContainer = document.createElement('div');
        emojiPicker.appendChild(emojiContainer);

        function showEmojiCategory(category) {
            emojiContainer.innerHTML = '';
            emojiCategories[category].forEach(emoji => {
                const emojiSpan = document.createElement('span');
                emojiSpan.textContent = emoji;
                emojiSpan.onclick = () => {
                    messageInput.value += emoji;
                    messageInput.focus();
                };
                emojiContainer.appendChild(emojiSpan);
            });

            // 활성 카테고리 표시
            document.querySelectorAll('.emoji-category').forEach(el => {
                el.classList.toggle('active', el.textContent === category);
            });
        }

        // 초기 카테고리 표시
        showEmojiCategory('😀');

        // 이모지 버튼 클릭 이벤트
        emojiButton.onclick = (event) => {
            event.stopPropagation();
            emojiPicker.style.display = emojiPicker.style.display === 'none' ? 'block' : 'none';
        };

        // 문서 클릭 시 이모지 선택기 닫기
        document.addEventListener('click', () => {
            emojiPicker.style.display = 'none';
        });

        emojiPicker.addEventListener('click', (event) => {
            event.stopPropagation();
        });
    }

    // 페이지 로드 시 이모지 선택기 초기화
    window.onload = function() {
        connectAndSubscribe();
        initializeEmojiPicker();
    };

    // 연결 초기 및 구독 시작
    connectAndSubscribe();
</script>
</body>
</html>