
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:questias/pages/model/chatMessage.dart';
import 'package:questias/pages/model/chatTile.dart';
import 'package:questias/pages/model/openAIChatModel.dart';

class ChatController with ChangeNotifier {
  // PageController

  List<OpenAIChatModel> messages = [];
  List<ChatTile> allChats = [];
  List<ChatTile> savedChats = [];
  bool isLoading = false; 

  void setLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void addSavedChat(ChatTile chatTile) {
    savedChats.add(chatTile);
    notifyListeners();
  }

  void addChat(ChatTile chatTile) {
    allChats.add(chatTile);
    notifyListeners();
  }

  void addMessage(OpenAIChatModel message) {
    messages.add(message);
    notifyListeners();
  }
}

