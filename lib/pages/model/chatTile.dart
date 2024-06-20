import 'package:questias/pages/model/chatMessage.dart';

class ChatTile {
  String id;
  List<ChatMessage> messages;
  String title = "GovBuddy";
  String lastMessage;
  String time = DateTime.now().toString();
  ChatTile({
    required this.id,
    required this.messages,
    required this.title,
    required this.lastMessage,
    required this.time,
  });
}
