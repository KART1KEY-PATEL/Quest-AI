import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String password;
  String plan;
  String phone;
  String imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.plan,
    required this.phone,
    required this.imageUrl,
  });

  // Convert a Firestore document to a UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      plan: data['plan'] ?? '',
      phone: data['phone'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'plan': plan,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }
}