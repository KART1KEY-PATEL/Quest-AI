import 'package:questias/pages/model/chatMessage.dart';
import 'package:questias/pages/model/openAIChatModel.dart';

class ChatTile {
  String id;
  List<OpenAIChatModel> messages;
  String title = "GovBuddy";
  String lastMessage;
  DateTime time = DateTime.now();
  ChatTile({
    required this.id,
    required this.messages,
    required this.title,
    required this.lastMessage,
    required this.time,
  });
}
