<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>WebSocket Test</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        #messages {
            border: 1px solid #ccc;
            background-color: #fff;
            height: 300px;
            overflow-y: scroll;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 5px;
        }
        #messageInput {
            width: calc(100% - 120px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-right: 10px;
        }
        button {
            padding: 10px 15px;
            background-color: #5cb85c;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #4cae4c;
        }
        .message {
            margin: 5px 0;
            padding: 5px;
            border-radius: 5px;
        }
        .sent {
            background-color: #d1e7dd;
            text-align: right;
        }
        .received {
            background-color: #f8d7da;
            text-align: left;
        }
    </style>
    <script>
        var stompClient = null;

        function connect() {
            var socket = new SockJS('/chat'); // 웹소켓 엔드포인트
            stompClient = Stomp.over(socket);

            stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/messages', function (message) {
                    // 메시지 본문을 JSON으로 파싱하고, content 속성을 사용하여 표시
                    showMessage(JSON.parse(message.body));
                });
            }, function (error) {
                // 연결 실패 시 에러 로그 출력
                console.error('Error connecting: ' + error);
            });
        }

        function sendMessage() {
            var message = document.getElementById("messageInput").value;
            if (message.trim() !== "") { // 빈 메시지 전송 방지
                stompClient.send("/app/send", {}, JSON.stringify(message)); // 메시지 전송 경로
                document.getElementById("messageInput").value = "";
            } else {
                alert("메시지를 입력하세요."); // 빈 메시지 경고
            }
        }

        function showMessage(message) {
            var messages = document.getElementById("messages");
            // 메시지 타입에 따라 다르게 표시
            var messageDiv = document.createElement("div");
            messageDiv.className = "message received"; // 수신 메시지 스타일
            messageDiv.innerText = message;
            messages.appendChild(messageDiv);
            messages.scrollTop = messages.scrollHeight; // 스크롤을 항상 맨 아래로
        }
    </script>
</head>
<body onload="connect()">
<h1>WebSocket을 이용한 간단한 채팅 테스트</h1>
<div id="messages"></div>
<input id="messageInput" type="text" placeholder="메시지를 입력하세요..." />
<button onclick="sendMessage()">전송</button>
</body>
</html>