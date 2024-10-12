import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/websocket_service.dart';

class ChatScreen extends StatefulWidget {
  final String username;

  ChatScreen({required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _webSocketService.onMessageReceived = _handleMessage;
    _webSocketService.onUserListReceived = _handleUserList;
    try {
      _webSocketService.connect(widget.username);
    } catch (e) {
      print('채팅 서버 연결 실패: $e');
      // 여기에 사용자에게 오류 메시지를 표시하는 로직을 추가할 수 있습니다.
    }
  }

  void _handleMessage(Message message) {
    setState(() {
      _messages.add(message);
    });
  }

  void _handleUserList(List<String> userList) {
    // 여기에 사용자 목록을 처리하는 로직을 추가할 수 있습니다.
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      _webSocketService.sendMessage(widget.username, _textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.from),
                  subtitle: Text(message.content),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }
}
