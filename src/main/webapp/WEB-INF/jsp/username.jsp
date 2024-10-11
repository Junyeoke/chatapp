<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enter Username</title>
</head>
<body>
<h2>Enter your username</h2>
<form action="chat" method="get">
    <input type="text" name="username" placeholder="Enter your username" required>
    <button type="submit">Join Chat</button>
</form>
</body>
</html>