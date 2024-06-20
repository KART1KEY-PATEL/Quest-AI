import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:questias/pages/model/chatMessage.dart';
import 'package:questias/pages/model/chatTile.dart';

class ChatController with ChangeNotifier {
  // PageController

  List<ChatMessage> messages = [];
  List<ChatTile> allChats = [];

  void addChat(ChatTile chatTile) {
    allChats.add(chatTile);
    notifyListeners();
  }

  void addMessage(ChatMessage message) {
    messages.add(message);
    notifyListeners();
  }
}
