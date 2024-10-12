class Message {
  final String from;
  final String content;
  final String type;

  Message({required this.from, required this.content, required this.type});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      from: json['from'] ?? '',
      content: json['message'] ?? '',
      type: json['type'] ?? 'chat',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'message': content,
      'type': type,
    };
  }
}
