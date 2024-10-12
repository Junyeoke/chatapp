import 'dart:io';

import 'package:chatapp/models/message.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  String _getWebSocketUrl() {
    const String serverPort = '8080'; // 스프링 부트 서버 포트
    const String wsPath = '/ws'; // WebSocket 엔드포인트 경로

    if (Platform.isAndroid) {
      return 'ws://10.0.2.2:$serverPort$wsPath'; // 안드로이드 에뮬레이터
    } else if (Platform.isIOS) {
      return 'ws://localhost:$serverPort$wsPath'; // iOS 시뮬레이터
    } else {
      return 'ws://192.168.0.1:$serverPort$wsPath'; // 실제 디바이스나 웹
    }
  }

  WebSocketChannel? _channel;

  void connect(String username) async {
    final String wsUrl = _getWebSocketUrl();
    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      await _channel!.ready;
      _channel!.sink.add(jsonEncode({'username': username}));
      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data is List) {
            if (onUserListReceived != null) {
              onUserListReceived!(List<String>.from(data));
            }
          } else {
            final decodedMessage = Message.fromJson(data);
            if (onMessageReceived != null) {
              onMessageReceived!(decodedMessage);
            }
          }
        },
        onError: (error) {
          print('WebSocket 오류: $error');
        },
        onDone: () {
          print('WebSocket 연결 종료');
        },
      );
    } catch (e) {
      print('WebSocket 연결 실패: $e');
      // 여기에 오류 처리 로직을 추가할 수 있습니다.
    }
  }
}
