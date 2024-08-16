import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questias/models/user_model.dart';
import 'package:questias/providers/subscription_provider.dart';

class UserProvider with ChangeNotifier {
  UserModel? user;
  
  Future<void> fetchUser(BuildContext context) async {
    try {
      // Get the current user
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        // If the document exists, convert it to a UserModel and notify listeners
        if (userDoc.exists) {
          user = UserModel.fromFirestore(userDoc);
          notifyListeners();

          // Update the currentPlan in SubscriptionProvider
          final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
          subscriptionProvider.setCurrentPlan(user!.plan);
        }
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }
}