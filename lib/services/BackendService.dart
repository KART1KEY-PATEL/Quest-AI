import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:questias/models/openAIChatModel.dart';
import 'package:questias/models/user_model.dart';
import 'package:questias/providers/user_provider.dart';

class BackendService {
  Future<String> getOpenAIResponse(
      {required List<OpenAIChatModel> messages}) async {
    final String backendUrl =
        "https://questias-backend-production.up.railway.app";

    // Trim messages to the last 32 elements
    final trimmedMessages = messages.length > 32
        ? messages.sublist(messages.length - 32)
        : messages;

    // Convert messages to JSON map
    final List<Map<String, String>> messageMaps =
        trimmedMessages.map((message) => message.toJson()).toList();

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/ask'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "messages": messageMaps,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['response'];
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load response');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load response');
    }
  } 
  
  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name, UserProvider userProvider, String phone, String imageUrl,) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful sign-up, add user to Firestore and update provider
      await addUserToFirestore(
        userId: userCredential.user!.uid,
        email: email,
        name: name,
        password: password,
        userProvider: userProvider,
        phone: phone,
        imageUrl: imageUrl,

      );
      print("User Creation Done ${userCredential.credential}");
    } catch (e) {
      print("Error signing up: $e");
      // Handle error
    }
  }

  // Sign In with Email/Password
  Future<bool> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (userCredential.user != null);
    } catch (e) {
      print("Error signing in: $e");
      return false;
    }
  }

  // Sign Out
  void signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen or perform other actions after logout
    } catch (e) {
      print("Error signing out: $e");
      // Handle error
    }
  }

  Future<void> addUserToFirestore({
    required String userId,
    required String email,
    required String name,
    required String password,
    required String phone,
    required String imageUrl,
    required UserProvider userProvider,
  }) async {
    try {
      // Add user to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'name': name,
        'password': password,
        'plan': 'basic',
        'phone': phone,
        'imageUrl': imageUrl,

        // Add more fields as needed
      });

      // Update the UserProvider with the new user's data
      userProvider.user = UserModel(
        id: userId,
        email: email,
        name: name,
        password: password,
        plan: 'basic',
        phone: phone,
        imageUrl: imageUrl,
      );
      userProvider.notifyListeners();
    } catch (e) {
      print("Error adding user to Firestore: $e");
      // Handle error
    }
  }

  Future<List<String>> readCategory() async {
    try {
      await FirebaseFirestore.instance
          .collection('category')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          print(element.data());
        });
      });
    } catch (e) {
      print("Error reading category: $e");
      return [
        'Developer',
        'Designer',
        'Consultant',
        'Student',
        'Add new category'
      ];
    }
    return [];
  }

  Future<void> addCategory(String category) async {
    try {
      await FirebaseFirestore.instance.collection('category').add({
        'category': category,
      });
    } catch (e) {
      print("Error adding category: $e");
      // Handle error
    }
  }
}