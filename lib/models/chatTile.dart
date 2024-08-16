import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questias/models/openAIChatModel.dart';

class ChatTile {
  String chatId;
  List<OpenAIChatModel> messages;
  String title;
  String lastMessage;
  DateTime time;

  ChatTile({
    required this.chatId,
    required this.messages,
    required this.title,
    required this.lastMessage,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'messages': messages.map((message) => message.toMap()).toList(),
      'title': title,
      'lastMessage': lastMessage,
      'time': time.toIso8601String(), // Store DateTime as a String
    };
  }

  factory ChatTile.fromMap(Map<String, dynamic> map, String documentId) {
    return ChatTile(
      chatId: documentId,
      title: map['title'] ?? 'No title',
      lastMessage: map['lastMessage'] ?? 'No last message',
      time: (map['createdAt'] as Timestamp).toDate(),
      messages: List<OpenAIChatModel>.from(
        map['messages']?.map((x) => OpenAIChatModel.fromMap(x)) ?? [],
      ),
    );
  }
}
