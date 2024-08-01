import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProvider with ChangeNotifier {
  List<String> _categories = [];

  List<String> get categories => _categories;

  CategoryProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc('data')
        .get();
    if (snapshot.exists) {
      List<String> fetchedCategories =
          List<String>.from(snapshot.data()!['categories']);
      _categories = fetchedCategories
          .where((category) => category != 'Add new category')
          .toList();
      _categories.add('Add new category');
      notifyListeners();
      print('Fetched categories: $_categories');
    }
  }

  Future<void> addCategory(String newCategory) async {
    _categories.insert(
        _categories.length - 1, newCategory); // Add before "Add new category"
    await FirebaseFirestore.instance
        .collection('categories')
        .doc('data')
        .update({
      'categories': _categories
          .where((category) => category != 'Add new category')
          .toList(),
    });
    notifyListeners();
    print('Added new category: $newCategory');
  }
}
