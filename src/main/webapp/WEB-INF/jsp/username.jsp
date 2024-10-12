<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>닉네임 입력</title>
    <style>
        body {
            font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif;
            background-color: #b2c7d9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 400px;
            width: 90%;
        }
        h2 {
            margin-bottom: 30px;
            color: #000000;
            font-weight: 700;
            font-size: 24px;
        }
        input[type="text"] {
            width: calc(100% - 30px);
            padding: 15px;
            margin-bottom: 25px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        input[type="text"]:focus {
            outline: none;
            border-color: #fee500;
            box-shadow: 0 0 0 2px rgba(254, 229, 0, 0.3);
        }
        button {
            width: 100%;
            padding: 15px;
            background-color: #fee500;
            color: #000000;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        button:hover {
            background-color: #fada0a;
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container">
    <h2>닉네임을 입력하세요</h2>
    <form action="chat" method="get">
        <input type="text" name="username" placeholder="닉네임을 입력해주세요" required>
        <button type="submit">채팅방 입장</button>
    </form>
</div>
</body>
</html>
