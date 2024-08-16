import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:questias/models/chatMessage.dart';
import 'package:questias/models/chatTile.dart';
import 'package:questias/models/openAIChatModel.dart';

class ChatController with ChangeNotifier {
  List<OpenAIChatModel> messages = [];
  List<ChatTile> allChats = [];
  List<ChatTile> savedChats = [];
  bool isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId =
      FirebaseAuth.instance.currentUser!.uid; // Replace with dynamic user ID

  void setLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  // Future<void> addSavedChat(ChatTile chatTile) async {
  //   // Ensure a unique chat ID for the saved chat, if it's not provided
  //   String savedChatId = chatTile.chatId.isEmpty
  //       ? FirebaseFirestore.instance.collection('savedChats').doc().id
  //       : chatTile.chatId;

  //   // Reference to the new saved chat document
  //   DocumentReference savedChatRef = _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('savedChats') // Note: using 'savedChats' instead of 'chats'
  //       .doc(savedChatId);

  //   final snapshot = await savedChatRef.get();

  //   if (!snapshot.exists) {
  //     await savedChatRef.set({
  //       'createdAt': Timestamp.now(), // Ensure this is outside the 'chat' map
  //       'chat': chatTile.toMap(),
  //       'messages': chatTile.messages.map((m) => m.toMap()).toList(),
  //     }, SetOptions(merge: true));
  //     savedChats.add(chatTile); // Add to the local list of saved chats
  //     notifyListeners();
  //   } else {
  //     print("Chat already exists in saved chats");
  //   }
  // }

  Future<void> addChat(String chatId, ChatTile chatTile) async {
    DocumentReference chatRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId);
    final snapshot = await chatRef.get();

    if (!snapshot.exists) {
      allChats.add(chatTile);
      await chatRef.set({
        'createdAt': Timestamp.now(), // Ensure this is outside the 'chat' map
        'chat': chatTile.toMap(),
        'messages': [],
      }, SetOptions(merge: true));
      notifyListeners();
    }
  }

  Future<void> addMessage(String chatId, OpenAIChatModel message) async {
    // Ensure chatId is not empty
    if (chatId.isEmpty) {
      print("Error: chatId is empty");
      return;
    }

    DocumentReference chatRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId);
    final snapshot = await chatRef.get();
    messages.add(message);
    notifyListeners();
    if (!snapshot.exists) {
      // If the chat does not exist, initialize it with `createdAt`
      messages = [];
      messages.add(message);
      await chatRef.set({
        'createdAt': Timestamp.now(),
        'messages': [message.toMap()],
        'lastMessage': message.content,
      }, SetOptions(merge: true));
    } else {
      // If the chat exists, just add the message
      await chatRef.update({
        'messages': FieldValue.arrayUnion([message.toMap()]),
        'lastMessage': message.content,
      });
    }

    notifyListeners();
  }

  Future<void> loadChats() async {
    setLoading();
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        print("No chats found.");
      }

      allChats = snapshot.docs.map((doc) {
        print("Loading chat: ${doc.id}");
        return ChatTile.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print("Loaded ${allChats.length} chats.");
    } catch (e) {
      print("Error loading chats: $e");
    }
    setLoading();
  }

// Add a method in ChatController to load messages for a specific chat
  Future<void> loadMessagesForChat(String chatId) async {
    setLoading();
    try {
      DocumentSnapshot chatDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(chatId)
          .get();

      if (chatDoc.exists) {
        var data = chatDoc.data() as Map<String, dynamic>;
        List<dynamic> messagesData = data['messages'] ?? [];
        print("Loaded ${messagesData.length} messages for chat $chatId");
        List<OpenAIChatModel> loadedMessages =
            messagesData.map((m) => OpenAIChatModel.fromMap(m)).toList();
        // Assuming messages is a field in ChatController that holds current chat messages
        messages = loadedMessages;
        print("Loaded ${messages.length} messages for chat $chatId");
      } else {
        print("No chat found with ID $chatId");
        messages = [];
      }
    } catch (e) {
      print("Error loading messages for chat $chatId: $e");
      messages = [];
    }
    setLoading();
    notifyListeners();
  }

  // Call this method when initializing the controller
  Future<void> initialize() async {
    await loadChats();
  }
}
