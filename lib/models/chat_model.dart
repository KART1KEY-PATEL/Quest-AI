class ChatModel {
  // final String id;
  final List<MessageModel> chat;
  final String createdAt;

  ChatModel({required this.chat, required this.createdAt});
}

class MessageModel {
  final String content;
  final String role;
  MessageModel({required this.content, required this.role});
}
