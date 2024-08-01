import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:questias/models/book_model.dart';
import 'package:path/path.dart' as path;

class BookProvider with ChangeNotifier {
  List<BookModel> _books = [];

  List<BookModel> get books => _books;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addBook(
      BookModel book, String filePath, String coverFilePath) async {
    try {
      // Upload book PDF to Firebase Storage
      String fileName = path.basename(filePath);
      Reference storageRef = _storage.ref().child('books/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(filePath));

      TaskSnapshot snapshot = await uploadTask;
      String bookUrl = await snapshot.ref.getDownloadURL();
      // Upload book PDF to Firebase Storage
      String coverFileName = path.basename(coverFilePath);
      Reference storageRefCover = _storage.ref().child('covers/$coverFileName');
      UploadTask coverUploadPath = storageRefCover.putFile(File(coverFilePath));

      TaskSnapshot coverSnapshot = await coverUploadPath;
      String bookCoverUrl = await coverSnapshot.ref.getDownloadURL();

      // Add book to Firestore
      book.bookUrl = bookUrl;
      book.bookCoverUrl = bookCoverUrl;

      DocumentReference docRef = await _firestore.collection('books').add({
        'title': book.title,
        'description': book.description,
        'category': book.category,
        'bookUrl': book.bookUrl,
        'bookCoverUrl': book.bookCoverUrl,
      });

      book.id = docRef.id;
      _books.add(book);
      notifyListeners();
    } catch (e) {
      print('Error adding book: $e');
      throw e;
    }
  }
}
